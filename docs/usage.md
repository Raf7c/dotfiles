# Usage

Everything you type: the bindings this configuration adds or changes, and
the aliases it defines. Stock defaults are not listed.

## zsh: line editing (vi mode)

`bindkey -v`, `KEYTIMEOUT=10` (100 ms to leave insert mode). bash mirrors
it (`set -o vi` in `.bashrc`), so the reflexes carry over to the fallback
shell.

| Key | Action | Source |
|---|---|---|
| `Esc` | normal mode (vi) | `.zshrc` |
| `Ctrl-R` | fuzzy history search (fzf) | `fzf --zsh` |
| `Ctrl-T` | fuzzy file picker, bat preview | `fzf --zsh` |
| `Alt-C` | fuzzy cd into a subdirectory | `fzf --zsh` |
| `Ctrl-F` | file picker **without** hidden files | `fzf.zsh` widget |
| `Tab` | fzf-tab completion menu (`<`/`>` switch groups, `Tab` moves down) | fzf-tab |

fzf uses `fd` when present, `find` otherwise; previews use `bat`, then
`head` as fallback, so every binding works on a machine that has none of
the three.

## tmux

Documented with its config:
[.config/tmux/README.md](../.config/tmux/README.md): bindings, theme,
clipboard, plugins.

## Shell aliases and functions

| Alias | Becomes | Needs |
|---|---|---|
| `ll` / `la` | `eza -lh` / `eza -lah`, icons and git status | eza (fallback: `ls -lh` / `ls -lah`) |
| `lt` | `eza --tree --icons` | eza (fallback: `tree`) |
| `ls` | `eza --icons` | eza only: without it, `ls` stays the system `ls` |
| `cat` | `bat` | bat |
| `diff` | `diff --color=auto` | GNU diff (probed) |
| `df` | `df -h` | nothing |
| `v` | `nvim` | nothing |
| `path` | `$PATH`, one directory per line | nothing |
| `g` / `gst` / `gd` / `gck` / `gcm` / `gcma` / `gbr` / `gbra` | git / status / diff / checkout / commit / commit -a / branch / branch -a | git |
| `ghc <repo>` | clones `github.com:$GITUSER/<repo>` into `$GHREPOS`, then cd | nothing |
| `glc <repo>` | same for GitLab into `$GLREPOS` | nothing |

`GITUSER`, `REPOS` (`~/lab`), `GHREPOS` (`$REPOS/github`) and `GLREPOS`
(`$REPOS/gitlab`) are set in `shell/env.sh`, which is where you change
them. The
directories are created by `./run install` (directories step).

These are **shell** aliases, not git aliases: `gst`, not `git st`. What
that costs is written where they live (`shell/aliases.sh`): outside an
interactive shell, git answers to plain git only. The git config itself
is documented at [.config/git/README.md](../.config/git/README.md).

## git objects: fzf-git.sh

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
**prints** it, hence `git switch $(gfb)`. Inside the picker: `Ctrl-O` opens
in the browser, `Alt-E` in `$EDITOR`, `Ctrl-/` cycles the preview.

## Terminals

Neither ghostty nor kitty carries a custom binding. Stock defaults on
both is what keeps muscle memory portable between them. Notable
behaviours: `copy-on-select`, `macos-option-as-alt`. Configuration:
[terminals.md](terminals.md).

---

See also: [tools.md](tools.md) for the tools behind these bindings, and
[terminals.md](terminals.md) for ghostty, kitty and their configuration.
