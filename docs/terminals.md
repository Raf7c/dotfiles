# Terminals & multiplexer

## [Ghostty](https://ghostty.org) (macOS, primary)

Config: `.config/ghostty/config`. The notable choices:

- **Font**: `JetBrainsMono Nerd Font Mono`. The *Nerd Font* variant
  matters: starship, eza and the tmux status bar print glyphs from its
  private range; plain "JetBrains Mono" renders them as tofu (empty
  boxes). Installed by `./run`: the `font-jetbrains-mono-nerd-font` cask on
  macOS, the `extras_fedora` step on Fedora.
- **Theme**: follows the OS appearance (Catppuccin Latte / Mocha).
- `copy-on-select = clipboard`, `macos-option-as-alt = true`.
- `cursor-style = block` **and** `shell-integration-features = no-cursor`:
  the second is what makes the first true. Ghostty's shell integration sets
  a bar at the prompt *"regardless of this configuration"*, so the block
  would survive everywhere except where you actually look at it.
- OSC 52 is on by default in Ghostty, which is what makes tmux copy work
  across SSH with zero remote-side binary.

## [Kitty](https://sw.kovidgoyal.net/kitty/) (Fedora fallback)

Installed on both OSes, and the terminal on Fedora, where ghostty is
deliberately absent: its own documentation says the project publishes
official binaries for macOS only, and that every Linux package is a
community build ([packages.md](packages.md)).

Config: `.config/kitty/kitty.conf`. The notable choices:

- **Mirror of ghostty**: same font, same sizes, `copy_on_select`,
  opacity/blur: one visual identity, whichever terminal runs.
- **Theme**: follows the OS appearance (Catppuccin Latte / Mocha) via the
  `*-theme.auto.conf` files, kitty's native mechanism (≥ 0.38) and the
  equivalent of ghostty's `theme = light:…,dark:…`.
- **Vendored themes**: both Catppuccin palettes live verbatim in `themes/`
  (MIT, upstream in the header). Static colours, no executed code: outside
  the plugin policy's scope.
- `shell_integration no-cursor`: without it, kitty's shell integration
  forces a beam cursor at the prompt. Ghostty does exactly the same thing
  and is disarmed the same way, one line above in its own config: both
  terminals keep the block only because they are told to.

## tmux

Documented with its config:
[.config/tmux/README.md](../.config/tmux/README.md): bindings, theme,
clipboard, plugins.

---

See also: [usage.md](usage.md) for zsh and fzf bindings, and
[tools.md](tools.md) for the rest of the CLI tooling.
