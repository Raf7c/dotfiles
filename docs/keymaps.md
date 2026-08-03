# Keymaps

Every binding this configuration adds or changes. Defaults are not listed.

## zsh — line editing (vi mode)

`bindkey -v`, `KEYTIMEOUT=10` (100 ms to leave insert mode).

| Key | Action | Source |
|---|---|---|
| `Esc` | normal mode (vi) | `.zshrc` |
| `Ctrl-R` | fuzzy history search (fzf) | `fzf --zsh` |
| `Ctrl-T` | fuzzy file picker, bat preview | `fzf --zsh` |
| `Alt-C` | fuzzy cd into a subdirectory | `fzf --zsh` |
| `Ctrl-F` | file picker **without** hidden files | `fzf.zsh` widget |
| `Tab` | fzf-tab completion menu (`<`/`>` switch groups, `Tab` moves down) | fzf-tab |

fzf uses `fd` when present, `find` otherwise; previews use `bat`, then
`head` as fallback — every binding works on a machine that has none of the
three.

## tmux

Documented with its config:
[.config/tmux/README.md](../.config/tmux/README.md) — bindings, theme,
clipboard, plugins.

## Shell aliases and functions

| Alias | Becomes | Needs |
|---|---|---|
| `ls` / `ll` / `la` / `lt` | `eza` with icons, git status, tree | eza (fallback: `ls -lh`) |
| `cat` | `bat` | bat |
| `diff` | `diff --color=auto` | GNU diff (probed) |
| `v` | `nvim` | — |
| `path` | `$PATH`, one directory per line | — |
| `ghc <repo>` | clones `github.com:$GITUSER/<repo>` into `$GHREPOS`, then cd | — |
| `glc <repo>` | same for GitLab into `$GLREPOS` | — |

`GITUSER`, `REPOS` (`~/lab`), `GHREPOS` (`$REPOS/github`) and `GLREPOS`
(`$REPOS/gitlab`) are set in `shell/env.sh` — change them there. The
directories are created by `./run install` (directories step).

The **git** aliases (`st`, `cm`, `br`…) are documented with their config:
[.config/git/README.md](../.config/git/README.md).

## Ghostty

No custom binding for now — stock defaults. Notable behaviours:
`copy-on-select = clipboard`, `macos-option-as-alt = true`.

---

See also: [tools.md](tools.md) — the tools behind these bindings ·
[terminals.md](terminals.md) — ghostty, kitty and their setup.
