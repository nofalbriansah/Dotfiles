# ❄️ My Ansible Dotfiles

This is my personal setup for managing my Linux (Arch Linux, CachyOS, Debian, Fedora) and Android (Termux) environments. It uses Ansible to handle packages, configurations, and visual assets. It's not a complex framework, just a declarative way to ensure my machine stays the way I like it without running manual scripts every time.

## ⚡ What it does

- **Package Management:** Installs or removes packages based on the operating system list. On Termux, it uses `pkg`, while on Linux it uses the native package managers (`pacman`, `apt`, `dnf`) and supports AUR packages on Arch.
- **Dotfiles:** Symlinks config and home files from `files/linux/` (for Linux desktop) or `files/termux/` (for Android) to the target directories.
- **Themes & Assets:** Places wallpapers, icons, and themes in their respective directories (Linux only).
- **Sudo & Android Handling:** Automatically detects Android to skip password capture and run non-root operations. On Linux, it sets up `nopasswd` for specific package management commands to avoid terminal hangs.

## 📂 Structure

```plaintext
ansible/
├── ansible.cfg       # Local execution settings (optimized for speed/offline)
├── ansible.sh        # The script to run workstation provisioning
├── server.sh         # The script to run remote server provisioning
├── inventory.ini     # Defines localhost (workstation) and remote hosts (server)
├── site.yml          # Main unified playbook (workstation & server)
├── server.yml        # Local server playbook (run directly ON the server)
├── files/
│   ├── linux/        # Linux-specific configs and home files
│   ├── termux/       # Termux-specific configs and home files
│   └── themes/       # Visual assets (backgrounds, icons, etc.) (Linux only)
├── roles/
│   ├── workstation/
│   │   ├── tasks/    # Workstation tasks (install packages, link files)
│   │   └── vars/     # Workstation package lists (Archlinux.yml, Android.yml, etc.)
│   └── server/
│       ├── tasks/    # Server tasks (install packages, link configs, install Zellij)
│       └── vars/     # Server variables (Debian.yml, RedHat.yml)
```

## 🚀 Usage

### 💻 Running Workstation Playbook (Local)
I run this locally on my machine (Arch Linux, Debian, Fedora, or Android Termux).

1.  **Clone the repo:**
    ```bash
    git clone https://github.com/nofalbriansah/Dotfiles
    cd Dotfiles/ansible
    ```

2.  **Run the script:**
    ```bash
    chmod +x ansible.sh
    ./ansible.sh
    ```

#### Tags
If I only want to update specific parts:
```bash
./ansible.sh --tags dotfiles  # Only update config symlinks
./ansible.sh --tags themes    # Only update wallpapers/icons
./ansible.sh --tags packages  # Only run package management
```

### ☁️ Running Server Playbook (Remote — from Termux/Laptop)
Used to provision remote Ubuntu/Debian or CentOS/RHEL/Rocky/AlmaLinux servers via SSH.

1.  **Configure remote SSH hosts** in `~/.ssh/config` (IP, ports, keys, users).
2.  **List target hosts** in `inventory.ini` under the `[servers]` group using their SSH aliases.
3.  **Run the server provisioning script:**
    ```bash
    chmod +x server.sh
    ./server.sh
    ```
    *This will prompt you for the sudo (`become`) password of the remote servers.*

#### Tags
```bash
./server.sh --tags packages  # Only install server system packages and Zellij
./server.sh --tags dotfiles  # Only symlink nvim and zellij configurations
```

### 🖥️ Running Server Playbook (Local — directly ON the server)
Use this when you have logged into the server manually and want to run Ansible locally.

1.  **Install prerequisites on the server:**
    ```bash
    # Ubuntu/Debian
    sudo apt install ansible -y

    # CentOS/RHEL (requires EPEL)
    sudo dnf install epel-release -y && sudo dnf install ansible -y
    ```

2.  **Clone the repo and run:**
    ```bash
    git clone https://github.com/nofalbriansah/Dotfiles
    cd Dotfiles/ansible
    chmod +x server.sh
    ./server.sh --local
    ```

#### Tags
```bash
./server.sh --local --tags packages  # Only install server system packages and Zellij
./server.sh --local --tags dotfiles  # Only symlink nvim and zellij configurations
```

## ⚙️ Configuration

- **Workstation Packages**: Defined in `roles/workstation/vars/<OS>.yml` (e.g. `Archlinux.yml` or `Android.yml`).
- **Server Packages**: Defined in `roles/server/vars/<OS_Family>.yml` (e.g. `Debian.yml` for Ubuntu/Debian, `RedHat.yml` for CentOS/RHEL).
- **Configs**: Placed in `files/linux/` (Linux desktop/server) or `files/termux/` (Termux). Inside each, there are `configs/` (linked to `~/.config/`) and `home/` (linked to `~/` root).
- **Offline Mode**: The workstation playbook ignores package upgrade failures if repositories are unreachable, allowing config sync without active internet.

## 💡 Why?

I wanted a single source of truth for my setups. Scripts are fine, but Ansible lets me declare the target state (idempotency) rather than writing "if file doesn't exist then do this" logic everywhere.