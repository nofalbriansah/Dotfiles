{ config, pkgs, unstable, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  system.stateVersion = "25.05";
  nixpkgs.config = {
    allowUnfree = true;
  };

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
      # noto-fonts noto-fonts-extra noto-fonts-emoji noto-fonts-cjk ttf-dejavu ttf-liberation
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
      enable = false;
      storageDriver = "btrfs";
    };
  };

  ######################
  # Programs
  ######################
  programs = {
    virt-manager.enable = true;
    adb.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
  };

  ######################
  # Security
  ######################
  security.rtkit.enable = true;
}

