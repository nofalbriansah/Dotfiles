#!/bin/bash
set -e

# --- 1. OS Detection ---
if [ -f /etc/arch-release ]; then
    DISTRO="Arch"
    PKG_MANAGER="pacman -S --needed --noconfirm"
elif [ -f /etc/debian_version ]; then
    DISTRO="Debian"
    PKG_MANAGER="apt install -y"
    sudo apt update
else
    echo "❌ Unsupported OS."
    exit 1
fi

# --- 2. Install Core Dependencies ---
for pkg in ansible git; do
    if ! command -v $pkg &> /dev/null; then
        echo "📦 Installing $pkg on $DISTRO..."
        sudo $PKG_MANAGER $pkg
    fi
done

# --- 3. Community Requirements ---
if command -v ansible-galaxy &> /dev/null; then
    echo "📥 Ensuring Ansible community collections are installed..."
    ansible-galaxy collection install community.general
fi

# --- 4. Execute Playbook ---
echo "🚀 Starting Ansible Magic..."
ansible-playbook -i inventory.ini site.yml --ask-become-pass "$@"