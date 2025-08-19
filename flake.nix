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
	dracuxan = lib.nixosSystem {
          inherit system;
          modules = [ 
            ./configuration.nix
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.dracuxan = {
                imports = [ ./home.nix ];
              };
            }
          ];
        };
      };
      hmConf = {
        dracuxan = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs;
          modules = [
            ./home.nix
            {
              home = {
                username = "dracuxan";
                homeDirectory = "/home/dracuxan";
                stateVersion = "25.05";
              };
            }
          ];
        };
      };
    };
}
