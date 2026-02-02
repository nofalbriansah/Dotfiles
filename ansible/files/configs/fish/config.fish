# ~/.config/fish/config.fish

# --- ENVIRONMENT VARIABLES ---
# Source POSIX shell exports from .linux_path safely
if test -f ~/.linux_path
    grep '^export ' ~/.linux_path | sed 's/^export //; s/=/ /' | while read -l line
        eval "set -gx $line"
    end
    
    set -l extra_paths (bash -c 'source ~/.linux_path && echo $PATH' | tr ':' '\n')
    fish_add_path $extra_paths
end
if status is-interactive
    # Remove greeting
    set -g fish_greeting " "

    # Notification settings
    set -g __done_min_cmd_duration 0
    set -g done_enabled 0

    # Starship
    starship init fish | source

    # --- ABBREVIATIONS ---
    # Navigation
    abbr -a dot "cd ~/Dotfiles"
    abbr -a pun "cd /mnt/Data/developments/obsidian/5-Content/punyanyanbs"
    abbr -a ob "cd /mnt/Data/developments/obsidian"
    abbr -a as "asciinema rec NAME-(date +%d-%b-%y-%H%M%S).cast"

    # Git
    abbr -a ga  "git add ."
    abbr -a gf  "git fetch"
    abbr -a gs  "git status"
    abbr -a gp  "git push"
    abbr -a gd  'git commit -m "docs: "'
    abbr -a gft 'git commit -m "feat: "'
    abbr -a gfx 'git commit -m "fix: "'
    abbr -a gc  'git commit -m "chore: "'
    abbr -a gr  'git commit -m "refactor: "'

    # NixOS Management
    abbr -a nu  "nix flake update --flake /home/nbs/Dotfiles/nix"
    abbr -a ng  "sudo nixos-rebuild list-generations"
    abbr -a ns  "sudo nixos-rebuild switch --flake .#nixos"
    abbr -a nr  "sudo nixos-rebuild switch --rollback"
    abbr -a nd  "sudo nix-collect-garbage -d"

    # Home Manager
    abbr -a hs  "nix run home-manager -- switch --flake ~/Dotfiles/nix#nix"
    abbr -a hg  "nix run home-manager -- generations"
    abbr -a hd  "nix-collect-garbage -d"

    # Arch Linux (Pacman + Paru)
    abbr -a cu  "sudo pacman -Syu"
    abbr -a cr  "sudo pacman -Scc "
    abbr -a ci  "sudo pacman -S "
    abbr -a pi  "paru -S "

    # Fedora
    abbr -a fu  "sudo dnf up && sudo dnf upgrade"
    abbr -a fd  "sudo dnf autoremove"

    # Config
    abbr -a ab "nvim ~/.config/fish/config.fish"
    abbr -a pa "nvim ~/.linux_path"
    abbr -a ina "nvim ~/Dotfiles/ansible/roles/workstation/vars/Archlinux.yml"

    # Apps
    abbr -a gem "gemini -y"
end
