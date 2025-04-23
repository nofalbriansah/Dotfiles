# ~/.bashrc
export PS1="\u@\h:\w\$ "

# Start Starship prompt
eval "$(starship init bash)"

# Load aliases from ~/.abbrs if exists
if [ -f "$HOME/.bash_abbrs" ]; then
    source "$HOME/.bash_abbrs"
fi

# Load custom PATH additions from ~/.path if exists
if [ -f "$HOME/.bash_path" ]; then
    source "$HOME/.bash_path"
fi


