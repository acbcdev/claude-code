---
argument-hint: file, directory, or scope to review (e.g., src/, auth.ts, staged)
description: Review code for clean code and KISS, DRY, YAGNI principles. Identify complexity, duplication, dead code, poor naming, and readability issues.
---

Review the code in $ARGUMENTS for **Clean Code** quality and violations of **KISS**, **DRY**, and **YAGNI** principles.

If $ARGUMENTS is empty, review all staged changes (`git diff --staged`). If no staged changes exist, review the current working directory.

Use the @code-style skill as the foundation for SOLID and style checks.

---

## Review Focus

### Clean Code

Code should read like well-written prose. If it needs a comment to explain, it needs rewriting.

**Naming — Flag these violations:**

- Vague names: `data`, `temp`, `result`, `info`, `handler`, `manager`, `process`
- Names that don't reveal intent or business meaning
- Inconsistent naming across the same codebase (mixing conventions)
- Abbreviations that aren't universally understood
- Boolean names that don't read as questions (`flag` → `isActive`)
- Magic numbers or string literals without named constants

**Functions — Flag these violations:**

- Functions longer than 20 lines (warning), 50+ lines (critical)
- Functions that do more than one thing (description includes "and")
- More than 3 parameters — use an object/struct instead
- Mixed abstraction levels in the same function
- Side effects hidden in function names that suggest pure computation
- Boolean flag parameters — split into separate functions

**Readability — Flag these violations:**

- Nesting deeper than 2-3 levels — flatten with guard clauses and early returns
- `else` blocks that could be eliminated with early returns
- Long conditional chains without extraction into named functions
- Code that requires scrolling to understand a single unit of logic
- Inconsistent formatting or structure within the same file

**Error Handling — Flag these violations:**

- Silent failures (empty catch blocks, swallowed errors)
- Generic catch-all without specific handling
- Error handling far from the source of the error
- Missing validation at system boundaries (user input, external APIs)

### KISS - Keep It Simple

The best code is the simplest code that works. Complexity is the enemy.

**Flag these violations:**

- Over-engineered abstractions for single-use cases
- Wrapper functions that add no value
- Complex generics or type gymnastics when a simple type suffices
- Clever one-liners that sacrifice readability
- Unnecessary design patterns (factory for one class, strategy for one behavior)
- Configuration systems for values that never change

**Ask:** "Can this be done in fewer lines without losing clarity?"

### DRY - Don't Repeat Yourself

Duplication is a missed abstraction — but only when the duplication is real, not coincidental.

**Flag these violations:**

- Identical or near-identical code blocks (3+ occurrences)
- Copy-pasted logic with minor variations that should be parameterized
- Repeated validation, formatting, or transformation patterns
- Duplicated constants or magic values across files

**Do NOT flag:**

- Similar code that serves different business purposes (coincidental duplication)
- Two instances of similar code — wait for the third before extracting

### YAGNI - You Aren't Gonna Need It

Never write code for hypothetical future requirements. The best code is code you never write.

**Flag these violations:**

- Unused parameters, functions, classes, or imports
- Feature flags or configuration for features that don't exist
- Abstract base classes with a single implementation
- Generic solutions when only one specific case exists
- "Just in case" error handling for impossible scenarios
- Commented-out code kept "for later"
- TODO comments for speculative features
- Premature optimization without measured bottlenecks
- Extra API endpoints, database fields, or UI elements with no current consumer

**Ask:** "Is anything using this right now? If not, delete it."

---

## Review Process

1. **Read** the target code thoroughly
2. **Identify** violations across all four areas: Clean Code, KISS, DRY, YAGNI
3. **Classify** each finding by category and severity:
   - **Critical**: Actively harmful — unreadable logic, dead code in production paths, silent failures
   - **Warning**: Should be addressed — large functions, duplication, over-abstraction, poor naming
   - **Suggestion**: Could be simpler — minor naming tweaks, small simplification opportunities
4. **Provide** specific fix for each finding with before/after examples
5. **Summarize** with a score and actionable next steps

---

## Output Format

```
## Code Review: [file/scope]

### Findings

#### [Clean Code|KISS|DRY|YAGNI] - [severity] - [short description]
**File:** `path/to/file:line`
**Problem:** What's wrong and why it matters
**Fix:** Concrete suggestion with code example

### Summary

| Principle  | Critical | Warning | Suggestion |
|------------|----------|---------|------------|
| Clean Code | 0        | 0       | 0          |
| KISS       | 0        | 0       | 0          |
| DRY        | 0        | 0       | 0          |
| YAGNI      | 0        | 0       | 0          |

**Verdict:** [CLEAN | NEEDS WORK | REFACTOR REQUIRED]
**Top priority:** [Most impactful change to make first]
```

---

## Key Rules

- **Be specific**: Point to exact lines and files, not vague advice
- **Show the fix**: Every finding must include a concrete before/after
- **Don't over-flag**: Only flag real problems, not style preferences
- **Respect existing patterns**: If a pattern is used consistently across the codebase, don't flag individual instances
- **Prioritize deletion**: The best refactor is removing code that shouldn't exist
- **No gold-plating**: Don't suggest adding features, abstractions, or "improvements" beyond what was asked
- **Readability wins**: When in doubt, favor the version a junior dev can understand in 5 seconds
