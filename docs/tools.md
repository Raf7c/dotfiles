# Tools

Why each tool is here: what it replaces, and what it earned its place
with. One line each; a tool that needs more deserves its own page. Where
each one comes from on which OS: [packages.md](packages.md).

## Daily drivers

| Tool | Replaces | Why |
|---|---|---|
| [eza](https://github.com/eza-community/eza) | ls | icons, git status column, tree view, wired into `ls/ll/la/lt` |
| [bat](https://github.com/sharkdp/bat) | cat | syntax highlighting; also the fzf preview engine (config: `numbers,changes,header`; the fzf preview overrides it with `plain,numbers`) |
| [fd](https://github.com/sharkdp/fd) | find | saner syntax, .gitignore-aware; feeds fzf |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | grep | fast recursive search, .gitignore-aware |
| [fzf](https://github.com/junegunn/fzf) | nothing | the fuzzy layer: history (`^R`), files (`^T`, `^F`), cd (`Alt-C`), Tab menu |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | cd | frecency jumps: `z proj` |
| [starship](https://starship.rs) | PS1 | one prompt config for zsh and bash, see below |
| [btop](https://github.com/aristocratos/btop) | top | readable resource view |
| [lazygit](https://github.com/jesseduffield/lazygit) | nothing | staging hunks beats `git add -p` |
| [jq](https://github.com/jqlang/jq) | nothing | JSON on the command line |
| [just](https://github.com/casey/just) | nothing | named-command runner. NOT a make replacement: make builds (C, incremental targets), just runs repo tasks without the .PHONY ceremony |

## Editors: nvim, and vim behind it

nvim carries the real config, as a submodule
([.config/nvim](https://github.com/Raf7c/nvim)). `vim` gets five lines in
`.vimrc` so a file edited without nvim keeps the same indentation:
**tabs, never spaces, four columns wide**.

`~/.vimrc` and not the XDG path on purpose: vim only reads
`~/.config/vim/vimrc` since 9.1.0327, so the XDG route would be ignored in
silence on an older vim.

## Prompt: starship

`.config/starship.toml`, one file for zsh and bash. The choice that
matters: the `format` is **closed**, listing only the runtimes actually
installed (node, rust), because every module costs a probe at *every
prompt*, even when it prints nothing. OS symbol per machine, path truncated
to 4 and cut at the repo root. Glyphs: Nerd Font required (see
[terminals.md](terminals.md)).

## Runtimes: mise

[mise](https://mise.jdx.dev) owns every runtime and every linter whose
verdict this repo trusts. It is why neovim is NOT in the Brewfile: one
installer per tool, no shadowed copies, and the same versions on both
machines. The list and the pins: [packages.md](packages.md).

## Shell quality

[shellcheck](https://www.shellcheck.net) +
[shfmt](https://github.com/mvdan/sh): **version-pinned by mise**
(`.config/mise/config.toml`), not taken from brew or dnf, because their output
defines conformance, so every machine and the CI must lint with the same
version (shfmt can change its formatting on a minor bump). Enforced by
`.editorconfig` and the CI: the repo's own scripts must pass both. The
formatter is an authority, not a suggestion.

---

See also: [packages.md](packages.md) for who installs what and where,
and [usage.md](usage.md) for the bindings and aliases these tools answer
to.
