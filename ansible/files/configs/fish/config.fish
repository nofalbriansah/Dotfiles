source /usr/share/cachyos-fish-config/cachyos-config.fish
function fish_greeting

end

### PROMPT INITIALIZATION
if status is-interactive
    starship init fish | source
end

### ABBREVIATIONS (Aliases)
# Navigation & Tools
abbr -a dot 'cd ~/Dotfiles'
abbr -a as 'asciinema rec NAME-(date +%d-%b-%y-%H%M%S).cast'

# Git
abbr -a ga 'git add .'
abbr -a gf 'git fetch'
abbr -a gs 'git status'
abbr -a gp 'git push'
abbr -a gd 'git commit -m "docs: "'
abbr -a gft 'git commit -m "feat: "'
abbr -a gfx 'git commit -m "fix: "'
abbr -a gc 'git commit -m "chore: "'
abbr -a gr 'git commit -m "refactor: "'

# Arch Linux (Pacman/AUR)
abbr -a cu 'sudo pacman -Syu'
abbr -a cr 'sudo pacman -Scc'
abbr -a ci 'sudo pacman -S'
abbr -a pi 'paru -S'

# Fedora (DNF)
abbr -a fu 'sudo dnf up && sudo dnf upgrade'
abbr -a fd 'sudo dnf autoremove'