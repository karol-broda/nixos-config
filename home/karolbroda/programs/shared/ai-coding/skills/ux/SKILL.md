---
name: ux
description: Review UI code for UX principles. Checks interaction design, accessibility, visual hierarchy, and Tailwind usage.
user-invocable: true
disable-model-invocation: true
argument-hint: "[file-or-directory]"
---

Review UI code for UX quality. If $ARGUMENTS is provided, review those files. Otherwise, review staged changes that touch UI components.

Evaluate against these principles:

**user effort**
- minimize steps to complete a task. every extra click is a cost
- don't make users confirm obvious actions or fill redundant fields
- pre-fill, default, and infer wherever possible
- make the primary action obvious and easiest to reach

**clarity**
- labels, buttons, and flows should be self-explanatory. don't make users think
- use verbs for actions ("Save draft", "Send invite"), not vague labels ("Submit", "OK", "Continue")
- error messages should say what went wrong AND how to fix it
- empty states should guide the user toward the first action

**feedback**
- every action needs visible feedback: loading states, success confirmation, error display
- disable buttons during submission to prevent double-clicks
- show progress for operations that take more than ~1 second
- optimistic UI where safe, loading spinners where not

**visual hierarchy**
- information density should match importance. don't bury key content
- consistent spacing, alignment, and grouping
- primary vs secondary actions should be visually distinct

**accessibility**
- keyboard navigable: tab order, focus indicators, escape to close
- sufficient color contrast (WCAG AA minimum)
- semantic HTML: buttons for actions, links for navigation, headings for structure
- labels on all form inputs, no placeholder-only fields

**responsive / layout**
- mobile-first when relevant. does it work on narrow viewports?
- avoid horizontal scroll on content areas
- touch targets at least 44x44px on mobile

**tailwind specifics** (when applicable)
- semantic class ordering: layout, spacing, sizing, typography, colors, effects
- no redundant utilities (e.g., `flex flex-row` since row is default)
- use design tokens / theme values over arbitrary values where possible

**output format**
- group findings by component/file
- for each issue: describe the UX problem from the user's perspective, then suggest the fix
- prioritize: blocking issues first, polish suggestions last
- if the UX is solid, say so. don't nitpick for the sake of it
