# Setup Guide - DevOps Practices MCP Server

This guide will help you set up the MCP server so Claude Code can access shared DevOps practices.

---

## Prerequisites

- Python 3.8 or higher
- Claude Code (claude-cli) installed
- Git

---

## Step 1: Verify Installation

### Check Files
```bash
cd /home/ukj/work/devops/protean/devops-practices-mcp

# Verify structure
ls -la
# Should see: practices/, templates/, mcp-server.py, README.md, etc.

# Verify practices loaded
ls practices/
# Should see: air-gapped-workflow.md, documentation-standards.md, etc.

# Verify templates loaded
ls templates/
# Should see: TRACKER-template.md, CURRENT-STATE-template.md, etc.
```

### Test MCP Server Directly
```bash
# Make server executable
chmod +x mcp-server.py

# Test server (manual test)
echo '{"id":1,"method":"tools/list","params":{}}' | python3 mcp-server.py

# Should return JSON with available tools:
# - get_practice
# - list_practices
# - get_template
# - list_templates
```

---

## Step 2: Configure Claude Code

### Find Claude Config File

Claude Code configuration is typically in one of these locations:
```bash
# Check common locations
ls ~/.config/claude/config.json 2>/dev/null || echo "Not found in ~/.config/claude/"
ls ~/.claude/config.json 2>/dev/null || echo "Not found in ~/.claude/"
ls ~/Library/Application\ Support/Claude/config.json 2>/dev/null || echo "Not found in ~/Library/"
```

If config file doesn't exist, create it:
```bash
# For Linux/WSL
mkdir -p ~/.config/claude
touch ~/.config/claude/config.json

# OR for macOS
mkdir -p ~/Library/Application\ Support/Claude
touch ~/Library/Application\ Support/Claude/config.json
```

### Add MCP Server Configuration

Edit the Claude config file and add the MCP server:

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

**IMPORTANT**:
- Use **absolute path** to mcp-server.py
- Use `python3` (not just `python`)
- Ensure path is correct for your system

### Full Example Config

If you have other MCP servers, your config might look like:
```json
{
  "mcpServers": {
    "devops-practices": {
      "command": "python3",
      "args": ["/home/ukj/work/devops/protean/devops-practices-mcp/mcp-server.py"],
      "env": {}
    },
    "another-server": {
      "command": "node",
      "args": ["/path/to/other-server.js"]
    }
  }
}
```

---

## Step 3: Initialize Git Repository

```bash
cd /home/ukj/work/devops/protean/devops-practices-mcp

# Initialize git
git init

# Create .gitignore
cat > .gitignore <<'EOF'
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
*.egg-info/
dist/
build/

# IDEs
.vscode/
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db

# Logs
*.log
EOF

# Add all files
git add .

# Initial commit
git commit -m "Initial commit: DevOps Practices MCP Server

- Add 6 practice documents (air-gapped workflow, documentation standards, etc.)
- Add 3 template files (TRACKER, CURRENT-STATE, CLAUDE)
- Add MCP server implementation (Python)
- Add documentation (README, SETUP)
"
```

---

## Step 4: Restart Claude Code

After configuring the MCP server:

```bash
# If Claude Code is running, restart it
# (Method depends on how you're running Claude Code)

# For CLI
pkill -f claude
# Then restart claude-code

# For VSCode extension
# Reload VSCode window: Cmd/Ctrl + Shift + P -> "Developer: Reload Window"
```

---

## Step 5: Test MCP Server with Claude

Start a Claude Code session and ask:

### Test 1: List Practices
```
User: "Can you list the available DevOps practices from the MCP server?"

Expected: Claude should list:
- air-gapped-workflow
- documentation-standards
- session-continuity
- task-tracking
- git-practices
- efficiency-guidelines
```

### Test 2: Get a Practice
```
User: "Can you show me the air-gapped workflow practice?"

Expected: Claude should retrieve and display the full air-gapped-workflow.md content
```

### Test 3: Get a Template
```
User: "Can you get the TRACKER template?"

Expected: Claude should retrieve and display TRACKER-template.md content
```

---

## Troubleshooting

### MCP Server Not Found

**Symptom**: Claude says "MCP server not available" or similar

**Fix**:
1. Check config file path is correct
2. Verify absolute path to mcp-server.py is correct
3. Ensure mcp-server.py is executable: `chmod +x mcp-server.py`
4. Test server manually: `echo '{"id":1,"method":"tools/list","params":{}}' | python3 mcp-server.py`
5. Restart Claude Code

### Practice Not Found

**Symptom**: Claude can't find a specific practice

**Fix**:
1. Check practice file exists: `ls practices/`
2. Check filename matches exactly (case-sensitive): `air-gapped-workflow.md`
3. Restart MCP server (restart Claude Code)

### Python Not Found

**Symptom**: Error about python3 not found

**Fix**:
1. Verify Python installed: `python3 --version`
2. Check Python path: `which python3`
3. Update config.json with full Python path: `"/usr/bin/python3"`

### Permission Denied

**Symptom**: Permission denied when running mcp-server.py

**Fix**:
```bash
chmod +x /home/ukj/work/devops/protean/devops-practices-mcp/mcp-server.py
```

---

## Verifying It Works

When working on a example project, Claude should:

1. **Have access to practices** without them being in CLAUDE.md
2. **Query practices when needed** instead of you providing them
3. **List practices** when asked
4. **Follow practices** from MCP server

**Example interaction**:
```
User: "What's the air-gapped workflow?"

Claude: [Queries MCP: get_practice("air-gapped-workflow")]
Claude: [Receives full practice content]
Claude: "Here's the air-gapped workflow:

The laptop where Claude runs has NO AWS access...
[Full content from air-gapped-workflow.md]
"
```

---

## Updating Practices

To update a practice:

```bash
cd /home/ukj/work/devops/protean/devops-practices-mcp

# Edit practice file
vim practices/documentation-standards.md

# Commit changes
git add practices/documentation-standards.md
git commit -m "Update documentation standards: add new RUNBOOKS guidelines"

# Push to remote (if configured)
git push origin main
```

**No need to restart Claude** - it will load the updated file on next query.

---

## Next Steps

1. **Test the MCP server** with Claude Code
2. **Simplify kafka-project/CLAUDE.md** to reference MCP server
3. **Use for other projects** (monitoring, networking, etc.)
4. **Update practices** as needed (commit to git)

---

## Quick Reference

```bash
# Test MCP server manually
echo '{"id":1,"method":"tools/list","params":{}}' | python3 mcp-server.py

# Check Claude config
cat ~/.config/claude/config.json

# Edit Claude config
vim ~/.config/claude/config.json

# Verify practices loaded
ls practices/

# Edit a practice
vim practices/air-gapped-workflow.md

# Commit changes
git add . && git commit -m "Update practice" && git push
```

---

**Questions?** Check [README.md](README.md) for architecture details.

---

**Maintained By**: Uttam Jaiswal
**Last Updated**: 2026-02-13