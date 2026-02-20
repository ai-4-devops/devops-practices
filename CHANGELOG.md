# Changelog

All notable changes to the DevOps Practices MCP will be documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.4.0] - 2026-02-20

### Fixed

**Critical MCP Server Stability Issue:**
- **Fixed stdio protocol corruption** - Changed logging from stderr to FileHandler only
  - Root cause: Default logging wrote to stderr, corrupting JSON-RPC 2.0 messages
  - Symptom: "Failed to connect" in `claude mcp list` despite server passing manual tests
  - Solution: Explicit FileHandler configuration writing to `~/.cache/claude/mcp-devops-practices.log`
  - Impact: Server now matches dev-kit stability pattern
  - Lines changed: mcp-server-sdk.py lines 18-28

**Configuration Fix:**
- Fixed `~/.claude.json` pointing to non-existent `.venv/bin/python3`
- Changed to `uv run` pattern matching dev-kit for consistency
- Now uses: `uv run --directory <path> python mcp-server-sdk.py`

### Added

**New MCP Tools (2):**
- **get_practice_summary** - Lightweight metadata extraction
  - Returns practice heading + description only (not full content)
  - Ideal for quick overview without loading full ~1000 line practices
  - Use case: "What does this practice cover?"

- **search_practices** - Keyword search across all practices
  - Searches practice names and content
  - Returns matching practices with context
  - Use case: "Find practices about git", "Find practices mentioning docker"

**Enhanced MCP Tools:**
- **list_practices** - Now includes metadata extraction
  - Returns: practice name, heading, description, line count
  - Uses regex to extract metadata from markdown
  - Provides context without loading full practice content

### Changed

**Major: GG-SS Reorganization (11 practices renamed)**

All practices reorganized with Group-Sequence prefix pattern for better discoverability:

**Group 01 - Workflow & Processes (3 practices):**
- `session-continuity.md` → **01-01-session-continuity.md**
- `task-tracking.md` → **01-02-task-tracking.md**
- `efficiency-guidelines.md` → **01-03-efficiency-guidelines.md**

**Group 02 - Version Control & Project Management (2 practices):**
- `git-practices.md` → **02-01-git-practices.md**
- `issue-tracking.md` → **02-02-issue-tracking.md**

**Group 03 - Infrastructure & Configuration (3 practices):**
- `configuration-management.md` → **03-01-configuration-management.md**
- `air-gapped-workflow.md` → **03-02-air-gapped-workflow.md**
- `standard-workflow.md` → **03-03-standard-workflow.md**

**Group 04 - Documentation Standards (3 practices):**
- `documentation-standards.md` → **04-01-documentation-standards.md**
- `readme-maintenance.md` → **04-02-readme-maintenance.md**
- `runbook-documentation.md` → **04-03-runbook-documentation.md**

**Implementation Details:**
- Used `git mv` to preserve full git history (100% renames)
- Renamed in both `practices/` and `src/devops_practices_mcp/practices/` directories
- GG-SS are **prefixes** to existing descriptive names (not replacements)
- Supports hierarchical organization and room for growth (01-04, 01-05, etc.)

**Documentation Updates:**
- **README.md** - Added group structure with descriptions, updated all examples
- **health-check.sh** - Updated EXPECTED_PRACTICES array with new GG-SS names
- **QUICK-START.md** - Batch updated all practice references
- **SETUP.md** - Batch updated all practice references
- **REORGANIZATION-PROPOSAL.md** - New comprehensive proposal document with rationale

**Code Improvements:**
- Enhanced mcp-server-sdk.py: 237 → 337 lines
- MCP tools: 5 → 7 tools
- Added `import re` for metadata extraction
- Improved error handling and logging

### Technical Details

**MCP Server:**
- Version: 1.3.1 → 1.4.0
- Total practices: 11 (unchanged count, reorganized naming)
- Total templates: 7 (unchanged)
- Total MCP tools: 7 (was 5)
- Lines of code: +100 lines (enhanced functionality)

**Git History:**
- All renames preserve full history via `git mv`
- Git shows 100% renames (not deletes + adds)
- No content changes to practices (only filenames)

**Duplicate Analysis:**
- ✅ NO duplicates found in practices
- Each practice has unique focus and purpose
- Confirmed no overlap with dev-kit practices (complementary, not duplicate)

### Benefits

**For Discoverability:**
- ✅ Practices grouped by function (workflow → infra → docs)
- ✅ Consistent with dev-kit GG-SS pattern
- ✅ Easy to browse: "03-xx = infrastructure practices"
- ✅ Alphabetical sorting now groups related practices

**For Scalability:**
- ✅ Room to grow within groups (01-04, 01-05, etc.)
- ✅ Clear where new practices fit
- ✅ Groups 05+ available for future expansion

**For Stability:**
- ✅ MCP server connection now stable (matches dev-kit reliability)
- ✅ No more stdio protocol corruption
- ✅ Consistent logging pattern across MCP servers

**For Intelligence:**
- ✅ Metadata extraction enables smart practice selection
- ✅ Search capability for finding relevant practices
- ✅ Future: Routing table for intelligent recommendations

### Migration Notes

**Breaking Changes:** Practice filenames changed (GG-SS prefixes added)

**Required Actions:**

1. **Update MCP Configuration** (if you modified it):
   ```json
   {
     "command": "uv",
     "args": [
       "run",
       "--directory",
       "/home/ukj/.mcp-servers/devops-practices-mcp",
       "python",
       "mcp-server-sdk.py"
     ]
   }
   ```

2. **Update practice references in your code**:
   ```python
   # Old
   get_practice("git-practices")

   # New
   get_practice("02-01-git-practices")
   ```

3. **Pull latest changes**:
   ```bash
   cd ~/.mcp-servers/devops-practices-mcp
   git pull origin main
   ```

4. **Restart Claude Code** to reload MCP server with new practice names

**Backward Compatibility:**
- ❌ Old practice names will not work (must use new GG-SS prefixed names)
- ✅ All templates unchanged (no breaking changes)
- ✅ All MCP tools backward compatible (new tools added, existing tools unchanged)

**Impact:**
- Projects using practice names in CLAUDE.md or scripts need updates
- MCP tools (list_practices, get_practice) work with new names automatically
- Documentation updated - follow examples in README.md

**Projects Affected:** All projects referencing devops-practices by name

---

## [1.3.0] - 2026-02-17

### Added

**Issue Tracking System (Advanced Feature):**
- **New Practice: issue-tracking.md** (569 lines) - Comprehensive in-repository issue tracking
  - Jira-like functionality without external dependencies
  - Granular work item tracking (bugs, features, tasks, deployments, docs, tech debt)
  - Complete issue lifecycle (Open → In Progress → Blocked → Resolved → Closed)
  - Priority levels (Critical, High, Medium, Low)
  - Complements TRACKER.md (milestones vs granular work items)
  - Ideal for projects with >20 work items, duration >1 month

- **New Templates (3):**
  - **ISSUE-TEMPLATE.md** (44 lines) - Individual issue template with metadata, tasks, notes
  - **ISSUES.md** (154 lines) - Issue index with stats dashboard and breakdowns
  - **issues-README.md** (182 lines) - Complete guide for using the issue system

- **New Tool:**
  - **tools/issue-manager.sh** (429 lines) - CLI tool for issue management
    - Create, list, update, close issues
    - Query by status, priority, type
    - Statistics and reporting
    - Colored output for readability

### Changed

**Documentation Updates:**
- Updated README.md:
  - Practice count: 10 → **11**
  - Template count: 4 → **7**
  - Added tools/ directory to architecture
  - Version: 1.2.0 → **1.3.0**

- Updated PRACTICE-INDEX.md:
  - Added new section: "When Managing Complex Projects"
  - Added issue-tracking to Supporting Practices (#11)
  - Cross-referenced relationship to TRACKER.md

- Updated QUICK-START.md:
  - Reflected new practice and template counts
  - Added issue tracking to capabilities

- **Enhanced configuration-management.md** (v1.1.0 → v2.0.0):
  - Changed from basic environment-first to **Hybrid Resource-Type-First** structure
  - Added separation: `configs/` (declarative), `scripts/` (automation), `docs/` (knowledge)
  - Expanded service type support: Added ecs/, rds/, terraform/, helm-values/, lambda/, s3/
  - New sections: "Service Types Reference" table, "Rationale: Why This Structure?", "Summary"
  - Reusable scripts pattern: Scripts take `--env` parameter (no duplication)
  - Better examples: Changed "tracing" → "observability" namespace
  - +118 lines, -21 lines (net +97 lines of guidance)
  - Prevents anti-patterns: No script duplication, centralized documentation

- **Enhanced configuration-management.md** (v2.0.0 → v2.1.0):
  - Enhanced "Environment Isolation" → **"Environment Isolation & Audit Readiness"**
  - Added comprehensive audit-ready requirements:
    - Self-contained environment folders (no symlinks, no cross-references)
    - Account-specific configurations (AWS account IDs per environment)
    - Standalone deployable (can deploy/audit independently)
    - Compliance considerations (SOC2/ISO27001 requirements)
  - Added "Why This Matters" section explaining security audit benefits
  - Enhanced examples with good/bad patterns for audit readiness
  - Added cross-reference to Multi-Environment Consistency section
  - Addresses real-world compliance and security audit requirements

- **Enhanced configuration-management.md** (v2.1.0 → v2.2.0):
  - Added **"Installation SOPs: Learn From Previous Environments"** section
  - Addresses critical operational inefficiency: Repeating same issues across environments
  - Solution: Create SOP during first environment (dev), reuse and improve for subsequent (test/uat/prod)
  - Comprehensive workflow with before/after runbook examples
  - Time savings: 56% reduction (12hrs → 5.25hrs for 4 environments)
  - Benefits table showing impact on time, issues, knowledge, quality
  - Cross-references to runbook-documentation.md and session-continuity.md
  - Real-world problem: Claude starting fresh each environment instead of learning from previous

- **Enhanced .claude/instructions.md**:
  - Added **"Working on Client Projects"** section with multi-environment installation guidelines
  - Operational guidelines: What to do for first vs subsequent environment installations
  - Critical reminders: Never start fresh, always build on previous environment learnings
  - Benefits metrics: Time savings, issues prevented, knowledge accumulated
  - Cross-reference to configuration-management.md Installation SOPs section
  - Purpose: Ensure Claude follows this pattern automatically without being reminded

- **Added .claude/instructions.md** (initial creation):
  - Documentation standards: Avoid repetition, add cross-references
  - Commit message guidelines (conventional commits)
  - Content quality standards (generic examples, no client references)
  - Version management guidance
  - Will prevent need to remind about repetition/cross-references

### Impact

**For Users:**
- ✅ Optional advanced feature - use only when needed
- ✅ Provides Jira-like tracking for complex projects
- ✅ Complete work history for performance reviews/reports
- ✅ Git-based, no external dependencies
- ✅ Automation via CLI tool

**Positioning:**
- **Advanced/Optional** - not required for simple projects
- **Complements TRACKER.md** - doesn't replace it
- **When to use:** Projects with >20 work items, long duration, need detailed tracking
- **When to skip:** Simple projects (<5 tasks), use TRACKER.md only

### Technical Details

- Total addition: ~1,908 lines
- All templates follow existing conventions
- CLI tool uses bash with colored output
- Maintains semantic versioning and git practices
- No breaking changes to existing functionality

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
  - Extracted from example observability stack project

- **configuration-management.md** (15K) - Configuration organization patterns
  - Directory structure standards (`configs/<env>/k8s/`, `configs/<env>/ec2/`)
  - Environment isolation principles
  - Service grouping patterns
  - Placeholder conventions for environment-specific values (`${ECR_REGISTRY}`, etc.)
  - Deployment workflows and best practices
  - Extracted from example observability stack project

- **readme-maintenance.md** (15K) - Directory documentation standards
  - When to create/update READMEs (CRITICAL practice)
  - Required README structure and contents
  - Proactive README creation triggers
  - Quality checklist and examples by directory type
  - Extracted from example observability stack project

**New Templates (1):**
- **RUNBOOK-template.md** (3.9K) - Standard session log template
  - All required sections pre-formatted
  - Placeholder variables for easy customization
  - Supports runbook-documentation.md practice
  - Extracted from example project runbook patterns

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

These additions were extracted from the example observability stack project after identifying common patterns that should be shared across all infrastructure projects.

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
| 1.4.0 | 2026-02-20 | 11 | 7 | 7 | CI/CD + CLI | GG-SS reorganization, stability fix, 2 new tools, enhanced search |
| 1.3.0 | 2026-02-17 | 11 | 7 | 5 | CI/CD + CLI | Issue tracking system (advanced), 3 templates, issue-manager tool |
| 1.2.0 | 2026-02-14 | 10 | 4 | 5 | CI/CD | GitLab Flow branching, CONTRIBUTING.md, enhanced docs |
| 1.1.0 | 2026-02-14 | 10 | 4 | 5 | CI/CD | Added render_template, GitLab CI/CD pipeline |
| 1.0.0 | 2026-02-13 | 10 | 4 | 4 | 1 | Production-ready with runbook, config, README practices |
| 0.1.0 | 2026-02-13 | 7 | 3 | 4 | 0 | Initial release |

---

## Upgrade Guide

### From 1.3.1 to 1.4.0

**Breaking Changes:** Practice filenames changed (GG-SS prefixes added)

**Critical Bug Fix:**
- MCP server stdio protocol corruption fixed (logging now to file only)
- Server connection stability now matches dev-kit

**New Features:**
- 2 new MCP tools (get_practice_summary, search_practices)
- Enhanced list_practices with metadata
- GG-SS hierarchical practice organization (4 groups)

**Migration Steps:**

1. **Pull latest changes:**
   ```bash
   cd ~/.mcp-servers/devops-practices-mcp
   git checkout main
   git pull origin main
   ```

2. **Restart Claude Code** to reload MCP server

3. **Update practice references** in your project files:
   ```bash
   # Example: Update CLAUDE.md references
   sed -i 's/git-practices/02-01-git-practices/g' CLAUDE.md
   sed -i 's/session-continuity/01-01-session-continuity/g' CLAUDE.md
   sed -i 's/configuration-management/03-01-configuration-management/g' CLAUDE.md
   # ... etc for other practices
   ```

4. **New practice naming convention:**
   - Group 01: Workflow & Processes (01-01, 01-02, 01-03)
   - Group 02: Version Control & PM (02-01, 02-02)
   - Group 03: Infrastructure & Config (03-01, 03-02, 03-03)
   - Group 04: Documentation Standards (04-01, 04-02, 04-03)

5. **Use new tools:**
   ```python
   # Quick summary without loading full practice
   get_practice_summary("02-01-git-practices")

   # Search across all practices
   search_practices("kubernetes")
   search_practices("git workflow")

   # List with metadata
   list_practices()  # Now includes heading, description, line count
   ```

**When to upgrade:**
- ✅ Immediately - Critical stability fix
- ✅ Better practice organization and discoverability
- ✅ Enhanced search and metadata capabilities

**Effort:** Low - Mostly practice name updates in documentation

**Projects Affected:** All projects referencing practices by name

**Impact:** High - Server stability significantly improved, better practice discoverability

---

### From 1.2.0 to 1.3.0

**Breaking Changes:** None

**New Features:**
- Issue Tracking system (advanced/optional)
- 3 new templates for issue management
- CLI tool for automation (issue-manager.sh)

**Migration Steps:**

1. Pull latest changes:
   ```bash
   cd ~/.mcp-servers/devops-practices
   git checkout main
   git pull origin main
   ```

2. No configuration changes needed - MCP server automatically serves new practice and templates

3. Issue tracking is **optional** - only use for complex projects:
   - Project has >20 work items
   - Duration >1 month
   - Need detailed tracking beyond TRACKER.md milestones

4. To use issue tracking in a project:
   ```bash
   # Copy templates to your project
   cp ~/.mcp-servers/devops-practices/templates/ISSUES.md ./
   mkdir -p issues
   cp ~/.mcp-servers/devops-practices/templates/issues-README.md ./issues/README.md

   # Optional: Install CLI tool
   cp ~/.mcp-servers/devops-practices/tools/issue-manager.sh ./scripts/
   chmod +x ./scripts/issue-manager.sh
   ```

5. Read the practice:
   ```bash
   cat practices/issue-tracking.md
   # Or ask Claude: "Show me the issue tracking practice"
   ```

**When to use:**
- ✅ Complex projects with many work items
- ✅ Long-duration projects (>1 month)
- ✅ Need complete work history for reports

**When to skip:**
- ❌ Simple projects (<5 tasks)
- ❌ Use TRACKER.md only

**Projects Affected:** None automatically - opt-in only

**Impact:** No impact on existing workflows - this is an additional optional capability

---

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
**Last Updated:** 2026-02-17
