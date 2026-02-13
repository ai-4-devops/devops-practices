# Git Best Practices

**Purpose**: Standard git practices for infrastructure projects.

**Principle**: Preserve history, enable collaboration, ensure traceability.

---

## Core Practices

### 1. Use `git mv` for Moving/Renaming Files

**CRITICAL**: ALWAYS use `git mv` instead of regular `mv` for tracked files.

**Why**: Preserves full git history when reorganizing files. Regular `mv` breaks history tracking (seen as delete + create).

**Bad** ❌:
```bash
mv old/path/file.md new/path/file.md
git add new/path/file.md
git rm old/path/file.md
# Git sees this as: deleted file + new file (history lost)
```

**Good** ✅:
```bash
git mv old/path/file.md new/path/file.md
# Git sees this as: rename (history preserved)
```

**Verification**:
```bash
# Check that git shows "R" (rename) not "D" (delete) + "A" (add)
git status --short
# Should show: R  old/path/file.md -> new/path/file.md
```

**Benefits**:
- Full file history preserved (blame, log, etc.)
- Clear rename indication in git log
- Easier to track file evolution
- Better for code review

---

### 2. Always Backup Before Updates

**CRITICAL**: Create timestamped backups before helm upgrades or kubectl apply.

**For Helm Deployments**:
```bash
# Before helm upgrade
helm get values <release> -n <namespace> > <release>-values-backup-$(date -u +%Y%m%dT%H%MZ).yaml

# Perform upgrade
helm upgrade <release> <chart> -f new-values.yaml -n <namespace>

# Rollback if needed
helm rollback <release> -n <namespace>
# OR restore from backup
helm upgrade <release> <chart> -f <release>-values-backup-20260213T1800Z.yaml -n <namespace>
```

**For Kubernetes Resources**:
```bash
# Before kubectl apply
kubectl get <resource> <name> -n <namespace> -o yaml > <resource>-backup-$(date -u +%Y%m%dT%H%MZ).yaml

# Perform update
kubectl apply -f new-config.yaml -n <namespace>

# Rollback if needed
kubectl apply -f <resource>-backup-20260213T1800Z.yaml -n <namespace>
```

**Why UTC Timestamps**:
- Unambiguous across timezones
- Sorts chronologically
- International consistency
- Standard format: `YYYYMMDDTHHMMz` (no seconds needed for backups)

---

### 3. Wait for Explicit Commit Request

**CRITICAL**: NEVER commit without explicit user request.

**User must say**:
- "please commit"
- "commit this"
- "commit these changes"
- "git commit"

**Never assume**:
- User will always want to commit
- Changes are ready to commit
- It's okay to be proactive about committing

**If unsure**: Ask the user explicitly.

**Why**: User may want to review changes, test further, or make additional edits before committing.

---

### 4. Commit Message Standards

**Structure**:
```
Short summary (50 chars or less)

Detailed description of changes:
- What changed and why
- Any notable details
- References to issues or docs

Technical details:
- File counts
- Breaking changes
- Migration notes
```

**Imperative Tone**:
- "Add feature" not "Added feature"
- "Fix bug" not "Fixed bug"
- "Update docs" not "Updated docs"

**Be Specific**:
- ❌ "Update files"
- ✅ "Reorganize documentation structure and enhance standards"

**Include Impact**:
- What's the benefit of this change?
- What problem does it solve?
- What's the scope (files changed, breaking changes)?

**Example**:
```
Reorganize repository structure and enhance documentation standards

Major reorganization implementing comprehensive DevOps documentation practices:

Repository Structure Changes:
- Move 24 UAT deployment session files to docs/RUNBOOKS/
- Move ADR-001 architecture decision to docs/plans/
- Move historical documentation to docs/archive/
- Clean project root (only 4 essential files remain)

New Documentation Structure:
- docs/guides/ → HOW to deploy (step-by-step procedures)
- docs/RUNBOOKS/ → WHAT we did (session activity logs)
- docs/reports/ → WHY we did it (reference & management reports)

Technical Details:
- All file moves preserve git history (used git mv)
- 37 files renamed/moved with history intact
- 13 new documentation files added

Benefits:
- Clear separation of concerns (HOW/WHAT/WHY)
- Self-documenting directory structure
- Session continuity across systems
```

---

### 5. Commit Hooks

**Be Aware**: Some projects have git hooks that enforce standards.

**Common Hooks**:
- Pre-commit: Check file formatting, run linters
- Commit-msg: Enforce message format
- Pre-push: Run tests

**If Hook Fails**:
- Read the error message carefully
- Fix the issue (don't try to bypass)
- Re-attempt the commit
- Never use `--no-verify` unless explicitly instructed

**Example Hook Failure**:
```bash
git commit -m "Add feature"
❌ ERROR: Commit message contains AI co-authorship line
Please remove AI attribution lines from your commit message.
```

**Fix**: Remove the problematic line and re-commit.

---

### 6. Branch Strategy

#### Overview

Choose a branching strategy based on project complexity and team size:

| Strategy | Best For | Key Branches |
|----------|----------|--------------|
| **Trunk-Based** | Simple projects, solo work | `main` only |
| **GitHub Flow** | Continuous deployment | `main` + feature branches |
| **GitLab Flow** | Versioned releases, multiple environments | `main` + `develop` + feature/release/hotfix |

---

#### Trunk-Based Development (Simple Projects)

**When to Use**:
- Solo developer or very small team
- Simple projects without formal releases
- Rapid iteration needed

**Structure**:
```
main ← All work happens here (or short-lived feature branches)
```

**Workflow**:
```bash
# Work directly on main OR use short feature branches
git checkout main
git pull origin main

# Make changes
git add files
git commit -m "Add feature"
git push origin main
```

**Pros**: Simple, fast, minimal overhead
**Cons**: Higher risk of breaking main, harder to manage releases

---

#### GitHub Flow (Continuous Deployment)

**When to Use**:
- Continuous deployment to production
- Web applications, APIs
- Every merge to main triggers deployment

**Structure**:
```
main ← Production-ready, always deployable
  ↑
feature/* ← Short-lived feature branches
hotfix/*  ← Critical production fixes
```

**Workflow**:
```bash
# Create feature branch from main
git checkout main
git pull origin main
git checkout -b feature/add-authentication

# Work on feature
git add files
git commit -m "Add authentication"
git push origin feature/add-authentication

# Create merge/pull request → main
# CI/CD runs tests
# Code review + approval
# Merge to main (auto-deploys)

# Delete feature branch
git branch -d feature/add-authentication
git push origin --delete feature/add-authentication
```

**Branch Protection**:
- Require pull/merge requests
- Require CI/CD passing
- Require code review approval
- Block force pushes

**Pros**: Simple, fast feedback, continuous deployment
**Cons**: No staging environment, harder to manage versions

---

#### GitLab Flow (Versioned Releases)

**When to Use**:
- Multiple environments (dev, staging, production)
- Versioned releases (semantic versioning)
- Shared libraries, infrastructure-as-code
- MCP servers with dependent projects ← **Recommended for this repo**

**Structure**:
```
main            ← Production releases only (v1.0.0, v1.1.0, etc.)
  ↑
develop         ← Integration branch, active development
  ↑
feature/*       ← New features
  ↑
release/*       ← Version preparation (v1.2.0-rc)
  ↑
hotfix/*        ← Critical fixes to production
```

**Branch Types**:

| Branch Type | Naming | Purpose | Lifespan | Merges To |
|-------------|--------|---------|----------|-----------|
| `main` | `main` | Production releases | Permanent | N/A |
| `develop` | `develop` | Active development | Permanent | `main` (via release) |
| Feature | `feature/description` | New functionality | Days-weeks | `develop` |
| Release | `release/v1.2.0` | Version preparation | Days | `main` + `develop` |
| Hotfix | `hotfix/critical-bug` | Production fixes | Hours-days | `main` + `develop` |

**Naming Conventions**:
```bash
# Features: feature/<short-description>
feature/kafka-topics
feature/add-authentication
feature/cicd-pipeline

# Releases: release/v<semver>
release/v1.2.0
release/v2.0.0-beta

# Hotfixes: hotfix/<critical-issue>
hotfix/security-patch
hotfix/broker-crash
hotfix/memory-leak

# Avoid generic names
❌ feature/update
❌ feature/fix
❌ feature/changes

# Use descriptive names
✅ feature/add-user-roles
✅ feature/kafka-monitoring
✅ hotfix/null-pointer-error
```

**Workflows**:

**Feature Development**:
```bash
# Start feature from develop
git checkout develop
git pull origin develop
git checkout -b feature/add-monitoring

# Work on feature
git add files
git commit -m "Add Prometheus monitoring"
git push origin feature/add-monitoring

# Create merge request → develop
# CI/CD runs on feature branch
# Code review + approval
# Merge to develop
# Delete feature branch
```

**Release Preparation**:
```bash
# Create release branch from develop
git checkout develop
git pull origin develop
git checkout -b release/v1.2.0

# Finalize version
# Update CHANGELOG.md
# Update version numbers
# Bug fixes only (no new features)
git add CHANGELOG.md
git commit -m "Prepare v1.2.0 release"
git push origin release/v1.2.0

# Create MR → main
# After approval and CI passing:
# Merge to main
# Tag the release
git checkout main
git pull origin main
git tag -a v1.2.0 -m "Release v1.2.0: Add monitoring and performance improvements"
git push origin v1.2.0

# Merge release back to develop
git checkout develop
git merge release/v1.2.0
git push origin develop

# Delete release branch
git branch -d release/v1.2.0
git push origin --delete release/v1.2.0
```

**Hotfix for Production**:
```bash
# Create hotfix from main
git checkout main
git pull origin main
git checkout -b hotfix/critical-security-patch

# Fix the issue
git add files
git commit -m "Fix security vulnerability CVE-2026-1234"
git push origin hotfix/critical-security-patch

# Create MR → main
# Fast-track approval
# Merge to main
# Tag hotfix release
git checkout main
git pull origin main
git tag -a v1.1.1 -m "Hotfix v1.1.1: Security patch"
git push origin v1.1.1

# Merge hotfix to develop
git checkout develop
git merge hotfix/critical-security-patch
git push origin develop

# Delete hotfix branch
git branch -d hotfix/critical-security-patch
git push origin --delete hotfix/critical-security-patch
```

---

#### Keeping Develop Synchronized with Main

**CRITICAL**: After any merge to `main` (especially hotfixes), always sync `develop` to prevent divergence.

**When to Sync**:
- ✅ After hotfix merges to main
- ✅ After release merges to main
- ✅ Periodically (weekly/bi-weekly) as a safety check
- ✅ Before creating new release branches from develop

**Sync Workflow**:
```bash
# Check if main has changes not in develop
git checkout main
git pull origin main

git checkout develop
git pull origin develop

# Check for differences
git log develop..main --oneline
# If output shows commits, develop is behind main

# Merge main into develop
git merge main
# OR rebase develop on main (if no conflicts expected)
# git rebase main

# Resolve any conflicts if they occur
# Then push
git push origin develop
```

**Automated Check** (recommended):
```bash
# Add to team workflow or CI/CD
# Check if develop is behind main
git fetch origin

if git log origin/develop..origin/main --oneline | grep -q .; then
  echo "⚠️  WARNING: develop is behind main!"
  echo "Run: git checkout develop && git merge main"
  exit 1
fi
```

**Common Scenario - After Hotfix**:
```bash
# Hotfix v1.1.1 just merged to main
# Now sync develop

git checkout develop
git pull origin develop
git merge main  # Brings in the hotfix
git push origin develop

# Verify
git log --oneline -5
# Should show the hotfix commit in develop history
```

**Why This Matters**:
- Prevents develop from missing critical fixes
- Ensures next release includes all production changes
- Avoids re-introducing bugs that were already fixed
- Maintains consistency between branches

---

#### Branch Protection Rules

**For `main` branch**:
- ✅ Require merge/pull requests (no direct commits)
- ✅ Require CI/CD pipeline passing
- ✅ Require 1+ code review approvals
- ✅ Block force pushes
- ✅ Block branch deletion
- ✅ Require linear history (optional)

**For `develop` branch**:
- ✅ Require merge/pull requests
- ✅ Require CI/CD pipeline passing
- ✅ Require code review (optional for small teams)
- ✅ Block force pushes
- ❌ Allow branch deletion (if needed)

**For feature/hotfix branches**:
- ❌ No restrictions (developers can force push to their own branches)
- ✅ Require CI/CD passing before merge

---

#### Merge Strategies

**Merge Commit (Recommended for main/develop)**:
```bash
git merge --no-ff feature/add-monitoring
# Creates merge commit, preserves full history
```

**Pros**: Full history preserved, clear feature boundaries
**Cons**: More commits, complex history graph

**Squash Merge**:
```bash
git merge --squash feature/add-monitoring
git commit -m "Add monitoring feature"
# Combines all commits into one
```

**Pros**: Clean history, single commit per feature
**Cons**: Loses detailed commit history

**Rebase (For feature branches only)**:
```bash
# Update feature branch with latest develop
git checkout feature/add-monitoring
git rebase develop
# Replays your commits on top of develop
```

**Pros**: Linear history, no merge commits
**Cons**: Rewrites history (never rebase published branches)

**When to Use**:
- **Merge commit**: `develop` → `main`, major features
- **Squash merge**: Small features, experimental work
- **Rebase**: Keep feature branch up-to-date (before merging)

**Never Rebase**:
- ❌ `main` or `develop` branches
- ❌ Branches others are working on
- ❌ Commits already pushed to origin (unless you force push and coordinate)

---

#### Semantic Versioning & Tagging

**Version Format**: `vMAJOR.MINOR.PATCH` (e.g., `v1.2.3`)

| Change Type | Increment | Example |
|-------------|-----------|---------|
| Breaking changes | MAJOR | `v1.0.0` → `v2.0.0` |
| New features (backward compatible) | MINOR | `v1.1.0` → `v1.2.0` |
| Bug fixes (backward compatible) | PATCH | `v1.2.0` → `v1.2.1` |

**Tagging Releases**:
```bash
# Annotated tags (recommended - stores metadata)
git tag -a v1.2.0 -m "Release v1.2.0: Add monitoring and template rendering"
git push origin v1.2.0

# Lightweight tags (not recommended)
git tag v1.2.0
git push origin v1.2.0

# List tags
git tag -l

# View tag details
git show v1.2.0

# Delete tag (if needed)
git tag -d v1.2.0
git push origin --delete v1.2.0
```

**Tag Message Format**:
```bash
git tag -a v1.2.0 -m "Release v1.2.0: Summary of key changes

New Features:
- Add Prometheus monitoring integration
- Add template rendering with variable substitution

Bug Fixes:
- Fix memory leak in health check
- Correct timestamp format in templates

Breaking Changes: None
"
```

---

#### Branch Cleanup

**After Merge**:
```bash
# Delete local branch
git branch -d feature/add-monitoring

# Delete remote branch
git push origin --delete feature/add-monitoring

# OR use -D to force delete (if not merged)
git branch -D feature/abandoned-experiment
```

**Cleanup Stale Branches**:
```bash
# List merged branches
git branch --merged develop

# List remote branches
git branch -r

# Prune deleted remote branches
git fetch --prune

# Delete all local branches merged to develop
git branch --merged develop | grep -v "\* develop" | xargs -n 1 git branch -d
```

**Automation** (GitLab CI/CD):
```yaml
# .gitlab-ci.yml - Auto-delete merged branches
delete-merged-branches:
  stage: cleanup
  script:
    - git fetch --prune
    - git branch --merged develop | grep -v "develop\|main" | xargs -n 1 git branch -d
  only:
    - develop
  when: manual
```

---

#### Quick Decision Guide

**Choose Trunk-Based If**:
- ✅ Solo developer or 2-3 person team
- ✅ Rapid prototyping or experimentation
- ✅ No formal releases needed
- ✅ Simple project structure

**Choose GitHub Flow If**:
- ✅ Continuous deployment to production
- ✅ Every commit should be deployable
- ✅ Web apps, APIs, SaaS products
- ✅ Fast feedback cycles

**Choose GitLab Flow If**:
- ✅ Multiple environments (dev, staging, prod)
- ✅ Versioned releases with semantic versioning
- ✅ Shared libraries, infrastructure-as-code, MCP servers
- ✅ Need to support multiple versions
- ✅ Require release candidates and testing

---

#### Common Anti-Patterns

**❌ Long-Lived Feature Branches**:
```bash
# Feature branch diverges for weeks/months
feature/massive-refactor (200+ commits behind develop)
# Result: Merge conflicts, integration hell
```

**✅ Solution**: Break into smaller features, merge frequently

**❌ Developing on Main**:
```bash
# Directly commit to main without review
git commit -m "Quick fix"
git push origin main
# Result: Breaking changes, no review, hard to rollback
```

**✅ Solution**: Always use feature branches + merge requests

**❌ Not Deleting Merged Branches**:
```bash
git branch -a
# Shows 100+ old feature branches
# Result: Confusion, clutter, hard to find active work
```

**✅ Solution**: Delete branches immediately after merge

**❌ Inconsistent Naming**:
```bash
feature/add-thing
feature-update-stuff
AddMonitoring
fix_bug
# Result: Hard to filter, unclear purpose
```

**✅ Solution**: Use consistent naming convention

---

#### Never Do This

- ❌ Force push to `main` or `develop` (unless explicitly requested and coordinated)
- ❌ Rebase published commits on shared branches
- ❌ Amend commits that others have based work on
- ❌ Merge without CI/CD passing (bypassing checks)
- ❌ Skip code review for non-trivial changes
- ❌ Create releases without updating CHANGELOG.md
- ❌ Use generic branch names like `update`, `fix`, `test`

---

### 7. Git Safety Protocol

**NEVER**:
- ❌ Update git config without permission
- ❌ Run destructive commands without confirmation:
  - `git push --force`
  - `git reset --hard`
  - `git checkout .`
  - `git restore .`
  - `git clean -f`
  - `git branch -D`
- ❌ Skip hooks (`--no-verify`, `--no-gpg-sign`)
- ❌ Force push to main/master

**Always Create NEW Commits**:
When a pre-commit hook fails, create a NEW commit (don't amend):
- Hook fails = commit did NOT happen
- `--amend` would modify PREVIOUS commit (data loss risk)
- Instead: Fix issue, re-stage, create NEW commit

**Example**:
```bash
# Attempt commit
git commit -m "Add topics"
# Hook fails (e.g., formatting issue)

# Fix the issue
prettier --write configs/

# Stage fixes
git add configs/

# Create NEW commit (not --amend)
git commit -m "Add topics"
```

---

### 8. Staging Best Practices

**Prefer Specific Files**:
```bash
# Good: Explicit files
git add configs/uat/kafka-topic-quote-requested.yaml
git add docs/guides/TOPIC-CREATION-PROCESS.md

# Avoid: Blanket adds (can accidentally include secrets)
git add -A
git add .
```

**Why**: Prevents accidentally staging:
- `.env` files (secrets)
- `credentials.json` (credentials)
- Large binaries
- Temporary files

**Review Before Commit**:
```bash
# Check what's staged
git status

# Review changes
git diff --staged

# If needed, unstage
git restore --staged <file>
```

---

### 9. Git Log Best Practices

**Useful Commands**:
```bash
# View recent commits
git log --oneline -10

# View with file changes
git log --stat -5

# Search commits
git log --grep="kafka"

# See file history
git log --follow -- path/to/file.md

# See what changed
git show <commit-hash>
```

---

### 10. Handling Large Reorganizations

When moving many files (like repository reorganization):

**Steps**:
1. Use `git mv` for all moves (preserves history)
2. Group related moves in single commit
3. Create detailed commit message
4. Verify renames: `git status --short` should show "R" not "D"+"A"
5. Push after verifying

**Example**:
```bash
# Move files with git mv
git mv file1.md new/location/file1.md
git mv file2.md new/location/file2.md
# ... (many more moves)

# Check status (should show "R" for rename)
git status --short

# Commit with detailed message
git commit -m "Reorganize documentation structure

- Move 24 session files to docs/RUNBOOKS/
- Move ADR to docs/plans/
- All moves preserve git history (used git mv)
"

# Push
git push origin main
```

---

## Common Mistakes

### ❌ Using `mv` Instead of `git mv`
```bash
mv old.md new.md
git add new.md
git rm old.md
# Result: Git sees delete + add (history lost)
```

### ✅ Correct Approach
```bash
git mv old.md new.md
# Result: Git sees rename (history preserved)
```

---

### ❌ Committing Without Review
```bash
git add -A
git commit -m "Update"
# Might accidentally commit secrets or unwanted files
```

### ✅ Correct Approach
```bash
git add specific-file.yaml
git status  # Review
git diff --staged  # Check changes
git commit -m "Add Kafka topic configuration for UAT"
```

---

### ❌ Amending After Hook Failure
```bash
git commit -m "Add feature"
# Hook fails
git add fixed-file
git commit --amend
# Might amend PREVIOUS commit (data loss)
```

### ✅ Correct Approach
```bash
git commit -m "Add feature"
# Hook fails (commit did NOT happen)
git add fixed-file
git commit -m "Add feature"
# Creates NEW commit (safe)
```

---

## Quick Reference

```bash
# File operations
git mv old/path new/path              # Move/rename (preserves history)
git add specific-file                 # Stage specific file
git restore --staged file             # Unstage file

# Review before commit
git status                            # What's staged
git diff                              # Unstaged changes
git diff --staged                     # Staged changes

# Backup before changes
helm get values release -n ns > backup-$(date -u +%Y%m%dT%H%MZ).yaml
kubectl get resource -n ns -o yaml > backup-$(date -u +%Y%m%dT%H%MZ).yaml

# Commit
git commit -m "Descriptive message"

# History
git log --oneline -10                 # Recent commits
git log --follow -- file.md           # File history
```

---

## Related Practices

- **[session-continuity.md](session-continuity.md)** - Everything lives in git for session resumption
- **[configuration-management.md](configuration-management.md)** - Version control for configs, use git mv for reorganization
- **[runbook-documentation.md](runbook-documentation.md)** - File naming conventions with UTC timestamps
- **[documentation-standards.md](documentation-standards.md)** - Commit best practices and conventions

---

**Maintained By**: Infrastructure Team
**Last Updated**: 2026-02-13
**Version**: 1.0.0