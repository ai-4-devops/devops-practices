# DevOps Practices - MCP Server

[![CI/CD Pipeline](https://github.com/ai-4-devops/devops-practices/actions/workflows/ci.yml/badge.svg)](https://github.com/ai-4-devops/devops-practices/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-1.4.0-blue.svg)](https://github.com/ai-4-devops/devops-practices/releases)
[![MCP Registry](https://img.shields.io/badge/MCP%20Registry-Published-green.svg)](https://registry.modelcontextprotocol.io/?search=devops-practices)
[![PyPI](https://img.shields.io/pypi/v/devops-practices-mcp.svg)](https://pypi.org/project/devops-practices-mcp/)

mcp-name: io.github.ai-4-devops/devops-practices

**Purpose**: Productivity framework for DevOps engineers using AI assistance (Claude Code) while working on PoCs.

**Type**: Model Context Protocol (MCP) Server for Claude Code

**Version**: 1.4.0

**Status**: 🎉 **Officially Published** in the [MCP Registry](https://registry.modelcontextprotocol.io/?search=devops-practices) (Published: February 18, 2026)

---

> **Who is this for?** DevOps engineers using **Claude Code (VS Code plugin)** for PoC development.
> **What it does:** Provides structure (TRACKER, ISSUES, docs, SoPs) so you can focus on building without worrying about documentation overhead.
> **What it's NOT:** Not a DevOps tutorial - it's a productivity framework for AI-assisted development.

---

## Why This MCP Server?

**Solves the CLAUDE.md Bloat Problem**

Tired of maintaining massive CLAUDE.md files (1000+ lines) across multiple projects? This MCP centralizes reusable DevOps instructions for engineers working on multiple PoCs, eliminating repeated instructions across projects and folders.

**The Problem:**
- ❌ Large CLAUDE.md files eat up context window
- ❌ Same practices duplicated across every project
- ❌ Reinventing TRACKER.md, ISSUES.md, docs, SoPs for every PoC
- ❌ Inconsistent standards across projects
- ❌ Context wasted on instructions instead of actual work

**The Solution:**
- ✅ **Pre-built structure** - Templates for TRACKER, ISSUES, docs, SoPs
- ✅ **Focus on work** - Not on "how should I document this?"
- ✅ **Consistency** - Same standards across all your PoCs
- ✅ **Team alignment** - Same patterns enable seamless collaboration and easy handovers across sessions, systems, and team members
- ✅ **Faster startup** - Copy template, start working
- ✅ **Context saved** - No bloated CLAUDE.md files

**What you get (structure, not knowledge):**
- 📋 **TRACKER.md template** - Start tracking immediately, don't design tracking
- 🐛 **ISSUES.md system** - Start logging issues, don't setup Jira
- 📚 **Documentation standards** - Start writing docs, don't debate structure
- 📖 **Runbook templates** - Start documenting ops, don't create SoP formats
- 🔄 **Session continuity** - Start handoffs, don't design handoff protocols

When searching "devops" in the MCP Registry (as of February 2026), this is the only result. While other MCPs focus on:
- 🔧 **Development tools** (code generation, testing, debugging)
- 📊 **Data analysis** (databases, APIs, analytics)
- 🎨 **Content creation** (writing, design, media)

**This MCP provides:**
- 🏗️ **Configuration structure** - How to organize configs per environment, generate new env configs from completed ones, create and validate SoPs
- 📚 **Documentation patterns** - TRACKER, ISSUES, docs, runbook templates ready to copy
- 🔄 **Operations templates** - Session handoff, runbook formats, documentation standards
- 🎯 **Structured guidance** - GG-SS organized practices for quick discovery

**What makes it different:**
- **Prescriptive, not generative** - Provides proven practices, not generated code
- **Infrastructure-first** - Built for ops teams, not developers
- **Reusable patterns** - Templates and standards across all your projects
- **AI-native design** - Organized for Claude to query and apply contextually
- **R&D optimized** - Accelerates proof-of-concept development and experimentation

**Perfect for:** DevOps engineers using Claude Code (VS Code plugin) to build PoCs and conduct R&D with AI assistance.

---

## How It Works

**No server management required:**
- ✅ **Auto-start**: Spawns when Claude Code/Desktop starts
- ✅ **Background**: Runs silently while you work
- ✅ **On-demand**: Claude queries practices as needed
- ✅ **Auto-stop**: Shuts down when Claude closes

**Configuration Options:**

You can configure the MCP server globally (all projects) or per-project:

**Option 1: Global Configuration** (`~/.claude.json`)
```json
{
  "mcpServers": {
    "devops-practices": {
      "command": "python3",
      "args": ["-u", "~/.mcp-servers/devops-practices/mcp-server.py"],
      "env": {"PYTHONUNBUFFERED": "1"}
    }
  }
}
```

**Option 2: Project-Level Configuration** (`.mcp.json` in project root)
```json
{
  "mcpServers": {
    "devops-practices": {
      "command": "python3",
      "args": ["-u", "~/.mcp-servers/devops-practices/mcp-server.py"],
      "env": {"PYTHONUNBUFFERED": "1"}
    }
  }
}
```

**Setup Steps:**
1. Install the MCP server (see Installation section below)
2. Add configuration to `~/.claude.json` (global) or `.mcp.json` (per-project)
3. Restart Claude Code/Desktop
4. MCP server runs automatically - no manual startup needed

**Note**: The `-u` flag and `PYTHONUNBUFFERED` ensure real-time logging for debugging.

---

## What This Provides

This MCP server provides shared DevOps practices that are common across infrastructure projects:

### Available Practices (11)

Organized using **GG-SS** prefix pattern (Group-Sequence) for better discoverability:

**Naming Pattern:** `GG-SS-practice-name`
- **GG** = Group ID (01-04) - Functional category
- **SS** = Sequence ID (01-03) - Order within group
- Example: `03-02-air-gapped-workflow` = Group 03, Sequence 02

**Group Legend:**
- **01** = Workflow & Processes (how to work effectively)
- **02** = Version Control & Project Management (git, issues)
- **03** = Infrastructure & Configuration (K8s, deployments, config)
- **04** = Documentation Standards (docs, READMEs, runbooks)

---

#### Group 01: Workflow & Processes
1. **01-01-session-continuity** - State tracking, handoff protocols, CURRENT-STATE.md
2. **01-02-task-tracking** - TRACKER.md, CURRENT-STATE.md, PENDING-CHANGES.md
3. **01-03-efficiency-guidelines** - When to script vs copy-paste, batching commands

#### Group 02: Version Control & Project Management
4. **02-01-git-practices** - Using `git mv`, commit conventions, backup protocols, GitLab Flow
5. **02-02-issue-tracking** 🆕 - In-repository Jira-like issue tracking system (Advanced)

#### Group 03: Infrastructure & Configuration
6. **03-01-configuration-management** ⭐ - Config organization, placeholders, environment isolation
7. **03-02-air-gapped-workflow** - Working across laptop, CloudShell, bastion, and EKS
8. **03-03-standard-workflow** - Common operational patterns and workflows

#### Group 04: Documentation Standards
9. **04-01-documentation-standards** - HOW/WHAT/WHY structure, naming conventions
10. **04-02-readme-maintenance** ⭐ - Directory documentation standards and best practices
11. **04-03-runbook-documentation** ⭐ - Mandatory session log standards and requirements

### Available Templates (7)
1. **TRACKER.md** - Task tracking template (milestones)
2. **CURRENT-STATE.md** - Session handoff template
3. **CLAUDE.md** - Simplified project instructions template
4. **RUNBOOK.md** ⭐ - Session log template with all required sections
5. **ISSUE.md** 🆕 - Individual issue template (Advanced)
6. **ISSUES.md** 🆕 - Issue index template with stats dashboard (Advanced)
7. **issues/README.md** 🆕 - How to use the issue system (Advanced)

---

## Architecture

```
devops-practices-mcp/
├── README.md                    # This file
├── mcp-server.py                # MCP server implementation
├── requirements.txt             # Python dependencies
├── .github/workflows/ci.yml     # GitHub Actions pipeline
├── health-check.sh              # Health validation script
├── practices/                   # Shared practice documents (11 files, GG-SS organized)
│   ├── 01-01-session-continuity.md
│   ├── 01-02-task-tracking.md
│   ├── 01-03-efficiency-guidelines.md
│   ├── 02-01-git-practices.md
│   ├── 02-02-issue-tracking.md  # 🆕 Advanced: In-repo issue tracking
│   ├── 03-01-configuration-management.md
│   ├── 03-02-air-gapped-workflow.md
│   ├── 03-03-standard-workflow.md
│   ├── 04-01-documentation-standards.md
│   ├── 04-02-readme-maintenance.md
│   └── 04-03-runbook-documentation.md
├── templates/                   # File templates (7 files)
│   ├── TRACKER-template.md
│   ├── CURRENT-STATE-template.md
│   ├── CLAUDE-template.md
│   ├── RUNBOOK-template.md
│   ├── ISSUE-TEMPLATE.md        # 🆕 Individual issue template
│   ├── ISSUES.md                # 🆕 Issue index with dashboard
│   └── issues-README.md         # 🆕 Issue system guide
├── tools/                       # Automation tools 🆕
│   └── issue-manager.sh         # CLI for managing issues
└── config/                      # MCP configuration
    └── mcp-config.json          # Server configuration
```

---

## MCP Tools

The MCP server provides 5 tools for Claude to query practices and templates:

| Tool | Description | Example |
|------|-------------|---------|
| `list_practices` | List all available practices | Returns list of 10 practices |
| `get_practice` | Get practice content by name | `get_practice("01-02-task-tracking")` |
| `list_templates` | List all available templates | Returns list of 4 templates |
| `get_template` | Get template content by name | `get_template("TRACKER-template")` |
| `render_template` | Render template with variable substitution | `render_template("TRACKER-template", {"PROJECT_NAME": "my-project"})` |

### Template Variable Substitution

Templates support `${VARIABLE}` placeholders that are automatically substituted:

**Auto-provided variables:**
- `${DATE}` - Current date (YYYY-MM-DD format)
- `${TIMESTAMP}` - UTC timestamp (YYYYMMDDTHHMMz format)
- `${USER}` - Current system user
- `${YEAR}` - Current year

**Custom variables:**
Pass any additional variables when rendering:
```python
render_template("RUNBOOK-template", {
    "SESSION_NUMBER": "1",
    "TITLE": "Kafka Deployment",
    "CLUSTER_NAME": "example-eks-uat",
    "OBJECTIVE_DESCRIPTION": "Deploy Kafka cluster to UAT"
})
```

All `${...}` placeholders in the template are replaced with provided values.

---

## CI/CD Pipeline

This repository includes a **GitHub Actions pipeline** (`.github/workflows/ci.yml`) that automatically validates changes:

### Pipeline Jobs

**On every merge request and commit to main/develop:**

1. **health-check** - Runs the comprehensive health check script
2. **python-validation** - Validates Python syntax and dependencies
3. **practice-validation** - Ensures all practice files exist
4. **template-validation** - Ensures templates contain variable placeholders
5. **link-checker** - Checks documentation cross-references

### Benefits

- ✅ Prevents breaking changes from reaching main branch
- ✅ Catches missing files or syntax errors automatically
- ✅ Ensures consistent quality standards
- ✅ No manual validation needed

### Pipeline Status

Check pipeline status in GitHub:
- **Green checkmark** ✅ - All checks passed, safe to merge
- **Red X** ❌ - Checks failed, review errors before merging

---

## Documentation

### Quick Reference
- **[PRACTICE-INDEX.md](PRACTICE-INDEX.md)** - Quick lookup guide for which practice to use when
  - Organized by task type (deploying, documenting, troubleshooting, etc.)
  - Common scenarios with recommended practices
  - Practice dependencies and relationships

### Migration Guide
- **[MIGRATION-GUIDE.md](MIGRATION-GUIDE.md)** - Roll out MCP to existing projects
  - Step-by-step migration from monolithic CLAUDE.md
  - Configuration setup for Claude Desktop/Code
  - Testing and validation procedures
  - Rollback plan if needed

### Version History
- **[CHANGELOG.md](CHANGELOG.md)** - Complete version history and upgrade guides
  - Version 1.0.0 (2026-02-13): 10 practices, 4 templates, health check tool
  - Version 0.1.0 (2026-02-13): Initial release

### Health Check
- **[health-check.sh](health-check.sh)** - Validate MCP server before deployment
  - 14 comprehensive checks (directory structure, files, Python environment, loading tests)
  - Colored output with pass/fail counts
  - Exit codes: 0 (healthy), 1 (unhealthy)

**Usage:**
```bash
cd devops-practices-mcp
bash health-check.sh
```

---

## How Projects Use This

### Project CLAUDE.md Structure
Each project has a simplified CLAUDE.md:

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

### 🔧 Manual Installation (Most Stable - Recommended for Development)

**Best for:** Developers, contributors, or anyone who wants full control

#### 1. Clone Repository
```bash
# Clone to recommended location
git clone https://github.com/ai-4-devops/devops-practices.git ~/.mcp-servers/devops-practices
cd ~/.mcp-servers/devops-practices
```

#### 2. Install Dependencies
```bash
# Using uv (10-100x faster)
curl -LsSf https://astral.sh/uv/install.sh | sh
uv pip install -r requirements.txt

# Or using traditional pip
pip install -r requirements.txt
```

#### 3. Configure MCP Server
Edit `~/.claude/config.json`:
```json
{
  "mcpServers": {
    "devops-practices": {
      "command": "python3",
      "args": ["-u", "~/.mcp-servers/devops-practices/mcp-server.py"],
      "env": {"PYTHONUNBUFFERED": "1"}
    }
  }
}
```

#### 4. Restart Claude Code/Desktop

#### 5. Verify MCP Connection
Ask Claude: "Can you list the available DevOps practices from the MCP server?"

**💡 Tip:** Claude may need a reminder to check the MCP. If it doesn't respond with practice names, try:
- "Please verify you can access the devops-practices MCP server"
- "List all available MCP tools"
- Restart Claude Code again

---

### 🧪 Experimental / Testing (For Nerds)

**⚠️ Note:** These methods are experimental and not yet fully tested. Use Manual Installation (above) for reliable setup.

**Option 1: MCP Registry via Claude Desktop UI** (Experimental):
1. Open Claude Desktop
2. Go to Settings → Developer → MCP Servers
3. Search for "devops-practices"
4. Click "Install"
5. Restart Claude Code/Desktop

**Option 2: Install via uvx** (✨ Recommended - automatic venv):
```bash
# Add MCP server using uvx (handles venv automatically)
claude mcp add devops-practices -- uvx devops-practices-mcp

# Restart Claude Code/Desktop to activate
```
**Why recommended:** `uvx` automatically manages the virtual environment for you - no setup needed.

**Option 3: Install with uv + venv** (For Python developers):
```bash
# Install uv if you don't have it
curl -LsSf https://astral.sh/uv/install.sh | sh

# Create virtual environment
uv venv ~/.venvs/devops-practices-mcp

# Activate venv
source ~/.venvs/devops-practices-mcp/bin/activate

# Install MCP server
uv pip install devops-practices-mcp

# Add to Claude configuration (using venv's python)
claude mcp add devops-practices -- ~/.venvs/devops-practices-mcp/bin/python -m devops_practices_mcp

# Restart Claude Code/Desktop to activate
```
**Why use this:** Full control over the virtual environment with modern `uv` tooling.

**Option 4: Install to user directory** (Legacy - no venv):
```bash
# Install using pip (to ~/.local/)
pip install --user devops-practices-mcp

# Add to Claude configuration
claude mcp add devops-practices -- python3 -m devops_practices_mcp

# Restart Claude Code/Desktop to activate
```

**Option 5: Install system-wide** (Requires sudo):
```bash
# Install system-wide (requires root)
sudo pip install devops-practices-mcp

# Add to Claude configuration
claude mcp add devops-practices -- python3 -m devops_practices_mcp

# Restart Claude Code/Desktop to activate
```

**Option 6: Manual configuration** (Edit config files directly):

Install via pip or uvx, then edit `~/.claude/config.json`:
```json
{
  "mcpServers": {
    "devops-practices": {
      "command": "uvx",
      "args": ["devops-practices-mcp"],
      "env": {}
    }
  }
}
```

---

## Real-World Use Cases

### 1. **Multi-Environment Kafka Deployment**
**Scenario**: Deploying Kafka across dev → test → uat → prod

**Without MCP**:
- Duplicate 580-line CLAUDE.md in each project
- Repeat same issues on each environment (12 hours total)
- No standardized approach across teams

**With MCP**:
- Claude queries `get_practice("configuration-management")` for installation SOPs
- Copies dev runbook for test environment (56% time savings)
- All teams follow same standards automatically

**Result**: 5.25 hours vs 12 hours (56% faster)

### 2. **Standardized Git Workflow**
**Scenario**: Team needs consistent branching strategy

**Without MCP**:
- Each project has different branching approach
- New team members confused about workflow
- Git practices documented differently everywhere

**With MCP**:
- Claude queries `get_practice("02-01-git-practices")`
- Everyone gets same 200+ line GitLab Flow documentation
- Single source of truth for git standards

**Result**: Consistent workflow across all 15 projects

### 3. **Air-Gapped Infrastructure Deployment**
**Scenario**: Deploying to secure environment without internet

**Without MCP**:
- Re-explain workflow every session
- Copy-paste commands from old runbooks
- Inconsistent file transfer procedures

**With MCP**:
- Claude queries `get_practice("air-gapped-workflow")`
- Gets step-by-step: Laptop → S3 → Bastion → Target
- Consistent process every time

**Result**: Zero security incidents, predictable deployments

### 4. **Project Documentation Setup**
**Scenario**: Starting new infrastructure project

**Without MCP**:
- Create CLAUDE.md from scratch (2 hours)
- Copy-paste from old projects (inconsistent)
- Miss important practices

**With MCP**:
```
User: "Create project structure for monitoring-stack project"
Claude: [Queries MCP for templates]
Claude: Creates TRACKER.md, CURRENT-STATE.md, RUNBOOK.md
        All following latest standards
```

**Result**: 15 minutes vs 2 hours (88% faster)

### 5. **Issue Tracking for Complex Projects**
**Scenario**: Managing 50+ work items across 3-month project

**Without MCP**:
- Use external Jira (access issues, overhead)
- Or track in scattered markdown files
- No consistent format

**With MCP**:
- Claude queries `get_template("ISSUES")`
- Creates in-repo issue tracking with dashboard
- Uses `tools/issue-manager.sh` for CLI management

**Result**: Git-based tracking, no external dependencies

---

## Usage Examples

### For Claude
When working on your projects:

**Query Practice:**
```
User: "What's the air-gapped workflow for file transfers?"
Claude: [Queries MCP: get_practice("air-gapped-workflow")]
Claude: [Receives markdown content]
Claude: "Here's the air-gapped workflow..."
```

**Get Template (Raw):**
```
User: "Show me the TRACKER template"
Claude: [Queries MCP: get_template("TRACKER-template")]
Claude: [Receives template with ${VARIABLES}]
Claude: "Here's the template..."
```

**Render Template (With Variables):**
```
User: "Create a TRACKER.md for my kafka-deployment project"
Claude: [Queries MCP: render_template("TRACKER-template", {
    "PROJECT_NAME": "kafka-deployment",
    "DATE": "2026-02-14",
    "PHASE_NAME": "UAT Deployment"
})]
Claude: [Receives rendered template with all variables substituted]
Claude: [Creates TRACKER.md with actual values]
```

### Updating Practices
**For Contributors:**
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

## Branching Strategy

This repository uses **GitLab Flow** with semantic versioning to ensure stability for dependent projects.

### Branch Structure

```
main            ← Production releases only (v1.0.0, v1.1.0, etc.)
  ↑
develop         ← Active development, integration branch
  ↑
feature/*       ← New practices, templates
release/*       ← Version preparation (v1.2.0)
hotfix/*        ← Critical production fixes
```

### Branch Types

| Branch | Purpose | Created From | Merges To |
|--------|---------|--------------|-----------|
| `main` | Production releases (tagged) | - | - |
| `develop` | Active development | `main` | `main` (via release) |
| `feature/*` | New functionality | `develop` | `develop` |
| `release/*` | Version preparation | `develop` | `main` + `develop` |
| `hotfix/*` | Critical fixes | `main` | `main` + `develop` |

### Why GitLab Flow?

- ✅ **Stability**: `main` always contains tested, production-ready code
- ✅ **Safety**: Changes go through `develop` before reaching production
- ✅ **Testing**: CI/CD validates all changes before merge
- ✅ **Versioning**: Clear semantic version releases (v1.0.0, v1.1.0, etc.)
- ✅ **Traceability**: Full history of what changed and when

### Quick Workflows

**Add New Practice/Template**:
```bash
git checkout develop
git checkout -b feature/add-security-practice
# Make changes, commit
git push origin feature/add-security-practice
# Create PR → develop
```

**Create Release**:
```bash
git checkout develop
git checkout -b release/v1.2.0
# Update CHANGELOG.md, version numbers
# Create PR → main
# Tag release: git tag v1.2.0
# Merge back to develop
```

**Critical Hotfix**:
```bash
git checkout main
git checkout -b hotfix/critical-bug
# Fix, commit, push
# Create PR → main (fast-track)
# Also merge to develop
```

**Full Documentation**: See [CONTRIBUTING.md](CONTRIBUTING.md) and [git-practices.md](practices/git-practices.md)

---

## Governance

### Who Maintains This
- **Owner**: Uttam Jaiswal Lead
- **Contributors**: DevOps Engineers
- **Review Process**: PR required for changes

### Update Protocol

**For New Practices/Templates**:
1. Create feature branch from `develop`
2. Update practice or template files
3. Run health check: `bash health-check.sh`
4. Update documentation (README.md, PRACTICE-INDEX.md)
5. Create PR with description → `develop`
6. Code review by team
7. Merge to `develop` after CI/CD passes

**For Releases**:
1. Create release branch from `develop`: `release/v1.x.0`
2. Update CHANGELOG.md and version numbers
3. Create PR → `main`
4. Tag release after merge: `git tag v1.x.0`
5. Merge release back to `develop`
6. Announce to team (affects all dependent projects)

**For Critical Fixes**:
1. Create hotfix branch from `main`: `hotfix/issue-name`
2. Fix issue and test thoroughly
3. Create PR → `main` (fast-track approval)
4. Tag hotfix release: `git tag v1.x.1`
5. Merge to `develop` to keep in sync
6. Announce urgent fix to team

**See**: [CONTRIBUTING.md](CONTRIBUTING.md) for detailed workflows

### Versioning
- **Major version** (2.0): Breaking changes to structure
- **Minor version** (1.1): New practices added
- **Patch version** (1.0.1): Clarifications, fixes

---

## Projects Using This MCP Server

| Project | Purpose | Location |
|---------|---------|----------|
| kafka-deployment | Apache Kafka deployment | Example project
| observability-stack | Observability stack | Example project
| network-infra | Network infrastructure | Example project

---

## Development

**See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed contribution workflow, branching strategy, and code review process.**

### Adding a New Practice
1. Create markdown file in `practices/`
2. Use clear structure with examples
3. Update `mcp-server.py` if needed
4. Test with Claude
5. Update this README (practice count)
6. Update [PRACTICE-INDEX.md](PRACTICE-INDEX.md) (add to scenario lists)
7. Update [CHANGELOG.md](CHANGELOG.md) (document the addition)
8. Run health check: `bash health-check.sh`

### Adding a New Template
1. Create template file in `templates/`
2. Use placeholders: `${PROJECT_NAME}`, `${DATE}`, etc. (see auto-provided variables in MCP Tools section)
3. No code changes needed - `render_template` handles all `${...}` substitutions automatically
4. Test template: `render_template("your-template", {"VAR": "value"})`
5. Update this README (template count)
6. Update [CHANGELOG.md](CHANGELOG.md) (document the addition)
7. Run health check: `bash health-check.sh`

### Making Changes
- **Before release:** Run health check to validate all files
- **After changes:** Update CHANGELOG.md with version bump
- **Breaking changes:** Update MIGRATION-GUIDE.md with migration notes
- **New features:** Update PRACTICE-INDEX.md with usage scenarios

---

## Troubleshooting

### Claude Can't Access MCP Server

**Symptoms:** Claude doesn't return practices when asked, or acts like MCP doesn't exist

**Solutions:**
1. **Remind Claude explicitly:** "Please check the devops-practices MCP server and list available practices"
2. **Verify MCP is loaded:** Ask "What MCP servers do you have access to?"
3. **Check configuration:** Verify `~/.claude/config.json` has correct paths (must be absolute paths)
4. **Restart Claude Code:** MCP servers load on startup
5. **Check logs:** Look at `~/.cache/claude/mcp-devops-practices.log` for errors
6. **Verify MCP process:** Run `ps aux | grep mcp-server.py` to confirm it's running

**💡 Pro Tip:** Claude sometimes "forgets" to check MCP servers. Explicitly remind it to verify the MCP before proceeding with tasks.

**Log location:** `~/.cache/claude/mcp-devops-practices.log`

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

MIT License - Free to use and modify

---

**Maintained By**: Uttam Jaiswal
**Last Updated**: 2026-02-20
**Version**: 1.4.0