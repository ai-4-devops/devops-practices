# Changelog

All notable changes to the DevOps Practices MCP will be documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0] - 2026-02-13

### Added

**New Practices (3):**
- **runbook-documentation.md** (9.6K) - 🚨 CRITICAL mandatory session log standards
  - File naming conventions with UTC timestamps
  - Required contents: metadata, commands, outputs, issues, verification
  - What to capture / never omit guidelines
  - Quality checklist and common mistakes to avoid
  - Extracted from example-project observability stack project

- **configuration-management.md** (15K) - Configuration organization patterns
  - Directory structure standards (`configs/<env>/k8s/`, `configs/<env>/ec2/`)
  - Environment isolation principles
  - Service grouping patterns
  - Placeholder conventions for environment-specific values (`${ECR_REGISTRY}`, etc.)
  - Deployment workflows and best practices
  - Extracted from example-project observability stack project

- **readme-maintenance.md** (15K) - Directory documentation standards
  - When to create/update READMEs (CRITICAL practice)
  - Required README structure and contents
  - Proactive README creation triggers
  - Quality checklist and examples by directory type
  - Extracted from example-project observability stack project

**New Templates (1):**
- **RUNBOOK-template.md** (3.9K) - Standard session log template
  - All required sections pre-formatted
  - Placeholder variables for easy customization
  - Supports runbook-documentation.md practice
  - Extracted from example-project project runbook patterns

**New Tools (1):**
- **health-check.sh** - Comprehensive MCP server health validation
  - Validates directory structure, files, and Python environment
  - Tests practice and template loading (14 checks total)
  - Colored output with pass/fail counts
  - Exit codes: 0 (healthy), 1 (unhealthy)

**Documentation:**
- Updated README.md with new practices and templates (10 practices, 4 templates)
- All practices now documented with clear examples

### Context

These additions were extracted from the example-project (Banking Supervision and Infrastructure Framework) observability stack project after identifying common patterns that should be shared across all infrastructure projects.

**Impact:**
- Total: 10 practices, 4 templates, 1 health check tool
- Enables consistent runbook documentation across all projects
- Standardizes configuration management patterns
- Promotes self-documenting repository structures

---

## [0.1.0] - 2026-02-13

### Initial Release

**Practices (7):**
1. Air-Gapped Workflow
2. Documentation Standards
3. Session Continuity
4. Task Tracking
5. Git Practices
6. Efficiency Guidelines
7. Standard Workflow

**Templates (3):**
1. TRACKER-template.md
2. CURRENT-STATE-template.md
3. CLAUDE-template.md

**Infrastructure:**
- MCP server implementation (mcp-server.py)
- Python-based with stdio communication
- Tools: list_practices, get_practice, list_templates, get_template

**Purpose:**
Initial release with core DevOps practices extracted from multiple infrastructure projects to promote consistency and reduce duplication.

---

## Version History

| Version | Date | Practices | Templates | Tools | Notes |
|---------|------|-----------|-----------|-------|-------|
| 1.0.0 | 2026-02-13 | 10 | 4 | 1 | Production-ready with runbook, config, README practices |
| 0.1.0 | 2026-02-13 | 7 | 3 | 0 | Initial release |

---

## Upgrade Guide

### From 0.1.0 to 1.0.0

**Breaking Changes:** None

**New Features:**
- 3 new practices available via MCP
- 1 new template available via MCP
- Health check tool for validation

**Migration Steps:**

1. Pull latest changes:
   ```bash
   cd devops-practices-mcp
   git pull origin main
   ```

2. Run health check:
   ```bash
   bash health-check.sh
   ```

3. Update project CLAUDE.md to reference new practices (optional):
   ```markdown
   - Runbook documentation
   - Configuration management
   - README maintenance
   ```

4. No changes required to MCP server configuration

**Projects Affected:** All projects using devops-practices MCP

---

## Contributing

To propose changes to practices or templates:

1. Create feature branch
2. Update practice/template files
3. Run health check: `bash health-check.sh`
4. Test with sample project
5. Update CHANGELOG.md (Unreleased section)
6. Create PR with description
7. After merge, maintainer will tag new version

---

**Maintainer:** Uttam Jaiswal
**Repository:** devops-practices-mcp
**Last Updated:** 2026-02-13
