nixos   := "nixos"
darwin  := "macbook"
user    := "karolbroda"

default:
    @just --list

build host=nixos:
    nixos-rebuild build --flake ".#{{host}}" --use-remote-sudo

switch host=nixos:
    sudo nixos-rebuild switch --flake ".#{{host}}"

test host=nixos:
    sudo nixos-rebuild test --flake ".#{{host}}"

boot host=nixos:
    sudo nixos-rebuild boot --flake ".#{{host}}"

diff host=nixos:
    #!/usr/bin/env bash
    set -euo pipefail
    nix build ".#nixosConfigurations.{{host}}.config.system.build.toplevel" --no-link
    nvd diff /run/current-system \
      "$(nix path-info ".#nixosConfigurations.{{host}}.config.system.build.toplevel")"

darwin-switch:
    darwin-rebuild switch --flake ".#{{darwin}}"

darwin-build:
    darwin-rebuild build --flake ".#{{darwin}}"

home-switch:
    home-manager switch --flake ".#{{user}}@{{nixos}}"

update *inputs:
    nix flake update {{inputs}}

upgrade host=nixos:
    just update
    just diff {{host}}

check:
    nix flake check --print-build-logs

fmt:
    alejandra .

fmt-check:
    alejandra --check .

lint:
    statix check .

dead:
    deadnix .

gc days="7":
    sudo nix-collect-garbage --delete-older-than {{days}}d
    nix-collect-garbage --delete-older-than {{days}}d

optimise:
    sudo nix store optimise

generations:
    sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

rollback:
    sudo nixos-rebuild --rollback switch

iso:
    nix build ".#nixosConfigurations.{{nixos}}.config.system.build.isoImage" --print-build-logs
    @echo "iso: $(ls result/iso/*.iso)"

pkg name:
    nix build ".#{{name}}" --print-build-logs

prefetch url:
    nix run ".#prefetch-url-sha256" -- "{{url}}"

dev:
    nix develop
