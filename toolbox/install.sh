#!/bin/bash

echo "Setting up toolbox environment..."

# Install additional tools in the container (optional, in case you need more tools)
sudo dnf install -y fish neovim git fastfetch starship eza zoxide
