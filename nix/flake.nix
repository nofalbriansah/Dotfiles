{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, unstable, home-manager, ... }:
    let
      system = "x86_64-linux";

      # Overlay for custom packages
      overlays = [
        # ABDownloadManager as a custom package
        (final: prev: {
          abdownloadmanager = prev.stdenv.mkDerivation rec {
            name = "abdownloadmanager";
            version = "1.6.14";
            sha256 = "08l0dcj8gjg7sari5b4yvw3d9xisswxsa8sai54dkm1qs7kzgnf4";
            src = prev.fetchurl {
              url = "https://github.com/amir1376/ab-download-manager/releases/download/${version}/ABDownloadManager_${version}_linux_x64.tar.gz";
              sha256 = sha256;
            };
            nativeBuildInputs = [ prev.autoPatchelfHook prev.makeWrapper ];
            buildInputs = with prev; [
              xorg.libXtst
              xorg.libXext
              xorg.libXrender
              xorg.libXi
              alsa-lib
              fontconfig
              dejavu_fonts
              glib
              gtk3
              libappindicator-gtk3
            ];
            unpackPhase = ''
              tar -xzf $src
            '';
            installPhase = ''
              mkdir -p $out/opt/abdownloadmanager
              cp -r ABDownloadManager/* $out/opt/abdownloadmanager

              mkdir -p $out/bin
              makeWrapper $out/opt/abdownloadmanager/bin/ABDownloadManager \
                $out/bin/abdm \
                --set LD_LIBRARY_PATH "${prev.lib.makeLibraryPath buildInputs}"
            '';
          };

        })
      ];
    in
    {
      # NixOS system configuration
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;

        # Special arguments for unstable packages
        specialArgs = {
          unstable = import unstable {
            inherit system;
            config.allowUnfree = true;
          };
        };

        # NixOS modules
        modules = [
          ./nixos/configuration.nix

          {
            # Apply overlays (custom packages)
            nixpkgs.overlays = overlays;

            # Proxy for GUI apps and system networking
            networking.proxy = {
              httpProxy = "http://127.0.0.1:7890";
              httpsProxy = "http://127.0.0.1:7890";
              noProxy = "127.0.0.1,localhost,::1";
            };

            # Environment variables for shell and user applications
            environment.sessionVariables = {
              http_proxy = "http://127.0.0.1:7890";
              https_proxy = "http://127.0.0.1:7890";
              no_proxy = "127.0.0.1,localhost,::1";
            };
          }

          # Home Manager integration
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";

            # Special args for unstable packages
            home-manager.extraSpecialArgs = {
              unstable = import unstable {
                inherit system;
                config.allowUnfree = true;
              };
            };

            # Import user home configuration
            home-manager.users.nbs = import ./home/home.nix;
          }
        ];
      };

      # Formatter for flake (nixpkgs-fmt)
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;
    };
}

