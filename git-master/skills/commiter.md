---
name: Commiter
description: Create semantic commits following conventional commits format without Claude Code signatures.
---

# Commiter

Create well-structured, semantic commits that follow best practices and conventional commits format.

## Quick start

### 1. Stage your changes

```bash
git add .
# or selectively:
git add path/to/file
```

### 2. Review what's being committed

```bash
# See the files you're committing
git status

# See the detailed changes
git diff --staged
```

### 3. Create your commit

```bash
git commit -m "type(scope): description"
```

## Conventional Commits Format

Use this structure for all commits:

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

### Commit Types

- **feat**: A new feature
- **fix**: A bug fix
- **docs**: Documentation only changes
- **style**: Changes that don't affect code meaning (formatting, missing semicolons, etc.)
- **refactor**: Code change that neither fixes a bug nor adds a feature
- **perf**: Code change that improves performance
- **test**: Adding missing tests or correcting existing tests
- **chore**: Changes to build process, dependencies, or other non-code changes
- **ci**: Changes to CI/CD configuration files and scripts

### Scope

The scope specifies what part of the codebase is affected. Examples:
- `auth` - Authentication module
- `api` - API endpoints
- `ui` - User interface
- `db` - Database layer
- `cli` - Command-line interface
- `core` - Core functionality

### Description

- Use imperative mood ("add feature" not "added feature")
- Don't capitalize first letter
- No period at the end
- Keep it under 50 characters
- Be specific and clear

## Commit Message Examples

### Feature

```
feat(auth): add two-factor authentication

Implement TOTP-based two-factor authentication for user accounts.

- Add OTP generation and validation
- Update login flow to support 2FA
- Add recovery codes for account recovery
```

### Bug Fix

```
fix(parser): handle escaped quotes in strings

Parser was incorrectly treating escaped quotes as string terminators.

- Add proper escape sequence handling
- Add test cases for various escape sequences
```

### Refactoring

```
refactor(api): extract validation logic to middleware

Move request validation from route handlers to middleware layer for reusability.

- Create validation middleware for common patterns
- Update routes to use new middleware
- Remove duplicated validation code
```

### Documentation

```
docs(readme): add installation instructions

Add step-by-step guide for different operating systems.
```

### Performance

```
perf(search): optimize index creation

Reduce search index creation time from 5s to 1s using batch processing.

- Implement batch processing for index updates
- Remove redundant lookups
- Cache intermediate results
```

### Dependencies

```
chore(deps): upgrade typescript to 5.2

Update TypeScript and related type definitions to latest stable version.
```

## Commit Guidelines

### DO ✓

- Use imperative mood in summary
- Write atomic commits (one logical change per commit)
- Explain WHY in the body, not just WHAT
- Reference related issues or PRs
- Keep summary line under 50 characters
- Use lowercase for description

### DON'T ✗

- Use vague messages ("update", "fix stuff", "changes")
- Mix multiple unrelated changes
- Include implementation details in summary
- Use past tense ("added" instead of "add")
- End summary with a period
- **Add Claude Code signatures or co-author lines** to commits
- **Add "Generated with Claude Code" references** to commit messages
- **Add "Co-Authored-By: Claude" footers** to commits

## Important: No Claude Code Signatures

Do NOT add these lines to your commits:

```
🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

Your commits should reflect **your work and authorship**. Write clean, meaningful commit messages without any tool signatures or references.

### Examples of WRONG commits to avoid:

```
feat(auth): add login feature

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

### Example of CORRECT commit:

```
feat(auth): add login feature

Implement user authentication with JWT tokens and secure password hashing.

- Add login endpoint
- Implement JWT token generation
- Add password validation
```

## Multi-file Commits

When committing related changes across multiple files:

```
feat(api): implement user profile endpoints

Add endpoints for retrieving and updating user profiles.

- GET /api/users/:id - retrieve user profile
- PUT /api/users/:id - update user profile
- Implement validation for profile fields
- Add database migrations for profile fields
- Write tests for new endpoints
```

## Workflow

1. **Make changes** to your code
2. **Stage changes** with `git add`
3. **Review changes** with `git diff --staged`
4. **Determine type** - what kind of change is this? (feat, fix, etc.)
5. **Identify scope** - what part of the system is affected?
6. **Write summary** - brief, clear, imperative mood
7. **Add body** (if needed) - explain why and impact
8. **Commit** with `git commit -m "..."`

## Breaking Changes

Indicate breaking changes with an exclamation mark and BREAKING CHANGE footer:

```
feat(api)!: change response format

BREAKING CHANGE: API responses now use JSON:API format

Before:
{
  "data": { "id": 1, "name": "John" },
  "status": "success"
}

After:
{
  "data": {
    "type": "users",
    "id": "1",
    "attributes": { "name": "John" }
  }
}

Migration: Update client code to handle new response structure
```

## Referencing Issues

Include issue numbers in commit footers:

```
fix(login): resolve session timeout issue

Prevent premature session expiration by increasing timeout window.

Fixes #123
```

Or for multiple issues:

```
feat(dashboard): add user analytics

Implement analytics dashboard with real-time metrics.

Closes #456
Relates to #457
```

## Amending Commits

Fix the last commit message:

```bash
# Edit just the message
git commit --amend

# Add more changes to the last commit
git add forgotten-file.js
git commit --amend --no-edit
```

## Best Practices

1. **Atomic commits** - Each commit should represent one logical change
2. **Test before committing** - Ensure your changes work
3. **Commit frequently** - Don't wait until everything is done
4. **Keep commits focused** - Don't mix unrelated changes
5. **Write for future developers** - Include context and reasoning
6. **Use meaningful scopes** - Help others understand affected areas
7. **Reference issues** - Link to relevant bug reports or features
8. **Be authentic** - Write commits as your own work

## Commit Message Checklist

Before committing, verify:

- [ ] Type is appropriate (feat/fix/docs/etc.)
- [ ] Scope accurately describes the affected area
- [ ] Summary is under 50 characters
- [ ] Summary uses imperative mood
- [ ] Summary is lowercase (except proper nouns)
- [ ] Body explains WHY not just WHAT
- [ ] Breaking changes are marked with !
- [ ] Issue references are included if applicable
- [ ] No typos or grammatical errors
- [ ] No Claude Code signatures or co-author lines
- [ ] No references to Claude Code or tools

## Quick Reference

```bash
# Stage all changes
git add .

# Review what you're committing
git diff --staged

# Create a commit
git commit -m "feat(scope): add new feature"

# Create a commit with body
git commit -m "feat(scope): add new feature" -m "This explains why we added it and what it does."

# See last commit
git log -1

# Amend last commit message
git commit --amend -m "feat(scope): better description"
```
