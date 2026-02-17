# Issue Tracking Practice

**Practice ID**: `issue-tracking`
**Version**: 1.0.0
**Last Updated**: 2026-02-17
**Category**: Project Management

---

## Overview

In-repository issue tracking system for managing granular work items, bugs, features, technical debt, and improvements. Provides Jira-like functionality without external dependencies, fully integrated with git history.

---

## When to Use

**Use issue tracking when:**
- Project has multiple work items beyond high-level milestones
- Need granular tracking of bugs, features, technical debt
- Want complete historical record of accomplishments
- Need to demonstrate achievements (performance reviews, reports)
- Team needs searchable, filterable work item management

**Don't use issue tracking when:**
- Project is simple with <5 tasks (use TRACKER.md only)
- External issue tracker required (company policy, client requirement)
- Project duration <1 week

---

## Relationship to TRACKER.md

**TRACKER.md** (Milestones) vs **ISSUES.md** (Work Items):

| Aspect | TRACKER.md | ISSUES.md |
|--------|------------|-----------|
| **Purpose** | High-level milestones | Granular work items |
| **Granularity** | Phases, major tasks | Individual bugs, features, tasks |
| **Example** | "Deploy Test/SIT environment" | "Fix OTLP endpoint bug", "Deploy kube-state-metrics", "Create deployment guide" |
| **Relationship** | 1 TRACKER task = Multiple issues | Many issues → 1 TRACKER milestone |
| **Updates** | Weekly/per session | Daily/as work progresses |

**Use together**: TRACKER.md for "where we are", ISSUES.md for "what needs doing"

---

## Structure

```
/
├── ISSUES.md                    # Main issue index (root level)
├── issues/                      # Individual issue files
│   ├── README.md               # How to use the issue system
│   ├── ISSUE-001.md            # Individual issues
│   ├── ISSUE-002.md
│   └── ...
└── scripts/
    └── issue-manager.sh        # CLI tool for management
```

**Location rationale**:
- `ISSUES.md` at root for visibility (alongside TRACKER.md, README.md)
- `issues/` at root (not in docs/ - this is active work tracking)
- Script in `scripts/` for automation

---

## Issue Lifecycle

```
Open → In Progress → [Blocked] → Resolved → Closed
```

**Status Definitions**:
- **Open**: Identified, not yet started
- **In Progress**: Actively being worked on
- **Blocked**: Stopped due to dependency or external factor
- **Resolved**: Work completed, awaiting verification
- **Closed**: Verified and completed

---

## Issue Types

| Type | Description | Examples |
|------|-------------|----------|
| **Bug** | Something broken | "OTLP endpoint 404 errors", "Pod crash loop" |
| **Feature** | New functionality | "Add auto-instrumentation", "Implement SSO" |
| **Task** | General work item | "Deploy to environment", "Configure component" |
| **Deployment** | Infrastructure/service deployment | "Deploy Jaeger", "Setup ES cluster" |
| **Documentation** | Documentation work | "Create deployment guide", "Write runbook" |
| **Technical Debt** | Known issues deferred | "Add Prometheus auth", "Enable TLS verification" |
| **Improvement** | Enhancement to existing | "Optimize query performance", "Add RBAC permissions" |

---

## Priority Levels

| Priority | Criteria | Action |
|----------|----------|--------|
| **Critical** | Blocking progress, production down | Fix immediately |
| **High** | Important, should address soon | Next sprint/session |
| **Medium** | Normal priority | Planned work |
| **Low** | Nice to have, can defer | When time permits |

---

## File Structure

### ISSUES.md (Main Index)

```markdown
# Issue Tracker

## Quick Stats
| Status | Count | Issues |
|--------|-------|--------|
| Open | 5 | ... |
| Closed | 20 | ... |

## Open Issues
[Filterable list by priority]

## Closed Issues (Achievements)
[Grouped by category/phase]

## Achievements Summary
[Timeline, statistics, key milestones]
```

### Individual Issue File (ISSUE-###.md)

```markdown
# ISSUE-###: [Title]

**Status**: Open | In Progress | Blocked | Resolved | Closed
**Type**: Bug | Feature | Task | etc.
**Priority**: Critical | High | Medium | Low
**Created**: YYYY-MM-DD
**Updated**: YYYY-MM-DD
**Assigned**: Name or Unassigned
**Related**: ISSUE-### (links to related issues)

## Description
[What needs to be done]

## Context
[Background, why needed]

## Tasks
- [ ] Task 1
- [ ] Task 2

## Related Files
- [file.yaml](../path/to/file.yaml)

## Notes
[Additional info, decisions, blockers]

## Resolution
[For closed issues: how it was resolved]

---

**History**:
- YYYY-MM-DD: Created
- YYYY-MM-DD: Status changed
- YYYY-MM-DD: Resolved
```

---

## Naming Conventions

**Issue Numbers**: `ISSUE-###` where ### is zero-padded 3-digit number

Examples:
- `ISSUE-001` - First issue
- `ISSUE-042` - Forty-second issue
- `ISSUE-137` - One hundred thirty-seventh issue

**Sequential numbering**: Never reuse numbers, always increment

---

## Git Integration

### Commit Messages

Reference issues in commits:
```bash
git commit -m "[ISSUE-042] Deploy Prometheus to monitoring cluster"
git commit -m "[ISSUE-010] Fix OTLP endpoint path doubling bug"
```

### Branch Naming (optional)

```bash
git checkout -b issue-042-deploy-prometheus
git checkout -b issue-010-fix-otlp-endpoint
```

### History Preservation

- Use `git mv` when moving issue files
- Never force-push issue-related commits
- Issues provide audit trail - preserve them

---

## Creating New Issues

### Manual Creation

1. Find next issue number: `ls issues/ | sort -V | tail -1`
2. Create `issues/ISSUE-###.md` using template
3. Fill in all required fields
4. Add entry to `ISSUES.md`
5. Commit: `git add issues/ISSUE-###.md ISSUES.md && git commit -m "Add ISSUE-###: [title]"`

### Using CLI Tool

```bash
# Interactive creation
./scripts/issue-manager.sh create

# Prompts for:
# - Title
# - Type
# - Priority
# - Description
# - Assignment
```

---

## Updating Issues

### Status Changes

**Manual**:
1. Edit `issues/ISSUE-###.md`
2. Update `**Status**` line
3. Update `**Updated**` date
4. Add entry to `**History**` section
5. Update `ISSUES.md` to reflect change

**CLI**:
```bash
./scripts/issue-manager.sh update ISSUE-042 --status "in_progress"
./scripts/issue-manager.sh update ISSUE-042 --status resolved
```

### Adding Notes/Progress

Edit issue file directly, update "Notes" section, add history entry

---

## Searching and Filtering

### CLI Tool

```bash
# List by status
./scripts/issue-manager.sh list --status open
./scripts/issue-manager.sh list --status closed

# List by priority
./scripts/issue-manager.sh list --priority high
./scripts/issue-manager.sh list --priority critical

# List by type
./scripts/issue-manager.sh list --type bug
./scripts/issue-manager.sh list --type deployment

# Show specific issue
./scripts/issue-manager.sh show ISSUE-042

# Search by keyword
./scripts/issue-manager.sh search "prometheus"
./scripts/issue-manager.sh search "jaeger"

# Statistics
./scripts/issue-manager.sh stats
```

### Manual (grep)

```bash
# Find all open issues
grep "^**Status**: Open" issues/*.md

# Find all high priority
grep "^**Priority**: High" issues/*.md

# Find all bugs
grep "^**Type**: Bug" issues/*.md

# Search content
grep -r "prometheus" issues/
```

---

## Retrospective Population

When adopting issue tracking mid-project, create retrospective issues for completed work:

**Benefits**:
- Complete historical record
- Demonstrates full scope of work
- Useful for performance reviews
- Provides context for new team members

**Process**:
1. Review TRACKER.md for completed tasks
2. Review session logs (RUNBOOKS/) for details
3. Create closed issues for significant completed work
4. Set resolved date to actual completion date
5. Document achievements, learnings, time investment

**Example** (example-project project):
- Created 22 retrospective issues for completed work
- Documented 54+ hours of work
- Captured 8-hour troubleshooting session
- Highlighted critical bug fix
- Recorded architectural innovations

---

## Maintenance

### Weekly Review

- Update open issue statuses
- Close resolved issues
- Create new issues as needed
- Update ISSUES.md stats
- Archive very old closed issues (optional)

### Archiving Old Issues

After 6-12 months:
```bash
mkdir -p docs/archive/issues/YYYY
mv issues/ISSUE-{001..050}.md docs/archive/issues/YYYY/
```

Update ISSUES.md to reflect archived issues

---

## Best Practices

1. **One Issue, One Problem** - Keep issues focused
2. **Update Regularly** - Keep status current
3. **Link Related Work** - Reference related issues, files, commits
4. **Close When Done** - Don't let resolved issues linger
5. **Document Resolution** - Future you will thank you
6. **Use in Commits** - Reference issue numbers
7. **Review Weekly** - Keep issue list clean
8. **Celebrate Achievements** - Highlight impactful completed work

---

## Common Patterns

### Bug Workflow

```
1. Bug reported → Create ISSUE-### (Status: Open, Type: Bug)
2. Investigation starts → Status: In Progress
3. Root cause found → Update "Notes" section
4. Fix implemented → Update "Resolution" section
5. Fix tested → Status: Resolved
6. Verified in production → Status: Closed
```

### Feature Workflow

```
1. Feature requested → Create ISSUE-###
2. Requirements clarified → Update "Context" and "Tasks"
3. Development → Status: In Progress
4. Implementation complete → Status: Resolved
5. User acceptance → Status: Closed
```

### Technical Debt

```
1. Identify debt → Create ISSUE-### (Type: Technical Debt, Priority: Low/Medium)
2. Prioritize when time permits → Status: Open (stays open)
3. Sprint planning → Select for upcoming sprint
4. Work on debt → Status: In Progress
5. Complete → Status: Closed
```

---

## Example: High-Impact Issue Documentation

**ISSUE-017: Deploy Jaeger v2** (from example-project project)

**Why impactful**:
- 8 hours of troubleshooting documented
- Major learning experience captured
- Non-obvious gotchas highlighted
- ES index pattern discovery preserved

**Documentation included**:
- Timeline of troubleshooting
- Each problem encountered
- Root causes identified
- Solutions applied
- Lessons learned
- Time investment
- Validation steps

**Value**: Future deployments reference this issue, avoiding same pitfalls

---

## Tooling

### issue-manager.sh

CLI tool for issue management (see `tools/issue-manager.sh` in MCP)

**Features**:
- Create issues interactively
- Update issue status
- List/filter issues
- Search issues
- Show statistics
- Color-coded output

**Setup**:
```bash
# Copy to project
cp ~/.mcp-servers/devops-practices/tools/issue-manager.sh ./scripts/
chmod +x ./scripts/issue-manager.sh
```

---

## Templates

MCP provides templates:
- `ISSUES.md` - Main index template
- `ISSUE-TEMPLATE.md` - Individual issue template
- `issues-README.md` - Directory README template

**Access**:
```bash
cp ~/.mcp-servers/devops-practices/templates/ISSUES.md ./ISSUES.md
cp ~/.mcp-servers/devops-practices/templates/issues-README.md ./issues/README.md
```

---

## Metrics and Reporting

Track these metrics in ISSUES.md:

**Velocity Metrics**:
- Issues opened per week/month
- Issues closed per week/month
- Time to resolution (open → closed)

**Quality Metrics**:
- Bug escape rate (bugs found in production)
- Reopen rate (closed issues reopened)
- Blocker rate (% of issues blocked)

**Achievement Metrics**:
- Total issues closed
- Time invested
- Major milestones completed
- Critical bugs fixed
- Innovations/improvements delivered

---

## Integration with Other Practices

**Works with**:
- **task-tracking** (TRACKER.md) - Issues feed into milestones
- **session-continuity** (CURRENT-STATE.md) - Reference current issues
- **runbook-documentation** - Document issue resolution in runbooks
- **git-practices** - Reference issues in commits

---

## Real-World Example

**example-project Observability Stack Project**:
- **Duration**: Jan 05 - Feb 17 (6 weeks)
- **Total Issues**: 31 (22 closed, 9 open)
- **Work Documented**: 54+ hours
- **Environments**: 4 (Monitoring, Dev, Test, UAT)
- **Key Achievements Captured**:
  - 8-hour Jaeger v2 troubleshooting
  - Critical OTLP bug discovery and fix
  - Centralized Jaeger architectural innovation
  - Complete Phase 1-3 deployments

**Benefits Realized**:
- Complete audit trail of work
- Achievement demonstration for performance reviews
- Searchable knowledge base
- Pattern identification (8 hours troubleshooting → documented lessons)
- New team member onboarding (read closed issues for context)

---

## Troubleshooting

### Issue Numbers Out of Sync

```bash
# Find next number
ls issues/ISSUE-*.md | sed 's/.*ISSUE-0*\([0-9]*\).*/\1/' | sort -n | tail -1
# Add 1 to result
```

### ISSUES.md Stats Incorrect

```bash
# Regenerate stats
./scripts/issue-manager.sh stats
# Manually update ISSUES.md
```

### Merge Conflicts in ISSUES.md

```bash
# Accept both changes, manually reconcile issue lists
# ISSUES.md is index, not source of truth (issues/*.md files are)
```

---

## FAQ

**Q: Should I create issues for every small task?**
A: No. Use judgment. Issues should be meaningful units of work. Trivial 5-minute tasks don't need issues.

**Q: Can I delete closed issues?**
A: Don't delete - they're achievements! Archive old ones to docs/archive/issues/ if needed.

**Q: How detailed should issue descriptions be?**
A: Enough for someone else to understand. Include context, not just "fix bug". Explain what/why/how.

**Q: Should I create issues for all historical work?**
A: Optional. If documenting achievements, yes. If just starting, focus on current/future work.

**Q: What if external Jira required?**
A: Maintain both. Use this for granular tracking, sync key items to Jira for visibility.

---

**Author**: DevOps Practices MCP
**Maintained By**: MCP Community
**Version**: 1.0.0
**Created**: 2026-02-17
**Based On**: example-project Observability Stack POC implementation
