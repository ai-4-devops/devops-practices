# Changelog

All notable changes to the DevOps Practices MCP will be documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.2.0] - 2026-02-14

### Added

**Branching Strategy (GitLab Flow):**
- **develop branch** - New permanent integration branch for active development
  - Created from `main` with full history
  - All new features merge here first before release
  - CI/CD runs on develop, feature/*, release/*, hotfix/* branches

- **CONTRIBUTING.md** (13K) - Comprehensive contribution guide
  - Step-by-step workflows for features, releases, hotfixes
  - Branching strategy overview with examples
  - Code review guidelines
  - Commit message conventions
  - Branch naming standards
  - Testing and CI/CD documentation
  - Recommended installation location: `~/.mcp-servers/devops-practices/`

**Documentation Enhancements:**
- **Branching Strategy section** in README.md
  - Visual branch structure diagram
  - Branch types table with purposes
  - Quick workflow examples
  - Links to detailed documentation

- **Enhanced git-practices.md** (Section 6 expanded from 17 to 200+ lines)
  - Complete GitLab Flow documentation
  - Trunk-Based, GitHub Flow, GitLab Flow comparison
  - Branch protection rules
  - Merge strategies (merge commit, squash, rebase)
  - Semantic versioning and tagging
  - Branch cleanup automation
  - Keeping develop synchronized with main (critical after hotfixes)
  - Decision guide for choosing strategies
  - Common anti-patterns and mistakes

### Changed

**CI/CD Pipeline:**
- Updated `.gitlab-ci.yml` for multi-branch workflow
  - Now runs on: MRs, main, develop, feature/*, release/*, hotfix/*
  - Added `release` stage with validation jobs
  - Added `release-validation` job for semantic version checking
  - Added `branch-protection-check` job (informational)
  - All jobs now support full branch spectrum

**Installation:**
- Updated README.md installation instructions
  - **Recommended location**: `~/.mcp-servers/devops-practices/`
  - Clearer clone and setup steps
  - Updated MCP server configuration example

**Governance:**
- Updated "Update Protocol" in README.md
  - Separate workflows for features, releases, hotfixes
  - References CONTRIBUTING.md for details

**Versioning:**
- README.md version: `1.1.0` → `1.2.0`
- CONTRIBUTING.md version: `1.2.0`

### Impact

**For Contributors:**
- ✅ Clear contribution workflow with step-by-step examples
- ✅ Safe feature development on `develop` branch
- ✅ Production stability guaranteed on `main` branch
- ✅ CI/CD validates all changes before merge

**For Dependent Projects:**
- ✅ `main` branch is now production-only (no breaking changes without release)
- ✅ Can safely pull from `main` for stable versions
- ✅ Can follow `develop` for upcoming features (optional)
- ✅ Semantic versioning with git tags (`v1.2.0`)

**For Maintainers:**
- ✅ Controlled release process with release branches
- ✅ Hotfix workflow for critical production issues
- ✅ Automated CI/CD validation on all branches
- ✅ Clear governance and update protocols

### Migration Notes

**No breaking changes.** Existing installations continue to work.

**Recommended actions:**
1. Update local clone: `git pull origin main`
2. Switch to `develop` for new work: `git checkout develop`
3. Read [CONTRIBUTING.md](CONTRIBUTING.md) before creating branches
4. Follow new branching conventions for future changes

**Branch strategy:**
- `main` - Pull for production-ready code (tagged releases)
- `develop` - Pull for latest development (pre-release)
- Feature work - Create from `develop`, merge back to `develop`

---

## [1.1.0] - 2026-02-14

### Added

**New MCP Tool:**
- **render_template** - Render templates with automatic variable substitution
  - Supports `${VARIABLE}` placeholder format
  - Auto-provides: `${DATE}`, `${TIMESTAMP}`, `${USER}`, `${YEAR}`
  - Accepts custom variables via dictionary parameter
  - Eliminates need for manual template substitution
  - Example: `render_template("TRACKER-template", {"PROJECT_NAME": "my-project"})`

**CI/CD Pipeline:**
- **GitLab CI/CD** configuration (`.gitlab-ci.yml`)
  - 5 automated validation jobs (health-check, python-validation, practice-validation, template-validation, link-checker)
  - Runs on merge requests and main/develop branches
  - Prevents breaking changes from reaching main branch
  - Uses GitLab.com free runners
  - Colored output with pass/fail status

### Changed

**Practice Metadata:**
- Standardized metadata footers across all 10 practice files
  - All practices now include: `Maintained By`, `Last Updated`, `Version`
  - Consistent format for easier tracking

**Documentation:**
- Added "MCP Tools" section to README documenting all 5 tools
- Added "CI/CD Pipeline" section explaining automated validation
- Updated architecture diagram to include `.gitlab-ci.yml` and `health-check.sh`
- Updated usage examples to demonstrate `render_template`
- Improved template development workflow documentation

### Technical

**Code Improvements:**
- Added `datetime` import to `mcp-server.py` for timestamp generation
- Implemented `render_template()` method with default variable support
- Added `render_template` tool to MCP protocol
- Variable substitution supports both `${VAR}` and `$VAR` formats
- MCP server now provides 5 tools (was 4)

**Impact:**
- Templates are now fully automated - no manual substitution needed
- CI/CD ensures quality and prevents accidental breakage
- Consistent metadata across all practices for better tracking

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

| Version | Date | Practices | Templates | MCP Tools | Scripts | Notes |
|---------|------|-----------|-----------|-----------|---------|-------|
| 1.2.0 | 2026-02-14 | 10 | 4 | 5 | CI/CD | GitLab Flow branching, CONTRIBUTING.md, enhanced docs |
| 1.1.0 | 2026-02-14 | 10 | 4 | 5 | CI/CD | Added render_template, GitLab CI/CD pipeline |
| 1.0.0 | 2026-02-13 | 10 | 4 | 4 | 1 | Production-ready with runbook, config, README practices |
| 0.1.0 | 2026-02-13 | 7 | 3 | 4 | 0 | Initial release |

---

## Upgrade Guide

### From 1.1.0 to 1.2.0

**Breaking Changes:** None

**New Features:**
- GitLab Flow branching strategy (`main`, `develop`, `feature/*`, `release/*`, `hotfix/*`)
- CONTRIBUTING.md with detailed contribution workflows
- Enhanced git-practices.md with comprehensive branching documentation
- Recommended installation location: `~/.mcp-servers/devops-practices/`

**Migration Steps:**

1. Pull latest changes and switch to main:
   ```bash
   cd ~/.mcp-servers/devops-practices  # Or your installation path
   git checkout main
   git pull origin main
   ```

2. New `develop` branch is now available:
   ```bash
   # For viewing upcoming features (optional)
   git checkout develop
   git pull origin develop

   # Switch back to main for stable version
   git checkout main
   ```

3. Read new contribution guide:
   ```bash
   cat CONTRIBUTING.md
   # Or read in your browser
   ```

4. If you contribute to this repo:
   - Create feature branches from `develop` (not `main`)
   - Follow new branching conventions in CONTRIBUTING.md
   - CI/CD now validates all branches before merge

5. No MCP server configuration changes needed

**Recommended:**
- If you haven't already, clone/move repo to: `~/.mcp-servers/devops-practices/`
- Update your MCP config to use this path for consistency

**Projects Affected:** All projects using devops-practices MCP

**Impact:** Production stability improved - `main` branch now contains only released versions

---

### From 1.0.0 to 1.1.0

**Breaking Changes:** None

**New Features:**
- `render_template` MCP tool for automatic variable substitution
- GitLab CI/CD pipeline for automated validation
- Standardized practice metadata

**Migration Steps:**

1. Pull latest changes:
   ```bash
   cd devops-practices-mcp
   git pull origin main
   ```

2. Restart Claude Code to load new `render_template` tool:
   ```bash
   # Restart Claude Code
   ```

3. (Optional) Enable GitLab CI/CD:
   - Pipeline activates automatically on next push
   - Requires GitLab runners (GitLab.com provides free runners)
   - No configuration changes needed

4. Update usage:
   - Old way: `get_template("TRACKER-template")` → Manual substitution
   - New way: `render_template("TRACKER-template", {"PROJECT_NAME": "my-project"})` → Automatic substitution

**Projects Affected:** All projects using devops-practices MCP

---

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

**See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed contribution workflow.**

**Quick summary:**

1. Create feature branch from `develop`: `git checkout -b feature/your-feature`
2. Update practice/template files
3. Run health check: `bash health-check.sh`
4. Test with sample project
5. Update CHANGELOG.md and documentation
6. Create MR: `feature/your-feature` → `develop`
7. After review and CI/CD passes, merge to `develop`
8. Maintainer will create release branch and tag new version

**Branching:**
- Features → `develop` branch
- Releases → `main` branch (via release/*)
- Hotfixes → `main` + `develop` branches

---

**Maintainer:** Uttam Jaiswal
**Repository:** devops-practices-mcp
**Last Updated:** 2026-02-14
