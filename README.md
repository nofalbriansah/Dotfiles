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
├── README.mdss
├── terminal
│   └── .config
│       ├── ghostty
│       │   └── config
│       └── kitty
└── themes
    └── .local
        └── share
            ├── backgrounds
            │   ├── forest.png
            │   ├── planets.png
            │   ├── robot.jpg
            │   ├── lanterns_festival.jpg
            │   └── wanna_join_our_party.jpg
            ├── icons
            │   ├── Cursor-Kobo-Kanaeru
            │   ├── Cursor-Megumin
            │   ├── icon-Colloid-Dark
            │   ├── icon-Colloid-Light
            │   └── icon-elementary
            └── themes
                ├── Marble-blue-dark
                ├── Marble-blue-light
                ├── Orchis-Dark-Compact
                └── Orchis-Light-Compact
```
