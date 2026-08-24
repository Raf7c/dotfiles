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
run                     CLI: arguments, step-name validation, set -f, dispatch
setup/manifest.sh       single source of truth: links, dirs, migrations
setup/lib/log.sh        coloured logs, warning/error counters (mktemp + traps)
setup/lib/os.sh         OS detection (macos / fedora), dnf wrapper
setup/lib/util.sh       run, run_soft, run_steps, backup/migration/links
setup/steps/<name>.sh   one responsibility each; sourced in $STEPS order
setup/commands/*.sh     one per command: install / update / upgrade
```

## The steps

`STEPS` in `run` fixes the order; each step is one file in
`setup/steps/`. What each does, and what it costs:

| # | Step | What it does | sudo | network | needs |
|---|---|---|---|---|---|
| 1 | `prereqs` | package manager + base tools (Homebrew on macOS, `git`/`curl` on Fedora) | yes | yes | nothing |
| 2 | `submodules` | init/sync the submodules, then attach each to its branch | no | yes | git, and access to the submodule remote |
| 3 | `directories` | create the XDG directories the shells need before first start | no | no | nothing |
| 4 | `migrate` | move legacy history files (`~/.bash_history`, `~/.lesshst`…) to XDG | no | no | nothing (`migrate_file` creates its own target directory) |
| 5 | `symlinks` | apply `manifest.sh`, backing up anything real it replaces | no | no | `submodules`, so the submodule is populated when linked |
| 6 | `packages` | `brew bundle` / `dnf`, then the no-sudo recipes (mise, starship, claude) | Fedora | yes | `prereqs` |
| 7 | `gitsign` | generate `config.local` from the keys this machine has | no | no | nothing |
| 8 | `runtimes` | install what `mise` declares (node, python, rust, neovim, linters) | no | yes | `packages`, for mise on the PATH |
| 9 | `extras_linux` | Fedora only: the four tools Fedora does not package (lazygit, sops, age-plugin-yubikey, the Nerd Font) | Fedora, for the COPR only | yes | `runtimes`, for cargo |
| 10 | `plugins` | clone TPM (zinit clones itself at first zsh start) | no | yes | `prereqs` for git, `symlinks` for `~/.config/tmux` |
| 11 | `shell` | `chsh` to zsh, asking first, and appends to `/etc/shells` | yes | no | `packages`, `chsh` needs zsh installed |

The order in `STEPS` is that dependency chain, nothing more. A missing
dependency is a clean skip with a log line, never a crash: **runtimes**
without mise, **extras_linux** without the cargo that `runtimes` provides,
**plugins** without network or before **symlinks**, **shell** without zsh.

Five deserve a note: **migrate** runs once per machine and never returns;
**gitsign** never overwrites a hand-written `config.local`; **prereqs** and
**shell** are the two that need sudo on macOS as well, the first because the
Homebrew installer calls `have_sudo_access` and aborts without it, the second
for `/etc/shells`; **extras_linux** is a clean no-op on macOS, where brew carries all
four.

## What each command replays

| Step | `install` | `update` | `upgrade` |
|---|---|---|---|
| prereqs, migrate, gitsign, extras_linux, shell | ✓ | | |
| submodules, directories, symlinks, packages, runtimes, plugins | ✓ | ✓ | |
| `git pull --ff-only` (before any step) | | ✓ | |
| version bumps (brew/dnf, mise, claude code, age-plugin-yubikey, zinit, TPM, submodules to latest) | | | ✓ |

The line between the two groups is not "what is risky", it is **where the
truth lives**. The six replayed steps read the repo: `manifest.sh`,
`fedora.txt`, `config.toml`, `.gitmodules`. Edit one of those, push, and the
other machine needs `update` to catch up. `gitsign` reads `~/.ssh`, and
`extras_linux` reads what is already installed plus your answer about a COPR. No
`git pull` can change either input, so replaying them after a pull would
recompute the same answer from the same data.

The practical consequence: a signing key added later needs
`./run install gitsign`, and a COPR declined once is offered again by
`./run install extras_linux`, never by an update. Which is also why `-y` cannot
enable a third-party repo behind your back: the step it lives in is not in
the update list at all.

> [!IMPORTANT]
> The **step** and the **tools it installed** are two different things.
> `upgrade` runs no step, yet it does maintain two of the four: lazygit rides
> the `dnf upgrade` it already performs, and age-plugin-yubikey has its own
> `cargo install --force` line in `upgrade.sh`. sops moves only when its pin
> is bumped in the repo, the font not at all
> ([packages.md](packages.md)).

## Adding a step

1. Create `setup/steps/<name>.sh`. `run_steps` sources it under `set -u` with
   `-e` turned OFF, so a failing command does NOT stop the step and the step's
   status is that of its LAST command. Check what can fail, by hand or through
   `run` / `run_soft`, and end on a line that says what you mean.
2. Add `<name>` to `STEPS` in `run`, at the right position.
3. Decide whether `update` must replay it, and if so add it to the list in
   `setup/commands/update.sh`. The rule is the one above: replay it only if
   its input lives in the repo. That list is hand-written on purpose, so
   nothing joins `update` behind your back — which also means nothing
   reminds you. A *typo* in that list is caught — `run_steps` logs an error and
   the command exits 1 — but an *omission* is not, and cannot be.
4. `./run install <name> -n`, then twice for real: the second run must be
   a no-op.

The libs are already sourced, so use them rather than reinventing:

| Helper | Use |
|---|---|
| `run <cmd…>` | run it, or print it under `--dry-run`. The default for anything that writes |
| `run_soft <cmd…>` | same, but a failure is logged and counted instead of stopping the run (network, package managers) |
| `run_steps <names…>` | run steps by name, capturing each exit code. A name matching no step is an error, not a silent skip |
| `log_step/info/ok/warn/error` | the only output channel; warn and error feed the final summary |
| `confirm "question?"` | asks on `/dev/tty`; yes under `-y` and `--dry-run` |
| `link_with_backup <src> <dst>` | inode-compared link, backup and restore-on-failure included |
| `backup_file` / `migrate_file` | move into this run's backup directory / relocate a legacy file |
| `pkg_install <pkgs…>` | `dnf install`, `run_soft`-wrapped. Fedora only: macOS goes through `brew bundle` |
| `is_macos` / `is_fedora` / `require_cmd <bin>` | branch on the platform, or fail loudly on a missing tool |
| `$_log_dir` | the run's private `mktemp -d`, removed by trap on every exit path. Where a step builds a scratch file. Read it as `"${_log_dir:?log.sh not sourced}"` |

Never call `exit` in a step: it kills `run` itself and the summary with
it. Use `return 1`: `run_steps` catches it and `log_summary` owns the exit
code.

## Third-party repos: asked, never assumed

The `extras_linux` step has exactly one place where `./run` adds a package source it
does not control: the lazygit COPR. That is a decision, so it goes through
`confirm`, the same helper `chsh` and the Homebrew bootstrap use. Declining is
a logged skip, not a failure, and the by-hand recipe stays in
[packages.md](packages.md).

The other three need no sudo and no third-party repo: sops and
the Nerd Font are downloaded, checked against the checksums file published
with the same release, and only then installed; age-plugin-yubikey is built by
the cargo that mise already provides. A checksum from the same origin as the
download proves integrity, not authenticity: it catches a truncated or altered
transfer, not a compromised release. Proving authenticity would mean verifying
the sigstore bundle with cosign, which is not part of this stack.

## Manual scripts (`scripts/`, on the PATH, never run by `./run`)

| Script | Effect |
|---|---|
| `osx.sh` | rewrites ~15 macOS `defaults` (Dock, Finder, screenshots) and disables the Spotlight shortcut. Read it before running |
| `tool42.sh` | installs norminette + c_formatter_42 (needs pipx, installed by mise). Lives HERE because the school repo installs nothing by design |
| `bootstrap-aidd.sh` | clones two private repos into `~/.config/aiddconf` and deploys their links |

---

See also: [architecture.md](architecture.md) for what these steps set up,
and [packages.md](packages.md) for where each package comes from.
