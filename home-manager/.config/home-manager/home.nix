{ config, pkgs, ... }:

{
  # Enable unfree packages
  nixpkgs.config.allowUnfree = true;

  # Set up the user and home directory configuration
  home.username = "nbs";
  home.homeDirectory = "/home/nbs";
  home.stateVersion = "24.11";

  # Path Bash and Fish
  home.sessionPath = [
    "$HOME/.nix-profile/bin"
    "$HOME/.pub-cache/bin"
    "$HOME/Development/Android/Sdk/platform-tools"
    "$HOME/Development/Android/Sdk/ndk-build"
    "$HOME/Development/flutter/bin"
  ];

  # Environment Variables
  home.sessionVariables = {
    JAVA_HOME = "${pkgs.openjdk21}/lib/openjdk";
    ANDROID_HOME = "/home/nbs/Development/Android/Sdk";
    FLUTTER_HOME = "/home/nbs/Development/flutter/bin";
    NODE_PATH = "${pkgs.nodePackages_latest.nodejs}/lib/node_modules";
  };

  # Enable font configuration
  fonts.fontconfig.enable = true;

  # Home Packages
  home.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono

    wget
    curl
    rmtrash
    nixpkgs-fmt
    zip
    unzip
    unrar
    btop
    nano
    tree
    stow
    bat #cat
    eza #ls
    zoxide #cd

    clang
    cmake
    ninja
    firebase-tools
    android-tools
    scrcpy
    nodePackages_latest.nodejs
    neovim-unwrapped
    bun
    gitui
    go delve
    hugo
    imagemagick
  ];

  # Enable Home Manager
  programs.home-manager.enable = true;

  # Enable Java
  programs.java = {
    enable = true;
    package = pkgs.openjdk21;
  };

  # Git configuration
  programs.git = {
    enable = true;
    userName = "nofalbriansah";
    userEmail = "nofalbriansah@gmail.com";
  };
          
  # Enable Starship prompt
  programs.starship = {
    enable = true;
    settings = {
      username = {
        show_always = true;
        style_user = "bold green";
        style_root = "bold red";
      };
      hostname = {
        ssh_only = false;
        format = "[$hostname]($style) ";
        style = "bold blue";
      };
    };
  };

  # Bash Configuration
  programs.bash.enable = true;

  # Fish configuration
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      # Disable Fish greeting
      set -g fish_greeting
    '';
    shellAbbrs = {
      # Application aliases
      ls = "eza";
      ll = "eza -l";
      rmt = "rmtrash";
      ff = "fastfetch";
      vim = "nvim";
      treed = "tree -L 5 -a";
      dot = "cd /home/nbs/Dotfiles";
      dev = "cd /mnt/Data/development";
      obsidian = "cd /mnt/Data/development/research/obsidian";
      gc = "git commit -a -m 'up'";
      gp = "git push";
      gs = "git status";

      # APT aliases
      au = "sudo nala update";
      ad = "sudo apt autoremove";
      fu = "flatpak update";

      # Nix aliases
      hmu = "nix-channel --update";
      hmd = "nix-collect-garbage -d";
      hms = "home-manager switch";
      hmg = "home manager generation";
      hmc = "home-manager edit";
    };
  };

  # Kitty Terminal Configuration
  programs.kitty = {
    enable = false;
    settings = {
      # Font
      font_family = "FiraCode Nerd Font";
      font_size = 12;

      # Scrolling dan Behavior
      enable_audio_bell = true;
      confirm_os_window_close = 0;

      # Cursor
      cursor_shape = "beam";
      cursor_blink_interval = 0;

      # Tab dan window management
      tab_bar_edge = "bottom";
      active_tab_font_style = "bold";

      # Set Fish as default shell in Kitty
      shell = "/home/nbs/.nix-profile/bin/fish";
    };
  };

  # Ghostty Terminal Configuration
  programs.ghostty = {
    enable = false;
    # shellIntegration.enableFishIntegration = true;
    settings = {
      font-size = 12;
      font-family = "FiraCode Nerd Font";
    };
  };

  # Fastfetch configuration
  programs.fastfetch = {
    enable = true;
    settings = {
      display = {
        size = {
          maxPrefix = "MB";
          ndigits = 0;
        };
      };
      modules = [
        "title"
        "separator"
        "os"
        "host"
        "kernel"
        "uptime"
        "packages"
        "shell"
        {
          type = "display";
          compactType = "original";
          key = "Resolution";
        }
        "de"
        "wm"
        "wmtheme"
        "theme"
        "icons"
        "terminal"
        {
          type = "terminalfont";
          format = "{/2}{-}{/}{2}{?3} {3}{?}";
        }
        "cpu"
        {
          type = "gpu";
          key = "GPU";
        }
        {
          type = "memory";
          format = "{/1}{-}{/}{/2}{-}{/}{} / {}";
        }
        "break"
        "colors"
      ];
    };
  };
}
