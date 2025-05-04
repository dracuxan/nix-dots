build:
	@nixos-rebuild switch --flake .#beru

update:
	@nix flake update
