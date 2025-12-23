{ config, pkgs, unstable, ... }:

{
  home.packages = with pkgs; [

    # CLI Tools
    neofetch
    stow
    tree
    unzip
    unrar
    wget
    zip
    nixpkgs-fmt
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
    #android-tools
    #scrcpy
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
        lazy-nvim
        LazyVim
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
        nc = "vi ~/Dotfiles/nix/nixos/configuration.nix";
        nf = "vi ~/Dotfiles/nix/flake.nix";
        nh = "vi ~/Dotfiles/nix/home/home.nix";
        nhc = "vi ~/Dotfiles/nix/home/cli.nix";
        nhg = "vi ~/Dotfiles/nix/home/gui.nix";

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
        cu = "sudo -E pacman -Syu";
        cs = "sudo -E pacman -Ss ";
        cr = "sudo -E pacman -Rns ";
        ci = "sudo -E pacman -S ";
        pu = "paru -Syu";
        ps = "paru -Ss ";
        pr = "paru -Rns ";
        pi = "paru -S ";

        # Fedora
        fu = "sudo dnf up && sudo dnf upgrade";
        fd = "sudo dnf autoremove";
      };
    };
  };
}
