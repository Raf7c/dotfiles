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

## License

See [LICENSE](LICENSE).
