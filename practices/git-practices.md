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

**Main Branch**:
- `main` or `master` - production-ready code
- Always deployable
- Protected from force pushes

**Working**:
- Work directly on main for simple projects
- Use feature branches for complex changes
- Use descriptive branch names: `feature/kafka-topics`, `fix/broker-oom`

**Never**:
- ❌ Force push to main/master (unless explicitly requested)
- ❌ Rebase published commits (use merge instead)
- ❌ Amend published commits (unless explicitly requested)

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