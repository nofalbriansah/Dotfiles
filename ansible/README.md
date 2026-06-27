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
├── ansible.sh        # The main script to run everything
├── inventory.ini     # Defines localhost
├── site.yml          # Main playbook entry point
├── files/
│   ├── linux/        # Linux-specific configs and home files
│   ├── termux/       # Termux-specific configs and home files
│   └── themes/       # Visual assets (backgrounds, icons, etc.) (Linux only)
├── roles/
│   └── workstation/
│       ├── tasks/    # The logic (install packages, link files)
│       └── vars/     # Package lists and OS-specific variables (Archlinux.yml, Android.yml, etc.)
```

## 🚀 Usage

### Prerequisites for Termux (Android)
Before running the playbook on Android, ensure python and ansible are installed:
```bash
pkg install python -y
pip install ansible
```

### Running the Playbook
I run this locally on my machine.

1. **Clone the repo:**
   ```bash
   git clone https://github.com/nofalbriansah/Dotfiles
   cd Dotfiles/ansible
   ```

2. **Run the script:**
   ```bash
   chmod +x ansible.sh
   ./ansible.sh
   ```

### Tags
If I only want to update specific parts without running the whole playbook:

```bash
./ansible.sh --tags dotfiles  # Only update config symlinks
./ansible.sh --tags themes    # Only update wallpapers/icons (Linux only)
./ansible.sh --tags packages  # Only run package management
```

## ⚙️ Configuration

- **Packages:** Defined in `roles/workstation/vars/<OS>.yml` (e.g., `Archlinux.yml` or `Android.yml` for Termux).
- **Configs:** Placed in `files/linux/` (Linux desktop only) or `files/termux/` (Termux only). Inside each, there are `configs/` (linked to `~/.config/`) and `home/` (linked to `~/` root, including `~/.termux/` for Termux settings).
- **Offline Mode:** The playbook is configured to ignore errors during the `pacman -Syu` step if the repositories are unreachable, so I can still sync my configs without an internet connection.

## 💡 Why?

I wanted a single source of truth for my setup. Scripts are fine, but Ansible lets me say "I want this state" (idempotency) rather than writing "if file doesn't exist then do this" logic everywhere.