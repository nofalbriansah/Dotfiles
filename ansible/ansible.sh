#!/bin/bash
# Provisions the local workstation using Ansible.
#
# Detects operating system, ensures Ansible and required Galaxy collections
# are installed, captures sudo credentials, and executes the workstation playbook.

set -euo pipefail

# Ensure working directory is the script root.
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_ROOT"

echo "🚀 Starting dotfiles provisioning..."

# Detect Android and Termux environments.
IS_ANDROID=false
if [[ "$(uname -o 2>/dev/null)" == "Android" ]]; then
    IS_ANDROID=true
fi

if [ "$IS_ANDROID" = false ]; then
    # Capture sudo credentials once to prevent interactive prompt collisions.
    read -s -p "[sudo] password for $USER: " SUDO_PASS
    echo ""

    # Verify sudo credentials.
    if ! echo "$SUDO_PASS" | sudo -S -v 2>/dev/null; then
        echo "❌ Sudo authentication failed. Check your password."
        exit 1
    fi

    export ANSIBLE_BECOME_PASS="$SUDO_PASS"
fi

# Automatically install Ansible if not present on the host system.
if ! command -v ansible-playbook &>/dev/null; then
    echo "⚙️  Ansible not found. Installing..."
    if command -v pacman &>/dev/null; then
        echo "$SUDO_PASS" | sudo -S pacman -S --noconfirm ansible
    elif command -v apt &>/dev/null; then
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

# Execute the dedicated workstation playbook.
ansible-playbook workstation.yml -i "localhost," -c local "$@"

# Clean up exported credentials.
if [ "$IS_ANDROID" = false ]; then
    unset ANSIBLE_BECOME_PASS
fi
