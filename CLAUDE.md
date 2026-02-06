# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **Claude Code plugin marketplace** providing agents, commands, and skills for professional development workflows. The project is organized with a central marketplace configuration and three independent plugins:

- **git-master** (v1.0.3) - Git repository management with conventional commits, branch operations, and changelog management
- **coder** (v1.0.1) - Code quality analysis and style suggestions
- **screaming-architecture** (v1.0.0) - Feature-based project organization and architecture patterns

## Repository Structure

```
claude-code/
├── .claude-plugin/                    # Central marketplace configuration
│   └── marketplace.json               # Plugin registry, versions, and metadata
├── .claude/                           # Internal Claude skills (not published)
│   └── skills/
│       ├── git-commit-helper/
│       │   └── SKILL.md               # Commit message generation helper
│       └── skill-creator/
│           ├── SKILL.md               # Guide for creating new skills
│           └── scripts/
│               ├── init_skill.py      # Initialize new skill directory
│               ├── package_skill.py   # Package skill for distribution
│               └── quick_validate.py  # Validate skill structure
├── agents/                            # Agent definitions (MD format)
│   ├── commit-generator.md            # Analyzes changes → generates conventional commits
│   ├── git-branch-manager.md          # Safe branch creation, rename, deletion
│   └── changelog-manager.md           # CHANGELOG.md maintenance (Keep a Changelog format)
├── plugins/                           # Plugin marketplace (each plugin is self-contained)
│   ├── git-master/
│   │   ├── .claude-plugin/
│   │   │   └── plugin.json            # Plugin metadata (v1.0.3)
│   │   ├── commands/
│   │   │   └── commit.md              # Git commit command definition
│   │   └── skills/
│   │       └── commiter/
│   │           ├── SKILL.md           # Core conventional commits guidelines
│   │           └── EXAMPLE.md         # Commit message examples and patterns
│   ├── coder/
│   │   ├── .claude-plugin/
│   │   │   └── plugin.json            # Plugin metadata (v1.0.1)
│   │   ├── commands/
│   │   │   └── review.md              # Clean code review (KISS, DRY, YAGNI)
│   │   └── skills/
│   │       └── code-style/
│   │           ├── SKILL.md           # SOLID principles and universal guidelines
│   │           └── references/
│   │               ├── javascript-typescript.md
│   │               └── python.md
│   └── screaming-architecture/
│       ├── .claude-plugin/
│       │   └── plugin.json            # Plugin metadata (v1.0.0)
│       └── skills/
│           ├── SKILL.md               # Core screaming architecture principles
│           ├── EXAMPLE.md             # Real-world folder structure examples
│           └── references/
│               └── nextjs.md          # Next.js specific guide
├── CLAUDE.md                          # Project guidance (this file)
├── README.md                          # Public documentation and plugin installation
└── statusline.sh                      # Status display script (model, tokens, cost, git info)
```

## Key Architecture Patterns

### 1. Plugin Marketplace Model
Each plugin is self-contained under `plugins/` with its own `.claude-plugin/plugin.json`, skills, and commands. The central `marketplace.json` registers all plugins with metadata, versions, and source paths.

### 2. Conventional Commits Standard
All commits follow the format: `<type>[scope]: <description>`

**Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`

**Breaking changes**: Use `!` marker and `BREAKING CHANGE:` footer

Scope format should use singular form and follow project conventions (e.g., `auth`, `api`, `ui`).

### 3. Skill System
Skills are reusable guides documented in Markdown (SKILL.md) with YAML frontmatter. They serve as templates for complex processes:
- **code-style skill** (`plugins/coder/skills/code-style/`): SOLID principles, clean code, language-specific idioms
- **commiter skill** (`plugins/git-master/skills/commiter/`): Conventional commits with breaking changes, issue references
- **screaming-architecture skill** (`plugins/screaming-architecture/skills/`): Feature-based project organization

### 4. Internal Claude Skills
The `.claude/skills/` directory contains non-published skills for internal use:
- **git-commit-helper**: Analyzes staged changes and generates descriptive commit messages
- **skill-creator**: Framework for creating new skills, includes Python scripts for init, packaging, and validation

### 5. Agent-Based Automation
Agents are specialized workflows at the repository root (`agents/`):
- **commit-generator**: Reads staged changes → analyzes → generates formatted commit message
- **git-branch-manager**: Validates branch names, checks protected status, safely manages branches
- **changelog-manager**: Maintains CHANGELOG.md following Keep a Changelog standards with semantic versioning

### 6. Multi-Language Support
Code style guidance is language-specific under `plugins/coder/skills/code-style/references/`:
- **JavaScript/TypeScript**: const/let/var, async/await, guard clauses, type hints (TypeScript)
- **Python**: snake_case conventions, EAFP over LBYK, type hints, comprehensions, context managers

**Key principle**: Avoid `else` statements in all languages; use early returns and guard clauses.

### 7. Screaming Architecture
Feature-based project organization under `plugins/screaming-architecture/skills/`:
- **Organization**: Group by feature domain, not technical type (NOT `components/`, `hooks/`, `api/`)
- **Structure**: `features/` (business features), `common/` (truly shared UI/utilities), `lib/` (integrations)
- **Naming**: Use kebab-case, descriptive filenames (NOT `index.tsx`), explicit component names
- **Barrel files**: Each feature exports public API through `index.ts`
- **Dependencies**: Features depend on `common/` and other features' barrel files only

**Key principle**: The folder structure should "scream" what the application does at first glance.

## Common Development Tasks

### Updating Conventional Commits Guidance
- Edit: `plugins/git-master/skills/commiter/SKILL.md` (core rules)
- Edit: `plugins/git-master/skills/commiter/EXAMPLE.md` (real-world examples)
- Update commit types or formatting in: `agents/commit-generator.md`

### Adding Code Style Rules
- Edit: `plugins/coder/skills/code-style/SKILL.md` (universal principles)
- Edit: `plugins/coder/skills/code-style/references/{javascript-typescript,python}.md` (language-specific)
- Structure: Use DO/AVOID format with concise examples
- Avoid: Verbose explanations, redundant examples across files

### Updating Screaming Architecture Guidance
- Edit: `plugins/screaming-architecture/skills/SKILL.md` (core principles and patterns)
- Edit: `plugins/screaming-architecture/skills/EXAMPLE.md` (real-world folder structures)
- Edit: `plugins/screaming-architecture/skills/references/nextjs.md` (Next.js specific)
- Use `features/`, `common/`, `lib/` folder structure (NOT `shared/`)

### Adding or Modifying Skills
Skills are Markdown files with YAML frontmatter (name, description). They should be:
- Concise and actionable (avoid generic advice)
- Organized with clear sections and examples
- Focused on the specific workflow they teach

### Creating New Skills
Use the internal skill-creator framework:
1. Run `scripts/init_skill.py <skill-name> --path <output-directory>` to scaffold
2. Edit the generated SKILL.md and resource files
3. Validate with `scripts/quick_validate.py`
4. Package with `scripts/package_skill.py <path/to/skill-folder>`

Scripts are located at `.claude/skills/skill-creator/scripts/`.

### Publishing Plugin Updates
- Increment version in the plugin's `.claude-plugin/plugin.json`
- Update version in central `.claude-plugin/marketplace.json`
- Ensure skill/command paths are correct relative to the plugin directory

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

The central `marketplace.json` (at `.claude-plugin/marketplace.json`) defines:
- **Marketplace metadata**: name, owner, description, version
- **Plugin entries**: Each with name, version, description, author, license, keywords, category, source path
- **Source paths**: Relative paths to plugin directories under `plugins/`

Each plugin also has its own `.claude-plugin/plugin.json` with local metadata (name, description, author, version).

Version format should follow semantic versioning (MAJOR.MINOR.PATCH).

## Key Files to Know

| File | Purpose |
|------|---------|
| `.claude-plugin/marketplace.json` | Central plugin registry and versioning |
| `plugins/git-master/.claude-plugin/plugin.json` | git-master plugin metadata |
| `plugins/coder/.claude-plugin/plugin.json` | coder plugin metadata |
| `plugins/screaming-architecture/.claude-plugin/plugin.json` | screaming-architecture plugin metadata |
| `plugins/coder/skills/code-style/SKILL.md` | Universal code style guidelines |
| `plugins/git-master/skills/commiter/SKILL.md` | Conventional commits standards |
| `agents/commit-generator.md` | Commit message generation logic |
| `agents/git-branch-manager.md` | Branch management workflows |
| `agents/changelog-manager.md` | Changelog maintenance logic |
| `.claude/skills/skill-creator/SKILL.md` | Skill creation framework guide |
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
- **ALWAYS update both** plugin.json and marketplace.json when versioning

## Optimization Principles

When updating skill files:
1. Remove redundant examples (DRY principle)
2. Use DO/AVOID format for clarity
3. Include only necessary context
4. Extract complex examples to dedicated files
5. Keep language-specific guides synchronized in structure
6. Avoid token waste with verbose explanations

Token efficiency is critical - every sentence should serve a purpose.
