# DevOps Practices - MCP Server

[![CI/CD Pipeline](https://github.com/ai-4-devops/devops-practices/actions/workflows/ci.yml/badge.svg)](https://github.com/ai-4-devops/devops-practices/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-1.4.0-blue.svg)](https://github.com/ai-4-devops/devops-practices/releases)
[![MCP Registry](https://img.shields.io/badge/MCP%20Registry-Published-green.svg)](https://registry.modelcontextprotocol.io/?search=devops-practices)
[![PyPI](https://img.shields.io/pypi/v/devops-practices-mcp.svg)](https://pypi.org/project/devops-practices-mcp/)

mcp-name: io.github.ai-4-devops/devops-practices

**Purpose**: Centralized DevOps practices and standards for infrastructure projects.

**Type**: Model Context Protocol (MCP) Server for Claude Code

**Version**: 1.4.0

**Status**: 🎉 **Officially Published** in the [MCP Registry](https://registry.modelcontextprotocol.io/?search=devops-practices) (Published: February 18, 2026)

---

## Why This MCP Server?

**Solves the CLAUDE.md Bloat Problem**

Tired of maintaining massive CLAUDE.md files (1000+ lines) across multiple projects? This MCP centralizes reusable DevOps instructions for engineers working on multiple PoCs, eliminating repeated instructions across projects and folders.

**The Problem:**
- ❌ Large CLAUDE.md files eat up context window
- ❌ Same practices duplicated across every project
- ❌ Hard to maintain consistency when practices change
- ❌ Context wasted on instructions instead of project-specific work

**The Solution:**
- ✅ Centralized DevOps knowledge base
- ✅ Reference practices via MCP, not paste them
- ✅ Update once → affects all projects
- ✅ Context saved for R&D and PoC development

When searching "devops" in the MCP Registry (as of February 2026), this is the only result. While other MCPs focus on:
- 🔧 **Development tools** (code generation, testing, debugging)
- 📊 **Data analysis** (databases, APIs, analytics)
- 🎨 **Content creation** (writing, design, media)

**This MCP provides:**
- 🏗️ **Infrastructure knowledge** - Kubernetes, deployments, configuration management
- 📚 **DevOps practices** - Battle-tested workflows, not just code templates
- 🔄 **Operations standards** - Runbooks, documentation, session continuity
- 🎯 **Context-aware guidance** - Structured practices (GG-SS) for easy discovery

**What makes it different:**
- **Prescriptive, not generative** - Provides proven practices, not generated code
- **Infrastructure-first** - Built for ops teams, not developers
- **Reusable patterns** - Templates and standards across all your projects
- **AI-native design** - Organized for Claude to query and apply contextually
- **R&D optimized** - Accelerates proof-of-concept development and experimentation

Perfect for DevOps teams conducting R&D, building PoCs, and managing infrastructure with Claude.

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
├── .gitlab-ci.yml               # GitLab CI/CD pipeline
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

This repository includes a **GitLab CI/CD pipeline** (`.gitlab-ci.yml`) that automatically validates changes:

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

Check pipeline status in GitLab:
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

### 🚀 Quick Install (Recommended)

**From MCP Registry** (Easiest - via Claude Desktop):
1. Open Claude Desktop
2. Go to Settings → Developer → MCP Servers
3. Search for "devops-practices"
4. Click "Install"

**From PyPI** (For command-line):
```bash
# Install via uvx (recommended)
uvx devops-practices-mcp

# Or via pip
pip install devops-practices-mcp
```

Then configure in `~/.claude/config.json`:
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

### 🔧 Manual Installation (For Development)

**Recommended Location**: `~/.mcp-servers/devops-practices/`

This keeps MCP servers organized and makes configuration easier. All examples below use this location.

#### 1. Clone Repository
```bash
# Clone to recommended location
git clone <repo-url> ~/.mcp-servers/devops-practices
cd ~/.mcp-servers/devops-practices
```

### 2. Install Dependencies

**Using uv (recommended - 10-100x faster):**
```bash
# Install uv if not already installed
curl -LsSf https://astral.sh/uv/install.sh | sh

# Install dependencies
uv pip install -r requirements.txt
```

**Or using traditional pip:**
```bash
pip install -r requirements.txt
```

**Why uv?**
- 10-100x faster than pip
- Better dependency resolution
- Built in Rust for performance
- Drop-in replacement for pip

### 3. Configure MCP Server
Edit `~/.config/claude/config.json` (or wherever Claude config lives):

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

**Note**: Replace `<username>` with your actual username, or use the full absolute path.

### 3. Restart Claude Code
```bash
# Restart Claude Code to load the MCP server
```

### 4. Test Connection
Ask Claude: "Can you list the available DevOps practices?"

Claude should be able to query the MCP server and list practices.

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
# Create MR → develop
```

**Create Release**:
```bash
git checkout develop
git checkout -b release/v1.2.0
# Update CHANGELOG.md, version numbers
# Create MR → main
# Tag release: git tag v1.2.0
# Merge back to develop
```

**Critical Hotfix**:
```bash
git checkout main
git checkout -b hotfix/critical-bug
# Fix, commit, push
# Create MR → main (fast-track)
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
5. Create MR with description → `develop`
6. Code review by team
7. Merge to `develop` after CI/CD passes

**For Releases**:
1. Create release branch from `develop`: `release/v1.x.0`
2. Update CHANGELOG.md and version numbers
3. Create MR → `main`
4. Tag release after merge: `git tag v1.x.0`
5. Merge release back to `develop`
6. Announce to team (affects all dependent projects)

**For Critical Fixes**:
1. Create hotfix branch from `main`: `hotfix/issue-name`
2. Fix issue and test thoroughly
3. Create MR → `main` (fast-track approval)
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

MIT License - Free to use and modify

---

**Maintained By**: Uttam Jaiswal
**Last Updated**: 2026-02-17
**Version**: 1.3.0