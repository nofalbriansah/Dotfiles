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

# --- ANSIBLE EXECUTION ---
ansible-playbook site.yml -i "localhost," -c local "$@"

# Cleanup
if [ "$IS_ANDROID" = false ]; then
    unset ANSIBLE_BECOME_PASS
fi
