---
argument-hint: grouping strategy (by files, by features, by modules, etc.)
description: Generate git commits grouped by specified strategy
---

Use the @agent-commit-generator to create commits grouped according to your strategy in $ARGUMENTS.

**Important:** Never include co-author information in commit messages.

**Grouping examples:**

- `by files` - one commit per modified file
- `by features` - one commit per feature touched across files
- `by domain` - group by business domain (auth, payments, etc.)
- `by modules` - organize by code modules or components

**Process:**

1. Specify in $ARGUMENTS how to group changes: "by files", "by features", "by modules", "by domain", etc.
2. The agent analyzes staged changes and groups them according to your strategy
3. Generate individual commit messages for each group
4. Each commit message reflects only the changes in that specific group
5. Review and apply the generated commits
6. Make the commit messages clear and concise, summarizing the changes effectively according to the grouping strategy never using co-author information
7. Remove the co-author information from the commit messages and the reference to claude-code 

