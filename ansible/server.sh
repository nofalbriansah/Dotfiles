#!/bin/bash

# --- PROJECT DIRECTORY SETUP ---
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_ROOT"

# --- MODE DETECTION ---
# Usage:
#   ./server.sh          → Remote mode: provisions servers listed in inventory.ini via SSH
#   ./server.sh --local  → Local mode:  provisions the current machine (run this ON the server)

if [[ "$1" == "--local" ]]; then
    # --- LOCAL MODE ---
    # Run server.yml directly on the current machine (no SSH needed).
    # Use this when you have cloned the repo and are running Ansible on the server itself.
    echo "🚀 Starting Local Server Provisioning..."
    shift # Remove --local from args before passing remaining args to ansible-playbook

    # Capture sudo password once to avoid repeated prompts
    read -s -p "[sudo] password for $USER: " SUDO_PASS
    echo ""

    if ! echo "$SUDO_PASS" | sudo -S -v 2>/dev/null; then
        echo "❌ Sudo authentication failed. Please check your password."
        exit 1
    fi

    export ANSIBLE_BECOME_PASS="$SUDO_PASS"
    ansible-playbook server.yml -i "localhost," -c local "$@"
    unset ANSIBLE_BECOME_PASS

else
    # --- REMOTE MODE ---
    # Run site.yml against remote servers listed in inventory.ini via SSH.
    # Use this from your local machine (e.g. Termux or laptop) to provision remote servers.
    echo "🚀 Starting Remote Server Provisioning..."
    ansible-playbook site.yml -i inventory.ini --limit servers --ask-become-pass "$@"
fi
