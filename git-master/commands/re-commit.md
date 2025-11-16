---
description: re-commit and enhance commit messages using the commit generator agent
argument-hint: [commit-ref] [operation] [scope]
allowed-tools: bash
---

Use @agent-commit-generator to amend and improve commit messages.

**Arguments:**

- `$1` (commit-ref): Commit identifier - can be a hash, "HEAD", range ("HEAD~3..HEAD"), or action-based filter
- `$2` (operation): What to do - "remove-coauthors", "remove-trailers", "enhance", "standardize"
- `$3` (scope, optional): "affected-files-only" (default) or "commit-only"

**Examples:**

- /agent-commit-generator abc1234 remove-coauthors
- /agent-commit-generator HEAD~5 remove-trailers affected-files-only
- /agent-commit-generator HEAD~10..HEAD enhance

Generate focused commit messages that clearly describe the changes. By default, strip co-author and trailer information unless the operation specifies otherwise.

Process:

1. Identify the commit(s) specified by $1
2. Execute the operation defined in $2
3. Apply scoping from $3 if provided
4. Generate improved commit messages using @agent-commit-generator
