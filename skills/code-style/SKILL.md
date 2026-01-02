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

A class or function should do one thing and have one reason to change.

- Extract when description includes "and"
- Keep functions under 100 lines; classes under 300 lines
- Separate concerns: business logic, data access, presentation

#### O - Open/Closed Principle

Open for extension, closed for modification. Add features without changing existing code.

- Use abstractions (interfaces, base classes) to define contracts
- Extend via inheritance or composition

**Avoid:** Breaking changes to existing code when adding features.

#### L - Liskov Substitution Principle

Child classes must be substitutable for parent classes without breaking behavior.

- Honor parent class contracts
- Strengthen invariants, don't weaken them

**Avoid:** Subclasses that break the parent's contract or behave unexpectedly.

#### I - Interface Segregation Principle

Keep interfaces small and focused. Don't force clients to implement unused methods.

- Split large interfaces into smaller, purpose-specific ones
- Implement only what you need

**Avoid:** Fat interfaces with unused implementations.

#### D - Dependency Inversion Principle

Depend on abstractions, not concrete implementations.

- Inject dependencies rather than creating them internally
- Program against interfaces, not concrete classes

**Avoid:** Hard-coded dependencies on concrete classes.

---

## Clean Code Fundamentals

Beyond SOLID, these practices improve code readability, maintainability, and team productivity.

### Readability & Naming

Names should reveal intent and be searchable.

- **Functions:** Use verbs (calculateTotal, fetchUserById, validateEmail)
- **Variables:** Use nouns (userProfile, orderTotal, isActive)
- **Booleans:** Phrase as questions (isValid, hasPermission, shouldCache)
- **Avoid abbreviations** unless universal (HTTP, API, ID)
- **Avoid magic values:** Extract to named constants

### Single Responsibility (Function/Class Size)

- **Functions:** Aim for <20 lines; refactor if over 50
- **Classes:** Split if over 300 lines
- **One level of abstraction:** Don't mix high-level and low-level details
- **Extract complex logic** into well-named helper functions

### DRY (Don't Repeat Yourself)

- Extract repeated code into functions or modules
- Use abstraction for similar patterns (base classes, shared utilities)
- Three-time rule: Extract when the same code appears three times

**Avoid:** Over-abstraction that hides intent.

### Error Handling Patterns

- **Fail fast:** Validate inputs at entry; catch problems early
- **Specific errors:** Use specific error types with clear messages
- **Handle at the right level:** Only catch what you can meaningfully handle
- **Avoid silent failures:** Log or rethrow errors

**Avoid:** Swallowing exceptions without logging.

---

## Universal Guidelines

These practices apply regardless of programming language.

### Code Structure & Flow

- **Limit nesting:** Aim for 2-3 levels max using guard clauses and early returns
- **Extract magic values:** Use named constants instead of literals
- **Avoid else statements:** Use early returns and guard clauses
- **Keep functions focused:** One reason to change; single responsibility

### Naming & Clarity

- **Names reveal intent:** Not just "what" but "why"
- **Single-word names:** OK if unambiguous (user, total, status)
- **Balance brevity & clarity:** `temp` is vague; `tempC` or `temperature` is better

### Conditional Logic

- **Guard clauses:** Handle edge cases first; process happy path after
- **Early returns:** Reduce nesting with `if (!condition) return;`
- **Avoid boolean parameters:** Create separate functions instead of flag parameters

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
