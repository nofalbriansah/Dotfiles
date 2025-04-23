#!/bin/bash

# Ensure we are in the dotfiles directory
DOTFILES_DIR=$(pwd)

# Folders to stow
FOLDERS=(
    "git"
    "shell/env"
    "shell/fastfetch"
    "shell/starship"
    "shell/fish"
    "shell/bash"
    "terminal"
    "themes"
    # "toolbox"
)

# Function to stow a directory
stow_directory() {
    local dir=$1
    echo "Stowing $dir..."
    stow $dir -v --dir=$DOTFILES_DIR
    if [ $? -eq 0 ]; then
        echo "$dir stowed successfully."
    else
        echo "Error stowing $dir."
    fi
}

# Loop through and stow the listed directories
for folder in "${FOLDERS[@]}"; do
    stow_directory "$folder"
done

echo "Dotfiles stowing complete!"
