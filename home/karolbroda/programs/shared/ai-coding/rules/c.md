---
paths:
  - "**/*.c"
  - "**/*.h"
---

- always check return values of allocation and I/O functions
- free what you allocate. match every `malloc`/`calloc` with a `free`
- use `const` on pointers when the data shouldn't be modified
- prefer `size_t` for sizes and indices
- use `static` for file-scoped functions and variables
- header guards or `#pragma once` on every header
