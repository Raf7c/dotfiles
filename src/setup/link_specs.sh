#!/bin/sh

setup_links_minimale() {
    cat <<'EOF'
.vimrc:.vimrc
.config/tmux:.config/tmux
.config/nvim:.config/nvim
EOF
}

setup_links_complet() {
    cat <<'EOF'
.vimrc:.vimrc
.config/tmux:.config/tmux
.config/nvim:.config/nvim
.config/git:.config/git
.config/ghostty:.config/ghostty
.config/shell:.config/shell
.config/bat:.config/bat
.config/starship.toml:.config/starship.toml
zsh/.zprofile:.zprofile
zsh/.zshrc:.zshrc
bash/.bash_profile:.bash_profile
bash/.bashrc:.bashrc
.tool-versions:.tool-versions
EOF
}
