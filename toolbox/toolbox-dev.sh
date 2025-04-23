#!/bin/bash

CONTAINER_NAME="dev"
HOST_DEVELOPMENTS_DIR="$HOME/Developments"

COPR_REPOS=(
  atim/starship
  zeno/scrcpy
)

# List of packages to install
PACKAGES=(
  wget
  curl
  libtrash
  zip
  unzip
  unrar
  btop
  nano
  tree
  stow
  bat
  zoxide
  clang
  cmake
  cargo
  ninja-build
  android-tools
  nodejs
  neovim
  gitui
  go
  delve
  dotnet-sdk-8.0
  dotnet-runtime-8.0
  mono-devel
  hugo
  gtk3-devel
  lzma-sdk-devel
  pkgconf-pkg-config
  java-21-openjdk
  fish
  fastfetch
  starship
  scrcpy
  # bun
  # eza
  # firebase-tools
  # blowfish-tools
)

# Create Developments dir if it doesn't exist
mkdir -p "$HOST_DEVELOPMENTS_DIR"

# Check if the container already exists
if ! toolbox list | grep -q "$CONTAINER_NAME"; then
  echo "Creating toolbox container $CONTAINER_NAME..."
  toolbox create --container "$CONTAINER_NAME"
fi

# Start the container, enable COPR repos, and install packages
echo "Starting $CONTAINER_NAME with Developments mounted and installing packages..."
toolbox run --container "$CONTAINER_NAME" bash -c "
  sudo dnf install -y dnf-plugins-core

  # Enable COPR repos
  for REPO in ${COPR_REPOS[@]}; do
    sudo dnf copr enable -y \$REPO
  done

  # Install the packages
  sudo dnf install -y ${PACKAGES[@]}

  echo 'Done installing packages!'
"
