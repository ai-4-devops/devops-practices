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

**⚠️ Fallback**: If MCP unavailable, critical practices are duplicated below in Appendix.

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

### Air-Gapped Workflow (Summary)
- **Laptop**: Git repo, Claude - NO AWS access
- **CloudShell/VPS**: ECR uploads - Uses environment variables
- **Bastion**: EKS access via SSM - Copy/paste commands only
- **EKS**: Air-gapped - Images must be in ECR

**File Transfer**: Laptop → S3 → Bastion

### Documentation Structure (Summary)
- `docs/guides/` = HOW to deploy
- `docs/RUNBOOKS/` = WHAT we did
- `docs/reports/` = WHY we did it

### Git Practices (Summary)
- ALWAYS use `git mv` for tracked files (preserves history)
- NEVER commit without explicit user request
- Backup before changes: `backup-$(date -u +%Y%m%dT%H%M%SZ).yaml`

---

**Maintained By**: Infrastructure Team
**Last Updated**: ${DATE}