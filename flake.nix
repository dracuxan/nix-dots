{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, zen-browser, ... } @ inputs:
    let
      system = "x86_64-linux";
      specialArgs = { inherit inputs system; };
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        dracuxan = lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.dracuxan = {
                imports = [ ./home.nix ];
              };
              home-manager.extraSpecialArgs = { inherit inputs system; };
            }
          ];
        };
      };

      # Optional standalone Home Manager (if you ever want to apply it without NixOS)
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
          extraSpecialArgs = { inherit inputs system; };
        };
      };
    };
}

