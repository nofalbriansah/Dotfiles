{ config, pkgs, unstable, ... }:

let
  abdownloadmanager = pkgs.stdenv.mkDerivation rec {
    pname = "abdownloadmanager";
    version = "1.6.10";

    src = pkgs.fetchurl {
      url = "https://github.com/amir1376/ab-download-manager/releases/download/v${version}/ABDownloadManager_${version}_linux_x64.tar.gz";
      sha256 = "D0ZwRwdXr+Y+xnC2ZWjSTSHeUAkmgM3mOCRWcZOc7Is=";
    };
    
    nativeBuildInputs = [ pkgs.makeWrapper ];
    
    buildInputs = with pkgs; [
      xorg.libXtst
      xorg.libXext
      xorg.libXrender
      xorg.libXi
      glib
      gtk3
      libappindicator-gtk3
    ];
    
    unpackPhase = ''
      tar -xzf $src
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/opt/abdownloadmanager
      cp -r ABDownloadManager/* $out/opt/abdownloadmanager

      chmod +x $out/opt/abdownloadmanager/bin/ABDownloadManager

      mkdir -p $out/bin
      makeWrapper $out/opt/abdownloadmanager/bin/ABDownloadManager \
        $out/bin/abdm \
        --set LD_LIBRARY_PATH "${pkgs.lib.makeLibraryPath buildInputs}"

      runHook postInstall
    '';
  };
in

{
  imports = [
    ./gnome.nix
    #./hyprland.nix
  ];

  home.username = "nbs";
  home.homeDirectory = "/home/nbs";
  home.stateVersion = "25.05";

  ######################
  # Env vars
  ######################
  home.sessionVariables = {
    ANDROID_HOME = "~/Developments/android/Sdk";
    ANDROID_SDK_ROOT = "~/Developments/android/Sdk";
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
    wget
    zip
    unzip
    unrar
    neofetch
    python3
    clang
    cmake
    vim
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
    unstable.nekoray
    unstable.flclash
    thunderbird
    onlyoffice-desktopeditors
    gnome-pomodoro
    obs-studio
    gimp3-with-plugins
    zotero
    discord
    vlc
    heroic-unwrapped
    kdePackages.kdenlive
    ghostty
    localsend
    zoom-us
    slack
    abdownloadmanager
    gnome-system-monitor
    gnome-disk-utility

    # Themes
    colloid-icon-theme
    reversal-icon-theme
    marble-shell-theme

    # SDK / IDE
    unstable.gemini-cli
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
        dot = "cd ~/Dotfiles";
        
        gs = "git status";
        ga = "git add .";
        gf = "git fetch";
        gp = "git push";
        gft = ''git commit -m "feat: "'';
        gfx = ''git commit -m "fix: "'';
        gc = ''git commit -m "chore: "'';
        gr  = ''git commit -m "refactor: "'';
        gd  = ''git commit -m "docs: "'';

        ng = "sudo nixos-rebuild list-generations";
        ns = "sudo nixos-rebuild switch --flake ~/Dotfiles/nixos";
        nr = "sudo nixos-rebuild switch --rollback";
        nd = "sudo nix-collect-garbage -d";
        nc = "nano ~/Dotfiles/nixos/nixos/configuration.nix";
        nf = "nano ~/Dotfiles/nixos/flake.nix";
        nh = "nano ~/Dotfiles/nixos/home/home.nix";
      };
    };
  };
}
