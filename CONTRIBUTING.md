# Contributing to DevOps Practices MCP Server

Thank you for contributing! This guide will help you understand our workflow and branching strategy.

---

## Table of Contents

1. [Quick Start](#quick-start)
2. [Branching Strategy](#branching-strategy)
3. [Development Workflow](#development-workflow)
4. [Testing Changes](#testing-changes)
5. [Code Review](#code-review)
6. [Release Process](#release-process)

---

## Quick Start

### Initial Setup

```bash
# Clone repository to the recommended location
git clone https://github.com/ai-4-devops/devops-practices.git ~/.mcp-servers/devops-practices
cd ~/.mcp-servers/devops-practices

# Install dependencies (using modern tooling - recommended)
uv pip install -r requirements.txt

# Or using traditional pip
pip install -r requirements.txt

# Run health check
bash health-check.sh
```

**Recommended Installation Location**: `~/.mcp-servers/devops-practices/`

This location keeps MCP servers organized and makes configuration easier.

**Modern Development Tooling (Recommended):**
- **[uv](https://github.com/astral-sh/uv)**: Fast Python package installer (10-100x faster than pip)
  ```bash
  curl -LsSf https://astral.sh/uv/install.sh | sh
  ```
- **[volta](https://volta.sh/)**: JavaScript tool version manager for Node.js/npm
  ```bash
  curl https://get.volta.sh | bash
  ```

These tools provide faster, more reliable dependency and version management.

---

## Branching Strategy

We use **GitLab Flow** with semantic versioning:

```
main          ← Production releases (v1.0.0, v1.1.0, etc.)
  ↑
develop       ← Active development, integration branch
  ↑
feature/*     ← New practices, templates, improvements
release/*     ← Version preparation (v1.2.0)
hotfix/*      ← Critical production fixes
```

### Branch Types

| Branch | Purpose | Created From | Merges To | Naming |
|--------|---------|--------------|-----------|--------|
| `main` | Production releases | - | - | `main` |
| `develop` | Active development | `main` | `main` (via release) | `develop` |
| Feature | New functionality | `develop` | `develop` | `feature/short-description` |
| Release | Version prep | `develop` | `main` + `develop` | `release/v1.2.0` |
| Hotfix | Critical fixes | `main` | `main` + `develop` | `hotfix/issue-description` |

**Full details**: See [git-practices.md](practices/git-practices.md#6-branch-strategy)

---

## Development Workflow

### Adding a New Practice or Template

**1. Create Feature Branch from Develop**

```bash
# Update develop
git checkout develop
git pull origin develop

# Create feature branch
git checkout -b feature/add-security-practice

# Verify you're on the right branch
git branch
```

**2. Make Changes**

```bash
# Add new practice file
vim practices/security-best-practices.md

# Update practice count in README
vim README.md

# Update practice index
vim PRACTICE-INDEX.md

# Test your changes
bash health-check.sh
```

**3. Commit Changes**

```bash
# Stage specific files
git add practices/security-best-practices.md
git add README.md
git add PRACTICE-INDEX.md

# Review what's staged
git status
git diff --staged

# Commit with descriptive message
git commit -m "Add security best practices guide

New practice covering:
- Secrets management
- Access control
- Audit logging
- Vulnerability scanning

Related to issue #42
"

# Push to remote
git push origin feature/add-security-practice
```

**4. Create Merge Request**

- Go to GitHub
- Create PR: `feature/add-security-practice` → `develop`
- Wait for CI/CD pipeline to pass
- Request code review
- Address feedback if needed
- Merge when approved

**5. Cleanup**

```bash
# After PR is merged
git checkout develop
git pull origin develop

# Delete local branch
git branch -d feature/add-security-practice

# Delete remote branch (if not auto-deleted)
git push origin --delete feature/add-security-practice
```

---

### Updating Existing Practice

Same workflow as above, but use descriptive branch names:

```bash
# Examples:
feature/update-git-practices-branching
feature/improve-docker-workflow
feature/clarify-runbook-standards
```

---

### Fixing Bugs

**Non-Critical Bugs** (can wait for next release):

```bash
# Create feature branch from develop
git checkout develop
git pull origin develop
git checkout -b feature/fix-template-typo

# Fix, commit, create PR → develop
```

**Critical Production Bugs** (hotfix):

```bash
# Create hotfix from main
git checkout main
git pull origin main
git checkout -b hotfix/mcp-server-crash

# Fix the issue
vim mcp-server.py

# Commit and push
git add mcp-server.py
git commit -m "Fix critical crash in MCP server template rendering"
git push origin hotfix/mcp-server-crash

# Create PR → main (fast-track approval)
# After merge to main:

# Also merge to develop
git checkout develop
git pull origin develop
git merge main  # Brings in the hotfix
git push origin develop
```

---

## Testing Changes

### Before Committing

```bash
# Run health check (validates all files)
bash health-check.sh

# Check Python syntax
python -m py_compile mcp-server.py

# Test MCP server locally
python mcp-server.py
```

### CI/CD Pipeline

All branches run automated checks:

- ✅ Health check validation
- ✅ Python environment validation
- ✅ Practice file validation
- ✅ Template file validation
- ✅ Documentation link checking

**Pipeline must pass before merge.**

---

## Code Review

### Requesting Review

**Good PR Description**:
```markdown
## Summary
Add security best practices covering secrets management, access control, and audit logging.

## Changes
- New file: practices/security-best-practices.md
- Updated: README.md (practice count)
- Updated: PRACTICE-INDEX.md (added to scenarios)

## Testing
- ✅ Health check passes
- ✅ CI/CD pipeline green
- ✅ Tested locally with Claude Code

## Related Issues
Closes #42
```

### Reviewing Others' PRs

**Check**:
- [ ] Clear, descriptive commit messages
- [ ] Practice follows existing structure/format
- [ ] Cross-references updated (PRACTICE-INDEX.md, README.md)
- [ ] Templates include variable placeholders (`${VARIABLE}`)
- [ ] CI/CD pipeline passes
- [ ] Changes align with DevOps best practices

**Feedback Tips**:
- Be constructive and specific
- Suggest improvements, don't just criticize
- Approve if changes look good (even if minor suggestions)

---

## Release Process

### Creating a New Release

**Only maintainers create releases.**

**1. Prepare Release Branch**

```bash
# Create release branch from develop
git checkout develop
git pull origin develop
git checkout -b release/v1.2.0
```

**2. Update Version Information**

```bash
# Update CHANGELOG.md
vim CHANGELOG.md
# Add:
# ## [1.2.0] - 2026-02-14
# ### Added
# - Security best practices guide
# - Enhanced branching strategy documentation
# ### Changed
# - Improved health check script
# ### Fixed
# - Template rendering bug

# Update version in README.md
vim README.md
# Change: **Version**: 1.1.0 → **Version**: 1.2.0

# Commit version updates
git add CHANGELOG.md README.md
git commit -m "Prepare v1.2.0 release"
git push origin release/v1.2.0
```

**3. Create PR → main**

- Create PR: `release/v1.2.0` → `main`
- Get approval from team
- Ensure CI/CD passes
- Merge to main

**4. Tag the Release**

```bash
# Checkout main
git checkout main
git pull origin main

# Create annotated tag
git tag -a v1.2.0 -m "Release v1.2.0

New Features:
- Security best practices guide
- Enhanced branching strategy with GitLab Flow
- CONTRIBUTING.md with workflow guide

Improvements:
- Improved CI/CD pipeline for multi-branch workflow
- Better health check validation

Bug Fixes:
- Template rendering edge cases
"

# Push tag
git push origin v1.2.0
```

**5. Merge Back to Develop**

```bash
# Important: Keep develop in sync
git checkout develop
git pull origin develop
git merge main
git push origin develop
```

**6. Cleanup**

```bash
# Delete release branch
git branch -d release/v1.2.0
git push origin --delete release/v1.2.0
```

**7. Announce Release**

- Update dependent projects
- Notify team via Slack/email
- Update documentation if needed

---

## Keeping Develop Synchronized

**CRITICAL**: After any merge to `main` (especially hotfixes), sync `develop`:

```bash
# Check if develop is behind main
git checkout main
git pull origin main
git checkout develop
git pull origin develop

# Check for differences
git log develop..main --oneline

# If there are differences, merge main to develop
git merge main
git push origin develop
```

**When to Sync**:
- ✅ After every hotfix
- ✅ After every release
- ✅ Weekly (as safety check)
- ✅ Before creating new release branch

---

## Commit Message Guidelines

**Format**:
```
Short summary (50 chars or less)

Detailed description of changes:
- What changed
- Why it changed
- Impact on users/projects

Technical details if relevant
```

**Examples**:

✅ **Good**:
```
Add security best practices guide

New practice covering:
- Secrets management with HashiCorp Vault
- RBAC configuration
- Audit logging setup
- Vulnerability scanning integration

This addresses common security questions from teams.

Related to issue #42
```

❌ **Bad**:
```
Update files
```

**Imperative Mood**:
- ✅ "Add security practice"
- ❌ "Added security practice"
- ❌ "Adding security practice"

---

## Branch Naming Conventions

**Good** ✅:
```bash
feature/add-security-practice
feature/improve-docker-workflow
feature/cicd-enhancements
hotfix/mcp-server-crash
hotfix/template-rendering-bug
release/v1.2.0
```

**Bad** ❌:
```bash
feature/update          # Too generic
my-feature              # Missing prefix
fix-stuff               # Not descriptive
feature/WIP             # Not clear
```

**Pattern**: `<type>/<short-description>`

| Type | Use For |
|------|---------|
| `feature/` | New practices, templates, features |
| `hotfix/` | Critical production bugs |
| `release/` | Version preparation |

---

## Getting Help

### Documentation
- **[README.md](README.md)** - Project overview
- **[PRACTICE-INDEX.md](PRACTICE-INDEX.md)** - Practice lookup guide
- **[git-practices.md](practices/git-practices.md)** - Detailed git workflows

### Questions
- Open an issue on GitHub
- Ask in team Slack channel
- Contact: Uttam Jaiswal (maintainer)

### Reporting Issues
- Check existing issues first
- Provide clear description
- Include steps to reproduce (if bug)
- Mention affected files/practices

---

## Code of Conduct

- Be respectful and professional
- Assume good intent
- Focus on the code, not the person
- Help others learn and improve
- Document your work for future contributors

---

**Thank you for contributing to DevOps Practices MCP Server!** 🎉

---

**Maintained By**: Uttam Jaiswal
**Last Updated**: 2026-02-14
**Version**: 1.2.0
