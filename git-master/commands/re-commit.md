---
description: Amend and enhance commit messages using the commit generator agent
argument-hint: [commit-ref] [operation] [scope]
---

Use @agent-commit-generator to amend and improve commit messages.

**Arguments:**

- `$1` (commit-ref): Commit identifier - accepts:
  - `all`: All commits in history
  - `N` (number): Last N commits (e.g., "4" = last 4 commits)
  - `HEAD~N`: Specific range (e.g., "HEAD~5" = last 5)
  - `HEAD~M..HEAD~N`: Range (e.g., "HEAD~10..HEAD~5")
  - Commit hash: Specific commit (e.g., "abc1234")
- `$2` (operation): What to do - "remove-coauthors", "remove-trailers", "enhance", "standardize"
- `$3` (scope, optional): "affected-files-only" (default) or "commit-only"

**Examples:**

- /agent-commit-generator all remove-coauthors
- /agent-commit-generator 4 remove-coauthors
- /agent-commit-generator 5 remove-trailers
- /agent-commit-generator abc1234 enhance affected-files-only
- /agent-commit-generator HEAD~10..HEAD standardize

Generate focused commit messages that clearly describe the changes. By default, strip co-author and trailer information unless the operation specifies otherwise.

Process:

1. Parse $1 and convert to git reference:
   - If "all" → use entire log
   - If numeric → convert to HEAD~N format
   - Otherwise use as-is
2. Identify the commit(s) specified
3. Execute the operation defined in $2
4. Apply scoping from $3 if provided
5. Generate improved commit messages using @agent-commit-generator
