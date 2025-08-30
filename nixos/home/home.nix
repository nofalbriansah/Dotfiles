{ config, pkgs, unstable, ... }:

{
  imports = [
    ./gnome.nix
  ];

  home.username = "nbs";
  home.homeDirectory = "/home/nbs";
  home.stateVersion = "25.05";

  ######################
  # Env vars
  ######################
  home.sessionVariables = {
    ANDROID_HOME = "/home/nbs/Developments/android/Sdk";
    ANDROID_SDK_ROOT = "/home/nbs/Developments/android/Sdk";
    JAVA_HOME = "${pkgs.jdk21}";
    CHROME_EXECUTABLE = "${unstable.google-chrome}/bin/google-chrome-stable";
    TERMINAL = "ghostty";
  };

  ######################
  # Packages
  ######################
  home.packages = with pkgs; [
    # CLI tools
    curl
    git
    stow
    tree
    unzip
    wget
    zip
    neofetch
    micro
    python3
    clang
    cmake
    ninja
    pkg-config
    nixpkgs-fmt
    android-tools
    scrcpy
    jdk
    mesa-demos
    go
    bun
    unstable.hugo

    # GUI apps
    unstable.firefox
    unstable.google-chrome
    unstable.obsidian
    thunderbird
    onlyoffice-desktopeditors
    gnome-pomodoro
    obs-studio
    gimp3-with-plugins
    zotero
    vlc
    heroic-unwrapped
    kdePackages.kdenlive
    ghostty
    localsend
    zoom-us
    gnome-system-monitor
    gnome-disk-utility

    # Themes
    colloid-icon-theme
    reversal-icon-theme
    marble-shell-theme

    # SDK / IDE
    unstable.flutter
    unstable.android-studio
    unstable.vscode
    unstable.code-cursor-fhs
    unstable.zed-editor
    unstable.godot
    unstable.jetbrains.goland
  ];

  ######################
  # Programs
  ######################
  programs = {
    starship = {
      enable = true;
      settings = {
        add_newline = true;
        format = "$all";
      };
    };

    fish = {
      enable = true;
      interactiveShellInit = ''
        set -g fish_greeting " "
        starship init fish | source
      '';
      shellAbbrs = {
        gs = "git status";
        gc = "git commit -m 'up'";
        gp = "git push";
        ns = "sudo nixos-rebuild switch";
        nd = "sudo nix-collect-garbage -d";
        nc = "sudo micro /etc/nixos/nixos/configuration.nix";
        nf = "sudo micro /etc/nixos/flake.nix";
        nh = "sudo micro /etc/nixos/home/home.nix";
      };
    };
  };
}

