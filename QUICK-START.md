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

### 6 Practice Documents
1. **air-gapped-workflow.md** - How to work across laptop/CloudShell/bastion/EKS
2. **documentation-standards.md** - HOW/WHAT/WHY structure, naming conventions
3. **session-continuity.md** - State tracking, handoff protocols
4. **task-tracking.md** - TRACKER.md guidelines
5. **git-practices.md** - Using `git mv`, backup protocols
6. **efficiency-guidelines.md** - Script vs copy-paste decisions

### 3 Template Files
1. **TRACKER-template.md** - Task tracking template
2. **CURRENT-STATE-template.md** - Session handoff template
3. **CLAUDE-template.md** - Simplified project CLAUDE.md template

### 1 MCP Server
- Python script that serves practices and templates
- Works with Claude Code via stdio protocol
- Zero dependencies (Python stdlib only)

---

## Setup (5 Minutes)

### Step 1: Test the MCP Server (30 seconds)

```bash
cd /home/ukj/work/devops/protean/devops-practices-mcp

# Test server works
echo '{"id":1,"method":"tools/list","params":{}}' | python3 mcp-server.py

# Should see:
# INFO - Loaded 6 practices and 3 templates
# INFO - Practices loaded: air-gapped-workflow, documentation-standards, ...
```

✅ If you see the above, server works!

---

### Step 2: Find Claude Config File (1 minute)

```bash
# Find your Claude config (one of these will exist):
ls ~/.config/claude/config.json       # Linux/WSL
ls ~/.claude/config.json               # Alternative location
ls ~/Library/Application\ Support/Claude/config.json  # macOS

# If none exist, create one:
mkdir -p ~/.config/claude
echo '{}' > ~/.config/claude/config.json
```

---

### Step 3: Add MCP Server to Config (2 minutes)

Edit the config file you found:

```bash
vim ~/.config/claude/config.json
```

Add this JSON (or merge if config already has content):

```json
{
  "mcpServers": {
    "devops-practices": {
      "command": "python3",
      "args": ["/home/ukj/work/devops/protean/devops-practices-mcp/mcp-server.py"],
      "env": {}
    }
  }
}
```

**⚠️ IMPORTANT**: Use the **absolute path** shown above (adjust if your home directory is different).

Save and exit.

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
Claude should list:
- air-gapped-workflow
- documentation-standards
- session-continuity
- task-tracking
- git-practices
- efficiency-guidelines

---

## Verification

### Test 1: List Practices ✅
```
User: "List available practices"
Claude: [Shows 6 practices from MCP server]
```

### Test 2: Get a Practice ✅
```
User: "Show me the air-gapped workflow"
Claude: [Displays full air-gapped-workflow.md content]
```

### Test 3: Get a Template ✅
```
User: "Get the TRACKER template"
Claude: [Displays TRACKER-template.md content]
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
| [README.md](README.md) | Architecture, usage, governance |
| [SETUP.md](SETUP.md) | Detailed setup instructions |
| [QUICK-START.md](QUICK-START.md) | This file - 5-minute guide |
| [mcp-server.py](mcp-server.py) | The MCP server itself |
| [practices/](practices/) | 6 practice documents |
| [templates/](templates/) | 3 template files |

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

## Success!

If you can ask Claude "List practices" and see 6 practices, **you're done!** 🎉

The MCP server is working and Claude can now query shared DevOps practices across all your projects.

---

**Questions?** See [SETUP.md](SETUP.md) for detailed troubleshooting.

**Maintained By**: Uttam Jaiswal
**Last Updated**: 2026-02-13