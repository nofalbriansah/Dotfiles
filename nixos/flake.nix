{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, unstable }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        unstable = import unstable {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
      };
      modules = [ ./configuration.nix ];
    };
  };
}

