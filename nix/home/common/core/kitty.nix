{ config, pkgs, ... }:
let
 themePath = ../../../theme/catppuccin_mocha.conf;
in
{
    enable = true;
    settings = {
      # Fonts
      font_family = "DaddyTimeMono Nerd Font Mono";
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      font_size = 20;

      # Customization
      hide_window_decorations = "titlebar-only";
      window_padding_width = 10;
      window_border_width = "5pt";

      # Tab bar
      tab_bar_style = "separator";
      tab_bar_edge = "top";
      tab_bar_margin_width = 9;
      tab_bar_margin_height = "9 0";
      tab_bar_min_tabs = 1;
      tab_bar_background = "none";
      tab_separator = "\"\"";
      tab_title_template = "{fmt.fg._5c6370}{fmt.bg.default}{fmt.fg._abb2bf}{fmt.bg._5c6370} {title.split()[0]} {fmt.fg._5c6370}{fmt.bg.default} ";
      active_tab_title_template = "{fmt.fg._e5c07b}{fmt.bg.default}{fmt.fg._282c34}{fmt.bg._e5c07b} {title.split()[0]} {fmt.fg._e5c07b}{fmt.bg.default} ";
    };

    # Option not supported
    extraConfig = ''
      include ${themePath}
      background_opacity 0.95
    '';
}