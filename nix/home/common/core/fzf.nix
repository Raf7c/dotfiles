{ pkgs, ... }:
{
  enable = true;
  enableZshIntegration = true;
  tmux.enableShellIntegration = true;

  defaultOptions = [
    "--height 40%"
    "--layout=reverse"
    "--border"
    "--info=inline"
    "--multi"
    "--preview 'bat --style=numbers --color=always {}'"
    "--preview-window='right:60%'"

  ];
}