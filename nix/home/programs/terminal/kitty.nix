{ config, pkgs, isLaptop ? false, fontSize, fontFamily, ... }:
{
  enable = true;
  settings = {
    # Fonts
    font_family = "${fontFamily} Nerd Font Mono";
    bold_font = "auto";
    italic_font = "auto";
    bold_italic_font = "auto";
    font_size = fontSize;

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
    
    # Configuration for remote control
    allow_remote_control = true;
    listen_on = "unix:/tmp/kitty";
  };

  extraConfig = ''
    # Dynamic theme managed by theme-switcher
    include ~/.config/nix-themes/current.conf
    
    # Opacity
    background_opacity ${if isLaptop then "1.0" else "0.95"}
    
    # macOS configuration
    macos_titlebar_color background
    macos_option_as_alt yes
  '';
} 