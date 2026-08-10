# tmux

Everything tmux lives here, next to its config — bindings, theme,
clipboard, plugins.

Prefix: **`Ctrl-Space`** (`C-b` unbound). vi keys everywhere, windows and
panes numbered from 1 (renumbered on close), 100k lines of history per
pane (scrollback is RAM), `escape-time 10` (the upstream default — 0 can
split escape sequences over slow ssh), `focus-events` (nvim autoread),
`allow-passthrough` (OSC/images through tmux), `detach-on-destroy off`
(destroying the last session switches to another instead of detaching).

## Bindings

### Sessions, windows, panes

| Key | Action |
|---|---|
| `prefix r` | reload tmux.conf |
| `prefix b` | horizontal split, same directory |
| `prefix v` | vertical split, same directory |
| `prefix c` | new window, same directory |
| `Ctrl-h/j/k/l` | navigate panes **and** nvim splits (vim-tmux-navigator) |
| `prefix h/j/k/l` | resize pane by 5 (repeatable) |
| `prefix m` | pane zoom (toggle) |
| `prefix Shift-←/→` | move window left / right (repeatable) |

### Copy mode (vi keys)

| Key | Action |
|---|---|
| `v` | begin selection |
| `V` | line selection |
| `Ctrl-v` | rectangle selection |
| `y` / `Enter` | copy and exit |
| `Esc` | clear selection |
| `prefix P` | paste the tmux buffer |

Mouse drag does **not** auto-copy (deliberate: the selection survives
releasing the button).

## Theme

Hand-written status bar on the
[Catppuccin](https://github.com/catppuccin/catppuccin) palette — not the
official plugin: two files in `themes/` (`latte.conf` / `mocha.conf`), zero
extra dependency.
Selected automatically **at server start**: macOS appearance (`defaults`)
or GNOME (`gsettings`), falling back to **mocha** when undetectable (ssh,
headless server — a pale bar would be unreadable there, the reverse still
reads). `TMUX_THEME=light|dark` forces the choice. No continuous
re-evaluation: after an OS light/dark switch, `prefix r` re-applies —
manual by design, a per-OS hook would cost more than it returns.

## Clipboard

Every copy helper is **probed** (`command -v`) before use — pbcopy
(macOS), wl-copy (Wayland), xclip (X11). If none exists (root-free
install, bare server): plain tmux selection as fallback, and
`set-clipboard on` still emits OSC 52 — the terminal gets the copy, SSH
included, zero remote-side binary required.

## Plugins (via TPM, cloned into `plugins/`, gitignored)

| Plugin | Role |
|---|---|
| [tpm](https://github.com/tmux-plugins/tpm) | plugin manager (`prefix I` installs, `prefix U` updates) |
| [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) | `Ctrl-h/j/k/l` across tmux panes *and* nvim splits |
| [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect) | save/restore sessions (nvim strategy: `session`) |
| [tmux-continuum](https://github.com/tmux-plugins/tmux-continuum) | auto-save every 15 min, restore at server start |
| [tmux-cpu-mem-monitor](https://github.com/hendrikmi/tmux-cpu-mem-monitor) | cpu / mem / disk in the bar (needs python3). Individual-maintainer upstream, knowingly accepted: it publishes no tag to pin, and exposure stays bounded to `prefix I`/`U` |

Unpinned — same policy as zinit:
[docs/architecture.md](../../docs/architecture.md).
