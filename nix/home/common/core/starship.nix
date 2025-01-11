{ pkgs, ... }:

{
  enable = true;
  enableZshIntegration = true;
  enableFishIntegration = true;
  settings = {
    format = ''
      $username$hostname$directory$git_branch$git_status
      $python$rust$nodejs
      $time$cmd_duration
      $character
    '';
    add_newline = true;
    username = {
      style_user = "green bold";
      show_always = true;
    };
    directory = {
      truncation_length = 3;
      truncate_to_repo = false;
    };
    git_branch = {
      symbol = "🌿 ";
      truncation_length = 4;
      truncation_symbol = "";
    };
    time = {
      disabled = false;
      format = "🕙 [$time]($style) ";
    };
    nix_shell = {
      symbol = " ";
      format = "via [$symbol$state]($style) ";
    };
    rust = {
      symbol = "🦀 ";
    };
    python = {
      symbol = "🐍 ";
      pyenv_version_name = true;
    };
    character = {
      success_symbol = "[➜](bold green)";
      error_symbol = "[✗](bold red)";
    };
    cmd_duration = {
      min_time = 500;
      format = "took [$duration](bold yellow)";
    };
    battery = {
      full_symbol = "🔋";
      charging_symbol = "🔌";
      discharging_symbol = "⚡";
    };
  };
}