---
paths:
  - "**/*.py"
---

- use type hints on function signatures
- prefer list/dict/set comprehensions over manual loops when readable
- use `pathlib.Path` over `os.path`
- numpy: prefer vectorized operations over loops. if you're iterating over an array, there's probably a better way
- numpy: use broadcasting instead of explicit reshaping when possible
- prefer f-strings over `.format()` or `%`
