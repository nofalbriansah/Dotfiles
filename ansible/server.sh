#!/bin/bash
# Provisions remote servers or local server instances using Ansible.
#
# Usage:
#   ./server.sh          Remote mode: provisions hosts listed in inventory.ini via SSH
#   ./server.sh --local  Local mode: provisions the current machine directly (no SSH)

set -euo pipefail

# Ensure working directory is the script root.
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_ROOT"

if [[ "${1:-}" == "--local" ]]; then
    # Local mode: provisions the current server host directly.
    echo "🚀 Starting local server provisioning..."
    shift

    # Capture sudo credentials once to prevent interactive prompt collisions.
    read -s -p "[sudo] password for $USER: " SUDO_PASS
    echo ""

    if ! echo "$SUDO_PASS" | sudo -S -v 2>/dev/null; then
        echo "❌ Sudo authentication failed. Check your password."
        exit 1
    fi

    # Automatically install Ansible if not present on the host system.
    if ! command -v ansible-playbook &>/dev/null; then
        echo "⚙️  Ansible not found. Installing..."
        if command -v apt &>/dev/null; then
            echo "$SUDO_PASS" | sudo -S apt update -y
            echo "$SUDO_PASS" | sudo -S apt install ansible -y
        elif command -v dnf &>/dev/null; then
            echo "$SUDO_PASS" | sudo -S dnf install ansible-core -y
        else
            echo "❌ Unsupported package manager. Install Ansible manually."
            exit 1
        fi
    fi

    # Install dependencies defined in requirements.yml.
    if [ -f "requirements.yml" ]; then
        echo "📦 Installing Ansible Galaxy dependencies..."
        ansible-galaxy install -r requirements.yml
    fi

    export ANSIBLE_BECOME_PASS="$SUDO_PASS"
    ansible-playbook server.yml -i "localhost," -c local -e "target_hosts=localhost" "$@"
    unset ANSIBLE_BECOME_PASS

else
    # Remote mode: provisions remote hosts defined in inventory.ini via SSH.
    echo "🚀 Starting remote server provisioning..."
    if [ -f "requirements.yml" ]; then
        echo "📦 Installing Ansible Galaxy dependencies..."
        ansible-galaxy install -r requirements.yml
    fi

    ansible-playbook server.yml -i inventory.ini --ask-become-pass "$@"
fi
