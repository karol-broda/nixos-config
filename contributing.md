# conventional commits

this repo uses [conventional commits](https://www.conventionalcommits.org) with scoped messages

## format

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

append `!` after the scope to flag a breaking change:

```
refactor(modules)!: rename personal.nix options to personal.nixConfig
```

## types

| type | use |
|---|---|
| `feat` | new feature, module, or program |
| `fix` | bug fix |
| `refactor` | restructuring without behavior change |
| `chore` | maintenance (deps, formatting, cleanup) |
| `docs` | documentation changes |
| `style` | code style / formatting only |

## scopes

scopes follow the directory structure with `/` as a separator for nested paths

### top-level scopes

| scope | directory | description |
|---|---|---|
| `flake` | `parts/`, `flake.nix` | flake inputs, builders, args, overlays |
| `modules` | `modules/` | nixos/darwin option modules |
| `nixos` | `hosts/nixos/` | nixos host configuration |
| `darwin` | `hosts/darwin/` | darwin host configuration |
| `home` | `home/` | home manager configuration |
| `pkgs` | `pkgs/` | custom package derivations |
| `fmt` | — | formatting / linting runs |

### nested scopes for `modules/`

use `modules/<area>` when changing a specific module area:

| scope | modules |
|---|---|
| `modules/shared` | `modules/shared/` — cross-platform (nix, fonts, locale, packages) |
| `modules/boot` | boot loader, kernel config |
| `modules/user` | user account, groups, sudo |
| `modules/docs` | documentation (man pages, dev docs) |
| `modules/services` | desktop services, power, thunderbolt |
| `modules/hypr` | hyprland compositor, greeter, portals |
| `modules/gaming` | steam, bottles |
| `modules/hw` | audio, bluetooth, fingerprint, spacenavd |
| `modules/net` | networking, netbird, avahi |
| `modules/virt` | docker, libvirt |
| `modules/security` | gnome keyring, polkit |
| `modules/programs` | wireshark, 1password, packet tracer |

### nested scopes for `home/`

use `home/<area>` when changing home manager program configs:

| scope | directory |
|---|---|
| `home/shared` | `home/karolbroda/programs/shared/` — cross-platform programs |
| `home/nixos` | `home/karolbroda/programs/nixos/` + `nixos.nix` |
| `home/darwin` | `home/karolbroda/programs/darwin/` + `darwin.nix` |

for specific programs, use the program name directly:

| scope | examples |
|---|---|
| `hypr` | hyprland home config (`home/.../nixos/hypr/`) |
| `quickshell` | quickshell bar/launcher |
| `nvim` | neovim / nixvim config |
| `git` | git config |
| `ghostty` | ghostty terminal |

### multiple scopes

when a change spans multiple areas, pick the most significant scope
if truly cross-cutting, use a broad scope:

```
refactor(modules): extract config into modular options
feat(flake): add system to builder specialargs
```

## trailers

use [git trailers](https://git-scm.com/docs/git-interpret-trailers) in the commit footer for metadata:

| trailer | use |
|---|---|
| `BREAKING CHANGE: <what>` | describes what broke and how to migrate (pairs with `!`) |
| `Refs: #<issue>` | links to a related issue |
| `Co-authored-by: name <email>` | credit co-authors |
| `Reviewed-by: name <email>` | credit reviewers |

### breaking change example

```
refactor(modules/shared)!: split nix.substituters into base and extra lists

move host-specific caches out of the default substituters list
into extraSubstituters. hosts that previously overrode substituters
now need to use extraSubstituters instead.

BREAKING CHANGE: personal.nix.substituters no longer contains
host-specific caches. use personal.nix.extraSubstituters for
per-host binary caches.
```

## examples

```
feat(modules/shared): add cross-platform packages module with named categories
fix(modules/hw): resolve bluetooth codec config not applying
refactor(nixos): migrate hardcoded settings to personal.* options
feat(hypr): add workspace animation config
chore(fmt): run alejandra formatter
feat(home/shared): add starship prompt config
fix(darwin): correct homebrew tap paths
feat(pkgs): add hytale launcher derivation
refactor(flake)!: remove mkDarwinHost hostname parameter
```
