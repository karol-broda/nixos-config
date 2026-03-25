---
paths:
  - "**/*.go"
  - "go.mod"
  - "go.sum"
---

- handle errors explicitly. never ignore with `_`, always check `err != nil`
- prefer returning errors over panicking. `panic` is for truly unrecoverable states
- check concrete error types with `errors.Is`/`errors.As`, not string matching
- keep interfaces small, one or two methods
- use `context.Context` for cancellation and timeouts, pass it as the first parameter
- prefer table-driven tests
- don't use `init()` unless absolutely necessary
