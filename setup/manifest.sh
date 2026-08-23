#!/usr/bin/env sh
# setup/manifest.sh: DATA only, no logic.
# Format: "<source in the repo>  <target under $HOME>", one per line.
# Adding a config = adding ONE line.

dotfiles_links() {
  cat <<'EOF'
# --- ~/.config ---
.config/shell          .config/shell
.config/zsh            .config/zsh
.config/tmux           .config/tmux
.config/git            .config/git
.config/ghostty        .config/ghostty
.config/kitty          .config/kitty
.config/bat            .config/bat
.config/nvim           .config/nvim
.config/starship.toml  .config/starship.toml
.config/mise           .config/mise
scripts                .config/scripts

# --- startup files at the root of $HOME ---
# .zshenv is the ZDOTDIR bootstrap: what lets zsh find .config/zsh without
# root. See docs/architecture.md.
# .vimrc: the historic path, the only one every vim reads.
.zshenv                .zshenv
.vimrc                 .vimrc
.bashrc                .bashrc
.bash_profile          .bash_profile
EOF
}

# Directories to create, one per line. The shells DO create their own state and
# cache dirs: .bashrc and .zshrc each mkdir -p beside their HISTFILE and beside
# the mise completion cache, zinit.zsh beside its compdump. (Names, not line
# numbers, so this comment cannot rot.) They stay listed anyway as a belt: this
# step runs before any first shell and cannot depend on a .zshrc having been
# read. What only this step provides:
#   - ~/.cache/less and ~/.local/share/python: less and python drop their
#     history in silence when the directory is missing, and neither creates it.
#   - ~/.local/bin: it must exist BEFORE a shell starts or env_path_prepend
#     skips it (its `[ -d "$1" ]` guard) and every tool there falls off PATH.
#   - ~/lab/github and ~/lab/gitlab: `git clone` would create them on demand,
#     so this is only so `cd $GHREPOS` works before the first clone.
dotfiles_dirs() {
  cat <<EOF
${XDG_CONFIG_HOME:-$HOME/.config}
${XDG_STATE_HOME:-$HOME/.local/state}/zsh
${XDG_STATE_HOME:-$HOME/.local/state}/bash
${XDG_CACHE_HOME:-$HOME/.cache}/zsh
${XDG_CACHE_HOME:-$HOME/.cache}/less
${XDG_DATA_HOME:-$HOME/.local/share}/mise
${XDG_DATA_HOME:-$HOME/.local/share}/python
$HOME/.local/bin
${REPOS:?REPOS must be set (exported by run)}/github
${REPOS}/gitlab
EOF
}

# History migrations: "<old absolute path>  <new absolute location>".
# UNQUOTED heredoc: $HOME and ${XDG_*:-default} are expanded here, so the
# targets follow any XDG customization for free.
dotfiles_history_migrations() {
  cat <<EOF
$HOME/.bash_history    ${XDG_STATE_HOME:-$HOME/.local/state}/bash/history
$HOME/.zsh_history     ${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history
$HOME/.lesshst         ${XDG_CACHE_HOME:-$HOME/.cache}/less/history
$HOME/.python_history  ${XDG_DATA_HOME:-$HOME/.local/share}/python/history
EOF
}
