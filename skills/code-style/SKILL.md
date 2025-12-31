---
name: code-style
description: Enforce SOLID principles and clean code practices to improve readability, maintainability, and code quality. Use when writing, refactoring, or reviewing code.
---

# Code Style Skill

## Overview

This skill guides you in writing code that follows SOLID principles and clean code best practices. Whether you're building new features, refactoring existing code, or reviewing code quality, this skill provides language-agnostic principles and guidelines to create maintainable, readable, and robust software.

## When to Use This Skill

- Writing new functions, classes, or modules
- Refactoring existing code to improve quality
- Conducting code reviews
- Addressing technical debt
- Establishing team coding standards

---

## Core Principles

### SOLID Principles

These five principles form the foundation of good object-oriented design and apply across most programming languages.

#### S - Single Responsibility Principle

A class or function should have one reason to change—it should do one thing and do it well.

**Apply by:**
- Extract a new function when your function description includes "and"
- Separate concerns: business logic, data access, presentation should be in different modules
- If a class/function exceeds 100-150 lines, it likely has multiple responsibilities

**Avoid:** God objects/functions that handle multiple unrelated concerns. This makes testing, reuse, and modification difficult.

#### O - Open/Closed Principle

Software should be open for extension but closed for modification. Existing code shouldn't change when adding new features.

**Apply by:**
- Use abstraction (interfaces, base classes, abstract classes) to define contracts
- Allow behavior to be extended through inheritance or composition
- Use polymorphism to handle variations without modifying existing code

**Avoid:** Making breaking changes to existing code every time a new feature is needed. This introduces bugs and breaks existing clients.

#### L - Liskov Substitution Principle

Derived classes must be substitutable for their base classes without breaking the application.

**Apply by:**
- Honor the contract defined by base classes/interfaces
- Child classes should strengthen invariants, not weaken them
- Avoid surprising behavior overrides that violate expectations

**Avoid:** Subclasses that break the parent's interface contract or behave unexpectedly compared to their parent.

#### I - Interface Segregation Principle

Clients should not be forced to depend on interfaces they don't use. Keep interfaces small and focused.

**Apply by:**
- Split large interfaces into smaller, purpose-specific ones
- Classes should implement only the methods they actually need
- Prefer many specific contracts over one general contract

**Avoid:** Fat interfaces that force implementing classes to have empty or unused method implementations.

#### D - Dependency Inversion Principle

Depend on abstractions, not concrete implementations. High-level modules shouldn't depend on low-level modules.

**Apply by:**
- Inject dependencies rather than creating them internally
- Program against interfaces/abstractions, not concrete classes
- Use dependency injection containers to manage dependencies

**Avoid:** Hard-coding dependencies on concrete classes, which makes code rigid and hard to test.

---

## Clean Code Fundamentals

Beyond SOLID, these practices improve code readability, maintainability, and team productivity.

### Readability & Naming

Clear naming is the cornerstone of readable code. Names should reveal intent and eliminate ambiguity.

**Guidelines:**
- **Function names:** Use verbs that describe what the function does (calculateTotal, fetchUserById, validateEmail)
- **Variable names:** Use nouns that describe what the data represents (userProfile, orderTotal, isActive)
- **Boolean names:** Phrase as questions to make them self-documenting (isValid, hasPermission, shouldCache, canDelete)
- **Avoid abbreviations:** Unless they're universally known (HTTP, API, ID). "usr" is unclear; "user" is clear
- **Meaningful distinctions:** If you need userA and userB, the naming is too generic. Use currentUser and previousUser instead
- **Use searchable names:** Choose names you can grep for; avoid magic values that appear in multiple contexts

### Single Responsibility (Function/Class Size)

Smaller, focused units of code are easier to test, understand, and modify.

**Guidelines:**
- **Functions:** Aim for <20 lines; anything over 50 lines should prompt refactoring consideration
- **Classes:** If a class exceeds 300-400 lines, split it into focused classes
- **One level of abstraction:** Don't mix high-level and low-level details within the same function
- **Extract complex logic:** If a section of code is hard to understand, extract it into a well-named helper function

**Benefits:** Easier testing, reusability, and maintenance.

### DRY (Don't Repeat Yourself)

Avoid code duplication to make updates easier and reduce bugs.

**Guidelines:**
- Extract repeated code into functions or modules
- Use abstraction to capture similar patterns (base classes, shared utilities, templates)
- Balance pragmatism: Don't over-DRY code that happens to look similar but serves unrelated purposes
- Three-time rule: When you write the same code three times, extract it

**Trade-off:** Over-abstraction can make code harder to read. Only extract when duplication is truly redundant.

### Error Handling Patterns

Proper error handling makes code robust and easier to debug.

**Guidelines:**
- **Fail fast:** Validate inputs at function entry; catch problems early before they propagate
- **Specific errors:** Use specific error types and messages that indicate what went wrong and why
- **Handle at the right level:** Only catch exceptions you can meaningfully handle; let others propagate
- **Avoid silent failures:** Don't swallow errors without logging or rethrowing
- **Prefer early returns:** Use guard clauses to reduce nesting and return early on error conditions

---

## Universal Guidelines

These practices apply regardless of programming language.

### Code Structure & Flow

- **Avoid deeply nested code:** Aim for 2-3 levels max. Use guard clauses and early returns to flatten conditionals
- **Avoid magic strings/numbers:** Extract literals into named constants that explain their purpose
  - Bad: `if (age > 18)`
  - Good: `const LEGAL_AGE = 18; if (age > LEGAL_AGE)`
- **DO NOT use `else` statements unless necessary:** They create branching and nesting
- **AVOID `else` statements:** Prefer guard clauses and early returns
- **Prefer early returns:** Exit functions immediately when conditions aren't met, reducing indentation
- **Keep functions focused:** Composable and reusable units are easier to test and maintain
- **One reason to change:** If you need to modify a function for multiple reasons, extract smaller functions

### Naming & Clarity

- **Use descriptive names that reveal intent:** A name should answer "why this exists", not just "what it does"
- **PREFER single word variable names where possible:** But only if they're unambiguous (e.g., `user`, `total`, `status`)
- **Balance brevity with clarity:** `temp` is too vague; `temperatureCelsius` is clear but long; `tempC` is reasonable

### Conditional Logic

- **PREFER use negative programming to reduce conditionals:**
  - Bad: `if (user.isActive) { doSomething(); }`
  - Good: `if (!user.isActive) { return; } doSomething();`
  - Negative logic eliminates nesting and makes error cases explicit
- **Guard clauses:** Handle error/edge cases first, then process the happy path
- **Reduce boolean flags:** If you're adding parameters to control behavior, consider extracting a separate function
- **Avoid boolean parameters:** They create multiple execution paths; consider using specific function names instead

---

## Language-Specific References

While these principles are universal, each language has idiomatic patterns and practices.

- [javascript-typescript.md](references/javascript-typescript.md) - Variable declarations, modern syntax, async patterns, TypeScript-specific guidance

- [python.md](references/python.md) - Pythonic idioms, type hints, PEP 8 conventions, exception handling patterns

---

## Summary

Good code is:
- **Readable:** Your name choice should tell the story
- **Maintainable:** Single responsibility makes changes safe
- **Testable:** Small, focused functions are easier to verify
- **Principled:** SOLID principles guide sustainable design
- **Consistent:** Following these guidelines creates a common standard

Remember: Code is read far more often than it's written. Optimize for the reader.
