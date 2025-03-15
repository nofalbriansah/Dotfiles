```
# Nix
sh <(curl -L https://nixos.org/nix/install) --no-daemon

# Home-manager (Standalone)
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager

nix-channel --update

nix-shell '<home-manager>' -A install

---

.
├── home-manager
│   └── .config
│       └── home-manager
│           └── home.nix
├── README.md
└── themes
    └── .local
        └── share
            ├── backgrounds
            │   ├── 2024-12-27-08-29-36-forest.png
            │   ├── 2024-12-27-08-31-47-planets.png
            │   └── 2025-01-02-03-10-16-robot.jpg
            ├── icons
            │   ├── cursor-Kobo-Kanaeru
            │   ├── cursor-Megumin
            │   ├── icon-Colloid-Dark
            │   ├── icon-Colloid-Light
            │   └── icon-elementary
            └── themes
                ├── Marble-blue-dark
                ├── Marble-blue-light
                ├── Orchis-Dark-Compact
                └── Orchis-Light-Compact
```
