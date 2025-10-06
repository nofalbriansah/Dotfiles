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
    ANDROID_HOME = "$HOME/Developments/android-sdk";
    ANDROID_SDK_ROOT = "$HOME/Developments/android-sdk";
    JAVA_HOME          = "${pkgs.jdk21_headless}";
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
    asciinema
    asciinema-agg
    
    ######################
    # Themes
    ######################
    colloid-icon-theme
    marble-shell-theme

    ######################
    # GUI Apps (stable)
    ######################
    abdownloadmanager
    discord
    calibre
    gimp3-with-plugins
    ghostty
    gnome-disk-utility
    gnome-pomodoro
    gnome-system-monitor
    heroic-unwrapped
    kdePackages.kdenlive
    #localsend
    obs-studio
    onlyoffice-desktopeditors
    vlc
    zoom-us
    #slack
    zotero

    ######################
    # GUI Apps (unstable)
    ######################
    unstable.firefox
    unstable.flclash
    unstable.google-chrome
    unstable.obsidian

    #######################
    # Dev / SDK / IDE Tools
    #######################
    android-tools
    bun
    cargo
    clang
    cmake
    curl
    git
    go
    jdk21_headless
    ninja
    mesa-demos
    pkg-config
    python3
    rustc
    scrcpy
    
    #unstable.android-studio
    unstable.code-cursor-fhs
    unstable.flutter
    #unstable.gemini-cli
    unstable.godot
    unstable.hugo
    #unstable.jetbrains.goland
    unstable.vscode
    #unstable.zed-editor
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
        as = "asciinema rec NAME-(date +%d-%b-%y-%H%M%S).cast";

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
        nu = "nix flake update --flake /home/nbs/Dotfiles/nixos";
        ns = "sudo nixos-rebuild switch --flake ~/Dotfiles/nixos";
        nr = "sudo nixos-rebuild switch --rollback";
        nd = "sudo nix-collect-garbage -d";

        # Edit config shortcuts
        nc = "nano ~/Dotfiles/nix/nixos/configuration.nix";
        nf = "nano ~/Dotfiles/nix/flake.nix";
        nh = "nano ~/Dotfiles/nix/home/home.nix";
      };
    };
  };
}

