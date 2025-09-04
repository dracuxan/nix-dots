.PHONY: all build install update

all: build

clean:
	nix-collect-garbage --delete-older-than 10d

build:
	@nixos-rebuild switch --flake .#dracuxan --impure

update:
	@nix flake update

install:
	@bash install.sh
