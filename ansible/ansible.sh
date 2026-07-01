#!/bin/bash

# --- PROJECT DIRECTORY SETUP ---
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_ROOT"

echo "🚀 Starting Dotfiles Provisioning..."

# --- DETECT ANDROID / TERMUX ---
IS_ANDROID=false
if [[ "$(uname -o 2>/dev/null)" == "Android" ]]; then
    IS_ANDROID=true
fi

if [ "$IS_ANDROID" = false ]; then
    # --- SUDO VALIDATION & PASSWORD CAPTURE ---
    # We capture the password once to pass it to Ansible, avoiding "Duplicate prompt" errors.
    read -s -p "[sudo] password for $USER: " SUDO_PASS
    echo ""

    # Verify the password is correct before proceeding
    if ! echo "$SUDO_PASS" | sudo -S -v 2>/dev/null; then
        echo "❌ Sudo authentication failed. Please check your password."
        exit 1
    fi

    # Export password for Ansible to use (avoiding interactive prompt issues)
    export ANSIBLE_BECOME_PASS="$SUDO_PASS"
fi

# --- AUTO-INSTALL ANSIBLE IF NOT FOUND ---
if ! command -v ansible-playbook &>/dev/null; then
    echo "⚙️  Ansible not found. Installing..."
    if command -v pacman &>/dev/null; then
        # Arch Linux / CachyOS
        echo "$SUDO_PASS" | sudo -S pacman -S --noconfirm ansible
    elif command -v apt &>/dev/null; then
        # Debian / Ubuntu
        echo "$SUDO_PASS" | sudo -S apt update -y
        echo "$SUDO_PASS" | sudo -S apt install ansible -y
    elif command -v dnf &>/dev/null; then
        # Fedora / CentOS / RHEL
        # ansible-core is available in AppStream on CentOS 10+ (no EPEL needed)
        echo "$SUDO_PASS" | sudo -S dnf install ansible-core -y
    else
        echo "❌ Unsupported package manager. Please install Ansible manually."
        exit 1
    fi
fi

# --- ANSIBLE EXECUTION ---
ansible-playbook site.yml -i "localhost," -c local "$@"

# Cleanup
if [ "$IS_ANDROID" = false ]; then
    unset ANSIBLE_BECOME_PASS
fi
