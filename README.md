# Declarative Workspace Dotfiles

A dual-engine declarative configuration framework for Linux and Android environments.

This repository provides a unified approach to system state management, enabling predictable and reproducible workstation setups using declarative logic across two specialized engines: **Ansible** and **Nix**.

## Repository structure

```text
.
├── ansible/   # Declarative provisioning for Linux (Arch, Debian, Fedora) & Android (Termux)
└── nix/       # Functional configurations for NixOS & Home Manager
```

## Getting started

Refer to the documentation in each engine directory to set up and apply configurations:

* For Linux (Arch Linux, CachyOS, Debian, Fedora) and Android (Termux) environments, see the [Ansible documentation](ansible/README.md).
* For NixOS and Home Manager setups, see the [Nix documentation](nix/README.md).

## Core principles

This framework treats configuration as the single source of truth:

* **Declarative clarity:** Package lists and system states are explicitly defined in YAML or Nix files.
* **Idempotency:** System changes apply only when the current state deviates from the target configuration.
* **Batch efficiency:** Package managers install and update dependencies in consolidated batch transactions.
* **Portability:** Centralized configurations allow single-command migrations across fresh installations.
