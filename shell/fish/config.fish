# ~/.config/fish/config.fish — via dotfiles

# Disable greeting
set -g fish_greeting

# Source the universal path and env config via Bash
if test -f "$HOME/Dotfiles/shell/env/paths_and_vars.sh"
    bash -c "source $HOME/Dotfiles/shell/env/paths_and_vars.sh"
end

# Source application aliases
if test -f "$HOME/Dotfiles/shell/env/abbr.sh"
    bash -c "source $HOME/Dotfiles/shell/env/abbr.sh"
end

# Starship prompt configuration
set -x STARSHIP_CONFIG "$HOME/Dotfiles/shell/starship/starship.toml"
