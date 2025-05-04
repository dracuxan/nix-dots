{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }: 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;      
    in {
      nixosConfigurations = {
        beru = lib.nixosSystem {
          inherit system;
          modules = [ 
            ./configuration.nix
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.beru = {
                imports = [ ./home.nix ];
              };
            }
          ];
        };
      };
      hmConf = {
        beru = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs;
          modules = [
            ./home.nix
            {
              home = {
                username = "beru";
                homeDirectory = "/home/beru";
                stateVersion = "24.11";
              };
            }
          ];
        };
      };
    };
}
