# how to communicate

- be concise, no filler, no preamble, no "Great question!", no emoji
- don't summarize what you just did, the diff speaks for itself
- don't ask "would you like me to...", just do it
- if something is genuinely ambiguous, ask a direct question instead of guessing

# how to write code

- use descriptive variable and function names that tell the domain story, never abbreviate
- calculate values instead of magic numbers: `7 * 24` not `168`, `60 * 5` not `300`
- comments only for hotfixes, genuinely complex logic, or non-obvious intent. never narrate what code does
- self-documenting code over commented code
- no premature abstraction. three similar lines is better than a helper used once
- if it can be simpler, make it simpler
- break up large files and functions into small, focused units with clear responsibilities
- nested directory structure is fine. use it to organize by domain, not by type
- minimal diffs. change only what's needed, don't "improve" surrounding code
- don't add docstrings, type annotations, or comments to code you didn't change
- be explicit over implicit. prefer clear checks over shorthand operators that hide intent
- check for null/error values explicitly, but trust the type system. don't guard against states the types already rule out
- don't add error handling for scenarios that can't happen
- don't create abstractions for one-time operations
- match the existing style and patterns of the surrounding codebase

# how to engineer

- read code before changing it. understand context first
- find root causes before implementing fixes, don't bandaid
- separate structural changes (refactoring) from behavioral changes (features) in commits
- don't attribute failures to "pre-existing issues" without verifying on the base branch
- test the real thing. avoid mocks when possible
