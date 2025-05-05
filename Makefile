.PHONY: all build install update

all: build install

build:
	@nixos-rebuild switch --flake .#beru

update:
	@nix flake update

install:
	@bash install.sh
