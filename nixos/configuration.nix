{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> {
    config = config.nixpkgs.config;
  };
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  system.stateVersion = "25.05";
  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "quiet" ];

  hardware.bluetooth.enable = false;
  hardware.bluetooth.powerOnBoot = false;

  hardware.graphics.enable = true;
  hardware.nvidia = {
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

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = false;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      nerd-fonts.fira-code
      fira-code-symbols
    ];
  };
  
  environment.variables = {
    ANDROID_HOME = "/home/nbs/Developments/android/Sdk";
    ANDROID_SDK_ROOT = "/home/nbs/Developments/android/Sdk";
    JAVA_HOME = "${pkgs.jdk21}";
    CHROME_EXECUTABLE = "${unstable.google-chrome}/bin/google-chrome-stable";
  };

  users.users.nbs = {
    isNormalUser = true;
    description = "nbs";
    extraGroups = [ "networkmanager" "wheel" "adbusers" ];
    packages = with pkgs; [
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
      scrcpy
      starship
      fish
    ];
  };

  environment.systemPackages = with pkgs; [
    wget
    curl
    zip
    unzip
    tree
    stow
    git
    python3
    nixpkgs-fmt
    android-tools
    clang
    cmake
    ninja
    pkg-config
    mesa-demos
    jdk

    unstable.flutter
    unstable.android-studio
    unstable.code-cursor-fhs
    unstable.vscode

    gnome-tweaks
    gnome-system-monitor
    gnome-disk-utility
    gnomeExtensions.user-themes
    gnomeExtensions.vitals
    gnomeExtensions.dash2dock-lite
    gnomeExtensions.blur-my-shell
    gnomeExtensions.arcmenu
    gnomeExtensions.just-perfection
    gnomeExtensions.top-bar-organizer
    colloid-icon-theme
    reversal-icon-theme
    marble-shell-theme
  ];

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.adb.enable = true;
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Core toolchain
    stdenv.cc.cc

    # Graphics / Vulkan / OpenGL
    vulkan-loader
    libGL
    libglvnd
    mesa

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

    # Input / udev
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

    # Optional (some games need them)
    libdrm
    wayland
    cairo
    pango
    harfbuzz
  ];
}

