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
      
      # Overlay for custom packages
      overlays = [
        # ABDownloadManager as a custom package definition
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
      ## NIXOS SYSTEM CONFIGURATION (FULL DESKTOP)
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { unstable = importUnstable { inherit system; }; };

        modules = [
          ./nixos/configuration.nix
          
          {
            # Apply overlays (custom packages)
            nixpkgs.overlays = overlays;
            
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
      # This configuration is used when running 'home-manager switch --flake .#nbs'
      homeConfigurations.nbs = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = { unstable = importUnstable { inherit system; }; };
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = overlays; 
        };

        modules = [
          # Only import CLI configuration for standalone use on non-NixOS (or for minimal deployment)
          ./home/home.nix 
          # Apply overlay so custom packages are available
          { nixpkgs.overlays = overlays; }
        ];
      };

      ## FORMATTER
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;
    };
}
