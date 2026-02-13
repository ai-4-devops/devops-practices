# Portability Guide - Using on Other Systems

**Quick Answer**: Yes! Just copy the MCP server repo and update one config file path.

---

## What You Need on Another System

### 1. The MCP Server Repository

**Option A: Clone from Git** (if you push to remote):
```bash
cd ~/projects
git clone <your-git-url>/devops-practices-mcp
```

**Option B: Copy Manually** (if not in Git yet):
```bash
# From original system
cd /home/ukj/work/devops/protean
tar -czf devops-practices-mcp.tar.gz devops-practices-mcp/

# Transfer to new system (USB, scp, email, etc.)
scp devops-practices-mcp.tar.gz user@newsystem:~/

# On new system
cd ~/
tar -xzf devops-practices-mcp.tar.gz
```

**Option C: Cloud Storage**:
```bash
# Upload to Dropbox, Google Drive, S3, etc.
# Download on new system
```

### 2. Python 3

```bash
# Verify Python 3 is installed
python3 --version

# Should show: Python 3.8 or higher
```

**No additional dependencies needed** - MCP server uses only Python standard library.

---

## Configuration on New System

### Step 1: Find Your Claude Config File

```bash
# Most likely location (project-specific):
ls ~/.claude.json

# Alternative locations:
ls ~/.config/claude/config.json
ls ~/Library/Application\ Support/Claude/config.json  # macOS
```

### Step 2: Update Path

**If you have `~/.claude.json`** (project-specific):
```bash
vim ~/.claude.json

# Find your project, update the path:
"/path/to/your/project": {
  "mcpServers": {
    "devops-practices": {
      "command": "python3",
      "args": ["/NEW/PATH/TO/devops-practices-mcp/mcp-server.py"],
      "env": {}
    }
  }
}
```

**If you have `~/.config/claude/config.json`** (global):
```bash
vim ~/.config/claude/config.json

# Add or update:
{
  "mcpServers": {
    "devops-practices": {
      "command": "python3",
      "args": ["/NEW/PATH/TO/devops-practices-mcp/mcp-server.py"],
      "env": {}
    }
  }
}
```

**Key Point**: Only the **path** changes. Everything else stays the same.

### Step 3: Restart Claude Code

```bash
# Restart however you normally do
# (CLI, VSCode reload, etc.)
```

### Step 4: Test

```
User: "Can you list the available DevOps practices?"
Claude: [Should list 7 practices from MCP server]
```

---

## Example: Three Different Systems

### System 1 (Original - Ubuntu WSL)
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

### System 2 (Work Laptop - macOS)
```json
{
  "mcpServers": {
    "devops-practices": {
      "command": "python3",
      "args": ["/Users/uttam/devops/devops-practices-mcp/mcp-server.py"],
      "env": {}
    }
  }
}
```

### System 3 (Remote Server - Linux)
```json
{
  "mcpServers": {
    "devops-practices": {
      "command": "python3",
      "args": ["/opt/devops-tools/devops-practices-mcp/mcp-server.py"],
      "env": {}
    }
  }
}
```

**Notice**: Only the path changes. Everything else identical.

---

## Project CLAUDE.md Files

Your project CLAUDE.md files **don't need to change** across systems (if using relative reference):

```markdown
## MCP Service Integration
**Shared Practices**: `devops-practices` MCP server

Query practices when needed:
- `get_practice("air-gapped-workflow")`
- `get_practice("documentation-standards")`
```

The path to the MCP server is in `~/.claude.json`, not in CLAUDE.md, so projects are portable.

---

## Keeping MCP Server Updated

### If Using Git

```bash
# On any system
cd devops-practices-mcp
git pull origin main

# Restart Claude Code - changes take effect immediately
```

### If Using Manual Copy

When you update practices:
```bash
# System 1 (where you edit)
cd devops-practices-mcp
vim practices/air-gapped-workflow.md
# Make changes
git commit -m "Update workflow"

# Transfer to other systems
tar -czf devops-practices-mcp.tar.gz devops-practices-mcp/
# Copy to other systems
```

---

## Recommended: Use Git

**Best practice**: Push MCP server to a Git repository

**Benefits**:
1. ✅ Easy sync across systems (`git pull`)
2. ✅ Version history
3. ✅ Team can contribute
4. ✅ Always get latest practices
5. ✅ No manual file copying

**Setup once**:
```bash
cd devops-practices-mcp
git remote add origin <your-git-url>
git push -u origin main
```

**Use everywhere**:
```bash
# On any new system
git clone <your-git-url>/devops-practices-mcp
# Update path in ~/.claude.json
# Done!
```

---

## Checklist for New System

- [ ] Copy/clone devops-practices-mcp repository
- [ ] Verify Python 3 installed (`python3 --version`)
- [ ] Find Claude config file (`~/.claude.json` or similar)
- [ ] Update MCP server path to new location
- [ ] Use absolute path
- [ ] Restart Claude Code
- [ ] Test: Ask Claude to list practices
- [ ] Verify: Claude shows 7 practices from MCP

**Time required**: 5 minutes

---

## Troubleshooting on New System

### "MCP server not found"
- Check path is absolute (not relative)
- Verify file exists: `ls /path/to/mcp-server.py`
- Make it executable: `chmod +x /path/to/mcp-server.py`

### "Python not found"
- Check Python 3: `which python3`
- Use full path in config: `"/usr/bin/python3"`

### "Permission denied"
- Make executable: `chmod +x mcp-server.py`
- Check ownership: `ls -la mcp-server.py`

---

## Summary

**Portable?** ✅ YES - Very easy

**What moves?** Just the `devops-practices-mcp` folder

**What changes?** Only the path in one config file

**Dependencies?** None (Python 3 standard library only)

**Time to setup on new system?** 5 minutes

**Best practice?** Use Git for easy sync

---

**Maintained By**: Uttam Jaiswal
**Last Updated**: 2026-02-13