# Packages

Where every tool comes from on each OS, and what is left for you to do
by hand. Why a given tool is here at all: [tools.md](tools.md).

## Four install tiers

Two steps install software, and the package files stay bare lists: what is
**not** in them is described here, once.

1. **Native package manager** (`packages`). `brew bundle` (Brewfile) on
   macOS, `dnf` (`fedora.txt`) on Fedora.
2. **No-sudo recipes** (`packages`). starship, mise and claude-code are
   missing from the Fedora repos: official scripts into `~/.local/bin`,
   idempotent (`command -v`, **then** `~/.local/bin` directly: a shell started
   before that directory existed does not carry it on its PATH, and
   `command -v` alone would reinstall on every run), downloaded **then**
   executed, which guards against running a truncated download.
3. **What Fedora does not package** (`extras`, Fedora only). One COPR, asked
   before it is enabled, plus two downloads verified against the checksums
   published with the same release and one cargo build. macOS gets all four
   from brew, so the step is a no-op there.
4. **By hand.** The five GUI apps, because none of them publishes anything
   worth verifying. Recipes below.

## Installed for you

`./run install` handles everything in this table, on both systems.
Legend: **brew** / **cask** = Brewfile · **dnf** = fedora.txt · **mise** =
`.config/mise/config.toml` · **`./run`** = a recipe in `packages.sh`.

| Tool | macOS | Fedora |
|---|---|---|
| git · tmux · zsh · bash · tree · eza · zoxide · fzf · bat · ripgrep · btop · jq · make · cmake · just · ansible · ansible-lint · age | brew | dnf |
| kitty · firefox | cask | dnf |
| bash-completion | brew `bash-completion@2` | dnf `bash-completion` |
| fd | brew `fd` | dnf `fd-find` |
| gnupg | brew `gnupg` | dnf `gnupg2` |
| ykman | brew `ykman` | dnf `yubikey-manager` |
| chsh | built in | dnf `util-linux-user` |
| PC/SC, the smart-card layer the YubiKey PIV applet talks to | built into macOS | dnf `pcsc-lite` (+ `pcsc-lite-devel`, needed to compile age-plugin-yubikey) |
| wl-clipboard · xclip | pbcopy is built in | dnf |
| containers | cask `docker-desktop` | dnf `podman` (rootless; `podman-docker` adds the `docker` command name) |
| starship · mise | brew | **`./run`**, official script into `~/.local/bin` |
| claude-code | **`./run`** | **`./run`** |
| runtimes and the pinned linters | mise | mise |
| lazygit | brew | **`./run`** `extras`, COPR, asked first |
| sops · Nerd Font | brew, cask | **`./run`** `extras`, download + checksum |
| age-plugin-yubikey | brew | **`./run`** `extras`, `cargo install` |

## What the `extras` step does on Fedora

Four tools, and none of them is a matter of taste: each was checked against
`packages.fedoraproject.org` and is genuinely absent from the Fedora
repositories. Fedora ships the plain `jetbrains-mono-fonts`, which is not the
same font: the patched build carries the glyphs, the plain one does not.

| Tool | In Fedora? | Source used | Checked how |
|---|---|---|---|
| lazygit | no | COPR `dejan/lazygit`, from lazygit's README | dnf, COPR signature |
| sops | no | the `linux.<arch>` binary of a pinned release | SHA-256 against `checksums.txt` |
| Nerd Font | plain family only | `JetBrainsMono.tar.xz`, latest release | SHA-256 against `SHA-256.txt` |
| age-plugin-yubikey | no | `cargo install`, rust comes from mise | crates.io |

Only lazygit asks, because it is the only one adding a package source: a COPR
is signed by whoever maintains it, not by Fedora. The other three touch
nothing outside `$HOME` and need no sudo.

What keeps them up to date afterwards is not the same for all four, and the
difference is deliberate:

| Tool | Kept current by |
|---|---|
| lazygit | `./run upgrade`, through `dnf upgrade`: a COPR is a repo like any other |
| age-plugin-yubikey | `./run upgrade`, `cargo install --force` |
| sops | **you**: bump `_ex_sops_version` in `setup/steps/extras.sh`, commit, rerun `./run install extras`. The step compares the installed version to the pin and replaces it when they differ, so the bump is what triggers the change. Same rule as a mise pin: a version move is a tracked edit, never a side effect |
| Nerd Font | nothing. An unpacked archive with no security surface; delete the directory and rerun the step to refresh it |

Two details that bite. `cargo install age-plugin-yubikey` will not compile
without the `pcsc-lite-devel` headers, and the plugin will not talk to the
YubiKey without `pcsc-lite` and its `pcscd` service: both are in
`fedora.txt`. And cargo drops its own registry cache in `~/.cargo` whatever
happens, only the binary is redirected to `~/.local/bin`.

## Fedora: what stays in your hands

The five GUI apps, and only them. None publishes a checksum worth the code
it would take to verify, and two ship a tarball whose URL has to be
discovered through an API.

| Tool | macOS gets it from | On Fedora, you |
|---|---|---|
| obsidian · gitkraken | cask | `flatpak install` from flathub |
| google-chrome | cask | enable Google's own repo |
| jetbrains-toolbox · keymapp | cask | official tarball, unpacked by hand |

## macOS only, on purpose

| Tool | Why nothing on Fedora |
|---|---|
| openssh · libfido2 | Fedora's stock openssh already signs `sk-*` keys |
| ghostty | its own docs call every Linux package a community build and say installing one means accepting a third party could have tampered with it. kitty comes from dnf and does the same job |
| cloudflared | deliberately not installed there |
| raycast · claude (desktop) | no Linux build exists |

## What mise pins

One installer per tool, and the versions live in
`.config/mise/config.toml` rather than in a package manager, so both
machines and the CI run the same thing.

| Tool | Pin |
|---|---|
| neovim | `0.12` |
| node | `24` |
| python | `3.14` |
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

<details>
<summary><b>Declined the COPR, or want it later</b></summary>

The `extras` step offers it again on every `./run install extras`, and never
during an update. To do it yourself, this is exactly what it would run:

```sh
sudo dnf copr enable dejan/lazygit && sudo dnf install lazygit
```

</details>

<details>
<summary><b>The Nerd Font</b>, once it is installed</summary>

The step unpacks it into `~/.local/share/fonts/JetBrainsMonoNerd` and
refreshes the cache. What it cannot do is pick it for you: point the
terminal at the family name `JetBrainsMono Nerd Font`. Without it the
prompt is a row of empty boxes, since starship, `eza --icons` and the tmux
status bar all draw from its private glyph range.

</details>

<details>
<summary><b>The GUI apps</b>, flathub for two, downloads for three</summary>

Obsidian and GitKraken come from flathub:

```sh
flatpak install flathub md.obsidian.Obsidian com.axosoft.GitKraken
```

The last three have no package at all: **jetbrains-toolbox** is a tarball
from `jetbrains.com/toolbox-app`, unpacked anywhere you own and started
once with `./bin/jetbrains-toolbox`, which writes its own `.desktop` entry;
**keymapp** a tarball from `zsa.io/flash` (it needs `libwebkit2gtk` 4.1);
and **google-chrome** comes from Google's own repo:

```sh
sudo dnf install fedora-workstation-repositories
sudo dnf config-manager setopt google-chrome.enabled=1
sudo dnf install google-chrome-stable
```

</details>

## Security

Secrets and YubiKey tooling on both platforms: age, sops,
age-plugin-yubikey and ykman via the Brewfile on macOS; on Fedora, `age`,
`yubikey-manager` and the `pcsc-lite` pair come from the base repos, while
sops and age-plugin-yubikey are handled by the `extras` step.

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
| mise | **2026.8.9** | the June batch (GHSA-436v-8fw5-4mj8 and friends, closed in 2026.6.4), the July advisory on shell arguments read from an untrusted local config (GHSA-g74g-rg72-j2p3, the incomplete-fix follow-up to CVE-2026-55448, closed in 2026.7.14), and the August GitLab/Forgejo token leak (GHSA-w8pw-h853-frw2, closed in 2026.8.9) | `setup/steps/packages.sh` warns below it |
| tmux | **3.6b** | CVE-2026-11623, a Sixel use-after-free. The floor is the only thing that closes it: `allow-passthrough` does not gate Sixel, upstream parses the image before reading that option | nothing automatic, `tmux -V`, and `tmux display -p '#{sixel_support}'` for whether the build carries Sixel at all |

> [!IMPORTANT]
> Revise this table whenever you touch either check. A floor that is never
> revised stops being a floor and becomes folklore.

---

See also: [tools.md](tools.md) for what each tool replaces and why, and
[installer.md](installer.md) for the `packages` step and its contract.
