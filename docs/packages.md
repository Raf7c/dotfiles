# Packages

Where every tool comes from on each OS, and what is left for you to do
by hand. Why a given tool is here at all: [tools.md](tools.md).

## Three install tiers

`setup/steps/packages.sh` installs in three tiers, and the package files
stay bare lists: what is **not** in them is described here, once.

1. **Native package manager.** `brew bundle` (Brewfile) on macOS, `dnf`
   (`fedora.txt`) on Fedora.
2. **No-sudo recipes.** starship, mise and claude-code are missing from
   the Fedora repos: official scripts into `~/.local/bin`, idempotent
   (`command -v` first), downloaded **then** executed, which guards
   against running a truncated download.
3. **By hand.** Whatever needs a third-party repo or has no package.
   The installer reports (INFO) and never blocks; the recipes are below.

## Installed for you

`./run install` handles everything in this table, on both systems.
Legend: **brew** / **cask** = Brewfile · **dnf** = fedora.txt · **mise** =
`.config/mise/config.toml` · **`./run`** = a recipe in `packages.sh`.

| Tool | macOS | Fedora |
|---|---|---|
| git · tmux · zsh · bash · tree · eza · zoxide · fzf · bat · ripgrep · btop · jq · make · cmake · just · ansible · ansible-lint · age · kitty · firefox | brew | dnf |
| bash-completion | brew `bash-completion@2` | dnf `bash-completion` |
| fd | brew `fd` | dnf `fd-find` |
| gnupg | brew `gnupg` | dnf `gnupg2` |
| ykman | brew `ykman` | dnf `yubikey-manager` |
| chsh | built in | dnf `util-linux-user` |
| wl-clipboard · xclip | pbcopy is built in | dnf |
| containers | cask `docker-desktop` | dnf `podman` (rootless; `podman-docker` adds the `docker` command name) |
| starship · mise | brew | **`./run`**, official script into `~/.local/bin` |
| claude-code | **`./run`** | **`./run`** |
| runtimes and the pinned linters | mise | mise |

## Fedora: what stays in your hands

Six things the installer will not do for you, because each needs a
third-party repo or has no package at all. It says so (INFO) and carries
on.

| Tool | macOS gets it from | On Fedora, you |
|---|---|---|
| lazygit | brew | enable COPR `atim/lazygit` |
| ghostty | cask | enable COPR `pgdev/ghostty` (kitty from dnf is the fallback) |
| sops | brew | drop the binary from the getsops GitHub releases |
| age-plugin-yubikey | brew | `cargo install age-plugin-yubikey` |
| Nerd Font | cask `font-jetbrains-mono-nerd-font` | unzip it into `~/.local/share/fonts` (recipe below) |
| jetbrains-toolbox · gitkraken · obsidian · keymapp · google-chrome | cask | flatpak, official tarball or vendor repo (recipes below) |

## macOS only, on purpose

| Tool | Why nothing on Fedora |
|---|---|
| openssh · libfido2 | Fedora's stock openssh already signs `sk-*` keys |
| cloudflared | deliberately not installed there |
| raycast · claude (desktop) | no Linux build exists |

## What mise pins

One installer per tool, and the versions live in
`.config/mise/config.toml` rather than in a package manager, so both
machines and the CI run the same thing.

| Tool | Pin |
|---|---|
| neovim | `0.12` |
| node | `22` |
| python | `3.13` |
| rust | `1` |
| shellcheck | `0.11` |
| shfmt | `3.13` |
| yamllint | `1` |
| pipx | `latest` |
| tree-sitter | `latest` |
| usage | `latest` |

Majors are pinned on purpose: `latest` installs whatever exists on the
day, so two machines set up a month apart would diverge and
"reproducible" would stop being true. Minor and patch updates still flow
through `./run upgrade`; majors get bumped in the file, deliberately.

`latest` is reserved for low-risk plumbing, the three entries above that
nothing depends on version-wise: pipx, tree-sitter and usage.

## Fedora, the by-hand recipes

One block per line of the table above, in the same order.

<details>
<summary><b>lazygit and ghostty</b>, from COPR</summary>

Enabling a third-party repo is a decision, not a detail, which is why the
installer leaves these two alone.

```sh
sudo dnf copr enable atim/lazygit && sudo dnf install lazygit
sudo dnf copr enable pgdev/ghostty && sudo dnf install ghostty
```

</details>

<details>
<summary><b>sops</b>, a prebuilt binary</summary>

Take the `linux.amd64` asset from the latest release on
`github.com/getsops/sops`, then:

```sh
chmod +x ~/Downloads/sops-*.linux.amd64
mv ~/Downloads/sops-*.linux.amd64 ~/.local/bin/sops
```

</details>

<details>
<summary><b>age-plugin-yubikey</b>, through cargo</summary>

Not packaged anywhere, but rust is already there through mise:

```sh
cargo install age-plugin-yubikey
```

</details>

<details>
<summary><b>The Nerd Font</b>, required and not in the repos</summary>

Required, not cosmetic: starship, `eza --icons` and the tmux status bar
all draw glyphs from its private range, and without it the prompt is a
row of empty boxes. Fedora packages the plain JetBrains Mono, which has
none of those glyphs, and the patched build is not in the repos.
Installing it in the user font directory needs neither sudo nor COPR.
Download `JetBrainsMono.zip` from the nerd-fonts releases, then:

```sh
mkdir -p ~/.local/share/fonts
unzip -o ~/Downloads/JetBrainsMono.zip -d ~/.local/share/fonts/JetBrainsMonoNerd
fc-cache -f ~/.local/share/fonts
```

Then point the terminal at the family name `JetBrainsMono Nerd Font`.

</details>

<details>
<summary><b>The GUI apps</b>, flathub for two, downloads for three</summary>

Obsidian and GitKraken come from flathub:

```sh
flatpak install flathub md.obsidian.Obsidian com.axosoft.GitKraken
```

The last three have no package at all: **jetbrains-toolbox** is a tarball
from `jetbrains.com/toolbox-app`, **keymapp** a tarball from
`zsa.io/flash` (it needs `libwebkit2gtk` 4.1), and **google-chrome** comes
from Google's own repo:

```sh
sudo dnf install fedora-workstation-repositories
sudo dnf config-manager setopt google-chrome.enabled=1
sudo dnf install google-chrome-stable
```

</details>

## Security

Secrets and YubiKey tooling on both platforms: age, sops,
age-plugin-yubikey and ykman via the Brewfile on macOS; on Fedora, `age`
and `yubikey-manager` come from the base repos, sops and
age-plugin-yubikey do not (see the comments in `fedora.txt`).

Homebrew openssh + libfido2 exist only to fix a macOS gap: Apple's
ssh-keygen cannot sign with FIDO2 `sk-*` keys. Side effect: the formula
is not keg-only, so brew's `ssh` shadows Apple's: any `UseKeychain` in
`~/.ssh/config` needs an `IgnoreUnknown UseKeychain` line before it.
Fedora needs neither, its stock openssh shipping with FIDO2 support,
which is why the gitsign step writes no `program` override there
(`setup/steps/gitsign.sh`).

Two version floors are enforced, and both are **perishable data**: they live
here, and the code points back at this page rather than repeating them.

| Tool | Floor | What it closes | Enforced by |
|---|---|---|---|
| mise | **2026.7.14** | the July advisory on shell arguments taken from an untrusted local config (High), the incomplete-fix follow-up to it, and the June batch (GHSA-436v-8fw5-4mj8 and friends) | `setup/steps/packages.sh` warns below it |
| tmux | **3.6b** | CVE-2026-11623, a Sixel use-after-free. `allow-passthrough on` is precisely what lets those sequences reach the terminal | nothing automatic, check `tmux -V` |

> [!IMPORTANT]
> Revise this table whenever you touch either check. A floor that is never
> revised stops being a floor and becomes folklore.

---

See also: [tools.md](tools.md) for what each tool replaces and why, and
[installer.md](installer.md) for the `packages` step and its contract.
