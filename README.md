## ❄️ Dotfiles: Declarative Workspace
Dual-engine declarative framework for Linux environments.

This repository provides a unified approach to system state management. It allows for a predictable and reproducible environment by leveraging declarative logic through two specialized engines.

## 📂 Repository Structure
```text
.
├── ansible/   # Declarative management for Arch Linux & CachyOS
└── nix/       # Functional configurations for NixOS & Home Manager
```

## 🚀 Getting Started

Individual documentation and execution scripts are located within their respective directories:
- For Arch Linux / CachyOS: Refer to the Ansible README.
- For NixOS & Home-Manager: Refer to the Nix README.

## 💡 Why

This setup exists to treat configuration as the ultimate source of truth. It relies on:
- Declarative Clarity: Explicitly tracking packages and configurations in YAML or Nix files.
- Idempotency: Applying changes only when the system state deviates from the config.
- Portability: Centralizing the entire workspace for single-command migrations.
