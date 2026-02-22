# Claude AI Assistant - ${PROJECT_NAME}

## MCP Service Integration

**Shared Practices**: `devops-practices` MCP server

Claude has access to shared DevOps practices via MCP service. Query practices when needed:
- **Air-gapped workflow** - Working across laptop, CloudShell, bastion, EKS
- **Documentation standards** - HOW/WHAT/WHY structure, naming conventions
- **Session continuity** - State tracking, handoff protocols
- **Task tracking** - TRACKER.md, CURRENT-STATE.md guidelines
- **Git practices** - Using `git mv`, commit conventions, backup protocols
- **Efficiency guidelines** - When to script vs copy-paste, command batching

**⚠️ Fallback**: If MCP unavailable, critical practices are in Appendix below + [GitHub practices](https://github.com/ai-4-devops/devops-practices/tree/main/practices)

---

## Role

You are my **expert ${ROLE}**. You bring deep expertise in ${EXPERTISE_AREAS}.

---

## Project-Specific: ${PROJECT_NAME}

### Overview
[Brief project description]

### Key Components
- Component 1: Version/details
- Component 2: Version/details
- Component 3: Version/details

### Environments

**ENV1** (AWS Account: ${ACCOUNT_ID})
- Cluster: ${CLUSTER_NAME}
- Endpoint: ${ENDPOINT}
- Configuration: ${CONFIG_DETAILS}
- Status: ✅ Operational / ⏳ Pending

**ENV2** (AWS Account: ${ACCOUNT_ID})
- Cluster: ${CLUSTER_NAME}
- Endpoint: ${ENDPOINT}
- Configuration: ${CONFIG_DETAILS}
- Status: ✅ Operational / ⏳ Pending

### Project-Specific Practices

[Only project-specific instructions that don't belong in shared MCP practices]

#### Specific Workflow
[Project-specific workflow details]

#### Specific Configurations
[Project-specific configuration details]

#### Common Issues
[Project-specific known issues and solutions]

---

## Appendix: Critical Practices (Fallback if MCP Unavailable)

**📚 Full Practices**: If MCP server is down, access complete practices at:
- GitHub: https://github.com/ai-4-devops/devops-practices/tree/main/practices
- Local clone: `~/.mcp-servers/devops-practices-mcp/practices/`

**Below are essential summaries for quick reference:**

---

### 03-02 Air-Gapped Workflow (Summary)
**File**: [03-02-air-gapped-workflow.md](https://github.com/ai-4-devops/devops-practices/blob/main/practices/03-02-air-gapped-workflow.md)

**Environment Separation:**
- **Laptop**: Git repo, Claude - NO AWS access
- **CloudShell/VPS**: ECR uploads - Uses environment variables
- **Bastion**: EKS access via SSM - Copy/paste commands only
- **EKS**: Air-gapped - Images must be in ECR

**File Transfer Pattern**: Laptop → S3 → Bastion
**Command Flow**: Write on Laptop → Execute on Bastion (copy/paste)

---

### 04-01 Documentation Standards (Summary)
**File**: [04-01-documentation-standards.md](https://github.com/ai-4-devops/devops-practices/blob/main/practices/04-01-documentation-standards.md)

**Directory Structure:**
- `docs/guides/` = HOW to deploy (procedures)
- `docs/RUNBOOKS/` = WHAT we did (session logs - MANDATORY)
- `docs/reports/` = WHY we did it (decisions)

**Naming**: `YYYYMMDD-descriptive-name.md`

---

### 02-01 Git Practices (Summary)
**File**: [02-01-git-practices.md](https://github.com/ai-4-devops/devops-practices/blob/main/practices/02-01-git-practices.md)

**Critical Rules:**
- ALWAYS use `git mv` for tracked files (preserves history)
- NEVER commit without explicit user request
- Backup before changes: `backup-$(date -u +%Y%m%dT%H%M%SZ).yaml`
- Follow GitLab Flow: feature → develop → main

---

### 01-02 Task Tracking (Summary)
**File**: [01-02-task-tracking.md](https://github.com/ai-4-devops/devops-practices/blob/main/practices/01-02-task-tracking.md)

**Required Files:**
- `TRACKER.md` - Milestones and tasks
- `CURRENT-STATE.md` - Session handoff state
- Update both at end of every session

**Template**: [TRACKER-template.md](https://github.com/ai-4-devops/devops-practices/blob/main/templates/TRACKER-template.md)

---

### 04-03 Runbook Documentation (Summary)
**File**: [04-03-runbook-documentation.md](https://github.com/ai-4-devops/devops-practices/blob/main/practices/04-03-runbook-documentation.md)

**MANDATORY**: Create runbook for EVERY session
**Location**: `docs/RUNBOOKS/YYYYMMDD-session-N-title.md`
**Template**: [RUNBOOK-template.md](https://github.com/ai-4-devops/devops-practices/blob/main/templates/RUNBOOK-template.md)

**Required Sections**: Objective, Pre-work, Execution, Observations, Next Steps

---

### 03-01 Configuration Management (Summary)
**File**: [03-01-configuration-management.md](https://github.com/ai-4-devops/devops-practices/blob/main/practices/03-01-configuration-management.md)

**Structure:**
```
configs/${ENV}/${COMPONENT}/
  ├── config-template.yaml  # Placeholder version
  ├── config.yaml          # Actual values (gitignored)
  └── README.md            # Parameter documentation
```

**Rule**: NEVER commit actual credentials or endpoints to git

---

### 01-01 Session Continuity (Summary)
**File**: [01-01-session-continuity.md](https://github.com/ai-4-devops/devops-practices/blob/main/practices/01-01-session-continuity.md)

**End of Session:**
1. Update `CURRENT-STATE.md` with current status
2. Update `TRACKER.md` with progress
3. Create/update runbook in `docs/RUNBOOKS/`
4. Commit all changes

**Start of Session:**
1. Read `CURRENT-STATE.md`
2. Review `TRACKER.md`
3. Read last runbook

---

**💡 MCP Server Troubleshooting**:
- Verify MCP running: `ps aux | grep mcp-server`
- Check logs: `~/.cache/claude/mcp-devops-practices.log`
- Restart Claude Code/Desktop to reload MCP
- Health check: `~/.mcp-servers/devops-practices-mcp/health-check.sh`

---

**Maintained By**: Uttam Jaiswal
**Last Updated**: ${DATE}