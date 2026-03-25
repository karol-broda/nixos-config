---
paths:
  - "**/*.ts"
  - "**/*.tsx"
  - "**/*.js"
  - "**/*.jsx"
---

- prefer `const` over `let`, never use `var`
- use strict TypeScript. no `any`, no `as` casts unless unavoidable
- be explicit. prefer `if (value === null)` over optional chaining (`?.`) when the check matters
- check for null values explicitly, but don't overcheck. if the type is `T | null`, check for `null`, don't also check `undefined`
- trust the type system. if the LSP says it can't be null, don't guard against it
- prefer named exports over default exports
- use early returns to avoid deep nesting
- React: prefer function components, keep components small and focused
- React: colocate state with the component that uses it, don't lift prematurely
- React: prefer `useMemo`/`useCallback` only when there's a measured need, not preemptively
- Tailwind: use design tokens over arbitrary values, keep class ordering consistent
