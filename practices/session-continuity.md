# Session Continuity

**Purpose**: Enable seamless session resumption from any system after `git commit && git push`.

**Principle**: Any session must be fully resumable from a different system without prior conversation history.

---

## Core Concept

**Problem**: You start work on your laptop, then need to continue from a different machine, or hand off to a teammate.

**Solution**: Everything needed to resume lives in git. No local-only state, no undocumented assumptions.

---

## How This Is Achieved

### 1. Everything Lives in Git ✅

All artifacts are version-controlled:
- Documentation (guides, runbooks, reports)
- Configuration files (k8s manifests, helm values)
- Scripts (deployment scripts, ECR upload scripts)
- State tracking (TRACKER.md, CURRENT-STATE.md, PENDING-CHANGES.md)
- Environment details (docs/env-details.md, docs/ecr-manifest.md)

**Never rely on**:
- Uncommitted files
- Local environment variables
- Bastion-side state that isn't documented
- Verbal conversations that aren't captured
- Temporary files or notes

### 2. Session Handoff Notes (CURRENT-STATE.md) ✅

At the end of each session, update or create `CURRENT-STATE.md` in repo root:

**Must include**:
- **What was just completed** - Summary of work done this session
- **What is in progress** - Exact state of ongoing work
- **What's next** - Specific commands or actions needed (priority order)
- **Pending items** - Approvals, image uploads, access requests, blockers
- **Current environment state** - Brief summary of each environment
- **Key files & references** - Links to important documents
- **Known issues** - Active problems with workarounds

**Example structure**:
```markdown
# Current State - Session Handoff
**Last Updated**: 2026-02-13 18:15 UTC
**Session**: 4
**Status**: Ready for commit

## What Was Just Completed
[Detailed summary of completed work]

## What Is Currently In Progress
[Exact state of ongoing work with context]

## What's Next (Priority Order)
### 1. Task Name (Status)
**Action**: Specific commands or steps
**Files Ready**: Links to prepared files
**Dependencies**: What needs to happen first

## Current Environment State
Brief status of each environment

## Key Files & References
Links to important documents

## Known Issues
Active problems with workarounds
```

### 3. No Local-Only State ✅

**Don't rely on**:
- Files that aren't committed
- Shell history
- Terminal scrollback
- Memory of previous conversations
- Local configuration that isn't in git

**Do capture**:
- All commands executed (in RUNBOOKS)
- All file changes (committed to git)
- All environment changes (in env-details.md)
- All decisions (in reports or RUNBOOKS)

### 4. Runbook Completeness ✅

Session logs in `docs/RUNBOOKS/` must be thorough enough that a new session can reconstruct context without prior conversation history.

**Must include**:
- Session metadata (date, session number, objectives)
- Every command executed (laptop, CloudShell/VPS, bastion)
- Complete output from each command (never truncate)
- Issues encountered with resolutions
- Configuration changes (before/after)
- Verification steps and results
- Timestamps and context

---

## Session Start Protocol

When starting a new session (or resuming after context loss), Claude should follow this protocol:

### 1. Read CLAUDE.md
**Purpose**: Understand project-specific working context
**Location**: Project root
**Contains**: Role, environment workflow, project-specific practices

### 2. Read CURRENT-STATE.md
**Purpose**: Get immediate session context
**Location**: Project root
**Contains**: What was completed, what's in progress, what's next
**This is the most important file** for understanding where to pick up

### 3. Read TRACKER.md
**Purpose**: Understand full task history and status
**Location**: Project root
**Contains**: All tasks with completion dates, references, progress tracking

### 4. Read docs/env-details.md
**Purpose**: Understand current infrastructure state
**Location**: docs/
**Contains**: Endpoints, credentials, service states, current configuration

### 5. Review Recent RUNBOOKS/
**Purpose**: Understand recent activities and context
**Location**: docs/RUNBOOKS/
**Action**: Check files modified in last 7-14 days

### 6. Review Recent Reports
**Purpose**: Understand recent decisions and issues
**Location**: docs/reports/
**Action**: Check for lessons learned, blockers, decisions

### 7. Confirm Understanding
**Action**: Summarize current state to user before proceeding
**Example**: "I see we completed X, Y is in progress, and next step is Z. Is that correct?"

---

## State Tracking Files

### TRACKER.md (Comprehensive Task List)
- **Purpose**: Single source of truth for all project tasks
- **Contains**: All tasks with status, dates, references
- **Update**: After each significant task completion
- **Use**: Understanding full project history and current progress

### CURRENT-STATE.md (Session Handoff)
- **Purpose**: Immediate session context and next steps
- **Contains**: What's done, in-progress, next (with priority)
- **Update**: At end of each session before committing
- **Use**: Picking up exactly where previous session left off

### PENDING-CHANGES.md (Infrastructure Tracker)
- **Purpose**: Track prepared but not yet deployed changes
- **Contains**: Manifests ready, deployment commands, environment status
- **Update**: When preparing deployments, when deploying, when changes committed
- **Use**: Understanding what's ready to deploy vs already deployed

### docs/env-details.md (Living Environment State)
- **Purpose**: Real-time environment state
- **Contains**: Endpoints, credentials, service states, current config
- **Update**: Whenever discovering new info or state changes
- **Use**: Understanding current infrastructure without querying it

### docs/ecr-manifest.md (Living Image Tracker)
- **Purpose**: Track ECR images across environments
- **Contains**: Repository names, tags, upload dates
- **Update**: Whenever images pushed or discovered
- **Use**: Preventing ImagePullBackOff errors, planning deployments

---

## Handoff Checklist

Before ending a session, ensure:

- [ ] All changes committed to git
- [ ] CURRENT-STATE.md updated with latest status
- [ ] TRACKER.md updated with completed tasks
- [ ] PENDING-CHANGES.md reflects current deployment state
- [ ] Living documents updated (env-details.md, ecr-manifest.md)
- [ ] Session RUNBOOK created or updated with complete command history
- [ ] Any blockers documented with context
- [ ] Next steps clearly specified with commands ready
- [ ] Git pushed to remote (enables resumption from any system)

---

## Benefits

### For You
- Resume work from any system without losing context
- Hand off to teammates seamlessly
- Come back after weeks/months and understand state immediately

### For Team
- Anyone can pick up where you left off
- New team members get full context
- Troubleshooting has complete history

### For Organization
- Audit trail of all changes
- Knowledge retention (not locked in one person's head)
- Reproducible deployments

---

## Anti-Patterns

### ❌ Bad: Relying on Memory
```
"I think we deployed 3 brokers last time..."
"Maybe the issue was with the storage class?"
```

### ✅ Good: Checking State Files
```
# Check CURRENT-STATE.md
"UAT has 3 brokers, DEV has 1 broker"

# Check RUNBOOKS
"Issue was EBS volume binding, resolved by checking storage class"
```

### ❌ Bad: Uncommitted Changes
```
User: "Can you continue from yesterday?"
Claude: "I don't see any recent commits. What was the last thing we did?"
```

### ✅ Good: Committed State
```
User: "Can you continue from yesterday?"
Claude: "I see you completed repo reorganization (commit 87928d8).
         CURRENT-STATE.md shows next step is deploying DEV topics.
         Ready to proceed?"
```

### ❌ Bad: Incomplete RUNBOOKS
```
# Ran some commands, got it working
```

### ✅ Good: Complete RUNBOOKS
```
# Session: 2026-02-13 - Deploy DEV Topics
## Command 1
kubectl apply -f kafka-topic-quote-requested.yaml

## Output 1
kafkatopic.kafka.strimzi.io/quote-requested created

## Verification
kubectl get kafkatopic quote-requested -n kafka
NAME              CLUSTER                  PARTITIONS   REPLICATION FACTOR   READY
quote-requested   kafka-project-cluster-dev   1            1                    True
```

---

## Session Continuity in Air-Gapped Environment

**Special Considerations**:

1. **Bastion has no git** - All file changes happen on laptop, transferred via S3
2. **Commands are copy/paste** - Document in RUNBOOKS exactly as pasted to bastion
3. **ECR images pre-staged** - Document in ecr-manifest.md before deployment
4. **Multiple systems** - Laptop (git), CloudShell (ECR), Bastion (EKS) - document flow

**Example Session Continuity**:
```
Session N-1 (Yesterday):
- Laptop: Created topic manifests
- CloudShell: Uploaded images to ECR
- Laptop: Committed manifests, updated CURRENT-STATE.md, pushed to git

Session N (Today, Different System):
- New laptop: git pull
- Read CURRENT-STATE.md: "Topics manifests ready, next: deploy to bastion"
- Check ecr-manifest.md: "Images confirmed in ECR"
- Generate S3 upload commands for manifests
- Generate kubectl commands for bastion
- User pastes commands to bastion
- Update RUNBOOKS with outputs
- Update CURRENT-STATE.md with completion
- Commit and push
```

---

## Related Practices

- **[task-tracking.md](task-tracking.md)** - TRACKER.md for tracking progress across sessions
- **[runbook-documentation.md](runbook-documentation.md)** - Session logs enable reproducibility
- **[git-practices.md](git-practices.md)** - Commit conventions and version control
- **[documentation-standards.md](documentation-standards.md)** - CURRENT-STATE.md structure and location

---

**Maintained By**: Infrastructure Team
**Last Updated**: 2026-02-13
**Version**: 1.0.0