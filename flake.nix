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
          modules = [ ./configuration.nix];
        };
      };
      hmConf = {
        beru = home-manager.lib.homeManagerConfiguration {
          inherit system pkgs;
          username = "beru";
          homeDirectory = "/home/beru";
          configuration = {
            imports = [
              ./home.nix
            ];
          };
        };
      };
    };
}
