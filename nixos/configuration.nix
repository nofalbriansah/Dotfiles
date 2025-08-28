{ config, pkgs, unstable, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  system.stateVersion = "25.05";
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  ######################
  # Boot
  ######################
  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 5;
      efi.canTouchEfiVariables = true;
    };
    kernelParams = [ "quiet" ];
  };

  ######################
  # Networking
  ######################
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    #proxy = {
    #  httpProxy = "http://10.79.128.24:1100";
    #  httpsProxy = "http://10.79.128.24:1100";
    #  noProxy = "127.0.0.1,localhost";
    #};
  };

  ######################
  # Hardware
  ######################
  hardware = {
    bluetooth = {
      enable = false;
      powerOnBoot = false;
    };
    graphics.enable = true;
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  ######################
  # Services
  ######################
  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      xkb.layout = "us";
    };
    printing.enable = false;
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  ######################
  # Fonts
  ######################
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      nerd-fonts.fira-code
      fira-code-symbols
    ];
  };

  ######################
  # Environment Variables
  ######################
  environment = {
    variables = {
      ANDROID_HOME = "/home/nbs/Developments/android/Sdk";
      ANDROID_SDK_ROOT = "/home/nbs/Developments/android/Sdk";
      JAVA_HOME = "${pkgs.jdk21}";
      CHROME_EXECUTABLE = "${unstable.google-chrome}/bin/google-chrome-stable";
    };

    sessionVariables = {
      TERMINAL = "ghostty";
    };

    systemPackages = with pkgs; [
      # CLI tools
      curl
      git
      stow
      tree
      unzip
      wget
      zip
      neofetch

      # Programming
      unstable.hugo
      python3
      clang
      cmake
      ninja
      pkg-config
      nixpkgs-fmt
      android-tools
      jdk
      mesa-demos
      go
      bun

      # Shell / prompt
      starship
      fish
      neovim-unwrapped
    ];
  };

  ######################
  # Users
  ######################
  users.users.nbs = {
    isNormalUser = true;
    description = "nbs";
    extraGroups = [ "networkmanager" "wheel" "adbusers" ];
    packages = with pkgs; [
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

      # GNOME tools
      gnome-tweaks
      gnome-system-monitor
      gnome-disk-utility

      # GNOME extensions
      gnomeExtensions.user-themes
      gnomeExtensions.vitals
      gnomeExtensions.dash2dock-lite
      gnomeExtensions.blur-my-shell
      gnomeExtensions.arcmenu
      gnomeExtensions.just-perfection
      gnomeExtensions.top-bar-organizer

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
    ];
  };

  ######################
  # Programs
  ######################
  programs = {
    dconf.enable = true;

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
        nu = "sudo nix-channel --update";
        ns = "sudo nixos-rebuild switch";
        nfs = "sudo nixos-rebuild switch --flake";
        nd = "sudo nix-collect-garbage -d";
        nc = "sudo nvim /etc/nixos/configuration.nix";
        nfc = "sudo nvim /etc/nixos/flake.nix";
      };
    };

    mtr.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    adb.enable = true;

    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        # Toolchain
        stdenv.cc.cc

        # Graphics / Vulkan / OpenGL
        vulkan-loader
        libGL
        libglvnd
        mesa
        libdrm
        wayland
        cairo
        pango
        harfbuzz

        # X11 stack
        xorg.libX11
        xorg.libXcursor
        xorg.libXext
        xorg.libXrandr
        xorg.libXrender
        xorg.libXi
        xorg.libXinerama
        xorg.libXxf86vm
        xorg.libXScrnSaver
        libxkbcommon

        # Input / system
        systemd
        libudev-zero

        # Audio
        alsa-lib
        pulseaudio
        pipewire
        openal

        # Common game deps
        SDL2
        freetype
        fontconfig
        zlib
        libpng
        libjpeg
        curl
        dbus
        expat
        glib
        nss
        nspr
        openssl
        libffi
        libuuid
      ];
    };
  };

  ######################
  # Security
  ######################
  security.rtkit.enable = true;
}
