# Ansible Dotfiles

Automated provisioning for Linux (Arch Linux, CachyOS, Debian, Fedora) and Android (Termux) environments using Ansible to manage packages, system configurations, and visual assets.

## Features

* **Package management:** Installs or removes packages based on the target operating system. Uses `pkg` on Termux, native package managers (`pacman`, `apt`, `dnf`) on Linux, and supports AUR packages on Arch Linux.
* **Configuration symlinking:** Links configuration and home directory files from `files/linux/` or `files/termux/` to their target locations.
* **Theme assets:** Places wallpapers, icons, and themes in their respective system directories on Linux desktop environments.
* **Environment handling:** Automatically detects Termux to run non-root operations without password prompts. Configures `nopasswd` rules for specific package management tasks on Linux to prevent terminal hangs.

## Repository structure

```text
ansible/
├── ansible.cfg       # Local execution settings (optimized for speed/offline)
├── ansible.sh        # Provisioning script for local workstations
├── server.sh         # Provisioning script for remote servers
├── inventory.ini     # Defines localhost (workstation) and remote hosts (servers)
├── site.yml          # Main unified playbook (workstation & server)
├── server.yml        # Local server playbook (run directly ON the server)
├── files/
│   ├── linux/        # Linux-specific configurations and home files
│   ├── termux/       # Termux-specific configurations and home files
│   └── themes/       # Visual assets (backgrounds, icons, etc.) (Linux only)
└── roles/
    ├── workstation/
    │   ├── tasks/    # Workstation tasks (package management, file symlinks)
    │   └── vars/     # Workstation package lists (Archlinux.yml, Android.yml, etc.)
    └── server/
        ├── tasks/    # Server tasks (package management, config links, Zellij setup)
        └── vars/     # Server variables (Debian.yml, RedHat.yml)
```

## Before you begin

Before running the playbooks, ensure your environment meets the following requirements:

* **Git and Ansible:** Verify that `git` and `ansible` are installed.
* **SSH configuration (for remote servers):** Define remote hosts in `~/.ssh/config` and list their hostnames under the `[servers]` group in `inventory.ini`.

## Usage

### Run the workstation playbook (Local)

Run this playbook locally on your workstation (Arch Linux, Debian, Fedora, or Android Termux):

1. **Clone the repository:**
   ```bash
   git clone https://github.com/nofalbriansah/Dotfiles
   cd Dotfiles/ansible
   ```

2. **Run the provisioning script:**
   ```bash
   chmod +x ansible.sh
   ./ansible.sh
   ```

#### Target specific components using tags

To run specific parts of the playbook, pass the `--tags` flag:

```bash
./ansible.sh --tags dotfiles  # Symlink configuration files only
./ansible.sh --tags themes    # Apply wallpapers and icons only
./ansible.sh --tags packages  # Run package management only
```

### Run the server playbook (Remote)

Provision remote Ubuntu/Debian or RHEL/CentOS servers over SSH from your local machine:

1. **Configure remote hosts** in `~/.ssh/config` and list them in `inventory.ini`.
2. **Execute the server script:**
   ```bash
   chmod +x server.sh
   ./server.sh
   ```
   *The script prompts for the remote `sudo` (`become`) password.*

#### Target specific server components

```bash
./server.sh --tags packages  # Install system packages and Zellij only
./server.sh --tags dotfiles  # Symlink Neovim and Zellij configurations only
```

### Run the server playbook (Local on server)

If you are logged into the remote server directly, run Ansible in local mode:

1. **Install Ansible on the server:**
   ```bash
   # Ubuntu/Debian
   sudo apt update && sudo apt install ansible -y

   # RHEL/CentOS (requires EPEL)
   sudo dnf install epel-release -y && sudo dnf install ansible -y
   ```

2. **Clone the repository and run the local flag:**
   ```bash
   git clone https://github.com/nofalbriansah/Dotfiles
   cd Dotfiles/ansible
   chmod +x server.sh
   ./server.sh --local
   ```

#### Target specific local server components

```bash
./server.sh --local --tags packages  # Install server packages only
./server.sh --local --tags dotfiles  # Symlink configurations only
```

## Configuration

* **Workstation package lists:** Defined in `roles/workstation/vars/<OS>.yml` (such as `Archlinux.yml` or `Android.yml`).
* **Server package lists:** Defined in `roles/server/vars/<OS_Family>.yml` (such as `Debian.yml` or `RedHat.yml`).
* **Configuration files:** Stored in `files/linux/` (Linux desktop/server) or `files/termux/` (Termux). Subdirectories include `configs/` (linked to `~/.config/`) and `home/` (linked to `~/`).
* **Offline execution:** The workstation playbook ignores package upgrade failures if repositories are unreachable, enabling configuration synchronization without an active internet connection.

## Architecture decisions

Using Ansible ensures a single source of truth for workstation configurations. Declarative playbooks maintain idempotency by enforcing the desired state without requiring manual conditional logic in shell scripts.