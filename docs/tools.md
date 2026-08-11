# Tools

The install list lives in `setup/packages/Brewfile` (macOS) and
`setup/packages/fedora.txt` — this page only adds what those files cannot
say: what each tool replaces, and why it earned its place. One line each; a
tool that needs more probably deserves its own page.

## Packages — where each tool comes from

`setup/steps/packages.sh` installs in three tiers, and the package files
stay bare lists: what is **not** in them is described here, once.

1. **Native package manager** — `brew bundle` (Brewfile) on macOS, `dnf`
   (`fedora.txt`) on Fedora.
2. **No-sudo recipes** — starship, mise and claude-code are missing from
   the Fedora repos: official scripts into `~/.local/bin`, idempotent
   (`command -v` first), downloaded **then** executed, which guards
   against running a truncated download.
3. **By hand** — whatever needs a third-party repo or has no package.
   The installer reports (INFO) and never blocks; the recipes are below.

Legend: **brew** / **cask** = Brewfile · **dnf** = fedora.txt · **mise**
= `.config/mise/config.toml` · **`./run`** = recipe in packages.sh ·
**hand** = you, once per machine · **—** = deliberately absent.

| Tool                                                                                                                                                   | macOS                                        | Fedora                                                  |
| ------------------------------------------------------------------------------------------------------------------------------------------------------ | -------------------------------------------- | ------------------------------------------------------- |
| git · tmux · zsh · bash · tree · eza · zoxide · fzf · bat · ripgrep · btop · jq · make · cmake · just · ansible · ansible-lint · age · kitty · firefox | brew                                         | dnf                                                     |
| bash-completion                                                                                                                                        | brew `bash-completion@2`                     | dnf `bash-completion`                                   |
| fd                                                                                                                                                     | brew `fd`                                    | dnf `fd-find`                                           |
| gnupg                                                                                                                                                  | brew `gnupg`                                 | dnf `gnupg2`                                            |
| ykman                                                                                                                                                  | brew `ykman`                                 | dnf `yubikey-manager`                                   |
| chsh                                                                                                                                                   | built in                                     | dnf `util-linux-user`                                   |
| wl-clipboard · xclip                                                                                                                                   | pbcopy is built in                           | dnf                                                     |
| starship · mise                                                                                                                                        | brew                                         | **`./run`** → `~/.local/bin`                            |
| claude-code                                                                                                                                            | **`./run`** → `~/.local/bin`                 | **`./run`** → `~/.local/bin`                            |
| neovim · node · python · rust · tree-sitter                                                                                                            | mise                                         | mise                                                    |
| shellcheck · shfmt · yamllint · pipx                                                                                                                   | mise                                         | mise                                                    |
| lazygit                                                                                                                                                | brew                                         | **hand** — COPR `atim/lazygit`                          |
| ghostty                                                                                                                                                | cask                                         | **hand** — COPR `pgdev/ghostty` (kitty is the fallback) |
| sops                                                                                                                                                   | brew                                         | **hand** — binary from the getsops GitHub releases      |
| age-plugin-yubikey                                                                                                                                     | brew                                         | **hand** — `cargo install age-plugin-yubikey`           |
| Nerd Font                                                                                                                                              | cask `font-jetbrains-mono-nerd-font`         | **hand** — see below                                    |
| docker                                                                                                                                                 | cask `docker-desktop`                        | **hand** — `sudo dnf install podman`                    |
| jetbrains-toolbox · gitkraken · obsidian · keymapp · google-chrome                                                                                     | cask                                         | **hand** — flatpak / official tarball / vendor repo     |
| openssh · libfido2                                                                                                                                     | brew (Apple's ssh-keygen cannot sign `sk-*`) | — Fedora's stock openssh already does                   |
| cloudflared                                                                                                                                            | brew                                         | — deliberately macOS-only                               |
| raycast · claude (desktop)                                                                                                                             | cask                                         | — no Linux build                                        |

### Fedora — the by-hand recipes

```sh
# Nerd Font (REQUIRED: starship, eza --icons and the tmux bar print glyphs
# from its private range; without it the prompt is a row of tofu).
# The patched build is not in the repos — no sudo, no COPR needed:
mkdir -p ~/.local/share/fonts
# download JetBrainsMono.zip from the nerd-fonts releases, then:
unzip -o JetBrainsMono.zip -d ~/.local/share/fonts/JetBrainsMonoNerd
fc-cache -f ~/.local/share/fonts
# then point the terminal at "JetBrainsMono Nerd Font"

# GUI apps
flatpak install flathub md.obsidian.Obsidian com.axosoft.GitKraken
# jetbrains-toolbox : tarball from jetbrains.com/toolbox-app
# keymapp           : tarball from zsa.io/flash (needs libwebkit2gtk 4.1)
# google-chrome     : sudo dnf install fedora-workstation-repositories,
#                     enable the google-chrome repo, then dnf install
#                     google-chrome-stable
```

## Daily drivers

| Tool                                                | Replaces | Why                                                                                                                                  |
| --------------------------------------------------- | -------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| [eza](https://github.com/eza-community/eza)         | ls       | icons, git status column, tree view — wired into `ls/ll/la/lt`                                                                       |
| [bat](https://github.com/sharkdp/bat)               | cat      | syntax highlighting; also the fzf preview engine (config: `numbers,changes,header`)                                                  |
| [fd](https://github.com/sharkdp/fd)                 | find     | saner syntax, .gitignore-aware; feeds fzf                                                                                            |
| [ripgrep](https://github.com/BurntSushi/ripgrep)    | grep     | fast recursive search, .gitignore-aware                                                                                              |
| [fzf](https://github.com/junegunn/fzf)              | —        | the fuzzy layer: history (`^R`), files (`^T`, `^F`), cd (`Alt-C`), Tab menu                                                          |
| [zoxide](https://github.com/ajeetdsouza/zoxide)     | cd       | frecency jumps: `z proj`                                                                                                             |
| [starship](https://starship.rs)                     | PS1      | one prompt config for zsh and bash — see below                                                                                       |
| [btop](https://github.com/aristocratos/btop)        | top      | readable resource view                                                                                                               |
| [lazygit](https://github.com/jesseduffield/lazygit) | —        | staging hunks beats `git add -p`                                                                                                     |
| [jq](https://github.com/jqlang/jq)                  | —        | JSON on the command line                                                                                                             |
| [just](https://github.com/casey/just)               | —        | named-command runner. NOT a make replacement: make builds (C, incremental targets), just runs repo tasks without the .PHONY ceremony |

## Prompt — starship

`.config/starship.toml`, one file for zsh and bash. The choice that
matters: the `format` is **closed** — it only lists the runtimes actually
installed (node, rust), because every module costs a probe at _every
prompt_, even when it prints nothing. OS symbol per machine, path truncated
to 4 and cut at the repo root. Glyphs: Nerd Font required (see
[terminals.md](terminals.md)).

## Runtimes — mise

Node, python, rust and neovim are versioned by
[mise](https://mise.jdx.dev) in `.config/mise/config.toml` (majors pinned,
minors flow via `./run upgrade`). This is why neovim is NOT in the
Brewfile: one installer per tool, no shadowed copies.

## Shell quality

[shellcheck](https://www.shellcheck.net) +
[shfmt](https://github.com/mvdan/sh): **version-pinned by mise**
(`.config/mise/config.toml`), not taken from brew or dnf — their output
defines conformance, so every machine and the CI must lint with the same
version (shfmt can change its formatting on a minor bump). Enforced by
`.editorconfig` and the CI: the repo's own scripts must pass both —
the formatter is an authority, not a suggestion.

## Security

Secrets and YubiKey tooling on both platforms: age, sops,
age-plugin-yubikey and ykman via the Brewfile on macOS; on Fedora, `age`
and `yubikey-manager` come from the base repos, sops and
age-plugin-yubikey do not (see the comments in `fedora.txt`).

Homebrew openssh + libfido2 exist only to fix a macOS gap: Apple's
ssh-keygen cannot sign with FIDO2 `sk-*` keys. Side effect: the formula
is not keg-only, so brew's `ssh` shadows Apple's — any `UseKeychain` in
`~/.ssh/config` needs an `IgnoreUnknown UseKeychain` line before it. Fedora needs neither — its
stock openssh ships with FIDO2 support, which is why the gitsign step
writes no `program` override there (`setup/steps/gitsign.sh`).

Version floor: **mise ≥ 2026.7.14** — the 2026 advisories (config
trust-check bypass and its incomplete-fix follow-up) are fixed there;
the packages step warns below it. A floor is perishable: it gets revised
whenever the check is touched.

---

See also: [installer.md](installer.md) — how these tools get installed ·
[keymaps.md](keymaps.md) — their bindings.
