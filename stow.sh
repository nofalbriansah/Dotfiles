#!/bin/bash

# Path to the dotfiles directory
DOTFILES_DIR=$(pwd)

# Run apps.sh first
echo "Installing required applications..."
bash "$DOTFILES_DIR/apps.sh"

# List of folders to stow
FOLDERS=(
    "git"
    "shell/env"
    "shell/fastfetch"
    "shell/starship"
    "shell/fish"
    "shell/bash"
    "terminal"
    "themes"
)

# Check if GNU Stow is installed
if ! command -v stow &> /dev/null; then
    echo "Error: GNU Stow is not installed. Install it via apps.sh or manually, then try again."
    exit 1
fi

# Function to stow a folder
stow_directory() {
    local dir="$1"
    echo "Stowing $dir..."
    if stow "$dir" -v --dir="$DOTFILES_DIR"; then
        echo "$dir stowed successfully."
    else
        echo "Error stowing $dir."
    fi
}

# Loop through each folder and stow it
for folder in "${FOLDERS[@]}"; do
    stow_directory "$folder"
done

echo "Dotfiles stowing complete!"

