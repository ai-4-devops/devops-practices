# Migration Guide - Rolling Out MCP to Other Projects

**Purpose:** Step-by-step guide for integrating DevOps Practices MCP into existing projects.

**Target:** Projects with existing CLAUDE.md files that contain duplicated DevOps practices.

---

## Overview

This guide helps you:
1. Configure Claude to use the DevOps Practices MCP server
2. Slim down project-specific CLAUDE.md files
3. Remove duplicated practices and replace with MCP references
4. Verify the integration works correctly

**Time required:** ~15-30 minutes per project

---

## Prerequisites

- [ ] Claude Desktop or Claude Code installed
- [ ] DevOps Practices MCP repository cloned at: `~/work/devops/protean/devops-practices-mcp`
- [ ] Python 3.x installed (`python3 --version`)
- [ ] Git access to target project repository

---

## Step 1: Verify MCP Server Health

**Before rolling out to other projects, ensure the MCP server is working:**

```bash
cd ~/work/devops/protean/devops-practices-mcp
bash health-check.sh
```

**Expected output:**
```
========================================
  Health Check Summary
========================================
Total checks: 14
Passed: 14
Failed: 0

🎉 All health checks passed!

MCP Server Status: ✅ HEALTHY
```

**If any checks fail:** Fix issues before proceeding.

---

## Step 2: Configure Claude to Use MCP

### Option A: Claude Desktop

**Edit:** `~/Library/Application Support/Claude/claude_desktop_config.json` (macOS)
**Or:** `%APPDATA%/Claude/claude_desktop_config.json` (Windows)

**Add MCP server configuration:**

```json
{
  "mcpServers": {
    "devops-practices": {
      "command": "python3",
      "args": ["/absolute/path/to/devops-practices-mcp/mcp-server.py"],
      "cwd": "/absolute/path/to/devops-practices-mcp"
    }
  }
}
```

**Replace** `/absolute/path/to/devops-practices-mcp` with actual path (e.g., `/home/ukj/work/devops/protean/devops-practices-mcp`).

### Option B: Claude Code (VS Code Extension)

**Edit:** `~/.config/Code/User/settings.json` (Linux)
**Or:** `~/Library/Application Support/Code/User/settings.json` (macOS)

**Add MCP server configuration:**

```json
{
  "claude-code.mcpServers": {
    "devops-practices": {
      "command": "python3",
      "args": ["/absolute/path/to/devops-practices-mcp/mcp-server.py"],
      "cwd": "/absolute/path/to/devops-practices-mcp"
    }
  }
}
```

### Step 2.1: Restart Claude

**Claude Desktop:** Quit and restart the application
**Claude Code:** Reload VS Code window (Cmd+Shift+P → "Reload Window")

### Step 2.2: Verify MCP Connection

**In Claude conversation, ask:**
```
List available DevOps practices
```

**Expected response:** Claude should list all 10 practices from the MCP server.

**If it fails:**
- Check that Python path is correct (`which python3`)
- Check that mcp-server.py path is absolute, not relative
- Check MCP server logs (if available)
- Verify health check passed

---

## Step 3: Analyze Target Project CLAUDE.md

**Before migration, identify what to keep vs what to move:**

### 3.1: Backup Current CLAUDE.md

```bash
cd /path/to/target-project
cp CLAUDE.md CLAUDE.md.backup-$(date +%Y%m%d-%H%M)
git add CLAUDE.md.backup-*
```

### 3.2: Identify Duplicated Practices

**Open target project's CLAUDE.md and check for these sections:**

- [ ] Air-Gapped Workflow (lines ~XX-XX)
- [ ] Documentation Standards (lines ~XX-XX)
- [ ] Session Continuity (lines ~XX-XX)
- [ ] Task Tracking (lines ~XX-XX)
- [ ] Git Practices (lines ~XX-XX)
- [ ] Efficiency Guidelines (lines ~XX-XX)
- [ ] Standard Workflow (lines ~XX-XX)
- [ ] Runbook Documentation (lines ~XX-XX)
- [ ] Configuration Management (lines ~XX-XX)
- [ ] README Maintenance (lines ~XX-XX)

**Mark each section you find for removal.**

### 3.3: Identify Project-Specific Content

**Keep these sections (NOT in MCP):**

- [ ] Project-specific role/context
- [ ] Repository structure (unique to this project)
- [ ] Environment-specific details (AWS accounts, endpoints, etc.)
- [ ] Project-specific workflows or tools
- [ ] Team-specific conventions
- [ ] Custom scripts or automation unique to this project

---

## Step 4: Slim Down CLAUDE.md

### 4.1: Create Slimmed Version

**Strategy:** Remove duplicated practices, add MCP reference instead.

**Before (Example - Project CLAUDE.md):**
```markdown
# Claude AI Assistant - Working Context

## Role
[Project-specific role]

## Repository Structure
[Project-specific structure]

## CRITICAL: Air-Gapped Environment Workflow
[~150 lines of air-gapped workflow details]

## Documentation & Reporting
[~200 lines of documentation standards]

## Session Continuity
[~80 lines of session continuity]

[... etc, total ~650 lines]
```

**After (Slimmed CLAUDE.md):**
```markdown
# Claude AI Assistant - Working Context

## MCP Integration

This project uses the **DevOps Practices MCP** for shared practices. All standard DevOps practices (air-gapped workflow, documentation standards, runbook documentation, configuration management, etc.) are provided via MCP.

**MCP Server:** `~/work/devops/protean/devops-practices-mcp`

**To reference a practice:**
- Ask: "Show me the [practice name] practice"
- Example: "Show me the air-gapped workflow practice"
- Example: "Get the runbook documentation template"

**Available practices:** See MCP server or ask "List available DevOps practices"

---

## Role

[Project-specific role - KEEP THIS]

You are my **expert DevOps engineer** for the [PROJECT NAME] project. [Project-specific details...]

---

## Repository Structure

[Project-specific structure - KEEP THIS]

```
/
├── CLAUDE.md
├── CURRENT-STATE.md
├── docs/
│   ├── env-details.md
│   ├── [project-specific dirs]
├── configs/
│   └── [project-specific configs]
└── [project-specific dirs]
```

---

## Environment-Specific Details

[Project-specific environment details - KEEP THIS]

**AWS Account:** [account-id]
**Region:** [region]
**Cluster:** [cluster-name]
**Access Method:** [bastion/SSM/etc]

[... etc, only project-specific content remains]
```

**Line count reduction:**
- Before: ~650 lines (practices + project-specific)
- After: ~200 lines (project-specific only)
- **Reduction:** ~70% smaller, much easier to maintain

### 4.2: Add MCP Reference Section

**Add this section near the top of slimmed CLAUDE.md:**

```markdown
## DevOps Practices (via MCP)

This project follows standard DevOps practices provided by the **DevOps Practices MCP server**.

### Available Practices

1. **Air-Gapped Workflow** - Laptop/bastion/CloudShell separation
2. **Documentation Standards** - File naming, report types, structure
3. **Session Continuity** - Handoff protocol, resumable work
4. **Task Tracking** - TRACKER.md maintenance
5. **Git Practices** - Version control best practices
6. **Efficiency Guidelines** - Copy-paste vs script decisions
7. **Standard Workflow** - Overall DevOps approach
8. **Runbook Documentation** - Session log standards (MANDATORY)
9. **Configuration Management** - Environment-specific config organization
10. **README Maintenance** - Directory self-documentation

### How to Use MCP Practices

**In conversation with Claude:**
- "Show me the air-gapped workflow practice"
- "Get the runbook documentation template"
- "List all available DevOps practices"

**Quick reference:** See [PRACTICE-INDEX.md](../devops-practices-mcp/PRACTICE-INDEX.md) for scenario-based lookup.

**⚠️ Fallback if MCP unavailable:**
- GitHub: https://github.com/ai-4-devops/devops-practices/tree/main/practices
- Local: `~/.mcp-servers/devops-practices-mcp/practices/`
- Critical summaries in Appendix below

### Templates Available

1. **CLAUDE.md** - Project instructions template
2. **TRACKER.md** - Task tracking template
3. **CURRENT-STATE.md** - Session handoff template
4. **RUNBOOK.md** - Session log template (use for EVERY session)
```

### 4.3: Add Fallback Appendix (Recommended)

**For resilience, add critical practice summaries as fallback:**

Use the appendix from [CLAUDE-template.md](templates/CLAUDE-template.md) or create a minimal one:

```markdown
## Appendix: Critical Practices (Fallback if MCP Unavailable)

**Full practices**: https://github.com/ai-4-devops/devops-practices/tree/main/practices

### Essential Patterns
- **Air-gapped**: Laptop → S3 → Bastion (no direct AWS from laptop)
- **Docs**: guides/ = HOW | RUNBOOKS/ = WHAT | reports/ = WHY
- **Git**: Always `git mv` for tracked files
- **Tracking**: Update TRACKER.md + CURRENT-STATE.md every session
- **Runbooks**: MANDATORY for every session in docs/RUNBOOKS/

See template for full appendix with summaries.
```

---

## Step 5: Test MCP Integration

### 5.1: Test Practice Retrieval

**In Claude conversation for target project:**

```
Show me the runbook documentation practice
```

**Expected:** Claude retrieves and displays the practice content.

### 5.2: Test Template Retrieval

```
Get the RUNBOOK template
```

**Expected:** Claude retrieves the RUNBOOK-template.md content.

### 5.3: Test During Actual Work

**Perform a small task (e.g., check cluster status) and ask:**

```
Which practices should I follow for this deployment?
```

**Expected:** Claude references MCP practices (air-gapped workflow, runbook documentation, etc.).

### 5.4: Test Runbook Creation

```
Create a runbook for this session using the template
```

**Expected:** Claude uses RUNBOOK-template.md from MCP to create session log.

---

## Step 6: Commit Changes

**Once testing is successful:**

```bash
cd /path/to/target-project

# Check what changed
git diff CLAUDE.md

# Stage changes
git add CLAUDE.md
git add CLAUDE.md.backup-*

# Commit
git commit -m "refactor: Migrate to DevOps Practices MCP

- Remove duplicated practices (~450 lines)
- Add MCP integration section
- Keep project-specific content only
- Backup original CLAUDE.md

CLAUDE.md now ~70% smaller and easier to maintain.

MCP server: ~/work/devops/protean/devops-practices-mcp
Practices available: 10
Templates available: 4"

# Push
git push origin main
```

---

## Step 7: Update Project Documentation

### 7.1: Update Project README

**Add MCP requirement to project README.md:**

```markdown
## Prerequisites

- Claude Desktop or Claude Code with MCP support
- **DevOps Practices MCP** configured (see [MIGRATION-GUIDE.md](../devops-practices-mcp/MIGRATION-GUIDE.md))
- Python 3.x (for MCP server)
- [Other project-specific prerequisites]
```

### 7.2: Add MCP Setup Instructions

**Create or update project's SETUP.md:**

```markdown
## MCP Configuration

This project requires the DevOps Practices MCP server.

**Setup:**
1. Clone MCP repository: `git clone [url] ~/work/devops/protean/devops-practices-mcp`
2. Configure Claude (see [MIGRATION-GUIDE.md](../devops-practices-mcp/MIGRATION-GUIDE.md#step-2-configure-claude-to-use-mcp))
3. Verify: Ask Claude to "List available DevOps practices"
```

---

## Rollback Plan

**If MCP integration causes issues, rollback:**

### Quick Rollback

```bash
cd /path/to/target-project

# Find backup
ls -la CLAUDE.md.backup-*

# Restore
cp CLAUDE.md.backup-YYYYMMDD-HHMM CLAUDE.md

# Commit
git add CLAUDE.md
git commit -m "revert: Rollback MCP migration

Restoring original CLAUDE.md due to [reason]."
git push origin main
```

### Remove MCP Configuration

**Edit Claude config file and remove MCP server entry:**

```json
{
  "mcpServers": {
    // Remove or comment out:
    // "devops-practices": { ... }
  }
}
```

**Restart Claude.**

---

## Migration Checklist (Per Project)

### Pre-Migration

- [ ] MCP health check passed
- [ ] MCP configured in Claude
- [ ] MCP connection verified ("List available DevOps practices" works)
- [ ] Target project CLAUDE.md backed up

### Migration

- [ ] Duplicated practices identified
- [ ] Project-specific content identified
- [ ] CLAUDE.md slimmed down (~70% reduction)
- [ ] MCP reference section added
- [ ] Changes committed and pushed

### Post-Migration

- [ ] Practice retrieval tested
- [ ] Template retrieval tested
- [ ] Actual work tested with MCP practices
- [ ] Runbook creation tested
- [ ] Project README updated (MCP prerequisite)
- [ ] Team notified of MCP requirement

---

## Multi-Project Migration Strategy

**If migrating multiple projects, use this order:**

### Phase 1: Pilot (1 project)
1. Choose least critical project for pilot
2. Complete full migration (Steps 1-7)
3. Use for 1-2 weeks to validate
4. Document any issues or improvements

### Phase 2: Rollout (Remaining projects)
5. Apply learnings from pilot
6. Migrate remaining projects one at a time
7. Allow 1-2 days between migrations for validation

### Phase 3: Maintenance
8. Update MCP server as needed (all projects benefit)
9. Keep project-specific CLAUDE.md files focused
10. Contribute new practices back to MCP

---

## Troubleshooting

### Issue: Claude doesn't see MCP practices

**Symptoms:** "List available DevOps practices" returns nothing or error

**Solutions:**
1. Verify MCP server path is absolute (not relative)
2. Check Python path: `which python3`
3. Run health check: `bash health-check.sh`
4. Restart Claude completely
5. Check Claude logs for MCP errors

**Fallback workaround:**
```
If MCP server won't start, access practices directly:
- GitHub: https://github.com/ai-4-devops/devops-practices/tree/main/practices
- Local: cat ~/.mcp-servers/devops-practices-mcp/practices/03-02-air-gapped-workflow.md
- Appendix in project CLAUDE.md (if you added it in Step 4.3)
```

### Issue: Practice content is outdated

**Symptoms:** MCP returns old version of practice

**Solutions:**
1. Pull latest MCP changes: `cd devops-practices-mcp && git pull`
2. Restart Claude (MCP reloads on restart)
3. Verify version: Check `CHANGELOG.md` for latest version

### Issue: Project-specific CLAUDE.md still too large

**Symptoms:** Slimmed CLAUDE.md still >400 lines

**Solutions:**
1. Review for more duplicated content
2. Move project-specific guides to `docs/guides/` and reference
3. Move environment details to `docs/env-details.md` and reference
4. Keep only critical project-specific workflows in CLAUDE.md

### Issue: Team members don't have MCP configured

**Symptoms:** Team members report Claude not following practices

**Solutions:**
1. Share this migration guide with team
2. Add MCP setup to project onboarding docs
3. Create project-specific MCP setup script
4. Document in project README as prerequisite

---

## Expected Results

### Before MCP

**Typical project CLAUDE.md:**
- **Size:** ~650 lines
- **Duplication:** 10 practices duplicated across 3+ projects
- **Maintenance:** Update each project individually (~2000 lines total)
- **Consistency:** Practices drift over time

### After MCP

**Slimmed project CLAUDE.md:**
- **Size:** ~200 lines (70% reduction)
- **Duplication:** Zero (practices centralized)
- **Maintenance:** Update MCP once, all projects benefit (~1100 lines total)
- **Consistency:** All projects use same practices, no drift

### ROI

**Per project:**
- Time saved: ~10-15 minutes per update
- Reduced confusion: No version drift
- Easier onboarding: Standard practices across projects

**Across 3+ projects:**
- **Maintenance reduction:** 45% fewer lines to maintain
- **Update efficiency:** 3× faster (update once, not 3 times)
- **Consistency gain:** 100% (practices synchronized)

---

## Next Steps After Migration

1. **Monitor usage:** Track how often MCP practices are referenced
2. **Gather feedback:** Ask team about MCP experience
3. **Improve practices:** Contribute improvements back to MCP
4. **Add new practices:** As patterns emerge, add to MCP
5. **Version control:** Tag MCP versions as practices evolve

---

## Support

**Issues with MCP server:**
- Check [CHANGELOG.md](CHANGELOG.md) for known issues
- Run health check: `bash health-check.sh`
- Review practice files in `practices/`

**Issues with migration:**
- Refer to rollback plan above
- Check project-specific CLAUDE.md backup
- Restore from git if needed

**Questions or improvements:**
- Open issue in devops-practices-mcp repository
- Discuss with DevOps team
- Update migration guide with learnings

---

## Examples

### Example 1: Example Project (Already Migrated)

**Before:**
- CLAUDE.md: 650 lines (practices + project-specific)
- All practices embedded in CLAUDE.md

**After:**
- CLAUDE.md: ~200 lines (project-specific only)
- Practices accessed via MCP
- 70% reduction in CLAUDE.md size

### Example 2: Project ABC (Target for Migration)

**Current state:**
```
Project-ABC/
├── CLAUDE.md                    # 580 lines (practices + project-specific)
├── docs/
│   ├── runbooks/
│   └── guides/
└── configs/
```

**After migration:**
```
Project-ABC/
├── CLAUDE.md                    # 180 lines (project-specific only)
├── CLAUDE.md.backup-20260213-1200  # Backup
├── docs/
│   ├── runbooks/
│   └── guides/
└── configs/
```

**Changes:**
- Removed: Air-gapped workflow, documentation standards, runbook docs, etc.
- Added: MCP reference section
- Kept: Project ABC specific role, repository structure, AWS account details

---

**Version:** 1.0.0
**Last Updated:** 2026-02-13
**Related:** [README.md](README.md) | [CHANGELOG.md](CHANGELOG.md) | [PRACTICE-INDEX.md](PRACTICE-INDEX.md)
