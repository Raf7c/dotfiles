{ ... }:
{
  # Import all development and productivity tools
  imports = [
    ./bat.nix         # Syntax highlighting for files
    ./fzf.nix         # Fuzzy finder for command line
    ./git.nix         # Git configuration and aliases
    ./tmux.nix        # Terminal multiplexer
    ./monitoring.nix  # System monitoring and automatic theme switching
  ];
} 