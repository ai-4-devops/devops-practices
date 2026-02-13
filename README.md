# example-project DevOps Practices - MCP Server

**Purpose**: Centralized DevOps practices and standards for all example-project infrastructure projects.

**Type**: Model Context Protocol (MCP) Server for Claude Code

**Version**: 1.0.0

---

## What This Provides

This MCP server provides shared DevOps practices that are common across all example-project projects:

### Available Practices
1. **Air-Gapped Workflow** - Working across laptop, CloudShell, bastion, and EKS
2. **Documentation Standards** - HOW/WHAT/WHY structure, naming conventions
3. **Session Continuity** - State tracking, handoff protocols
4. **Task Tracking** - TRACKER.md, CURRENT-STATE.md, PENDING-CHANGES.md
5. **Git Practices** - Using `git mv`, commit conventions, backup protocols
6. **Efficiency Guidelines** - When to script vs copy-paste, batching commands

### Available Templates
1. **TRACKER.md** - Task tracking template
2. **CURRENT-STATE.md** - Session handoff template
3. **PENDING-CHANGES.md** - Infrastructure changes template
4. **README.md** - Directory README template
5. **Project CLAUDE.md** - Simplified project instructions template

---

## Architecture

```
devops-practices-mcp/
├── README.md                    # This file
├── mcp-server.py                # MCP server implementation
├── requirements.txt             # Python dependencies
├── practices/                   # Shared practice documents
│   ├── air-gapped-workflow.md
│   ├── documentation-standards.md
│   ├── session-continuity.md
│   ├── task-tracking.md
│   ├── git-practices.md
│   └── efficiency-guidelines.md
├── templates/                   # File templates
│   ├── TRACKER-template.md
│   ├── CURRENT-STATE-template.md
│   ├── PENDING-CHANGES-template.md
│   ├── README-template.md
│   └── CLAUDE-template.md
└── config/                      # MCP configuration
    └── mcp-config.json          # Server configuration
```

---

## How Projects Use This

### Project CLAUDE.md Structure
Each example-project project has a simplified CLAUDE.md:

```markdown
# Claude AI Assistant - [Project Name]

## MCP Service Integration
**Shared Practices**: `devops-practices` MCP server

Claude has access to shared DevOps practices via MCP:
- Air-gapped workflow
- Documentation standards
- Session continuity protocols
- Task tracking guidelines
- Git best practices
- Efficiency guidelines

## Project-Specific: [Project Details]
[Only project-specific instructions here]
```

### Benefits
- **DRY**: Shared practices written once, used everywhere
- **Consistency**: All projects follow same standards
- **Maintainability**: Update once, all projects benefit
- **Discoverability**: Claude can query practices when needed

---

## Installation & Setup

### 1. Install Dependencies
```bash
cd devops-practices-mcp
pip install -r requirements.txt
```

### 2. Configure MCP Server
Edit `~/.config/claude/config.json` (or wherever Claude config lives):

```json
{
  "mcpServers": {
    "devops-practices": {
      "command": "python",
      "args": ["/full/path/to/devops-practices-mcp/mcp-server.py"],
      "env": {}
    }
  }
}
```

### 3. Restart Claude Code
```bash
# Restart Claude Code to load the MCP server
```

### 4. Test Connection
Ask Claude: "Can you list the available DevOps practices?"

Claude should be able to query the MCP server and list practices.

---

## Usage Examples

### For Claude
When working on a example-project project:

**Query Practice:**
```
User: "What's the air-gapped workflow for file transfers?"
Claude: [Queries MCP: get_practice("air-gapped-workflow")]
Claude: [Receives markdown content]
Claude: "Here's the air-gapped workflow..."
```

**Get Template:**
```
User: "Create a TRACKER.md for this project"
Claude: [Queries MCP: get_template("TRACKER")]
Claude: [Receives template content]
Claude: [Creates populated TRACKER.md]
```

### For DevOps Team
**Update a Practice:**
```bash
cd devops-practices-mcp
vim practices/documentation-standards.md
# Make changes
git add practices/documentation-standards.md
git commit -m "Update documentation standards: add new RUNBOOKS guidelines"
git push
# All projects using this MCP server now get updated standards
```

---

## Governance

### Who Maintains This
- **Owner**: Infrastructure Team Lead
- **Contributors**: DevOps Engineers
- **Review Process**: PR required for changes

### Update Protocol
1. Create branch for changes
2. Update practice or template files
3. Test with sample project
4. Create PR with description of changes
5. Review by team
6. Merge to main
7. Announce to team (affects all projects)

### Versioning
- **Major version** (2.0): Breaking changes to structure
- **Minor version** (1.1): New practices added
- **Patch version** (1.0.1): Clarifications, fixes

---

## Projects Using This MCP Server

| Project | Purpose | Location |
|---------|---------|----------|
| kafka-project | Apache Kafka deployment | protean/kafka-project |
| example-monitoring | Observability stack | protean/example-monitoring |
| example-networking | Network infrastructure | protean/example-networking |

---

## Development

### Adding a New Practice
1. Create markdown file in `practices/`
2. Use clear structure with examples
3. Update `mcp-server.py` if needed
4. Test with Claude
5. Update this README

### Adding a New Template
1. Create template file in `templates/`
2. Use placeholders: `${PROJECT_NAME}`, `${DATE}`, etc.
3. Update `mcp-server.py` to handle substitutions
4. Test template generation
5. Update this README

---

## Troubleshooting

### Claude Can't Access MCP Server
1. Check MCP server is running: `ps aux | grep mcp-server.py`
2. Check Claude config: `~/.config/claude/config.json`
3. Check file paths are absolute
4. Restart Claude Code

### Practice File Not Found
1. Verify file exists: `ls practices/`
2. Check filename matches exactly (case-sensitive)
3. Check MCP server logs

### Template Substitution Failing
1. Verify placeholder syntax: `${VARIABLE}`
2. Check template file encoding (UTF-8)
3. Review mcp-server.py logs

---

## License

Internal use only - example-project Infrastructure Team

---

**Maintained By**: Infrastructure Team
**Last Updated**: 2026-02-13
**Version**: 1.0.0