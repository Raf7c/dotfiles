# The installer

`./run` is a POSIX sh dispatcher: `install`, `update`, `upgrade`. No
framework, no dependency beyond git and coreutils.

## Design contract

Every step honours the same four rules:

1. **Idempotent** — a second run performs zero action (links tested by
   inode, `mkdir -p`, markers). Two consecutive `./run install` are the
   test.
2. **Faithful dry-run** — `-n` prints every command it would execute and
   writes nothing, not even a temp file.
3. **Loud failure, no abort** — network and package-manager commands go
   through `run_soft`: a failure is logged and counted, the run continues,
   `log_summary` returns 1 at the end. One dead mirror never kills an
   install halfway.
4. **Restorable backups** — everything replaced goes to
   `~/.local/state/dotfiles/backups/<timestamp>/`, keeping its path
   relative to `$HOME`. If a link fails after the backup, the original is
   restored.

## Anatomy

```
run                     CLI: arguments, $0 resolved through symlinks,
                        set -f, dispatch
setup/manifest.sh       single source of truth: links, dirs, migrations
setup/lib/log.sh        coloured logs, warning/error counters (mktemp + traps)
setup/lib/os.sh         OS detection (macos / fedora), dnf wrapper
setup/lib/util.sh       run, run_soft, run_steps, backup/migration/links
setup/steps/<name>.sh   one responsibility each; sourced in $STEPS order
setup/commands/*.sh     the update / upgrade flows
```

Step order (see `STEPS` in `run`): prereqs → submodules → directories →
migrate → symlinks → packages → gitsign → runtimes → plugins → shell.

Notable steps:

- **migrate** — once per machine: moves the legacy `~/.bash_history`,
  `~/.zsh_history`, `~/.lesshst`, `~/.python_history` to their XDG paths.
- **gitsign** — generates `~/.config/git/config.local` from what the
  machine actually has: the Homebrew `ssh-keygen` on macOS (Apple's build
  cannot sign with FIDO2 `sk-*` keys), `commit.gpgsign` only where the key
  exists. Never overwrites a hand-written file.
- **shell** — `chsh` to zsh (the only step that may ask for sudo, for
  `/etc/shells`).

## Adding a step

1. Create `setup/steps/<name>.sh` — sourced under `set -eu`, must follow
   the contract above (`run` / `run_soft` for anything that can fail).
2. Add `<name>` to `STEPS` in `run`, at the right position.
3. `./run install <name> -n`, then twice for real: the second run must be
   a no-op.

## Diagnostics — `scripts/doctor.sh`

The shell degrades without blocking — so the silence gets verified, not
assumed. `doctor.sh` follows the `brew doctor` / `:checkhealth` model:
read-only, every check prints OK / WARN / FAIL with the suggested fix. Run
it on macOS **and** Fedora — after a `./run install` or `upgrade`, and
whenever something feels slow or broken.

```sh
doctor.sh                  # everything
doctor.sh env aliases      # selected sections
```

### Principles

- **Read-only** — no file is modified; only `/tmp/doctor.$$*` temp files
  are created and removed.
- **Asks real interactive shells** — env, PATH and aliases are read from an
  actual `zsh -i` / `bash -i`, not recomputed from the files: it measures
  what a shell receives, not what the config claims.
- **Reuses the sources of truth** — links come from `setup/manifest.sh`,
  never from a copied list.

### Reading the result

| Mark | Meaning |
|---|---|
| `OK` | conforming |
| `WARN` | degraded or suspicious — investigate, nothing breaks |
| `FAIL` | broken — the fix is in the message |
| `---` | information (optional tool missing, known limit) |

Exit codes: `0` healthy (WARNs may remain), `1` at least one FAIL, `2`
unknown section.

### Dependencies

Required — already present on every targeted machine: POSIX sh, zsh, bash,
coreutils (awk, sed, grep, sort, diff).

Optional — probed, never demanded; without them the check degrades to a
`---` line:

| Tool | Role | Without it |
|---|---|---|
| hyperfine | startup benchmark (warmup, outliers) | home-made ×10 median loop |
| coreutils (macOS) | `gdate` for nanosecond precision | timing skipped |
| shellcheck / shfmt | lint section | info line with the install command |
| checkbashisms | catch bashisms in POSIX scripts | same |

### Sections

| Section | Checks |
|---|---|
| shells | zsh + bash syntax, cold start (empty stderr), ×10 median time (WARN > 200 ms, hyperfine when present), zprof |
| bootstrap | `~/.zshenv` points into the repo; WARN if the old `/etc/zshenv` block lingers |
| env | EDITOR resolves, XDG/GITUSER/REPOS set in **both shells** + zsh/bash coherence (env.sh is the single source: divergence = FAIL), HISTFILE directory writable per shell, legacy history files back at the root |
| path | mise shims first, duplicates, dead entries — read from a real interactive shell, zsh **and** bash |
| links | every `manifest.sh` line exists and points into the repo |
| aliases | every alias target resolves, zsh **and** bash — asked to the shell, not the file (the `command -v` guards are honoured) |
| mise | present, declared runtimes installed, shims generated |
| plugins | zinit cloned, orphan plugins on disk, compinit dump for the right host+version, TPM |
| lint | shellcheck (bar: warning+), shfmt (`-d` must stay silent), checkbashisms |

## Manual scripts (`scripts/`, on the PATH, never run by `./run`)

| Script | Effect |
|---|---|
| `doctor.sh` | full health check, read-only — see the Diagnostics section |
| `osx.sh` | rewrites ~15 macOS `defaults` (Dock, Finder, screenshots) and disables the Spotlight shortcut — read before running |
| `tool42.sh` | installs norminette + c_formatter_42 (needs python3) |
| `bootstrap-aidd.sh` | clones two private repos into `~/.config/aiddconf` and deploys their links |

---

See also: [architecture.md](architecture.md) — what these steps set up ·
[tools.md](tools.md) — what the packages step installs.
