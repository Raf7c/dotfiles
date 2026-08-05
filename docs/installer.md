# The installer

`./run` is a POSIX sh dispatcher: `install`, `update`, `upgrade`. No
framework, no dependency beyond git and coreutils.

## Design contract

Every step honours the same four rules:

1. **Idempotent** — a second run performs zero action (links tested by
   inode, `mkdir -p`, markers). Two consecutive `./run install` are the
   test.
2. **Faithful dry-run** — `-n` prints every command it would execute and
   performs no observable change to `$HOME` or the system. Steps may build
   a scratch file inside the run's private mktemp directory to compute a
   diff — that is what makes the preview informative.
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

## Manual scripts (`scripts/`, on the PATH, never run by `./run`)

| Script | Effect |
|---|---|
| `osx.sh` | rewrites ~15 macOS `defaults` (Dock, Finder, screenshots) and disables the Spotlight shortcut — read before running |
| `tool42.sh` | installs norminette + c_formatter_42 (needs python3) |
| `bootstrap-aidd.sh` | clones two private repos into `~/.config/aiddconf` and deploys their links |

---

See also: [architecture.md](architecture.md) — what these steps set up ·
[tools.md](tools.md) — what the packages step installs.
