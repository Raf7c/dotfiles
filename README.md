# dotfiles

![macOS](https://img.shields.io/badge/macOS-000000?logo=apple&logoColor=white)
![Fedora](https://img.shields.io/badge/Fedora-51A2DA?logo=fedora&logoColor=white)
![Shell](https://img.shields.io/badge/shell-zsh%20%C2%B7%20bash-1a1a1a?logo=gnubash&logoColor=white)
![Install](https://img.shields.io/badge/install-POSIX%20sh%20%C2%B7%20idempotent-2ea44f)
![License](https://img.shields.io/badge/license-MIT-blue)

My entire working environment, versioned and reproducible: a single `./run install` takes a fresh machine (**macOS** or **Fedora**) to a ready-to-use workstation. `$HOME` stays clean: everything follows the [XDG Base Directory](https://specifications.freedesktop.org/basedir-spec/latest/) specification.

<!-- Drop a screenshot or GIF of your terminal (starship + tmux) at the repo
     root as preview.png, then add: ![Terminal preview](preview.png) -->

> [!WARNING]
> Don't blindly use my settings unless you know what they do. Use at your own risk!

## Requirements

- **macOS (Apple Silicon)** or **Fedora**
- Git
- An SSH key configured on GitHub — the clone and the submodule use SSH
- `sudo` is **not** needed for the shell configuration: `~/.zshenv` bootstraps
  `ZDOTDIR` from `$HOME`. It is only asked for to install packages with `dnf`
  on Fedora, and to append zsh to `/etc/shells` if you accept the `chsh` prompt.

> [!IMPORTANT]
> `./run install` **moves** four existing files out of `$HOME` into their XDG
> locations: `.bash_history`, `.zsh_history`, `.lesshst` and `.python_history`
> (see `dotfiles_history_migrations` in `setup/manifest.sh`). Nothing is
> deleted, but the paths change.

## Quick start

```sh
git clone --recurse-submodules git@github.com:Raf7c/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./run install
```

`install` is **idempotent**: you can re-run it safely, it only does what's missing. To preview without changing anything:

```sh
./run install --dry-run
```

> [!NOTE]
> The Neovim configuration is a Git submodule (`.config/nvim`).

## Commands

```sh
./run install     # install everything -> ready (idempotent)
./run update      # git pull + resync (links, packages, runtimes, submodules, tmux plugins)
./run upgrade     # bump versions (brew/dnf, mise, zinit, TPM, submodules)
```

Options: `-n`/`--dry-run` (preview), `-y`/`--yes` (no confirmation), `-h`/`--help`.
Target specific modules (install only): `./run install symlinks packages`.

## Scripts

`scripts/` is symlinked to `~/.config/scripts`, which is on the `PATH`: every
file in it is callable by name. **None of them is run by `./run`** — they are
manual tools, and two of them have side effects worth knowing about.

| Script | What it does |
|---|---|
| `verify-zsh.sh` | Read-only checks: `zsh -n`, empty stderr at startup, startup timing, `zprof`, shellcheck, and the `~/.zshenv` bootstrap. Run it after touching any zsh file. |
| `osx.sh` | **Rewrites about fifteen macOS `defaults`** (Dock, Finder, screenshots, keyboard) and disables the Spotlight shortcut. Read it before running it. |
| `tool42.sh` | Installs `norminette` and `c_formatter_42` (42 school toolchain). Needs python3. |
| `bootstrap-aidd.sh` | **Clones two private repositories** into `~/.config/aiddconf` and deploys the symlinks. Requires access to those repos. |

## Environment

Two variables reach beyond this repo:

- **`BASH_ENV`** is exported by `.bashrc` to `~/.config/shell/env.sh`, so *every
  non-interactive bash* on the machine sources it. That is how scripts inherit
  the same `PATH` and XDG variables — at the cost of one extra file read per
  bash subprocess.
- **`NO_COLOR`**, if set, disables every colour in the installer output
  (`setup/lib/log.sh`).

## Third-party plugins

zinit, TPM and their plugins are cloned from GitHub and sourced by every
interactive shell and every tmux server. They are **not pinned**, and that is a
decision rather than an oversight:

- a tag only *delays* an upstream compromise. At bump time you take whatever the
  new tag holds, with no more review than before;
- the clone is guarded, so exposure is not continuous: it happens on a fresh
  install or on `./run upgrade`, both of which you trigger yourself;
- eight hand-written versions are eight things that go stale.

Automatic updates are worth more here than a frozen version. The repository and
the installed state can drift, though -- a plugin removed from the config stays
on disk. This lists what a machine actually runs, and flags what is no longer
declared:

```sh
_zc="${ZDOTDIR:-${XDG_CONFIG_HOME:-$HOME/.config}/zsh}/zinit.zsh"
_tc="${XDG_CONFIG_HOME:-$HOME/.config}/tmux/tmux.conf"
git -C "${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git" rev-parse --short HEAD
find "${XDG_DATA_HOME:-$HOME/.local/share}/zinit/plugins" \
     "${XDG_CONFIG_HOME:-$HOME/.config}/tmux/plugins" \
     -mindepth 1 -maxdepth 1 -type d 2>/dev/null | while IFS= read -r _d; do
  [ -d "$_d/.git" ] || continue
  _n=${_d##*/}
  # zinit stores plugins as "user---repo"; tmux as plain "repo".
  case "$_n" in *---*) _r="${_n%%---*}/${_n#*---}" ;; *) _r=$_n ;; esac
  if grep -qF -- "$_r" "$_zc" "$_tc" 2>/dev/null; then
    printf '%-45s %s\n' "$_n" "$(git -C "$_d" rev-parse --short HEAD)"
  else
    printf '%-45s %s  <- ORPHAN, no longer declared\n' "$_n" \
      "$(git -C "$_d" rev-parse --short HEAD)"
  fi
done
```

`find` and not a glob: zsh aborts on a pattern that matches nothing, so a
missing plugin directory would kill the whole listing.

## Uninstall

The symlinks point into this repo: removing the repo just leaves dead links
(delete them at your convenience). Backups made by the installer live in
`~/.local/state/dotfiles/backups/<timestamp>/`.

The zsh config is bootstrapped by `~/.zshenv`, a symlink into this repo:
deleting it is enough, no root involved. The only system file `./run install`
can touch is `/etc/shells`, and only if you accept the `chsh` prompt:

```sh
# Optional: restore the previous login shell (zsh stays listed in /etc/shells)
chsh -s /bin/bash
```

Migrating from a version that wrote the bootstrap into `/etc/zshenv`? Remove
the old block once — `~/.zshenv` already does the job:

```sh
# works with BSD and GNU sed
sudo sed -i.bak '/# >>> dotfiles ZDOTDIR >>>/,/# <<< dotfiles ZDOTDIR <<</d' /etc/zshenv
```

## License

See [LICENSE](LICENSE).
