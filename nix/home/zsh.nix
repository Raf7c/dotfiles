{ pkgs, config, lib, ... }:

{
  enable = true;
  history.size = 10000;
  shellAliases = {
    vim = "nvim";
    ls = "ls --color";
    ctrl-l = "clear";
    C-l = "ctrl-l";
    control-l = "clear";
    clean = "clear";
  };
  initExtra = ''
     export EDITOR=nvim
      # Add any additional configurations here
      export PATH=/run/current-system/sw/bin:$HOME/.nix-profile/bin:$PATH
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
    '';
  oh-my-zsh = {
    enable = true;
    plugins = [
      "git"
    ];
  };

}
