# The installer

`./run` is a POSIX sh dispatcher: `install`, `update`, `upgrade`. No
framework, no dependency beyond git and coreutils.

## Design contract

Every step honours the same four rules, and this page is where they are
written down: the step files themselves say what they do, not how they behave.

1. **Idempotent.** A second run performs zero action (links tested by
   inode, `mkdir -p`, markers). Two consecutive `./run install` are the
   test.
2. **Faithful dry-run.** `-n` prints every command it would execute and
   performs no observable change to `$HOME` or the system. Steps may build
   a scratch file inside the run's private mktemp directory to compute a
   diff, and that is what makes the preview informative.
3. **Loud failure, no abort.** Network and package-manager commands go
   through `run_soft`: a failure is logged and counted, the run continues,
   `log_summary` returns 1 at the end. One dead mirror never kills an
   install halfway.
4. **Restorable backups.** Everything replaced goes to
   `~/.local/state/dotfiles/backups/<timestamp>/`, keeping its path
   relative to `$HOME`. If a link fails after the backup, the original is
   restored.

## Anatomy

```text
run                     CLI: arguments, $0 resolved through symlinks,
                        set -f, dispatch
setup/manifest.sh       single source of truth: links, dirs, migrations
setup/lib/log.sh        coloured logs, warning/error counters (mktemp + traps)
setup/lib/os.sh         OS detection (macos / fedora), dnf wrapper
setup/lib/util.sh       run, run_soft, run_steps, backup/migration/links
setup/steps/<name>.sh   one responsibility each; sourced in $STEPS order
setup/commands/*.sh     the update / upgrade flows
```

## The steps

`STEPS` in `run` fixes the order; each step is one file in
`setup/steps/`. What each does, and what it costs:

| # | Step | What it does | sudo | network | needs |
|---|---|---|---|---|---|
| 1 | `prereqs` | package manager + base tools (Homebrew on macOS, `git`/`curl` on Fedora) | Fedora | yes | nothing |
| 2 | `submodules` | init/sync the submodules, then attach each to its branch | no | yes | git, and access to the submodule remote |
| 3 | `directories` | create the XDG directories the shells need before first start | no | no | nothing |
| 4 | `migrate` | move legacy history files (`~/.bash_history`, `~/.lesshst`…) to XDG | no | no | `directories` |
| 5 | `symlinks` | apply `manifest.sh`, backing up anything real it replaces | no | no | `submodules`, so the submodule is populated when linked |
| 6 | `packages` | `brew bundle` / `dnf`, then the no-sudo recipes (mise, starship, claude) | Fedora | yes | `prereqs` |
| 7 | `gitsign` | generate `config.local` from the keys this machine has | no | no | nothing |
| 8 | `runtimes` | install what `mise` declares (node, python, rust, neovim, linters) | no | yes | `packages`, for mise on the PATH |
| 9 | `plugins` | clone TPM (zinit clones itself at first zsh start) | no | yes | `prereqs` for git, `symlinks` for `~/.config/tmux` |
| 10 | `shell` | `chsh` to zsh, asking first, and appends to `/etc/shells` | yes | no | `packages`, `chsh` needs zsh installed |

The order in `STEPS` is that dependency chain, nothing more. A missing
dependency is a clean skip with a log line, never a crash: **runtimes**
without mise, **plugins** without network, **shell** without zsh.

Three deserve a note: **migrate** runs once per machine and never returns;
**gitsign** never overwrites a hand-written `config.local`; **shell** is
the only step that needs sudo on macOS too.

## What each command replays

| Step | `install` | `update` | `upgrade` |
|---|---|---|---|
| prereqs, migrate, gitsign, shell | ✓ | | |
| submodules, directories, symlinks, packages, runtimes, plugins | ✓ | ✓ | |
| version bumps (brew/dnf, mise, zinit, TPM, submodules to latest) | | | ✓ |

`update` replays only what re-syncs a machine with the repo. `upgrade`
runs no step at all; it moves versions.

> [!NOTE]
> `gitsign` is not in that list. A signing key added after the install
> needs `./run install gitsign` by hand, `update` will not pick it up.

## Adding a step

1. Create `setup/steps/<name>.sh`, sourced under `set -eu`. It must follow
   the contract above (`run` / `run_soft` for anything that can fail).
2. Add `<name>` to `STEPS` in `run`, at the right position.
3. `./run install <name> -n`, then twice for real: the second run must be
   a no-op.

The libs are already sourced, so use them rather than reinventing:

| Helper | Use |
|---|---|
| `run <cmd…>` | run it, or print it under `--dry-run`. The default for anything that writes |
| `run_soft <cmd…>` | same, but a failure is logged and counted instead of stopping the run (network, package managers) |
| `run_steps <names…>` | run steps by name, capturing each exit code |
| `log_step/info/ok/warn/error` | the only output channel; warn and error feed the final summary |
| `confirm "question?"` | asks on `/dev/tty`; yes under `-y` and `--dry-run` |
| `link_with_backup <src> <dst>` | inode-compared link, backup and restore-on-failure included |
| `backup_file` / `migrate_file` | move into this run's backup directory / relocate a legacy file |
| `pkg_install <pkgs…>` | the OS's package manager, `run_soft`-wrapped |
| `is_macos` / `is_fedora` / `require_cmd <bin>` | branch on the platform, or fail loudly on a missing tool |

Never call `exit` in a step: it kills `run` itself and the summary with
it. Use `return 1`: `run_steps` catches it and `log_summary` owns the exit
code.

## Manual scripts (`scripts/`, on the PATH, never run by `./run`)

| Script | Effect |
|---|---|
| `sync-check.sh` | verifies the cross-repo contract: the files both dotfiles repos keep byte-identical (kitty, tmux themes) |
| `osx.sh` | rewrites ~15 macOS `defaults` (Dock, Finder, screenshots) and disables the Spotlight shortcut. Read it before running |
| `tool42.sh` | installs norminette + c_formatter_42 (needs pipx, installed by mise). Lives HERE because the school repo installs nothing by design |
| `bootstrap-aidd.sh` | clones two private repos into `~/.config/aiddconf` and deploys their links |

---

See also: [architecture.md](architecture.md) for what these steps set up,
and [packages.md](packages.md) for where each package comes from.
