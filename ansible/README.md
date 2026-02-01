# ❄️ My Ansible Dotfiles

This is my personal setup for managing my Arch Linux (and CachyOS) environment. It uses Ansible to handle packages, configurations, and visual assets. It's not a complex framework, just a declarative way to ensure my machine stays the way I like it without running manual scripts every time.

## ⚡ What it does

- **Package Management:** Installs or removes packages (Official & AUR) based on a list. It tries to handle system updates first, but if I'm offline, it skips the update and just checks installed packages.
- **Dotfiles:** Symlinks config folders from `files/configs/` to `~/.config/`.
- **Themes & Assets:** Places wallpapers, icons, and themes in their respective `~/.local/share/` directories.
- **Sudo Handling:** Sets up `nopasswd` for specific package management commands so I don't get stuck at a password prompt during long updates.

## 📂 Structure

```plaintext
ansible/
├── ansible.cfg       # Local execution settings (optimized for speed/offline)
├── ansible.sh        # The main script to run everything
├── inventory.ini     # Defines localhost
├── site.yml          # Main playbook entry point
├── files/
│   ├── configs/      # Config folders (nvim, kitty, etc.)
│   └── themes/       # Visual assets (backgrounds, icons, etc.)
├── roles/
│   └── workstation/
│       ├── tasks/    # The logic (install packages, link files)
│       └── vars/     # My package lists (Archlinux.yml)
```

## 🚀 Usage

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
./ansible.sh --tags themes    # Only update wallpapers/icons
./ansible.sh --tags packages  # Only run package management
```

## ⚙️ Configuration

- **Packages:** I define what I want installed in `roles/workstation/vars/Archlinux.yml`.
- **Configs:** I just drop new folders into `files/configs/`, and the playbook automatically links them to `~/.config/`.
- **Offline Mode:** The playbook is configured to ignore errors during the `pacman -Syu` step if the repositories are unreachable, so I can still sync my configs without an internet connection.

## 💡 Why?

I wanted a single source of truth for my setup. Scripts are fine, but Ansible lets me say "I want this state" (idempotency) rather than writing "if file doesn't exist then do this" logic everywhere.