{ config, pkgs, lib, ... }:

{
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    prefix = "C-Space";  # Control + Espace
    mouse = true;
  };
  
  # Création du lien symbolique pour tmux.conf
  home.file.".config/tmux/tmux.conf".source = ./tmux.conf;
  
  # Installation automatique de TPM
  home.activation.setupTmux = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
      mkdir -p "$HOME/.tmux/plugins"
      ${pkgs.git}/bin/git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    fi
  '';
}