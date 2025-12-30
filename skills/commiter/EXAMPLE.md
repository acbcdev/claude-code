---
name: Commit Examples Reference
description: Real-world examples of correct and incorrect commit messages for the commiter skill.
---

# Commit Examples Reference

Quick reference guide for commit message examples. Use these as templates when creating commits.

## Table of Contents

- [Correct Commit Patterns](#correct-commit-patterns)
- [Examples to Avoid](#examples-to-avoid)
- [Real-World Scenarios](#real-world-scenarios)

---

## Correct Commit Patterns

### Pattern 1: Simple Feature

**When**: Adding a new feature to a single component.

```
feat(auth): add password reset functionality

Implement email-based password reset with secure token validation.

- Generate secure reset tokens with 1-hour expiration
- Create password reset email template
- Add reset token validation endpoint
- Update user service with reset method
- Add tests for token expiration and reuse prevention
```

### Pattern 2: Bug Fix with Issue Reference

**When**: Fixing a reported bug linked to an issue.

```
fix(payment): prevent duplicate charges on retry

Users were being charged twice when clicking submit multiple times during network delays due to missing idempotency.

- Add idempotency key generation and validation
- Implement request deduplication in payment service
- Disable submit button during payment processing
- Add tests for concurrent payment submissions

Fixes #834
```

### Pattern 3: Feature Across Multiple Files

**When**: New feature touching multiple files/modules as one logical unit.

```
feat(auth): implement two-factor authentication

Add TOTP-based two-factor authentication for user security.

- Add OTP generation and validation service
- Update login flow to challenge with 2FA
- Create user-facing 2FA settings UI
- Generate and display recovery codes
- Add comprehensive test coverage

Closes #234
```

### Pattern 4: Breaking Change

**When**: Changes that require users/consumers to update their code.

```
feat(api)!: restructure user response format

BREAKING CHANGE: User endpoints now return nested response format requiring client updates

Before:
  { "id": 1, "name": "John", "email": "john@example.com" }

After:
  { "user": { "id": 1, "name": "John", "email": "john@example.com" } }

Migration: Update client code to access user data at response.user instead of directly at response root. See migration guide at docs/api-v2-migration.md

Closes #567
```

### Pattern 5: Documentation Update

**When**: Documentation-only changes.

```
docs(readme): add installation instructions for Windows

Add step-by-step guide for Windows installation including visual setup screenshots.
```

### Pattern 6: Refactoring

**When**: Restructuring code without changing behavior.

```
refactor(api): extract validation logic to middleware

Move request validation from route handlers to middleware layer for reusability and consistency.

- Create validation middleware for common patterns
- Update routes to use new middleware
- Remove duplicated validation code
- Add middleware tests
```

### Pattern 7: Performance Improvement

**When**: Optimizing performance.

```
perf(search): optimize index creation using batch processing

Reduce search index creation time from 5s to 1s by batching operations.

- Implement batch processing for index updates
- Remove redundant lookups in search algorithm
- Cache intermediate results during indexing
- Add performance benchmarks
```

### Pattern 8: Dependency Update

**When**: Updating project dependencies.

```
chore(deps): upgrade TypeScript to 5.2 and ESLint to 8.5

Update development dependencies to latest stable versions with type compatibility.

- TypeScript 4.8 -> 5.2 (add new type utilities)
- ESLint 8.3 -> 8.5 (add new linting rules)
- Update type definitions for compatibility
- Run full test suite to verify compatibility
```

### Pattern 9: Test Addition

**When**: Adding or improving tests.

```
test(auth): add comprehensive login flow tests

Add test coverage for login endpoint including success, failure, and edge cases.

- Test valid credentials acceptance
- Test invalid credentials rejection
- Test rate limiting on failed attempts
- Test concurrent login attempts
- Test session creation and validation
```

### Pattern 10: Multiple Related Issues

**When**: Commit resolves or relates to multiple issues.

```
fix(validation): correct email regex and phone number format

Fixed email validation regex that rejected valid addresses and updated phone validation.

- Fix email regex to support all RFC 5322 valid formats
- Update phone validation for international formats
- Add comprehensive validation test cases
- Update API documentation with examples

Fixes #111, #222
Relates to #333
```

---

## Examples to Avoid

### WRONG: Claude Code Signatures

**Problem**: Adds tool attribution that pollutes git history and falsely credits AI.

```
feat(auth): add login feature

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

**Problems**:
- Tool signature pollutes git history
- Falsely credits AI instead of human developer
- Makes commit less professional and authentic
- Violates conventional commits standard

**CORRECT**:

```
feat(auth): add login feature

Implement user authentication with JWT tokens and secure password hashing.

- Add login endpoint with request validation
- Implement JWT token generation and expiration
- Add password hashing with bcrypt
- Create login tests covering success and error cases
```

---

### WRONG: Tool References Anywhere

**Problem**: Mentioning the tool used even without formal signatures.

```
fix(api): resolve rate limiting bug

Fixed race condition in rate limiter. Generated with Claude Code.

Fixes #456
```

**Problems**:
- Still mentions tool in commit body
- Unprofessional and unnecessary
- Clouds the actual technical change

**CORRECT**:

```
fix(api): prevent rate limiter race condition

Resolved race condition where concurrent requests bypassed rate limits when checking counter and incrementing atomically.

- Use atomic increment operation instead of separate read/write
- Add test for concurrent request handling
- Update rate limiter documentation

Fixes #456
```

---

### WRONG: Vague Descriptions

**Problem**: Unclear what was actually changed.

```
feat: update code
```

**Problems**:
- Unclear what was actually changed
- No scope to identify affected area
- Useless in git history (what feature? what update?)

**CORRECT**:

```
feat(search): add fuzzy matching algorithm

Implement fuzzy string matching for search results to improve user experience with typos and partial matches.

- Add Levenshtein distance calculation
- Integrate fuzzy matching into search service
- Add tests with common typo patterns
```

---

### WRONG: Past Tense

**Problem**: Uses past tense and personal narration instead of imperative mood.

```
feat(auth): added OAuth2 support

I added OAuth2 login integration with Google and GitHub providers.

Closes #789
```

**Problems**:
- Uses past tense ("added") instead of imperative
- Includes personal narration ("I added")
- Violates conventional commits format

**CORRECT**:

```
feat(auth): add OAuth2 login support

Implement OAuth2 authentication for Google and GitHub providers with account linking.

- Create OAuth2 strategy configuration
- Implement callback handlers for each provider
- Add user account linking workflow
- Update authentication middleware
- Add integration tests

Closes #789
```

---

### WRONG: Mixed Concerns

**Problem**: Unrelated changes in single commit that should be separate.

```
feat(api): add user endpoints and update dependencies

Add new endpoints for user management plus update TypeScript, ESLint, and testing libraries.

- Add GET /api/users endpoint
- Add POST /api/users endpoint
- Upgrade TypeScript to 5.2
- Upgrade ESLint to 8.5
- Update Jest to 29.0
```

**Problems**:
- Mixes feature (feat) with dependency updates (chore)
- Two unrelated concerns in single commit
- Makes git history harder to bisect
- Breaks semantic versioning signal

**CORRECT** - Create Two Separate Commits:

```bash
# Commit 1: Feature
feat(api): add user CRUD endpoints

Implement complete user management API with GET, POST, PUT, DELETE operations.

- Create UserController with validation
- Add user service layer
- Implement database migrations
- Add comprehensive test coverage

# Commit 2: Dependencies
chore(deps): upgrade TypeScript, ESLint, and Jest

Update development dependencies to latest stable versions.

- TypeScript 5.0 -> 5.2
- ESLint 8.3 -> 8.5
- Jest 28.0 -> 29.0
```

---

### WRONG: Breaking Change Not Marked

**Problem**: Breaking changes without `!` marker or BREAKING CHANGE footer.

```
feat(api): change user response format

Response format changed from flat structure to nested. Users need to update clients.

Closes #567
```

**Problems**:
- Breaking change NOT marked with `!`
- No BREAKING CHANGE footer
- Consumers won't know to check this commit
- Breaks semantic versioning (should be major version)

**CORRECT**:

```
feat(api)!: restructure user response format

BREAKING CHANGE: User endpoints now return nested response format requiring client updates

Before:
  { "id": 1, "name": "John", "email": "john@example.com" }

After:
  { "user": { "id": 1, "name": "John", "email": "john@example.com" } }

Migration: Update client code to access user data at response.user instead of directly at response root. See migration guide at docs/api-v2-migration.md

Closes #567
```

---

### WRONG: Missing Issue References

**Problem**: Fixes critical bug but doesn't reference tracked issue.

```
fix(payment): prevent duplicate charges

Users were being charged twice when clicking submit during network delays.

- Add idempotency keys
- Disable button during processing
- Add concurrency tests
```

**Problems**:
- Fixes critical bug but doesn't reference issue
- No way to track in issue system
- Missing link between git history and issue tracker

**CORRECT**:

```
fix(payment): prevent duplicate charges on retry

Users were being charged twice when clicking submit multiple times during network delays due to missing idempotency.

- Add idempotency key generation and validation
- Implement request deduplication in payment service
- Disable submit button during payment processing
- Add tests for concurrent payment submissions

Fixes #834
```

---

### WRONG: Capitalization and Punctuation Errors

**Problem**: Capitalized description with period at end.

```
feat(auth): Add JWT token support.

Adds JWT authentication support to the system.
```

**Problems**:
- Capitalized description ("Add" not "add")
- Period at end of description
- Vague explanation

**CORRECT**:

```
feat(auth): add JWT token-based authentication

Implement JWT tokens for stateless authentication with 24-hour expiration and refresh token support.

- Create JWT generation and validation service
- Update authentication middleware
- Add token refresh endpoint
- Implement logout blacklist
```

---

### WRONG: Non-Standard Scopes

**Problem**: Scope doesn't follow project conventions.

```
feat(UserAuthenticationManagementModule): implement SSO

Changes are too vague and scope name is too long.
```

**Problems**:
- Scope too long and not concise
- Not matching project conventions
- Hard to read and maintain

**CORRECT**:

```
feat(auth): add single sign-on integration

Implement SSO with SAML 2.0 for enterprise customers.

- Create SAML assertion parser and validator
- Add SSO user provisioning workflow
- Update login flow to support SSO
- Add enterprise account setup UI
```

---

### WRONG: Poorly Formatted Issue References

**Problem**: Multiple issues without proper formatting.

```
fix(api): handle edge cases

Fixes #111 #222 #333

Related to the issues.
```

**Problems**:
- Multiple issue numbers on one line without commas
- Wrong keyword usage
- Vague description

**CORRECT**:

```
fix(api): handle edge cases in pagination

Fixed boundary conditions in pagination that caused data loss or duplication on large datasets.

- Add validation for page numbers beyond total pages
- Prevent negative limit values
- Handle zero-length result sets correctly
- Add edge case test coverage

Fixes #111, #222
Relates to #333
```

---

### WRONG: Incomplete Breaking Changes

**Problem**: Breaking change marked with `!` but missing details.

```
feat(api)!: remove old endpoints

We removed the old REST endpoints. Use GraphQL instead.
```

**Problems**:
- BREAKING CHANGE footer missing
- No migration path or examples
- Vague explanation
- Missing timeline

**CORRECT**:

```
feat(api)!: remove deprecated REST endpoints

BREAKING CHANGE: REST API v1 endpoints removed. Migrate to GraphQL API.

Deprecated endpoints:
  GET /api/v1/users/:id
  POST /api/v1/users
  PUT /api/v1/users/:id
  DELETE /api/v1/users/:id

Replacement GraphQL operations:
  query { user(id: ID!) { id name email } }
  mutation { createUser(input: UserInput!) { id name } }

Migration path:
1. Update API calls to use GraphQL endpoint at /graphql
2. See migration guide: docs/graphql-migration.md
3. Timeline: v2.0 endpoints available now, v1.0 removed in v3.0

Closes #999
```

---

## Real-World Scenarios

### Scenario 1: You Fixed a Login Bug

**Your changes**:
- Modified `src/auth/login.ts` to fix email validation
- Updated `src/auth/login.test.ts` with new test cases
- Updated `docs/auth.md` with clarification
- Fixes issue #456

**Commit**:

```
fix(auth): correct email validation regex

Email validation was too strict and rejected valid RFC 5322 addresses. Updated regex to support all standard email formats.

- Fix email regex pattern in login validator
- Add test cases for valid emails (including plus addressing)
- Add test cases for invalid emails
- Update documentation with email format examples

Fixes #456
```

---

### Scenario 2: You Added a New Search Feature

**Your changes**:
- Created `src/search/fuzzy.ts` - fuzzy matching algorithm
- Created `src/search/fuzzy.test.ts` - comprehensive tests
- Updated `src/search/index.ts` to use new algorithm
- Updated `src/ui/search-component.tsx` with results
- Related to feature request #234

**Commit**:

```
feat(search): add fuzzy matching for improved results

Implement fuzzy string matching to improve search results when users make typos or partial matches.

- Add Levenshtein distance calculation with configurable threshold
- Integrate into main search service
- Update search results UI to show match quality
- Add comprehensive test suite with 50+ test cases
- Update search documentation with fuzzy matching examples

Closes #234
```

---

### Scenario 3: You Updated Multiple Dependencies

**Your changes**:
- Updated package.json and package-lock.json
- Ran full test suite (all passing)
- Updated TypeScript types where needed
- No code logic changes

**Commit**:

```
chore(deps): upgrade major dependencies

Update key dependencies to latest stable versions for security and compatibility.

- TypeScript 4.8 -> 5.2
- ESLint 8.3 -> 8.5
- Jest 28.5 -> 29.2
- React 18.1 -> 18.3
- All tests passing with new versions
```

---

### Scenario 4: You Made an API Breaking Change

**Your changes**:
- Changed response format from flat to nested structure
- Updated all response handlers
- Created migration guide
- Fixes issue #789

**Commit**:

```
feat(api)!: restructure response format for consistency

BREAKING CHANGE: All API responses now use nested data structure instead of flat format

Before:
  {
    "id": "123",
    "name": "John",
    "email": "john@example.com",
    "createdAt": "2024-01-15"
  }

After:
  {
    "data": {
      "id": "123",
      "name": "John",
      "email": "john@example.com",
      "createdAt": "2024-01-15"
    },
    "meta": {
      "version": "2.0",
      "timestamp": "2024-01-20T10:30:00Z"
    }
  }

Migration steps:
1. Update all API response handlers to access data at response.data
2. Update error handling to check response.error instead of root level
3. See detailed migration guide: docs/api-v2-migration.md
4. Timeline: New format available v2.0, old format removed in v3.0 (Q2 2024)

Closes #789
```

---

### Scenario 5: You Refactored and Fixed a Bug

**Your changes**:
- Refactored validation middleware (no behavior change)
- Fixed bug in rate limiter
- Added tests

**Two separate commits** (mixing feat with refactor):

```bash
# Commit 1: Refactoring (no behavior change)
refactor(validation): extract common patterns to reusable middleware

Move repeated validation logic from multiple route handlers into shared middleware layer for maintainability.

- Create validation middleware factory
- Update routes to use new middleware
- Remove duplicated validation code
- Verify behavior unchanged with existing tests

# Commit 2: Bug fix (behavioral change)
fix(api): prevent rate limiter bypass on concurrent requests

Race condition allowed concurrent requests to bypass rate limits by checking and incrementing counter non-atomically.

- Use atomic increment for rate counter
- Ensure thread-safe rate limit checking
- Add tests for high-concurrency scenarios

Fixes #445
```

---

## Quick Format Reference

### Header Only (Simple changes):
```
type(scope): description
```

### Header + Body (Complex changes):
```
type(scope): description

Detailed explanation of what and why.

- Bullet point 1
- Bullet point 2
```

### Header + Body + Footer (With issue/breaking changes):
```
type(scope)!: description

Detailed explanation.

- Bullet point 1

BREAKING CHANGE: explanation
Fixes #123
```

### Issue Keywords:
- `Fixes #123` - for bug fixes
- `Closes #456` - for any issue
- `Resolves #789` - alternative to Closes
- `Relates to #101` - references without closing

---

## Type Quick Reference

| Type | Use When | Semver |
|------|----------|--------|
| `feat` | Adding new feature | MINOR |
| `fix` | Fixing a bug | PATCH |
| `docs` | Documentation only | - |
| `style` | Formatting only | - |
| `refactor` | Code restructure, same behavior | - |
| `perf` | Performance improvement | PATCH |
| `test` | Adding/modifying tests | - |
| `build` | Build system changes | - |
| `ci` | CI/CD configuration | - |
| `chore` | Maintenance, dependencies | - |

---

**Need help?** Reference this file when creating commits to ensure high-quality commit messages!
