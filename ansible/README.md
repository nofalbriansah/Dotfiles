# Ansible Dotfiles

Automated system provisioning for Linux (Arch Linux, CachyOS, Debian, Fedora) and Android (Termux) environments using Ansible to manage packages, user configurations, and desktop assets.

## Features

* **Consolidated batch package management:** Synchronizes official packages via `pacman`, `apt`, `dnf`, or `pkg` in single-transaction batch executions for maximum speed.
* **Ansible Galaxy integration:** Uses curated collections (such as `kewlfft.aur` for Arch User Repository management) managed through a declarative `requirements.yml` file.
* **XDG-compliant configuration management:** Deploys configurations into `$XDG_CONFIG_HOME` (`~/.config/`) using symlinks locally or file synchronization remotely.
* **Single source of truth:** Shares universal configurations (such as Neovim and Git) across Linux, Server, and Termux environments from a unified `files/common/` directory.
* **Compressed visual assets:** Packs desktop themes, icons, and cursors into an optimized archive (`theme-assets.tar.xz`), minimizing repository size while maintaining idempotent unpacking.
* **Non-root privilege escalation:** Configures targeted `sudoers` rules for package managers on Linux workstations to prevent terminal hangs during non-interactive runs.

## Repository structure

```text
ansible/
├── ansible.cfg        # Ansible execution settings, paths, and output formatting
├── ansible.sh         # Bootstrap script for local workstation provisioning
├── server.sh          # Bootstrap script for remote or local server provisioning
├── inventory.ini      # Inventory file defining remote server endpoints
├── requirements.yml   # Ansible Galaxy collections and roles manifest
├── site.yml           # Master orchestrator playbook importing sub-playbooks
├── workstation.yml    # Dedicated playbook for local workstation provisioning
├── server.yml         # Dedicated playbook for server provisioning
├── files/
│   ├── common/        # Cross-platform configurations (Neovim, Git)
│   ├── linux/         # Linux desktop configurations (Fish, Alacritty, Kitty, Zed)
│   ├── termux/        # Android Termux configurations (Zellij)
│   └── themes/        # Wallpapers and compressed theme assets
└── roles/
    ├── workstation/
    │   ├── meta/      # Ansible Galaxy metadata for the workstation role
    │   ├── tasks/     # Workstation tasks (packages, dotfiles, themes)
    │   └── vars/      # Categorized package lists (Archlinux.yml, Debian.yml, etc.)
    └── server/
        ├── meta/      # Ansible Galaxy metadata for the server role
        ├── tasks/     # Server tasks (system packages, dotfiles, Zellij)
        └── vars/      # Server package lists (Debian.yml, RedHat.yml)
```

## Prerequisites

Before executing playbooks, verify that your host meets the following requirements:

* **Git:** Required to clone the repository.
* **Ansible:** Version 2.12 or later. The bootstrap scripts automatically attempt to install Ansible if missing.
* **SSH configuration (remote servers):** Configure target hosts in `~/.ssh/config` and verify they match the hostnames in `inventory.ini`.

## Usage

### Provision a local workstation

Run the workstation provisioning script on your local machine:

1. **Clone the repository:**
   ```bash
   git clone https://github.com/nofalbriansah/Dotfiles
   cd Dotfiles/ansible
   ```

2. **Execute the provisioning script:**
   ```bash
   chmod +x ansible.sh
   ./ansible.sh
   ```

#### Target specific components using tags

To limit playbook execution to specific subsystems, pass the `--tags` argument:

```bash
./ansible.sh --tags dotfiles   # Link configuration directories only
./ansible.sh --tags packages   # Run package synchronization only
./ansible.sh --tags themes     # Unpack theme assets and wallpapers only
```

### Provision a remote server (over SSH)

Provision remote Debian, Ubuntu, RHEL, or CentOS instances from your local machine:

1. **Add remote hosts** to `~/.ssh/config` and list them under the `[servers]` group in `inventory.ini`.
2. **Execute the server script:**
   ```bash
   chmod +x server.sh
   ./server.sh
   ```
   *The script prompts for the remote sudo password before starting execution.*

#### Target specific remote components

```bash
./server.sh --tags packages    # Install server packages and Zellij binary only
./server.sh --tags dotfiles    # Synchronize server configurations only
```

### Provision a server locally

When running directly on the server instance:

```bash
chmod +x server.sh
./server.sh --local
```

You can append tags to local executions as well:

```bash
./server.sh --local --tags packages
```

## Configuration and customization

* **Package definitions:** Package lists are modularized into `base_packages`, `dev_packages`, and `gui_packages` within `roles/workstation/vars/<OS>.yml`.
* **Galaxy dependencies:** Add new Ansible Galaxy roles or collections to `requirements.yml`. The bootstrap scripts automatically run `ansible-galaxy install` before invoking playbooks.
* **Distro fallback:** Workstation variable loading dynamically checks `{{ distribution }}.yml`, falls back to `{{ os_family }}.yml`, and then defaults to `default.yml`.
* **Offline resilience:** System package update tasks specify `ignore_errors: true` on cache refreshes, allowing offline configuration runs when remote mirrors are unreachable.