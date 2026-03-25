---
paths:
  - "**/*.nix"
  - "flake.lock"
---

- use `lib.mkIf` for conditional config, `lib.mkMerge` for combining sets
- prefer `let...in` for local bindings, keep let blocks close to their usage
- module structure: imports at top, then options/config
- use `lib.` prefix for library functions. avoid `with lib;` scope pollution
- don't manually format, formatters handle it
- use `lib.mkEnableOption`, `lib.mkPackageOption` for module options
- prefer `lib.optionalAttrs` and `lib.optionals` over if-then-else for attrs/lists
