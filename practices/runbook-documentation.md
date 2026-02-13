# Runbook Documentation Practice

**Purpose**: Standards for maintaining detailed session activity logs that enable troubleshooting and reproducibility.

**🚨 CRITICAL - MANDATORY FOR EVERY SESSION 🚨**

---

## Why Runbooks Matter

Session logs are the **single source of truth** for:
- Troubleshooting and reproducing deployments
- Understanding what was done and why
- Enabling session continuity across different systems
- Audit trails for compliance and governance

**Missing commands or outputs can cause hours of debugging later.**

---

## Directory Structure

```
docs/
└── RUNBOOKS/              # Per-session activity logs
    ├── README.md          # Index and conventions
    ├── 20260203T1430Z-SESSION8-PHASE2-COMPLETE-RECORD.md
    ├── 20260212T0830Z-SESSION11-GRAFANA-DASHBOARD-DEPLOYMENT.md
    └── ...
```

**Location:** All session logs go in `docs/RUNBOOKS/` directory.

---

## File Naming Convention

All runbook files are prefixed with a UTC timestamp at creation time:

```bash
$(date -u +%Y%m%dT%H%MZ)-<descriptive-name>.md
```

**Format:** `YYYYMMDDTHHMMz-<description>.md`

**Examples:**
- `20260203T1430Z-SESSION8-PHASE2-COMPLETE-RECORD.md`
- `20260212T0830Z-SESSION11-GRAFANA-DASHBOARD-DEPLOYMENT.md`
- `20260128T0915Z-SESSION6-MONITORING-FINALIZATION.md`

**Rules:**
- Use UTC timestamp (append `Z`)
- Use hyphens to separate words
- Include session number if applicable
- Be descriptive but concise
- Same file is updated throughout the task/subtask lifecycle
- Create new timestamp only for new tasks or subtasks

---

## Required Contents

### Session Metadata

Every runbook MUST start with:

```markdown
# Session N: [Title]

**Date:** YYYY-MM-DD
**Session ID:** N
**Duration:** ~X hours/minutes
**Cluster:** [cluster-name] or [environment]
**User:** [who executed commands]
**Status:** ✅ Successful / ⚠️ Partial / ❌ Failed

---

## Objective

[Clear statement of what this session aimed to accomplish]

**Goals:**
- [Specific goal 1]
- [Specific goal 2]
- [Specific goal 3]
```

### Environment Context

Document the environment at session start:

```markdown
## Environment Context

**Bastion/System:**
- Access method: [SSM Session Manager / SSH / local]
- User: [username@hostname]
- Working directory: [path]
- Tools available: [kubectl, jq, helm, etc.]

**Target Environment:**
- Account: [AWS account ID or name]
- Cluster: [cluster-name]
- Namespace(s): [relevant namespaces]
- Current state: [brief description]
```

### Commands and Outputs (CRITICAL)

**⚠️ CAPTURE EVERYTHING VERBATIM**

For EVERY command executed:
1. **Command** - Exact command as typed
2. **Description** - What it does (brief)
3. **Output** - Complete output (do not truncate!)
4. **Result** - Success/failure/partial

**Format:**

```markdown
### Step N: [Step Description]

**Command:**
\`\`\`bash
[exact command here]
\`\`\`

**Output:**
\`\`\`
[complete output - DO NOT TRUNCATE]
\`\`\`

✅ **Result:** [Success/Failed/Partial - explain]
```

**Example:**

```markdown
### Step 3: Deploy OTel Collector

**Command:**
\`\`\`bash
kubectl apply -f otel-collector-deployment.yaml -n observability
\`\`\`

**Output:**
\`\`\`
deployment.apps/otel-collector created
service/otel-collector created
configmap/otel-collector-config created
\`\`\`

✅ **Result:** OTel Collector deployed successfully. All resources created.
```

### Issues and Resolutions

Document problems encountered:

```markdown
## Issues Encountered

### Issue 1: ImagePullBackOff Error

**Problem:**
\`\`\`
Error: ErrImagePull
Message: Failed to pull image "docker.io/otel/collector:0.114.0"
\`\`\`

**Root Cause:**
Image not available in ECR. Cluster is air-gapped and cannot reach Docker Hub.

**Resolution:**
1. Uploaded image to ECR via CloudShell
2. Updated deployment to use ECR image
3. Reapplied deployment

**Command:**
\`\`\`bash
kubectl apply -f otel-collector-deployment-ecr.yaml -n observability
\`\`\`

**Result:** ✅ Deployment successful after ECR image upload.
```

### Configuration Changes

Document before/after states:

```markdown
## Configuration Changes

### Change 1: Update Fluent Bit Cluster Label

**Before:**
\`\`\`yaml
[FILTER]
    Name                modify
    Match               kube.*
    Add                 cluster example-eks-cluster-cluster
\`\`\`

**After:**
\`\`\`yaml
[FILTER]
    Name                modify
    Match               kube.*
    Add                 cluster example-eks-cluster-cluster-mon
\`\`\`

**Reason:** Align cluster label with new naming convention.

**Backup:** \`fluent-bit-values-backup-20260204T1254Z.yaml\`
```

### Verification and Testing

Document how success was verified:

```markdown
## Verification

### 1. Pod Status Check

**Command:**
\`\`\`bash
kubectl get pods -n observability
\`\`\`

**Output:**
\`\`\`
NAME                              READY   STATUS    RESTARTS   AGE
otel-collector-68d7c9b8f5-7xk2m   1/1     Running   0          2m30s
kube-state-metrics-7b8f9c-4nx7t   1/1     Running   0          5m
\`\`\`

✅ **Result:** All pods running.

### 2. Metrics Flow Verification

[Document how metrics/logs/traces were verified]
```

### Summary

End with clear summary:

```markdown
## Summary

### ✅ Successfully Completed
1. [Accomplishment 1]
2. [Accomplishment 2]
3. [Accomplishment 3]

### ⚠️ Partial/Issues
1. [Any incomplete items]
2. [Known issues]

### 📋 Next Steps
1. [What needs to happen next]
2. [Dependencies or blockers]

---

**Session Completed:** YYYY-MM-DD HH:MM UTC
**Status:** ✅ Successful / ⚠️ Partial / ❌ Failed
**Outcome:** [Brief statement of what was accomplished]
```

---

## What to Capture

### ALWAYS Capture

✅ **Every command** executed (laptop, CloudShell, bastion)
✅ **Complete outputs** (do not truncate!)
✅ **Error messages** (full stack traces)
✅ **Configuration files** (before/after diffs)
✅ **Verification steps** (how you confirmed it works)
✅ **Timestamps** (when critical events occurred)
✅ **File transfers** (S3 uploads/downloads)
✅ **ECR operations** (image uploads, tagging)

### NEVER Omit

❌ Command outputs (even if lengthy)
❌ Error details (full messages matter)
❌ Intermediate steps (every command counts)
❌ Failed attempts (document what didn't work!)
❌ Workarounds (capture the actual solution used)

---

## Special Cases

### Multi-Session Tasks

When a task spans multiple sessions:

```markdown
# Session 8 Phase 1: Dev OTel Prometheus Receiver

[Session 8 Phase 1 details]

---

# Session 8 Phase 2: Dev Infrastructure Exporters

**Continuation of:** Session 8 Phase 1
**Previous Runbook:** 20260203T0745Z-SESSION8-DEV-OTEL-PROMETHEUS-RECEIVER.md

[Session 8 Phase 2 details]
```

### Interactive Sessions

When working interactively (e.g., troubleshooting):

```markdown
## Interactive Troubleshooting

### Iteration 1: First Attempt

**Command:** [command]
**Output:** [output]
**Result:** ❌ Failed - [reason]

### Iteration 2: Second Attempt

**Command:** [adjusted command]
**Output:** [output]
**Result:** ⚠️ Partial - [details]

### Iteration 3: Final Solution

**Command:** [working command]
**Output:** [output]
**Result:** ✅ Success
```

### Background Tasks

When tasks run in background:

```markdown
### Step 5: Start Port-Forward (Background)

**Command:**
\`\`\`bash
kubectl port-forward -n monitoring svc/prometheus-grafana 3001:80 &
\`\`\`

**Output:**
\`\`\`
[1] 57301
Forwarding from 127.0.0.1:3001 -> 3000
Forwarding from [::1]:3001 -> 3000
\`\`\`

⏳ **Status:** Running in background (PID 57301)

[Continue with other commands while port-forward is active]
```

---

## Best Practices

### 1. Write as You Go

- Document commands IMMEDIATELY after execution
- Don't wait until end of session
- Fresh context ensures accuracy

### 2. Use Consistent Formatting

- Use code blocks for all commands/outputs
- Use status indicators (✅ ⚠️ ❌)
- Use headers for clear sections

### 3. Be Thorough, Not Brief

- It's better to capture too much than too little
- Future you will thank present you
- Assume reader has zero context

### 4. Include Context

- Why was this command run?
- What was the expected result?
- What actually happened?

### 5. Document Failures

- Failed attempts are valuable learning
- Show what didn't work and why
- Document the path to success

---

## Templates

Use the standard runbook template: `templates/RUNBOOK-template.md`

**Get template:**
```bash
# Via MCP
[Query MCP: get_template("RUNBOOK-template")]

# Or copy from:
devops-practices-mcp/templates/RUNBOOK-template.md
```

---

## Quality Checklist

Before finishing a runbook, verify:

- [ ] File name follows timestamp convention
- [ ] Session metadata is complete
- [ ] ALL commands are documented
- [ ] ALL outputs are captured (not truncated)
- [ ] Errors and resolutions are documented
- [ ] Verification steps are included
- [ ] Summary is clear and actionable
- [ ] No critical information is missing

---

## Common Mistakes to Avoid

❌ **Truncating long outputs** - Capture everything!
❌ **Skipping "obvious" commands** - Document everything!
❌ **Missing error context** - Full error messages matter!
❌ **No timestamps** - When did this happen?
❌ **Vague descriptions** - Be specific!
❌ **Forgetting file transfers** - S3 commands count!
❌ **Incomplete verification** - How do you know it worked?

---

## Examples

See existing runbooks in example-project project:
- `docs/RUNBOOKS/20260203T1430Z-SESSION8-PHASE2-COMPLETE-RECORD.md` - Comprehensive example
- `docs/RUNBOOKS/20260212T0830Z-SESSION11-GRAFANA-DASHBOARD-DEPLOYMENT.md` - Interactive session example
- `docs/RUNBOOKS/20260128T0000Z-SESSION6-COMPLETE-RECORD.md` - Multi-component deployment

---

## Related Practices

- **[documentation-standards.md](documentation-standards.md)** - Overall documentation structure (HOW/WHAT/WHY)
- **[session-continuity.md](session-continuity.md)** - State tracking and session handoff
- **[task-tracking.md](task-tracking.md)** - TRACKER.md guidelines
- **[git-practices.md](git-practices.md)** - File naming and backup conventions

---

**Remember:** Runbooks are not just logs - they are reproducible deployment instructions!

---

**Maintained By**: Infrastructure Team
**Last Updated**: 2026-02-13
**Version**: 1.0.0
