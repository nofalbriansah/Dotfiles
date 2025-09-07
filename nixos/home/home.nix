{ config, pkgs, unstable, ... }:

{
  imports = [
    ./gnome.nix
  ];

  home.username = "nbs";
  home.homeDirectory = "/home/nbs";
  home.stateVersion = "25.05";

  ######################
  # Environment Variables
  ######################
  home.sessionVariables = {
    ANDROID_HOME       = "~/Developments/android/Sdk";
    ANDROID_SDK_ROOT   = "~/Developments/android/Sdk";
    JAVA_HOME          = "${pkgs.jdk21}";
    CHROME_EXECUTABLE  = "${unstable.google-chrome}/bin/google-chrome-stable";
    TERMINAL           = "ghostty";
  };

  ######################
  # Packages
  ######################
  home.packages = with pkgs; [

    ######################
    # CLI Tools
    ######################
    neofetch
    stow
    tree
    unzip
    unrar
    vim
    wget
    zip
    nixpkgs-fmt
    
    ######################
    # Themes
    ######################
    colloid-icon-theme
    marble-shell-theme
    reversal-icon-theme

    ######################
    # GUI Apps (stable)
    ######################
    abdownloadmanager
    discord
    gimp3-with-plugins
    ghostty
    gnome-disk-utility
    gnome-pomodoro
    gnome-system-monitor
    heroic-unwrapped
    kdePackages.kdenlive
    localsend
    obs-studio
    onlyoffice-desktopeditors
    thunderbird
    vlc
    zoom-us
    slack
    zotero

    ######################
    # GUI Apps (unstable)
    ######################
    unstable.firefox
    unstable.flclash
    unstable.google-chrome
    unstable.obsidian

    ######################
    # Dev / SDK / IDE Tools
    ######################
    android-tools
    bun
    clang
    cmake
    curl
    git
    go
    jdk
    ninja
    mesa-demos
    pkg-config
    python3
    scrcpy
    
    unstable.android-studio
    unstable.code-cursor-fhs
    unstable.flutter
    unstable.gemini-cli
    unstable.godot
    unstable.hugo
    unstable.jetbrains.goland
    unstable.vscode
    unstable.zed-editor
  ];

  ######################
  # Programs Configuration
  ######################
  programs = {

    starship = {
      enable = true;
      settings = {
        add_newline = true;
        format      = "$all";
      };
    };

    fish = {
      enable = true;
      interactiveShellInit = ''
        set -g fish_greeting " "
        starship init fish | source
      '';
      shellAbbrs = {
        dot = "cd ~/Dotfiles";

        # Git shortcuts
        ga  = "git add .";
        gf  = "git fetch";
        gs  = "git status";
        gp  = "git push";
        gd  = ''git commit -m "docs: "'';
        gft = ''git commit -m "feat: "'';
        gfx = ''git commit -m "fix: "'';
        gc  = ''git commit -m "chore: "'';
        gr  = ''git commit -m "refactor: "'';

        # NixOS shortcuts
        ng = "sudo nixos-rebuild list-generations";
        ns = "sudo nixos-rebuild switch --flake ~/Dotfiles/nixos";
        nr = "sudo nixos-rebuild switch --rollback";
        nd = "sudo nix-collect-garbage -d";

        # Edit config shortcuts
        nc = "nano ~/Dotfiles/nixos/nixos/configuration.nix";
        nf = "nano ~/Dotfiles/nixos/flake.nix";
        nh = "nano ~/Dotfiles/nixos/home/home.nix";
      };
    };
  };
}

