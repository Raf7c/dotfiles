{ pkgs, ... }:

{
  # Activation de FZF
  enable = true;

  # Intégration avec Zsh
  enableZshIntegration = true;

  # Intégration avec Tmux
  tmux.enableShellIntegration = true;

  # Options par défaut pour FZF
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