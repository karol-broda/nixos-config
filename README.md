# nix-config

my personal nix configuration for nixos and macos using home-manager. everything is managed declaratively through a flake with per-platform modules.

<div align="center">
  <img src="home/karolbroda/programs/quickshell/assets/screenshots/terminal.png" alt="terminal screenshot" width="800" />
</div>

## what's inside

this repo contains system and home-manager configurations for both linux (nixos) and macos (darwin). the setup is split into:

- **hosts/** for system-level configuration (nixos and darwin)
- **home/** for user-level home-manager modules organized by platform

shared programs live in `home/karolbroda/programs/shared/` and get imported by both systems. platform-specific stuff goes in `nixos/` or `darwin/` subdirectories.

## nixos

rebuild the system:

```bash
sudo nixos-rebuild switch --flake .#nixos
```

---

## darwin

### fresh install

install nix using the determinate systems installer:

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

clone the repo and cd into it:

```bash
git clone https://github.com/karol-broda/nix-config.git ~/nix-config
cd ~/nix-config
```

first build (homebrew is installed automatically via [nix-homebrew](https://github.com/zhaofengli/nix-homebrew)):

```bash
sudo nix run nix-darwin -- switch --flake .#macbook
```

### rebuilding

after the initial setup:

```bash
sudo darwin-rebuild switch --flake .#macbook
```

## updating inputs

```bash
nix flake update
```
