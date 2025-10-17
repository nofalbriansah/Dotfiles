# My Nix and Home Manager Dotfiles 🚀

This repository manages my system configurations for **NixOS** and other Linux distributions (like Arch/Fedora) using **Nix Flakes** and **Home Manager**.

## 📁 Repository Structure
```
.
├── nix
│   ├── flake.lock
│   ├── flake.nix
│   ├── home
│   │   ├── cli.nix
│   │   ├── gnome.nix
│   │   ├── gui.nix
│   │   └── home.nix
│   └── nixos
│       ├── configuration.nix
│       └── hardware-configuration.nix
├── README.md
└── themes
```

The core configuration is segregated into functional modules under the `nix/home/` directory:

| Path | Purpose |
| :--- | :--- |
| `nix/home/home.nix` | Universal **Base Config** (User/Env Vars) and **CLI Default** entry point. |
| `nix/home/cli.nix` | All Command Line Interface (CLI) packages and shell configuration. |
| `nix/home/gui.nix` | All Graphical User Interface (GUI) applications. |
| `nix/home/gnome.nix` | GNOME-specific configurations. |
| `nix/flake.nix` | Defines system outputs and composes modules. |
| `nix/nixos/` | NixOS system configuration files. |
| `themes/` | Custom themes, icons, and backgrounds. |

---

## 🛠️ Prerequisites for Flakes

To use Nix functionality, it is essential to enable the experimental features nix-command and flakes. 

Add the following line to Nix configuration file (typically ~/.config/nix/nix.conf or /etc/nix/nix.conf):

```
experimental-features = nix-command flakes
```

## 🚀 Workflow & Usage Summary

This workflow utilizes explicit module composition in `flake.nix` for NixOS, while relying on `home.nix` for standalone Home Manager systems.

| Target | Command | Module Composition | Notes |
| :--- | :--- | :--- | :--- |
| **NixOS** (Full Desktop) | `sudo nixos-rebuild switch --flake .#nixos` | **CLI + GUI + GNOME** | Flake guarantees the full set.|
| **Non-NixOS** | `nix run home-manager -- switch --flake ~/Dotfiles/nix#nbs` | **CLI ONLY** (by default) | `home.nix` imports CLI by default, maintaining a lightweight setup. **To install GUI apps:** Uncomment the `gui.nix` and `gnome.nix` imports inside `nix/home/home.nix` temporarily. |
