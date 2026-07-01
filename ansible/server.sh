#!/bin/bash

# --- PROJECT DIRECTORY SETUP ---
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_ROOT"

echo "🚀 Starting Remote Server Provisioning..."

# --- ANSIBLE EXECUTION ---
# Running site.yml against inventory.ini and limiting execution to the 'servers' group.
# --ask-become-pass (-K) will prompt you for the sudo password of the remote servers.
ansible-playbook site.yml -i inventory.ini --limit servers --ask-become-pass "$@"
