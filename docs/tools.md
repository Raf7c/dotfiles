# Tools

The install list lives in `setup/packages/Brewfile` (macOS) and
`setup/packages/fedora.txt` — this page only adds what those files cannot
say: what each tool replaces, and why it earned its place. One line each; a
tool that needs more probably deserves its own page.

## Packages — three install tiers

`setup/steps/packages.sh` installs in three tiers:

1. **Native package manager** — `brew bundle` (Brewfile) on macOS, `dnf`
   (`fedora.txt`) on Fedora.
2. **No-sudo recipes** — starship, mise and claude-code are not in the
   Fedora repos: official scripts into `~/.local/bin`, idempotent
   (`command -v` first), downloaded **then** executed — never a straight
   `curl | sh`.
3. **Documented, by hand** — whatever needs a third-party repo or has no
   package: COPR (lazygit, ghostty), GitHub binary (sops), cargo
   (age-plugin-yubikey), the Nerd Font, GUI apps. Each has its recipe as a
   comment in `fedora.txt`; the installer reports (INFO) without ever
   blocking.

## Daily drivers

| Tool | Replaces | Why |
|---|---|---|
| [eza](https://github.com/eza-community/eza) | ls | icons, git status column, tree view — wired into `ls/ll/la/lt` |
| [bat](https://github.com/sharkdp/bat) | cat | syntax highlighting; also the fzf preview engine (config: `numbers,changes,header`) |
| [fd](https://github.com/sharkdp/fd) | find | saner syntax, .gitignore-aware; feeds fzf |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | grep | fast recursive search, .gitignore-aware |
| [fzf](https://github.com/junegunn/fzf) | — | the fuzzy layer: history (`^R`), files (`^T`, `^F`), cd (`Alt-C`), Tab menu |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | cd | frecency jumps: `z proj` |
| [starship](https://starship.rs) | PS1 | one prompt config for zsh and bash — see below |
| [btop](https://github.com/aristocratos/btop) | top | readable resource view |
| [lazygit](https://github.com/jesseduffield/lazygit) | — | staging hunks beats `git add -p` |
| [jq](https://github.com/jqlang/jq) | — | JSON on the command line |
| [just](https://github.com/casey/just) | — | named-command runner. NOT a make replacement: make builds (C, incremental targets), just runs repo tasks without the .PHONY ceremony |

## Prompt — starship

`.config/starship.toml`, one file for zsh and bash. The choice that
matters: the `format` is **closed** — it only lists the runtimes actually
installed (node, rust), because every module costs a probe at *every
prompt*, even when it prints nothing. OS symbol per machine, path truncated
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
ssh-keygen cannot sign with FIDO2 `sk-*` keys. Fedora needs neither — its
stock openssh ships with FIDO2 support, which is why the gitsign step
writes no `program` override there (`setup/steps/gitsign.sh`).

---

See also: [installer.md](installer.md) — how these tools get installed ·
[keymaps.md](keymaps.md) — their bindings.
