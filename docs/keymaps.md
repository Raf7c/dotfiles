# Keymaps

Every binding this configuration adds or changes. Defaults are not listed.

## zsh — line editing (vi mode)

`bindkey -v`, `KEYTIMEOUT=10` (100 ms to leave insert mode). bash mirrors
it (`set -o vi` in `.bashrc`) — same reflexes in the fallback shell.

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
| `g` / `gst` / `gd` / `gck` / `gcm` / `gcma` / `gbr` / `gbra` | git / status / diff / checkout / commit / commit -a / branch / branch -a | git |
| `ghc <repo>` | clones `github.com:$GITUSER/<repo>` into `$GHREPOS`, then cd | — |
| `glc <repo>` | same for GitLab into `$GLREPOS` | — |

`GITUSER`, `REPOS` (`~/lab`), `GHREPOS` (`$REPOS/github`) and `GLREPOS`
(`$REPOS/gitlab`) are set in `shell/env.sh` — change them there. The
directories are created by `./run install` (directories step).

These are **shell** aliases, not git aliases — `gst`, not `git st`. What
that costs is written where they live (`shell/aliases.sh`): outside an
interactive shell, git answers to plain git only. The git config itself
is documented at [.config/git/README.md](../.config/git/README.md).

## git objects — fzf-git.sh

[fzf-git.sh](https://github.com/junegunn/fzf-git.sh), loaded by zinit
when fzf is present. Every binding starts with `Ctrl-G`; the same
functions are also reachable as plain `gf*` commands.

| Binding | Alias | Object |
|---|---|---|
| `Ctrl-G Ctrl-F` | `gff` | files (tracked + untracked, with status) |
| `Ctrl-G Ctrl-B` | `gfb` | branches |
| `Ctrl-G Ctrl-T` | `gft` | tags |
| `Ctrl-G Ctrl-R` | `gfr` | remotes |
| `Ctrl-G Ctrl-H` | `gfh` | commit hashes |
| `Ctrl-G Ctrl-S` | `gfs` | stashes |
| `Ctrl-G Ctrl-L` | `gfl` | reflogs |
| `Ctrl-G Ctrl-W` | `gfw` | worktrees |
| `Ctrl-G Ctrl-E` | `gfe` | each ref (`git for-each-ref`) |
| `Ctrl-G ?` | `gfk` | the list of these bindings |

The binding **inserts** the selection into the command line; the alias
**prints** it — `git switch $(gfb)`. Inside the picker: `Ctrl-O` opens
in the browser, `Alt-E` in `$EDITOR`, `Ctrl-/` cycles the preview.

## Ghostty

No custom binding for now — stock defaults. Notable behaviours:
`copy-on-select = clipboard`, `macos-option-as-alt = true`.

---

See also: [tools.md](tools.md) — the tools behind these bindings ·
[terminals.md](terminals.md) — ghostty, kitty and their setup.
