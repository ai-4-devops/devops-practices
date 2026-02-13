# Quick Start - DevOps Practices MCP Server

**5-Minute Setup Guide for Beginners**

---

## What You Just Got

A **centralized knowledge base** for all your example-project DevOps projects. Instead of copying 580 lines of instructions into every project's CLAUDE.md, Claude now queries this MCP server for shared practices.

**Before MCP**:
```
kafka-project/CLAUDE.md         → 580 lines (70% shared, 30% project-specific)
example-monitoring/CLAUDE.md    → 580 lines (same 70% duplicated)
example-networking/CLAUDE.md    → 580 lines (same 70% duplicated)
```

**After MCP**:
```
devops-practices-mcp/   → Shared practices (used by all)
kafka-project/CLAUDE.md         → ~150 lines (only Kafka-specific)
example-monitoring/CLAUDE.md    → ~150 lines (only monitoring-specific)
example-networking/CLAUDE.md    → ~150 lines (only networking-specific)
```

---

## What's Inside

### 10 Practice Documents
1. **air-gapped-workflow.md** - How to work across laptop/CloudShell/bastion/EKS
2. **documentation-standards.md** - HOW/WHAT/WHY structure, naming conventions
3. **session-continuity.md** - State tracking, handoff protocols
4. **task-tracking.md** - TRACKER.md guidelines
5. **git-practices.md** ⭐ - GitLab Flow branching, `git mv`, backup protocols (200+ lines)
6. **efficiency-guidelines.md** - Script vs copy-paste decisions
7. **standard-workflow.md** - Common operational patterns
8. **runbook-documentation.md** ⭐ - Mandatory session log standards
9. **configuration-management.md** ⭐ - Config organization, placeholders
10. **readme-maintenance.md** ⭐ - Directory documentation standards

### 4 Template Files
1. **TRACKER-template.md** - Task tracking template
2. **CURRENT-STATE-template.md** - Session handoff template
3. **CLAUDE-template.md** - Simplified project CLAUDE.md template
4. **RUNBOOK-template.md** ⭐ - Session log template

### MCP Server + CI/CD
- **mcp-server.py** - Python MCP server (5 tools: list/get practices & templates, render templates)
- **health-check.sh** - Comprehensive validation script (14 checks)
- **.gitlab-ci.yml** - Automated CI/CD pipeline (validates all changes)
- **CONTRIBUTING.md** ⭐ - Complete contribution guide with GitLab Flow workflows
- Zero dependencies (Python stdlib only)

---

## Setup (5 Minutes)

**Recommended Installation Location**: `~/.mcp-servers/devops-practices/`

This keeps MCP servers organized and makes configuration easier.

### Step 1: Clone & Test (1 minute)

```bash
# Clone to recommended location
git clone <repo-url> ~/.mcp-servers/devops-practices
cd ~/.mcp-servers/devops-practices

# Install dependencies (if needed)
pip install -r requirements.txt

# Run health check
bash health-check.sh

# Should see:
# ✅ All 14 checks passed!
# ✅ MCP server is healthy
```

✅ If all checks pass, server is ready!

---

### Step 2: Find Claude Config File (1 minute)

```bash
# Find your Claude config (check these locations in order):
ls ~/.claude.json                     # Most common (project-specific config)
ls ~/.config/claude/config.json       # Alternative (global config)
ls ~/Library/Application\ Support/Claude/config.json  # macOS

# If none exist:
echo "Config file not found - check Claude Code installation"
```

**Most likely**: You have `~/.claude.json` with project-specific configurations.

---

### Step 3: Add MCP Server to Config (2 minutes)

#### Option A: Project-Specific Config (Most Common)

If you have `~/.claude.json` with a structure like:
```json
{
  "projects": {
    "/path/to/your/project": {
      "mcpServers": {}
    }
  }
}
```

**Find your project path** and add MCP server:
```bash
# Edit config
vim ~/.claude.json

# Find your project (search for the path), then update:
"/path/to/your/kafka-project": {
  "mcpServers": {
    "devops-practices": {
      "command": "python",
      "args": ["/home/<username>/.mcp-servers/devops-practices/mcp-server.py"],
      "env": {}
    }
  }
}
```

#### Option B: Global Config (Recommended)

If you have `~/.config/claude/config.json` with simpler structure:
```bash
vim ~/.config/claude/config.json
```

Add at root level:
```json
{
  "mcpServers": {
    "devops-practices": {
      "command": "python",
      "args": ["/home/<username>/.mcp-servers/devops-practices/mcp-server.py"],
      "env": {}
    }
  }
}
```

**⚠️ CRITICAL**:
- Use **absolute path** to mcp-server.py
- Replace `<username>` with your actual username
- Recommended: `~/.mcp-servers/devops-practices/mcp-server.py`
- Save and exit

---

---

### Step 4: Restart Claude Code (30 seconds)

```bash
# Kill Claude if running
pkill -f claude

# Restart Claude Code
# (However you normally start it - CLI or VSCode)
```

---

### Step 5: Test with Claude (1 minute)

Start Claude Code and ask:

```
"Can you list the available DevOps practices from the MCP server?"
```

**Expected Response**:
Claude should list 10 practices:
- air-gapped-workflow
- documentation-standards
- session-continuity
- task-tracking
- git-practices
- efficiency-guidelines
- standard-workflow
- runbook-documentation
- configuration-management
- readme-maintenance

---

## Verification

### Test 1: List Practices ✅
```
User: "List available practices"
Claude: [Shows 10 practices from MCP server]
```

### Test 2: Get a Practice ✅
```
User: "Show me the git branching strategy"
Claude: [Displays git-practices.md with GitLab Flow documentation]
```

### Test 3: Render a Template ✅
```
User: "Create a TRACKER.md for my project"
Claude: [Uses render_template with auto-substituted variables]
```

### Test 4: Health Check ✅
```bash
cd ~/.mcp-servers/devops-practices
bash health-check.sh
# Should show: ✅ All 14 checks passed!
```

---

## What This Means for You

### When Working on kafka-project (or any example-project project):

**Before MCP**:
- Claude had to read 580-line CLAUDE.md every session
- Updating standards meant editing 5+ project files
- Standards could drift between projects

**After MCP**:
- Claude queries MCP server for shared practices
- Update one MCP file → all projects get the update
- All projects guaranteed to follow same standards

### Example Interaction:

```
User: "What's the file transfer workflow?"

Claude: [Queries MCP server: get_practice("air-gapped-workflow")]
Claude: "Here's the air-gapped workflow:
- Laptop → S3: aws s3 cp file.yaml s3://bucket/
- S3 → Bastion: aws s3 cp s3://bucket/file.yaml ./
..."
```

Claude **automatically** knows the answer without it being in kafka-project/CLAUDE.md!

---

## Next Steps

### For kafka-project Project:

1. **Simplify CLAUDE.md** to reference MCP server
2. **Keep only Kafka-specific instructions** in CLAUDE.md
3. **Test** that Claude can still do everything needed

See [SETUP.md](SETUP.md) for detailed instructions on updating project CLAUDE.md files.

---

### For New example-project Projects:

When creating a new project:

1. Copy [templates/CLAUDE-template.md](templates/CLAUDE-template.md)
2. Replace `${PROJECT_NAME}`, `${ROLE}`, etc.
3. Add project-specific instructions only
4. Done! MCP server provides the rest

---

## Troubleshooting

### "MCP server not found"
- Check config file path: `cat ~/.config/claude/config.json`
- Verify absolute path to mcp-server.py is correct
- Restart Claude Code

### "Practice not found"
- Check practice exists: `ls practices/`
- Filename is case-sensitive: `air-gapped-workflow.md`

### "Python not found"
- Check Python: `python3 --version`
- Use full path in config: `"/usr/bin/python3"`

---

## Key Files

| File | Purpose |
|------|---------|
| [README.md](README.md) | Architecture, usage, governance, branching strategy |
| [CONTRIBUTING.md](CONTRIBUTING.md) ⭐ | Complete contribution guide with workflows |
| [SETUP.md](SETUP.md) | Detailed setup instructions |
| [QUICK-START.md](QUICK-START.md) | This file - 5-minute guide |
| [CHANGELOG.md](CHANGELOG.md) | Version history and upgrade guides |
| [mcp-server.py](mcp-server.py) | The MCP server (5 tools) |
| [health-check.sh](health-check.sh) | Validation script (14 checks) |
| [.gitlab-ci.yml](.gitlab-ci.yml) | CI/CD pipeline configuration |
| [practices/](practices/) | 10 practice documents |
| [templates/](templates/) | 4 template files |

---

## Questions?

1. **How do I update a practice?**
   - Edit file in `practices/`
   - Commit to git
   - Claude gets updated content on next query

2. **Do I need to restart Claude after updating practices?**
   - No! MCP server reads files on each query

3. **Can I add new practices?**
   - Yes! Create new .md file in `practices/`
   - Restart Claude Code
   - New practice is available

4. **What if MCP server is down?**
   - Projects have fallback practices in CLAUDE.md appendix
   - Most critical practices duplicated for offline work

---

## What's New in v1.2.0

- **GitLab Flow Branching**: Complete branching strategy with `main`, `develop`, feature/*, release/*, hotfix/*
- **CONTRIBUTING.md**: Step-by-step contribution workflows and code review guidelines
- **Enhanced git-practices.md**: Expanded from 17 to 200+ lines with comprehensive branching docs
- **CI/CD Pipeline**: Automated validation on all branches (main, develop, feature/*, etc.)
- **render_template Tool**: Automatic variable substitution in templates
- **3 New Practices**: runbook-documentation, configuration-management, readme-maintenance
- **Recommended Location**: `~/.mcp-servers/devops-practices/` for better organization

See [CHANGELOG.md](CHANGELOG.md) for complete version history.

---

## Success!

If you can ask Claude "List practices" and see 10 practices, **you're done!** 🎉

The MCP server is working and Claude can now query shared DevOps practices across all your projects.

---

## Contributing

Now that you have the MCP server set up, if you want to contribute improvements:

1. Read [CONTRIBUTING.md](CONTRIBUTING.md) for the complete workflow
2. Follow GitLab Flow branching strategy
3. Create feature branches from `develop`
4. CI/CD validates all changes automatically

---

**Questions?** See [SETUP.md](SETUP.md) for detailed troubleshooting.

**Maintained By**: Uttam Jaiswal
**Last Updated**: 2026-02-14
**Version**: 1.2.0