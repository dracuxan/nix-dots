.PHONY: all build install update

all: build install

clean:
	nix-collect-garbage --delete-older-than 10d

build:
	@nixos-rebuild switch --flake .#dracuxan

update:
	@nix flake update

install:
	@bash install.sh
