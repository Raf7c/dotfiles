# Terminals & multiplexer

## [Ghostty](https://ghostty.org) (macOS, primary)

Config: `.config/ghostty/config`. The notable choices:

- **Font**: `JetBrainsMono Nerd Font Mono` — the *Nerd Font* variant
  matters: starship, eza and the tmux status bar print glyphs from its
  private range; plain "JetBrains Mono" renders them as tofu (empty
  boxes). Installed by the packages step (`font-jetbrains-mono-nerd-font`
  cask).
- **Theme**: follows the OS appearance (Catppuccin Latte / Mocha).
- `copy-on-select = clipboard`, `macos-option-as-alt = true`.
- OSC 52 is on by default in Ghostty — this is what makes tmux copy work
  across SSH with zero remote-side binary.

## [Kitty](https://sw.kovidgoyal.net/kitty/) (Fedora fallback)

Installed on both OSes; the terminal of choice on Fedora since ghostty is
not in the base repos.

Config: `.config/kitty/kitty.conf`. The notable choices:

- **Mirror of ghostty**: same font, same sizes, `copy_on_select`,
  opacity/blur — one visual identity, whichever terminal runs.
- **Theme**: follows the OS appearance (Catppuccin Latte / Mocha) via the
  `*-theme.auto.conf` files — kitty's native mechanism (≥ 0.38), the
  equivalent of ghostty's `theme = light:…,dark:…`.
- **Vendored themes**: both Catppuccin palettes live verbatim in `themes/`
  (MIT, upstream in the header). Static colours, no executed code: outside
  the plugin policy's scope.
- `shell_integration no-cursor`: without it, kitty's shell integration
  forces a beam cursor at the prompt where ghostty keeps the block.

## tmux

Documented with its config:
[.config/tmux/README.md](../.config/tmux/README.md) — bindings, theme,
clipboard, plugins.

---

See also: [keymaps.md](keymaps.md) — zsh and fzf bindings ·
[tools.md](tools.md) — the rest of the CLI tooling.
