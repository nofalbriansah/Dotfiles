## ❄️ Ansible Dotfiles

A declarative and modular dotfiles framework for Arch Linux & CachyOS.

This framework manages packages, configurations, and visual assets (themes/icons) using declarative logic, allowing a system to be treated as a predictable, reproducible environment. By leveraging Ansible's idempotency, the desired state is defined in simple YAML files, and the automation ensures the machine matches that state perfectly.

## ✨ Features

- ⚡ Zero-to-Hero Bootstrap: A single script detects the OS, installs Ansible, and bootstraps AUR helpers (paru) automatically.

- 📦 Declarative Package Sync: System state is managed by defining packages as present or absent. The logic handles the installation or purging of software and unused dependencies based on the central configuration.

- 🔄 System Synchronization: A full system upgrade (pacman -Syu) is performed automatically before applying changes to maintain environment stability.

- 🎨 Automated Asset Deployment: Icons, Cursors, GTK Themes, and Wallpapers are managed with automatic conflict detection and cache refreshing.

- 📂 Dynamic Configuration Linking: Folders within files/configs/ are mapped to ~/.config/ using real-time file-system discovery.

## 📂 Directory Structure

```Plaintext

ansible/
├── bin/
│ └── dotfiles.sh # The bootstrap & run script
├── files/
│ ├── configs/ # Config folders (nvim, bash, kitty, etc.)
│ └── themes/ # Visual assets
│ ├── icons/ # Icons -> ~/.local/share/icons
│ ├── cursor/ # Cursors -> ~/.local/share/icons
│ ├── themes/ # GTK Themes -> ~/.local/share/themes
│ └── backgrounds/ # Wallpapers -> ~/.local/share/backgrounds
├── roles/
│ └── workstation/
│ ├── tasks/ # The logic (Archlinux.yml, dotfiles.yml, themes.yml)
│ └── vars/ # The state (Package lists & OS variables)
└── site.yml # Playbook entry point
```

## 🚀 Getting Started

1. Cloning the Repository
   Bash

git clone https://github.com/nofalbriansah/Dotfiles
cd Dotfiles/ansible

2. Executing the Workflow

The bootstrap script handles the initial setup. Sudo privileges are required for system upgrades and package synchronization.
Bash

chmod +x bin/dotfiles.sh
./bin/dotfiles.sh

## ⚙️ Customization Logic

1. Defining Package State

The file roles/workstation/vars/Archlinux.yml serves as the source of truth for the system software.

- Installation: State is set to present.

- Removal: State is set to absent.

- Exclusion: The line is commented out with #.

sys_packages:

- { name: 'neovim', state: 'present' }
- { name: 'nano', state: 'absent' }

2. Configuration Management

Configuration folders are placed inside ansible/files/configs/. The .bashrc file is handled as a special case to link directly to the home directory. 3. Visual Assets

Folders added to ansible/files/themes/ are symlinked to the appropriate XDG directories. The framework automatically refreshes the icon cache upon completion.
🛠 Targeted Execution (Tags)

Specific parts of the setup can be targeted using tags to save time:
Command Action
./bin/dotfiles.sh --tags dotfiles Updates only symlinks in ~/.config
./bin/dotfiles.sh --tags themes Updates only wallpapers, icons, and themes
./bin/dotfiles.sh --tags packages Performs system sync and package management

## 💡 Why

This setup was created to simplify dotfile management using declarative Ansible automation. Inspired by Nix, the framework ensures that every package and configuration is explicitly tracked in a single source of truth.

The system relies on:

- Declarative Clarity: Makes it easy to track installed packages and active configurations at a glance within YAML files.

- dempotency: Changes are only applied if the system state deviates from the configuration, ensuring efficiency.

- Predictability: Automatic system synchronization ensures package compatibility with the current environment.

- Portability: The entire setup is centralized in one repository, allowing system migration with a single command.
