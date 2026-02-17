# Issue Tracking System

## Overview

This directory contains individual issue files for tracking work items, bugs, features, technical debt, and improvements for the example-project Observability Stack project.

## Issue Lifecycle

```
Open → In Progress → [Blocked] → Resolved → Closed
```

**Status Definitions:**
- **Open**: Issue identified, not yet started
- **In Progress**: Actively being worked on
- **Blocked**: Work stopped due to dependency or blocker
- **Resolved**: Work completed, awaiting verification
- **Closed**: Verified and completed

## Issue Types

- **Bug**: Something broken that needs fixing
- **Feature**: New functionality to be added
- **Task**: General work item (deployment, configuration, etc.)
- **Deployment**: Infrastructure/service deployment work
- **Documentation**: Documentation creation or updates
- **Technical Debt**: Known issues deferred for later
- **Improvement**: Enhancement to existing functionality

## Issue Priority

- **Critical**: Blocking progress, must fix immediately
- **High**: Important, should be addressed soon
- **Medium**: Normal priority
- **Low**: Nice to have, can be deferred

## File Naming Convention

Issues are named: `ISSUE-###.md` where ### is a zero-padded 3-digit number.

Examples:
- `ISSUE-001.md` - First issue
- `ISSUE-002.md` - Second issue
- `ISSUE-042.md` - Forty-second issue

## Issue File Structure

Each issue file contains:
```markdown
# ISSUE-###: [Title]

**Status**: Open | In Progress | Blocked | Resolved | Closed
**Type**: Bug | Feature | Task | Deployment | Documentation | Technical Debt | Improvement
**Priority**: Critical | High | Medium | Low
**Created**: YYYY-MM-DD
**Updated**: YYYY-MM-DD
**Assigned**: Name or Unassigned
**Related**: Links to related issues (ISSUE-###)

## Description

[Detailed description of the issue]

## Context

[Background information, why this is needed]

## Tasks

- [ ] Task 1
- [ ] Task 2
- [ ] Task 3

## Related Files

- [path/to/file1.yaml](../path/to/file1.yaml)
- [path/to/file2.sh](../path/to/file2.sh)

## Notes

[Additional notes, decisions, blockers, etc.]

## Resolution

[For resolved/closed issues: how it was resolved]

---

**History:**
- YYYY-MM-DD: Created
- YYYY-MM-DD: Status changed to In Progress
- YYYY-MM-DD: Resolved
```

## How to Use

### Creating a New Issue

1. Find the next available issue number by checking existing files
2. Copy the issue template structure above
3. Fill in all required fields
4. Save as `ISSUE-###.md`
5. Add entry to `../ISSUES.md` (main index)

### Updating an Issue

1. Edit the issue file
2. Update the `Updated` date
3. Add entry to **History** section at bottom
4. Update status in `../ISSUES.md` if changed

### Closing an Issue

1. Update status to "Resolved" or "Closed"
2. Fill in the **Resolution** section
3. Update `../ISSUES.md` to reflect closure
4. Add reference in commit message if applicable

### Referencing Issues in Git Commits

Use format: `[ISSUE-###] Commit message`

Example:
```bash
git commit -m "[ISSUE-001] Deploy UAT OTel Collector with centralized Jaeger"
```

### Searching Issues

**By status:**
```bash
grep "^**Status**: Open" issues/*.md
```

**By priority:**
```bash
grep "^**Priority**: Critical" issues/*.md
```

**By type:**
```bash
grep "^**Type**: Bug" issues/*.md
```

**Or use the issue manager script:**
```bash
./scripts/issue-manager.sh list --status open
./scripts/issue-manager.sh list --priority critical
./scripts/issue-manager.sh list --type bug
```

## Integration with TRACKER.md

**TRACKER.md** tracks high-level milestones and project phases.

**Issues** track granular work items within those milestones.

**Relationship:**
- 1 TRACKER.md task = Multiple issues
- Example: "Deploy Test/SIT observability stack" (TRACKER) = 5+ issues (OTel, kube-state-metrics, node-exporter, validation, etc.)

## Best Practices

1. **Keep issues focused** - One issue, one problem/feature
2. **Update regularly** - Keep status and notes current
3. **Link related work** - Reference related issues, files, commits
4. **Close when done** - Don't let resolved issues linger
5. **Document resolution** - Future you will thank you
6. **Use in commits** - Reference issue numbers in commit messages
7. **Review weekly** - Keep the issue list clean and current

## Maintenance

- Review open issues weekly
- Close stale issues or update status
- Archive very old closed issues (move to `docs/archive/issues/`)
- Keep `../ISSUES.md` synchronized with individual issue files

---

**Last Updated**: 2026-02-17
**Maintained By**: DevOps Team
