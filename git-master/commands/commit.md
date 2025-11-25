---
argument-hint: grouping strategy (by files, by features, by modules, etc.)
description: Generate git commits grouped by specified strategy
---

Use the @agent-commit-generator to create commits grouped according to your strategy in $ARGUMENTS.

**Important:** Never include co-author information in commit messages.

**Grouping examples:**

default strategy is `by files`

- `by files` - one commit per each file
- `by features` - one commit per each feature touched across files
- `by domain` - group by each business domain (auth, payments, etc.)
- `by modules` - organize by each code module or component

**Process:**

1. Specify in $ARGUMENTS how to group changes: "by files", "by features", "by modules", "by domain", etc.
2. The agent analyzes staged changes and groups them according to your strategy
3. Generate individual commit messages for each group
4. Each commit message reflects only the changes in that specific group
5. Review and apply the generated commits
6. Make the commit messages clear and concise, summarizing the changes effectively according to the grouping strategy never using co-author information
7. Remove the co-author information from the commit messages and the reference to claude-code

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
