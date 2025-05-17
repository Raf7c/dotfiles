{ config, pkgs, lib, ... }:

{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "screen-256color";
    historyLimit = 10000;
    keyMode = "vi";
    
    extraConfig = ''
      # Enable mouse
      set -g mouse on
      
      # Start window and pane indexing at 1 instead of 0
      set -g base-index 1
      setw -g pane-base-index 1
      
      # Reload configuration with PREFIX + r
      bind r source-file ~/.config/tmux/tmux.conf \; display "Configuration reloaded!"
      
      # Use | and - to split windows
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      
      # Navigate between panes with Alt+arrows
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D
    '';
  };
} 