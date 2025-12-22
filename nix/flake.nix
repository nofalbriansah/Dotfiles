{ inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, unstable, home-manager, ... }:
    let
      system = "x86_64-linux";

      # Function to import the unstable channel with 'allowUnfree' set.
      importUnstable = args: (import unstable {
        inherit (args) system;
        config.allowUnfree = true;
      });
    in
    {
      ## NIXOS SYSTEM CONFIGURATION (FULL DESKTOP)
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { unstable = importUnstable { inherit system; }; };

        modules = [
          ./nixos/configuration.nix

          {
            # System-level proxy configuration
            networking.proxy = {
              httpProxy = "http://127.0.0.1:7890";
              httpsProxy = "http://127.0.0.1:7890";
              noProxy = "127.0.0.1,localhost,::1";
            };
            environment.sessionVariables = {
              http_proxy = "http://127.0.0.1:7890";
              https_proxy = "http://127.0.0.1:7890";
              no_proxy = "127.0.0.1,localhost,::1";
            };
          }

          # Home Manager integration as a NixOS module (for 'nixos-rebuild switch')
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.extraSpecialArgs = { unstable = importUnstable { inherit system; }; };

            home-manager.users.nbs = {
              # Import all user modules (base, CLI, GUI) for the NixOS environment
              imports = [
                ./home/home.nix
                ./home/gui.nix
                ./home/gnome.nix
              ];
            };
          }
        ];
      };

      ## STANDALONE HOME MANAGER (CLI ONLY DEFAULT)
      # This configuration is used when running 'home-manager switch --flake .#nix'
      homeConfigurations.nix = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = { unstable = importUnstable { inherit system; }; };
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        modules = [
          # Only import CLI configuration for standalone use on non-NixOS (or for minimal deployment)
          ./home/home.nix
        ];
      };

      ## FORMATTER
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;
    };
}
