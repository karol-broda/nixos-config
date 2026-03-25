---
paths:
  - "**/*.rs"
  - "Cargo.toml"
  - "Cargo.lock"
---

- match on `Result`/`Option` explicitly when each variant needs handling. use `?` only for straightforward propagation
- don't chain `.unwrap()`, `.expect()`, or `.unwrap_or_default()` to hide error paths. handle them
- avoid `.clone()` unless justified. if you're cloning to satisfy the borrow checker, rethink ownership
- use `impl Trait` in function signatures for simple generic bounds
- prefer iterators and combinators over manual loops
- keep `unsafe` blocks minimal and always document why they're safe
