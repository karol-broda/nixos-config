---
name: review
description: Review code changes against coding principles. Catches magic numbers, bad names, over-engineering, narrating comments, and style mismatches.
user-invocable: true
disable-model-invocation: true
argument-hint: "[file-or-directory]"
---

Review code for quality issues. If $ARGUMENTS is provided, review those files. Otherwise, review staged git changes (`git diff --cached`). If nothing is staged, review all uncommitted changes (`git diff`).

For each file, check against these criteria and report violations:

**naming**
- are variable and function names descriptive and self-explanatory?
- do names tell the domain story? flag abbreviations, single letters (except loop indices), or generic names like `data`, `result`, `temp`, `handler`

**magic numbers**
- are there hardcoded numeric values that should be expressions?
- `7 * 24` not `168`, `60 * 5` not `300`, `1024 * 1024` not `1048576`
- constants are fine when the value IS the meaning (e.g., `port = 443`, `exit 1`)

**comments**
- are there narrating comments that just describe what the code does? flag them
- comments are only acceptable for: hotfixes, genuinely complex logic, non-obvious intent
- "// increment counter" or "// loop through items" = always wrong

**complexity**
- are there unnecessary abstractions, wrappers, or indirection?
- are there monolith functions that should be broken up?
- is there over-engineering: error handling for impossible cases, unused parameters, premature generalization?
- could anything be simpler while achieving the same result?

**style**
- does the new code match the patterns and conventions of the surrounding codebase?
- are there inconsistencies in naming conventions, indentation, or structure?

**output format**
- group findings by file
- for each issue: quote the line, explain what's wrong, suggest the fix
- if the code is clean, just say so. don't manufacture issues
