# ~/.bashrc — via dotfiles

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Source the universal path and env config
if [ -f "$HOME/Dotfiles/shell/env/paths_and_vars.sh" ]; then
  source "$HOME/Dotfiles/shell/env/paths_and_vars.sh"
fi

# Source application aliases
if [ -f "$HOME/Dotfiles/shell/env/abbr.sh" ]; then
  source "$HOME/Dotfiles/shell/env/abbr.sh"
fi

# Starship prompt configuration
export STARSHIP_CONFIG="$HOME/Dotfiles/shell/starship/starship.toml"
