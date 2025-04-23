#!/bin/bash

COPR_REPOS=(
  "atim/starship"
  "zeno/scrcpy"
)

PACKAGES=(
  git
  wget
  curl
  libtrash
  tree
  stow
  java-21-openjdk
  fish
  fastfetch
  starship
  toolbox
  podman
  ghostty
)

# Enable COPR repositories if not already enabled
for repo in "${COPR_REPOS[@]}"; do
  # Check if the COPR repo is already enabled
  if ! sudo dnf repolist enabled | grep -q "$repo"; then
    echo "Enabling COPR repository: $repo"
    sudo dnf copr enable -y "$repo"
  else
    echo "COPR repository $repo is already enabled."
  fi
done
echo "Done checking and enabling COPR repos."

# Install the packages
sudo dnf install -y $(printf "%s " "${PACKAGES[@]}")
echo "Done installing packages!"

