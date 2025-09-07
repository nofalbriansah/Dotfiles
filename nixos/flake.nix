{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, unstable, home-manager, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      specialArgs = {
        unstable = import unstable {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
      };

      modules = [
        ./nixos/configuration.nix
        
        {
          networking.proxy = {
            httpProxy = "http://127.0.0.1:7897";
            httpsProxy = "http://127.0.0.1:7897";
            noProxy = "127.0.0.1,localhost,::1";
          };

          environment.sessionVariables = {
            http_proxy = "http://127.0.0.1:7897";
            https_proxy = "http://127.0.0.1:7897";
            no_proxy = "127.0.0.1,localhost,::1";
          };
        }

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";

          home-manager.extraSpecialArgs = {
            unstable = import unstable {
              system = "x86_64-linux";
              config.allowUnfree = true;
            };
          };

          home-manager.users.nbs = import ./home/home.nix;
        }
      ];
    };
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
  };
}


