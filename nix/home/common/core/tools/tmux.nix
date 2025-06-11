{ config, pkgs, lib, ... }:

{
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    prefix = "C-Space";  # Control + Espace
    mouse = true;
    
    extraConfig = ''
      # True color support
      set -ga terminal-overrides ",*256col*:Tc"
      set -ga terminal-overrides ",xterm-kitty:Tc"
      set -as terminal-features ",xterm-kitty:RGB"
      
      # Performance options
      set -g focus-events on
      set -sg escape-time 0
      
      # Binding to reload the configuration
      bind r source-file $HOME/.config/tmux/tmux.conf \; display-message "Config reloaded!"
      
      # TPM - Tmux Plugin Manager
      set -g @plugin 'tmux-plugins/tpm'
      set -g @plugin 'catppuccin/tmux'
      set -g @plugin 'tmux-plugins/tmux-sensible'
      
      # Initialisation TPM (toujours à la fin)
      run '~/.tmux/plugins/tpm/tpm'
    '';
  };
  
  # Installation automatique de TPM
  home.activation.setupTmux = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
      mkdir -p "$HOME/.tmux/plugins"
      ${pkgs.git}/bin/git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    fi
  '';
}