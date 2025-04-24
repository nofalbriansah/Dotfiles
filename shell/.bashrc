# ~/.bashrc
export PS1="\u@\h:\w\$ "

# Start Starship prompt
eval "$(starship init bash)"

# Load environment variables and PATH
if [ -f ~/.linux_paths ]; then
    source ~/.linux_paths
fi

# Load Abbrs and Aliases
if [ -f ~/.linux_abbrs ]; then
    . ~/.linux_abbrs
fi


