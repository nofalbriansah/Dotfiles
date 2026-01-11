{ config, pkgs, unstable, ... }:

{
  home.packages = with pkgs; [

    # Fonts
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code

    # CLI Tools
    neofetch
    keyd
    stow
    tree
    unzip
    unrar
    wget
    zip
    syncthing
    nixpkgs-fmt
    lazygit
    asciinema
    asciinema-agg

    # Dev / SDK / IDE
    clang
    cmake
    ninja
    pkg-config
    python3
    python3Packages.pip
    mesa-demos

    cargo
    rustc
    rustfmt
    rust-analyzer
    clippy

    go
    gopls
    gotools
    golangci-lint
    delve

    #unstable.flutter
    android-tools
    scrcpy
    gtk3
    jdk21_headless

    unstable.hugo
    bun
  ];

  # Programs configuration associated with CLI
  programs = {
    starship = {
      enable = true;
      settings = {
        add_newline = true;
        format      = "$all";
      };
    };
    
    neovim = {
      enable = true;
      package = pkgs.neovim-unwrapped;
    
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      plugins = with pkgs.vimPlugins; [
        #lazy-nvim
        #LazyVim
      ];
       
      extraPackages = with pkgs; [
        ripgrep 
        fd                
        lua-language-server
        stylua
	wl-clipboard
      ];
    };    

    fish = {
      enable = true;
      interactiveShellInit = ''
        set -g __done_min_cmd_duration 0
        set -g done_enabled 0
        set -g fish_greeting " "
        starship init fish |
        source
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

        # Edit config shortcuts
        nc = "vim ~/Dotfiles/nix/nixos/configuration.nix";
        nf = "vim ~/Dotfiles/nix/flake.nix";
        nh = "vim ~/Dotfiles/nix/home/home.nix";
        nhc = "vim ~/Dotfiles/nix/home/cli.nix";
        nhg = "vim ~/Dotfiles/nix/home/gui.nix";

        # NixOS shortcuts
        nu = "nix flake update --flake /home/nbs/Dotfiles/nix";
        ng = "sudo nixos-rebuild list-generations";
        ns = "sudo nixos-rebuild switch --flake .#nixos";
        nr = "sudo nixos-rebuild switch --rollback";
        nd = "sudo nix-collect-garbage -d";

        # Home-Manager shortcuts
        hs = "nix run home-manager -- switch --flake ~/Dotfiles/nix#nix";
        hg = "nix run home-manager -- generations";
        hd = "nix-collect-garbage -d";

        # Arch (pacman + aur)
        cu = "sudo pacman -Syu";
        cr = "sudo pacman -Scc ";
        ci = "sudo pacman -S ";
        pi = "paru -S ";

        # Fedora
        fu = "sudo dnf up && sudo dnf upgrade";
        fd = "sudo dnf autoremove";
      };
    };
  };
}
