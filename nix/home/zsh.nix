{ config, pkgs, lib, ...}:
{
  enable = true;
  history = {
    size = 10000;
    path = "${config.xdg.dataHome}/zsh/history";
    ignoreDups = true;
    ignoreSpace = true;
    expireDuplicatesFirst = true;
    share = true;
    save = 10000;
  };

  shellAliases = {
    vim = "nvim";
    cat = "bat";
    cl = "clear";
    ls = "eza -lhF --icons --git";
    ll = "eza -lahF --icons --git";
    lt = "eza -hF --tree --level=2 --long --icons --git";
    ltree = "eza -lahF --tree --level=2 --long --icons --git";
    fvim = "nvim $(fzf --preview=\"bat --color=always {}\")";
    rebuild-flake = "darwin-rebuild switch --flake .#Mac --impure";
    sczshrc = "source ~/.zshrc";
  };

  initExtra = ''
    ### ----  EXPORT  ---- ###
    export TERM="xterm-256color" 
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
    export PATH=/opt/homebrew/bin:$PATH
    export HOMEBREW_CASK_OPTS="--no-quarantine"
    export TERMINAL="kitty"
    export BROWSER="arc"
    export EDITOR=nvim
    export NULLCMD=bat

    ### ----  Installer zinit  ---- ###
    ZINIT_HOME="''${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
    if [[ ! -d $ZINIT_HOME ]]; then
      mkdir -p "$(dirname $ZINIT_HOME)"
      git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
    fi

    source "''${ZINIT_HOME}/zinit.zsh"


    ### ----  PLUGINS  ---- ###
    zinit load zsh-users/zsh-autosuggestions
    zinit load zsh-users/zsh-syntax-highlighting
    zinit load zsh-users/zsh-completions
    zinit ice wait lucid
    zinit light Aloxaf/fzf-tab

    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -lah --color=always --icons --git $realpath'


    ### ---- HISTORY additional ---- ###
    setopt hist_find_no_dups
    setopt hist_save_no_dups
    setopt appendhistory

    ### ---- SHELL integrations ---- ###
    . ${pkgs.asdf-vm}/share/asdf-vm/asdf.sh

  '';
}