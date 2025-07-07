{ config, pkgs, lib, ... }:

{
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    prefix = "C-Space";  # Control + Espace
    mouse = true;

    plugins = with pkgs.tmuxPlugins; [
      # yank
      # vim-tmux-navigator
      # resurrect
    ];


    extraConfig = ''
      ##############################
      # ⚙️ Basic configuration
      ##############################

      set -g default-command "${pkgs.zsh}/bin/zsh -l"  # ou bash
      set -ag terminal-overrides ",xterm-256color:RGB"
      set -g focus-events on

      # Configuration des touches en mode vi
      set -g mode-keys vi
      set -g status-keys vi


      ###################################
      # 🖱️ Enable copy with mouse + pbcopy
      ###################################

      set-option -g set-clipboard on
      bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "pbcopy"


      ##############################
      # �� History management
      ##############################

      set -g history-limit 10000
      set -g history-file ~/.tmux_history


      #################################
      # 🎨 Dynamic macOS theme loading
      #################################

      run-shell "if [ \"$(defaults read -g AppleInterfaceStyle 2>/dev/null)\" = \"Dark\" ]; then \
        tmux source-file ~/.config/tmux/themes/catppuccin-mocha.conf; \
      else \
        tmux source-file ~/.config/tmux/themes/catppuccin-latte.conf; \
      fi"


      ##############################
      # 🔁 Reload tmux config
      ##############################

      bind r source-file ~/.config/tmux/tmux.conf \; display-message "Config rechargée ✅"


      ##############################
      # 🔢 Start indices at 1
      ##############################
      set -g base-index 1
      set -g pane-base-index 1
      set -g renumber-windows on


      ##############################
      # 🧭 Pane navigation (hjkl)
      ##############################

      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R

      ###########################################
      # 🗂️ Contextual window menu: C-Space + w
      ###########################################

      bind-key w display-menu -T "#[align=centre] Window" \
      "Split horizontally" wx "split-window -h" \
      "Split vertically"   wy "split-window -v" \
      "Rename window"      wr "command-prompt -I '#W' 'rename-window %%'" \
      "Close window"       wd "kill-window"


      ###########################################
      # ⌨️ Direct key table: C-Space + t + key
      ###########################################

      unbind t
      bind-key t switch-client -T window-ops

      bind-key -T window-ops t new-window                                   # New window
      bind-key -T window-ops d kill-window                                  # Close current window
      bind-key -T window-ops r command-prompt -I '#W' 'rename-window %%'    # Rename window
      bind-key -T window-ops n next-window                                  # Next window
      bind-key -T window-ops p previous-window                              # Previous window

  
      ##############################
      # 📟 Status bar
      ##############################

      set -g status-position top
      set -g status-interval 2
      set -g status-left-length 20
      set -g status-right-length 50
      set -g status-justify centre
      
      set -g status-left "#[fg=#{@thm_surface_2},bg=#{@thm_bg}]#[fg=#{@thm_fg},bg=#{@thm_surface_2},bold]  #{?session_name,#S,Session} #[fg=#{@thm_surface_2},bg=#{@thm_bg},nobold]"
      set -g window-status-current-format "#[fg=#{@thm_blue},bg=default]  #I:#W"
      set -g status-right "#[fg=#{@thm_surface_2},bg=#{@thm_bg}]#[fg=#{@thm_fg},bg=#{@thm_surface_2}] #H #[fg=#{@thm_surface_2},bg=#{@thm_bg}]"
    '';
  };

  ##############################
  # 🎨 Symlinks for themes
  ##############################

  xdg.configFile = {
    "tmux/themes/catppuccin-latte.conf".source = ../../../../theme/catppuccin/tmux/catppuccin-latte.conf;
    "tmux/themes/catppuccin-mocha.conf".source = ../../../../theme/catppuccin/tmux/catppuccin-mocha.conf;
  };

  ###################################
  # ⚙️ Auto-install TPM on first run
  ###################################
  
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

  ##############################
  # 🐚 Shell aliases for tmux
  ##############################

  home.shellAliases = {
    tl = "tmux list-sessions";
    tn = "tmux new-session -s";
    ta = "tmux attach";
    tks = "tmux kill-session";
  };
}