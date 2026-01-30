#!/bin/bash

# --- PROJECT DIRECTORY SETUP ---
# Get the absolute path of the project root directory (one level up from /bin)
# This ensures the script works regardless of where it is called from.
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Change working directory to the project root where site.yml is located
cd "$PROJECT_ROOT"

echo "🚀 Starting Dotfiles Provisioning..."

# --- ANSIBLE EXECUTION ---
# Execute the main playbook.
# -i "localhost," : Forces Ansible to target localhost without needing an external inventory file.
# -K              : Prompts for the sudo (become) password at the start.
# "$@"            : Forwards any additional flags passed to this script (e.g., --tags "packages").
ansible-playbook site.yml -i "localhost," -c local -K "$@"