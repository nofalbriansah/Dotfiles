# ~/.config/fish/config.fish — via dotfiles

# Disable greeting
set -g fish_greeting

# Start Starship prompt
starship init fish | source

# Source abbrs
if test -f ~/.config/fish/fish_abbrs.fish
    source ~/.config/fish/fish_abbrs.fish
end

# Source custom path
if test -f ~/.config/fish/fish_path.fish
    source ~/.config/fish/fish_path.fish
end
