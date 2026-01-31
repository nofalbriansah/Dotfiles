#!/bin/bash

# --- PROJECT DIRECTORY SETUP ---
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

echo "🚀 Starting Dotfiles Provisioning..."

# --- ANSIBLE EXECUTION ---
# Pastikan tidak ada karakter aneh setelah "$@"
ansible-playbook site.yml -i "localhost," -c local -K "$@"