# ~/.bashrc
export PS1="\u@\h:\w\$ "

# Start Starship prompt
eval "$(starship init bash)"

# Load environment variables and PATH
if [ -f ~/.linux_paths ]; then
    while IFS= read -r line; do
        # Skip empty or comment lines
        [[ -z "$line" || "$line" =~ ^# ]] && continue

        # Handle PATH additions
        if [[ "$line" == export\ PATH=* ]]; then
            dir="${line#export PATH=}"
            dir="${dir//\~/$HOME}"
            dir="${dir//:\$PATH/}"
            IFS=':' read -ra dirs <<< "$dir"
            for d in "${dirs[@]}"; do
                if [[ -n "$d" && -d "$d" && ":$PATH:" != *":$d:"* ]]; then
                    export PATH="$d:$PATH"
                fi
            done

        # Handle other environment variables
        elif [[ "$line" == export\ * ]]; then
            var_assignment="${line#export }"
            var_name="${var_assignment%%=*}"
            var_value="${var_assignment#*=}"
            var_value="${var_value//\~/$HOME}"
            export "$var_name=$var_value"
        fi
    done < ~/.linux_paths
fi

# Load Abbrs and Aliases
if [ -f ~/.linux_abbrs ]; then
    . ~/.linux_abbrs
fi
# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
