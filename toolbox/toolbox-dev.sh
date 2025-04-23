#!/bin/bash

CONTAINER_NAME="dev"
HOST_DEVELOPMENTS_DIR="$HOME/TES"

# List of packages to install
PACKAGES=(
  "wget"
  "curl"
  "rmtrash"
  "nixpkgs-fmt"
  "zip"
  "unzip"
  "unrar"
  "btop"
  "nano"
  "tree"
  "stow"
  "bat"
  "eza"
  "zoxide"
  "clang"
  "cmake"
  "gnumake"
  "cargo"
  "ninja"
  "firebase-tools"
  "android-tools"
  "scrcpy"
  "nodejs"
  "neovim"
  "bun"
  "gitui"
  "go"
  "delve"
  "dotnet-sdk-8"
  "dotnet-runtime-8"
  "mono"
  "hugo"
  "imagemagick"
)

# Create Developments dir if it doesn't exist
mkdir -p "$HOST_DEVELOPMENTS_DIR"

# Check if the container already exists
if ! toolbox list | grep -q "$CONTAINER_NAME"; then
  echo "Creating toolbox container $CONTAINER_NAME..."
  toolbox create --container "$CONTAINER_NAME"
fi

# Start the container with Developments folder mounted and install packages
echo "Starting $CONTAINER_NAME with Developments mounted and installing packages..."
toolbox run --container "$CONTAINER_NAME" bash -c "
  echo 'PWD inside container:' && pwd
  sleep 3
  sudo dnf install -y ${PACKAGES[@]}
  echo 'Done installing packages!'
  /bin/fish -l
"

