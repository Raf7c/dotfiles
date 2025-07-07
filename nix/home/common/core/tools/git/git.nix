{ config, pkgs, lib, ... }:
let
  # Use relative paths instead 
  dotfilesDir = builtins.toString ../../../../.;
in
{
  programs.git = {
    enable = true;
    userName = "Raphael C";
    userEmail = "122828688+Raf7c@users.noreply.github.com";
    extraConfig = {
      alias = {
        st = "status";
        addp = "add --patch";
        br = "branch";
        bra = "branch --all";
        co = "checkout";
        cob = "checkout -b";
        cl = "clone";
        clr = "clone --recursive";
        df = "diff --staged";
        lg = "log";
        lga = "log --all";
      };
      color = {
        ui = "auto";
      };
      column = {
        ui = "auto";
      };
      branch = {
        sort = "-committerdate";
      };
      tag = {
        sort = "version:refname";
      };
      init = {
        defaultBranch = "main";
      };
      core = {
        editor = "nvim";
        excludesfile = "~/.config/git/ignore";
      };
      diff = {
        algorithm = "histogram";
        colorMoved = "plain";
        mnemonicPrefix = true;
        renames = true;
      };
      push = {
        default = "simple";
        autoSetupRemote = true;
        followTags = true;
      };
      fetch = {
        prune = true;
        pruneTags = true;
        all = true;
      };
      help = {
        autocorrect = "prompt";
      };
      commit = {
        verbose = true;
      };
      rerere = {
        enabled = true;
        autoupdate = true;
      };
    };
  };

  ##############################
  # Global git ignore
  ##############################

  xdg.configFile."git/ignore".source = ./.gitignore;
}