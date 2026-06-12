#!/usr/bin/env sh
# setup/manifest.sh — symlink DATA (no logic here).
# Format: "<source in the repo>  <target under $HOME>". One target per line.
#
# Adding a config = adding ONE line.

dotfiles_links() {
  cat <<'EOF'
# --- ~/.config ---
.config/shell          .config/shell
.config/zsh            .config/zsh
.config/tmux           .config/tmux
.config/git            .config/git
.config/ghostty        .config/ghostty
.config/bat            .config/bat
.config/nvim           .config/nvim
.config/starship.toml  .config/starship.toml
.config/mise           .config/mise
scripts                .config/scripts

# --- startup files at the root of $HOME ---
.bashrc                .bashrc
.bash_profile          .bash_profile
EOF
}

# Directories to create (absolute paths, computed from XDG — unquoted heredoc).
# One directory per line. This is what fixes C2 (missing zsh state/cache).
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
${REPOS:-$HOME/lab}/github
${REPOS:-$HOME/lab}/gitlab
EOF
}

# History migrations: "<old absolute path>  <new absolute location>".
# Move legacy history files from the root to their XDG directory.
# UNQUOTED heredoc (<<EOF): $HOME and the ${XDG_*:-default} are EXPANDED here,
# so the targets automatically follow any XDG customization.
dotfiles_history_migrations() {
  cat <<EOF
$HOME/.bash_history    ${XDG_STATE_HOME:-$HOME/.local/state}/bash/history
$HOME/.zsh_history     ${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history
$HOME/.lesshst         ${XDG_CACHE_HOME:-$HOME/.cache}/less/history
$HOME/.python_history  ${XDG_DATA_HOME:-$HOME/.local/share}/python/history
EOF
}
