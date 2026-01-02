# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **Claude Code plugin collection** providing agents, commands, and skills for professional development workflows. The project is organized as a plugin marketplace with two main plugins:

- **git-master** - Git repository management with conventional commits, branch operations, and changelog management
- **coder** - Code quality analysis and style suggestions

## Repository Structure

```
claude-code/
├── .claude-plugin/          # Plugin marketplace configuration
│   └── marketplace.json     # Plugin definitions, versions, and metadata
├── agents/                  # Agent definitions (MD format)
│   ├── commit-generator.md  # Analyzes changes → generates conventional commits
│   ├── git-branch-manager.md # Safe branch creation, rename, deletion
│   └── changelog-manager.md # CHANGELOG.md maintenance (Keep a Changelog format)
├── commands/                # Command-line interface commands
│   └── commit.md           # Git commit command definition
├── skills/                  # Reusable skill guides
│   ├── commiter/           # Advanced conventional commits skill
│   │   ├── SKILL.md        # Core conventional commits guidelines
│   │   └── EXAMPLE.md      # Commit message examples and patterns
│   ├── code-style/         # Code style and clean code practices
│   │   ├── SKILL.md        # SOLID principles and universal guidelines
│   │   └── references/     # Language-specific guides
│   │       ├── javascript-typescript.md
│   │       └── python.md
│   └── screaming-architecture/  # Feature-based project organization
│       ├── SKILL.md        # Core screaming architecture principles
│       ├── EXAMPLE.md      # Real-world folder structure examples
│       └── references/     # Framework-specific guides
│           └── nextjs.md
├── hooks/                   # Pre/post-commit hooks and Git integration
├── statusline.sh            # Status display script (model, tokens, cost, git info)
└── README.md               # Public documentation and plugin installation
```

## Key Architecture Patterns

### 1. Conventional Commits Standard
All commits follow the format: `<type>[scope]: <description>`

**Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`

**Breaking changes**: Use `!` marker and `BREAKING CHANGE:` footer

Scope format should use singular form and follow project conventions (e.g., `auth`, `api`, `ui`).

### 2. Skill System
Skills are reusable guides documented in Markdown (SKILL.md). They serve as templates for complex processes:
- **code-style skill**: Teaches SOLID principles, clean code, language-specific idioms
- **commiter skill**: Advanced conventional commits with breaking changes, issue references

### 3. Agent-Based Automation
Agents are specialized workflows that handle specific tasks:
- **commit-generator**: Reads staged changes → analyzes → generates formatted commit message
- **git-branch-manager**: Validates branch names, checks protected status, safely manages branches
- **changelog-manager**: Maintains CHANGELOG.md following Keep a Changelog standards with semantic versioning

### 4. Multi-Language Support
Code style guidance is language-specific:
- **JavaScript/TypeScript**: const/let/var, async/await, guard clauses, type hints (TypeScript)
- **Python**: snake_case conventions, EAFP over LBYK, type hints, comprehensions, context managers

**Key principle**: Avoid `else` statements in all languages; use early returns and guard clauses.

### 5. Screaming Architecture
Feature-based project organization where the folder structure communicates business purpose:
- **Organization**: Group by feature domain, not technical type (NOT `components/`, `hooks/`, `api/`)
- **Structure**: `features/` (business features), `common/` (truly shared UI/utilities), `lib/` (integrations)
- **Naming**: Use kebab-case, descriptive filenames (NOT `index.tsx`), explicit component names
- **Barrel files**: Each feature exports public API through `index.ts`
- **Dependencies**: Features depend on `common/` and other features' barrel files only
- **Scaling**: Easy to add new features and understand the codebase structure at a glance

**Key principle**: The folder structure should "scream" what the application does at first glance.

## Common Development Tasks

### Updating Conventional Commits Guidance
- Edit: `skills/commiter/SKILL.md` (core rules)
- Edit: `skills/commiter/EXAMPLE.md` (real-world examples)
- Update commit types or formatting in: `agents/commit-generator.md`

### Adding Code Style Rules
- Edit: `skills/code-style/SKILL.md` (universal principles)
- Edit: `skills/code-style/references/{javascript-typescript,python}.md` (language-specific)
- Structure: Use DO/AVOID format with concise examples
- Avoid: Verbose explanations, redundant examples across files

### Updating Screaming Architecture Guidance
- Edit: `skills/screaming-architecture/SKILL.md` (core principles and patterns)
- Edit: `skills/screaming-architecture/EXAMPLE.md` (real-world folder structures)
- Edit: `skills/screaming-architecture/references/{nextjs,react,vue}.md` (framework-specific)
- Use `features/`, `common/`, `lib/` folder structure (NOT `shared/`)
- Include both structure examples and migration guides

### Adding or Modifying Skills
Skills are Markdown files with YAML frontmatter (name, description). They should be:
- Concise and actionable (avoid generic advice)
- Organized with clear sections and examples
- Focused on the specific workflow they teach

### Publishing Plugin Updates
- Increment version in: `marketplace.json` (update plugin `version` field)
- Update plugin references if adding agents or commands
- Ensure agent/skill paths are correct relative to repository root

## Status Line Configuration

The `statusline.sh` script displays:
- Current folder, model name, context usage percentage
- API cost, request time, lines added/removed
- Git branch and repository status

Used for real-time awareness during development sessions.

## Git Workflow Rules

**Critical rules for commits**:
- Use imperative mood ("add", "fix", "remove" - not "added", "fixed")
- Keep header under 50 characters
- Never add Claude signatures or attribution lines
- For multi-file commits: one commit = one logical unit
- Use heredoc format for multi-line messages

**Breaking changes**:
- Must use `!` marker in header
- Must include `BREAKING CHANGE:` footer with migration info
- Document before/after behavior clearly

**Branch naming**:
- Should follow conventions (feature/name, fix/issue-number, etc.)
- Avoid protected branch modifications
- Validate against repository policies

## Plugin Marketplace Configuration

The `marketplace.json` defines:
- **Plugin metadata**: name, version, description, author, license, keywords, category
- **Agent references**: paths to agent definition files
- **Command references**: paths to command definition files
- **Skill references**: paths to skill directories

Version format should follow semantic versioning (MAJOR.MINOR.PATCH).

## Future Plugins (In Development)

Planned additions visible in README.md:
- project-architect (folder structure organization)
- code-quality-auditor (detailed code review)
- test-automation-suite (test validation and automation)
- documentation-engine (README, API docs, JSDoc generation)
- naming-convention-enforcer (consistent naming)
- code-refactor-optimizer (refactoring assistance)
- performance-analyzer (bundle size, lazy loading)
- planning-orchestrator (project planning)
- impact-analyzer (dependency impact analysis)

## Key Files to Know

| File | Purpose |
|------|---------|
| `marketplace.json` | Plugin registration and versioning |
| `skills/code-style/SKILL.md` | Universal code style guidelines |
| `skills/commiter/SKILL.md` | Conventional commits standards |
| `agents/commit-generator.md` | Commit message generation logic |
| `agents/git-branch-manager.md` | Branch management workflows |
| `statusline.sh` | Session monitoring display |

## Important Constraints

- **DO NOT** modify protected branches without explicit user request
- **DO NOT** add Claude Code signatures or tool attribution to commits
- **DO NOT** include verbose explanations when simple examples suffice
- **DO NOT** create redundant examples across language-specific files
- **DO prefix all CLI commands with descriptions** explaining what they do
- **ALWAYS validate branch names** against naming conventions before operations
- **ALWAYS use heredoc format** for multi-line commit messages
- **ALWAYS follow the established code style** guidelines in SKILL.md files

## Optimization Principles

When updating skill files:
1. Remove redundant examples (DRY principle)
2. Use DO/AVOID format for clarity
3. Include only necessary context
4. Extract complex examples to dedicated files
5. Keep language-specific guides synchronized in structure
6. Avoid token waste with verbose explanations

Token efficiency is critical - every sentence should serve a purpose.
