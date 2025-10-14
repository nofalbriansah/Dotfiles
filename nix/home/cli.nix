{ config, pkgs, unstable, ... }:

{
  home.packages = with pkgs; [

    # CLI Tools
    neofetch
    stow
    tree
    unzip
    unrar
    vim
    wget
    zip
    nixpkgs-fmt
    #asciinema
    #asciinema-agg

    # Dev / SDK / IDE Tools (Non-GUI)
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
    unstable.hugo
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

    fish = {
      enable = true;
      interactiveShellInit = ''
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
        nc = "nano ~/Dotfiles/nix/nixos/configuration.nix";
        nf = "nano ~/Dotfiles/nix/flake.nix";
        nh = "nano ~/Dotfiles/nix/home/home.nix";
        nhc = "nano ~/Dotfiles/nix/home/cli.nix";
        nhg = "nano ~/Dotfiles/nix/home/gui.nix";
        
        # NixOS shortcuts
        nu = "nix flake update --flake /home/nbs/Dotfiles/nix";
        ng = "sudo nixos-rebuild list-generations";
        ns = "sudo nixos-rebuild switch --flake .#nixos";
        nr = "sudo nixos-rebuild switch --rollback";
        nd = "sudo nix-collect-garbage -d";
        
        # Home-Manager shortcuts
        hs = "nix run home-manager -- switch --flake ~/Dotfiles/nix#nbs";
        hg = "nix run home-manager -- generations";
        hd = "nix-collect-garbage -d";
        
        # Arch (pacman + yay)
        pu = "sudo pacman -Syu";
        ps = "sudo pacman -Ss "; 
        pr = "sudo pacman -Rns "; 
        pi = "sudo pacman -S ";
        
        yu = "yay -Syu"; 
        ys = "yay -Ss "; 
        yr = "yay -Rns "; 
        yi = "yay -S "; 
      };
    };
  };
}
