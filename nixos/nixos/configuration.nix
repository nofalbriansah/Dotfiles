{ config, pkgs, unstable, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  system.stateVersion = "25.05";
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    warn-dirty = false;
  };

  ######################
  # Boot
  ######################
  boot = {
    loader = {
      systemd-boot.enable = true;
      # systemd-boot.configurationLimit = 5;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_6_16;
    kernelModules = [ "kvm-intel" ];
    kernelParams = [ "quiet" ];
  };

  ######################
  # Networking
  ######################
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
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
        intelBusId  = "PCI:0:2:0";
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
  # Users
  ######################
  users.users.nbs = {
    isNormalUser = true;
    description = "nbs";
    extraGroups = [
      "networkmanager"
      "wheel"
      "adbusers"
      "libvirtd"
      "qemu-libvirtd"
      "docker"
      "vidio"
      "audio"
    ];
  };

  ######################
  # Virtualisation
  ######################
  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
    docker = {
      enable = true;
      storageDriver = "btrfs";
    };
  };

  ######################
  # Programs
  ######################
  programs = {
    virt-manager.enable = true;
    dconf.enable = true;
    mtr.enable = true;
    adb.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    nekoray = {
      enable = true;
      tunMode.enable = true;
    };

    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc
        vulkan-loader
        libGL
        libglvnd
        mesa
        libdrm
        wayland
        cairo
        pango
        harfbuzz
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
        systemd
        libudev-zero
        alsa-lib
        pulseaudio
        pipewire
        openal
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

