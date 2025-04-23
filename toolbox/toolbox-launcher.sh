#!/bin/bash

CONTAINER_NAME="devbox"
DOTFILES_DIR="$HOME/Dotfiles"

# Check if the container already exists
if ! toolbox list | grep -q "$CONTAINER_NAME"; then
  echo "Creating toolbox container $CONTAINER_NAME..."
  toolbox create --container "$CONTAINER_NAME"  # Create container if it doesn't exist
fi

# Start the container and mount the Dotfiles directory to /home/nbs/Dotfiles inside the container
echo "Starting $CONTAINER_NAME with Dotfiles mounted..."
toolbox enter --container "$CONTAINER_NAME" -- podman run --rm -it \
  -v "$DOTFILES_DIR:/home/nbs/Dotfiles:Z" \  # Mount Dotfiles directory to container
  fedora:latest /bin/bash -l -c "source /home/nbs/Dotfiles/shell/bash/paths_and_vars.sh; source /home/nbs/Dotfiles/shell/bash/abbr.sh; /bin/fish -l -c 'source /home/nbs/Dotfiles/shell/env/paths_and_vars.sh; source /home/nbs/Dotfiles/shell/env/abbr.sh; fish'"  # Start bash, then enter fish shell with paths and aliases
