{ config, pkgs, lib, ... }:

{
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    prefix = "C-Space";  # Control + Espace
    mouse = true;
    
    extraConfig = ''
      #Configuration de base
      set -g default-terminal "tmux-256color"
      set -ag terminal-overrides ",xterm-256color:RGB"
      
      # Detecting the system theme and loading the appropriate theme
      run-shell "if [ \"$(defaults read -g AppleInterfaceStyle 2>/dev/null)\" = \"Dark\" ]; then \
        tmux source-file ~/.config/tmux/themes/catppuccin-mocha.conf; \
      else \
        tmux source-file ~/.config/tmux/themes/catppuccin-latte.conf; \
      fi"
      
      # Customizing the status bar
      set -g status-position top
      set -g status-interval 2
      set -g status-left-length 20
      set -g status-right-length 50
      
      # Status bar format
      set -g status-left "#[fg=#{@thm_fg},bg=#{@thm_surface_2},bold] #S #[fg=#{@thm_fg},bg=#{@thm_bg},nobold] "
      set -g status-right "#[fg=#{@thm_fg},bg=#{@thm_surface_2}] %H:%M #[fg=#{@thm_fg},bg=#{@thm_surface_1}] %d-%b "
    '';
  };

  # Creating symbolic links for themes
  xdg.configFile = {
    "tmux/themes/catppuccin-latte.conf".source = ../../../../theme/catppuccin/tmux/catppuccin-latte.conf;
    "tmux/themes/catppuccin-mocha.conf".source = ../../../../theme/catppuccin/tmux/catppuccin-mocha.conf;
  };

  # Automatic TPM installation and initial theme setup
  home.activation.setupTmux = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
      mkdir -p "$HOME/.tmux/plugins"
      ${pkgs.git}/bin/git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    fi

    # Apply initial theme if tmux is running
    if command -v tmux >/dev/null 2>&1 && tmux list-sessions >/dev/null 2>&1; then
      theme-switcher auto || true
    fi
  '';
}