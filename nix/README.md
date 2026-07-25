# Nix and Home Manager Dotfiles

System configurations for **NixOS** and standalone Linux distributions (such as Arch Linux or Fedora) managed using **Nix Flakes** and **Home Manager**.

## Repository structure

```text
.
├── nix
│   ├── flake.lock
│   ├── flake.nix
│   ├── home
│   │   ├── cli.nix
│   │   ├── gnome.nix
│   │   ├── gui.nix
│   │   └── home.nix
│   └── nixos
│       ├── configuration.nix
│       └── hardware-configuration.nix
├── README.md
└── themes
```

The core configuration is organized into functional modules in `nix/home/`:

| Path | Purpose |
| :--- | :--- |
| `nix/home/home.nix` | Base configuration for user settings, environment variables, and CLI default entry points. |
| `nix/home/cli.nix` | Command-line interface (CLI) packages and shell configurations. |
| `nix/home/gui.nix` | Graphical user interface (GUI) applications. |
| `nix/home/gnome.nix` | GNOME desktop environment configurations. |
| `nix/flake.nix` | Defines system outputs and composes modules. |
| `nix/nixos/` | NixOS system-level configuration files. |
| `themes/` | Custom themes, icons, and background assets. |

## Before you begin

To use Nix Flakes features, enable experimental flags in your Nix configuration file (typically `~/.config/nix/nix.conf` or `/etc/nix/nix.conf`):

```text
experimental-features = nix-command flakes
warn-dirty = false
```

## Usage and workflow

The workflow uses explicit module composition in `flake.nix` for NixOS systems, and relies on `home.nix` for standalone Home Manager setups.

| Target | Command | Module composition | Notes |
| :--- | :--- | :--- | :--- |
| **NixOS** (Desktop) | `sudo nixos-rebuild switch --flake .#nixos` | **CLI + GUI + GNOME** | Flakes enforce the complete system module set. |
| **Non-NixOS** | `nix run home-manager -- switch --flake ~/Dotfiles/nix#nix` | **CLI ONLY** (Default) | `home.nix` imports CLI configurations by default. To include GUI applications, uncomment `gui.nix` and `gnome.nix` in `nix/home/home.nix`. |

