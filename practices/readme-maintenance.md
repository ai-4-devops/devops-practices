# README Maintenance Practice

**Purpose**: Standards for creating and maintaining self-documenting directory structures.

**Principle**: Every directory with multiple files or subdirectories must have a `README.md` that explains its contents.

---

## Why README Files Matter

**Benefits:**
- **Self-documenting structure** - Anyone can understand the repository
- **Easy navigation** - Quick overview of what's where
- **Clear handover** - New team members onboard faster
- **Audit-friendly** - Compliance and documentation requirements met
- **Reduces confusion** - No more "what's this folder for?"

---

## When to Create READMEs

### Required

✅ **When creating a new directory** with multiple files (3+)
✅ **When directory structure changes** significantly
✅ **When adding new file types** or categories
✅ **When archiving or reorganizing** content
✅ **During handover preparation**

### Optional but Recommended

- Directories with complex naming conventions
- Directories with specific workflows
- Directories with external dependencies

---

## README Structure

### Minimum Required Sections

Every README must include:

```markdown
# [Directory Name]

**Purpose:** [One sentence describing what this directory is for]

## Contents

[List of what's inside with brief descriptions]

## When to Use

[Guidance on when to reference or update contents]

**Last Updated:** YYYY-MM-DD
```

### Complete README Template

```markdown
# [Directory Name]

**Purpose:** [One sentence describing what this directory is for]

---

## Contents

### [Category 1]
- **[File/Directory]** - [Description]
- **[File/Directory]** - [Description]

### [Category 2]
- **[File/Directory]** - [Description]
- **[File/Directory]** - [Description]

---

## Naming Conventions

[How files are named in this directory]

**Format:** `[pattern]`

**Examples:**
- `example-file-1.md`
- `example-file-2.yaml`

---

## When to Use

[Use cases for the contents of this directory]

**Examples:**
- Use X when deploying to production
- Reference Y for troubleshooting
- Update Z after infrastructure changes

---

## Organization

[How the directory is organized]

**Structure:**
\`\`\`
directory/
├── subdirectory-1/
│   └── ...
├── subdirectory-2/
│   └── ...
└── ...
\`\`\`

---

## Related

- [Link to related directory or documentation]
- [Link to external resources]

---

## Maintenance

**Owner:** [Team or person responsible]
**Update Frequency:** [How often to review]
**Last Review:** YYYY-MM-DD

---

**Last Updated:** YYYY-MM-DD
```

---

## Required READMEs by Directory Type

### Documentation Directories

```
docs/
├── README.md              # Overview of docs structure
├── guides/
│   └── README.md          # Summary of all guides
├── RUNBOOKS/
│   └── README.md          # Session log index
├── reports/
│   └── README.md          # Report types
├── archive/
│   └── README.md          # Historical content
└── plans/
    └── README.md          # Architecture plans
```

### Configuration Directories

```
configs/
├── README.md              # Configuration structure overview
├── dev/
│   └── README.md          # Dev-specific configurations
├── production/
│   └── README.md          # Production-specific configurations
└── shared/
    └── README.md          # Shared configurations
```

### Scripts Directories

```
scripts/
├── README.md              # Script categories and usage
├── deployment/
│   └── README.md          # Deployment scripts
└── utilities/
    └── README.md          # Utility scripts
```

### Account Directories

```
accounts/
├── README.md              # Account structure overview
├── monitoring/
│   └── README.md          # Monitoring account details
├── dev/
│   └── README.md          # Dev account details
└── production/
    └── README.md          # Production account details
```

---

## Content Guidelines

### 1. Purpose Statement

**Format:** One clear sentence describing the directory's purpose.

**✅ Good:**
> This directory contains deployment guides and standard operating procedures (SoPs) for infrastructure components.

**❌ Bad:**
> This has some files.

### 2. Contents Overview

**List items with brief descriptions:**

**✅ Good:**
```markdown
## Contents

### Deployment Guides
- **JAEGER-DEPLOYMENT-GUIDE.md** - Complete guide for deploying Jaeger v2 across environments
- **PROMETHEUS-GRAFANA-DEPLOYMENT.md** - kube-prometheus-stack deployment and configuration

### Reference Guides
- **AUTO-INSTRUMENTATION-GUIDE.md** - OpenTelemetry auto-instrumentation for Java, Node.js, Python
```

**❌ Bad:**
```markdown
## Contents

- File 1
- File 2
- File 3
```

### 3. Naming Conventions

**Explain the pattern:**

**✅ Good:**
```markdown
## Naming Conventions

All runbook files use UTC timestamp prefixes:

**Format:** `YYYYMMDDTHHMMz-<description>.md`

**Examples:**
- `20260203T1430Z-SESSION8-PHASE2-COMPLETE-RECORD.md`
- `20260212T0830Z-SESSION11-GRAFANA-DASHBOARD-DEPLOYMENT.md`
```

**❌ Bad:**
```markdown
## Naming

Files are named with dates.
```

### 4. When to Use

**Provide context for when to reference:**

**✅ Good:**
```markdown
## When to Use

- **Before deploying** - Review relevant guide for pre-deployment checklist
- **During troubleshooting** - Check runbooks for similar past issues
- **For architecture decisions** - Refer to reports for rationale
```

**❌ Bad:**
```markdown
## When to Use

Use these files when needed.
```

### 5. Navigation Links

**Link to related resources:**

**✅ Good:**
```markdown
## Related

- [RUNBOOKS/](../RUNBOOKS/) - Session activity logs
- [reports/](../reports/) - Reference reports and decisions
- [Monitoring Setup Guide](MONITORING-SETUP.md)
```

---

## Examples by Directory Type

### Example 1: Guides Directory README

```markdown
# Deployment Guides

**Purpose:** Step-by-step deployment guides and standard operating procedures (SoPs) for infrastructure components.

---

## Contents

### Core Services
- **[JAEGER-DEPLOYMENT-GUIDE.md](JAEGER-DEPLOYMENT-GUIDE.md)** - Jaeger v2 deployment across environments
- **[ELASTICSEARCH-KIBANA-SETUP.md](ELASTICSEARCH-KIBANA-SETUP.md)** - ES/Kibana EC2 setup and configuration
- **[PROMETHEUS-GRAFANA-DEPLOYMENT.md](PROMETHEUS-GRAFANA-DEPLOYMENT.md)** - kube-prometheus-stack deployment

### OpenTelemetry
- **[OTEL-COLLECTOR-GUIDE.md](OTEL-COLLECTOR-GUIDE.md)** - OTel Collector deployment and configuration
- **[AUTO-INSTRUMENTATION-GUIDE.md](AUTO-INSTRUMENTATION-GUIDE.md)** - Application auto-instrumentation

### Monitoring
- **[FLUENT-BIT-DEPLOYMENT.md](FLUENT-BIT-DEPLOYMENT.md)** - Fluent Bit log collection setup

---

## Guide Structure

All guides follow this structure:
1. **Overview** - What the guide covers
2. **Prerequisites** - What's needed before starting
3. **Deployment Steps** - Detailed step-by-step instructions
4. **Verification** - How to confirm successful deployment
5. **Troubleshooting** - Common issues and solutions

---

## When to Use

- **Before deploying** a new component (read the relevant guide)
- **During deployment** (follow step-by-step)
- **For reference** (understand how components were deployed)
- **When training** new team members

---

## Related

- **[RUNBOOKS/](../RUNBOOKS/)** - Session logs showing actual deployments
- **[reports/](../reports/)** - Why we chose specific approaches
- **[configs/](../../configs/)** - Configuration files referenced in guides

---

**Last Updated:** 2026-02-12
```

### Example 2: RUNBOOKS Directory README

```markdown
# Session Activity Logs (RUNBOOKS)

**Purpose:** Detailed per-session logs capturing every command, output, and decision made during infrastructure work.

---

## Contents

### By Session Number

| Session | Date | Focus | Runbook |
|---------|------|-------|---------|
| 11 | 2026-02-12 | Grafana dashboard deployment | [20260212T0830Z-SESSION11-GRAFANA-DASHBOARD-DEPLOYMENT.md](20260212T0830Z-SESSION11-GRAFANA-DASHBOARD-DEPLOYMENT.md) |
| 10 | 2026-02-04 | Jaeger ingress & Test plan | Multiple files |
| 9 | 2026-02-04 | Documentation reorganization | [20260204-...-SESSION9-DOC-REORG.md](...) |
| 8 Phase 2 | 2026-02-03 | Dev infrastructure exporters | [20260203T1530Z-SESSION8-PHASE2-COMPLETE-RECORD.md](20260203T1530Z-SESSION8-PHASE2-COMPLETE-RECORD.md) |

[Full list...]

---

## Naming Convention

All runbooks use UTC timestamp prefixes:

**Format:** `YYYYMMDDTHHMMz-<description>.md`

**Examples:**
- `20260203T1430Z-SESSION8-PHASE2-COMPLETE-RECORD.md`
- `20260212T0830Z-SESSION11-GRAFANA-DASHBOARD-DEPLOYMENT.md`

**Rules:**
- Use UTC time (append `Z`)
- Include session number if applicable
- Be descriptive but concise
- Use hyphens to separate words

---

## What's Inside a Runbook

Each runbook contains:
- Session metadata (date, duration, cluster, user)
- Complete command history with outputs
- Issues encountered and resolutions
- Configuration changes (before/after)
- Verification steps and results
- Summary of what was accomplished

See **[Runbook Documentation Practice](../practices/runbook-documentation.md)** for full standards.

---

## When to Use

- **During deployment** - Document as you work
- **For troubleshooting** - Find similar past issues
- **For reproducibility** - Follow exact steps from successful deployments
- **For auditing** - Complete record of infrastructure changes
- **For handover** - Transfer knowledge to new team members

---

## Organization

Runbooks are organized chronologically by creation timestamp. Use the index above or file timestamps to find relevant sessions.

---

## Related

- **[guides/](../guides/)** - HOW to deploy (procedures)
- **[reports/](../reports/)** - WHY we did it (decisions, lessons learned)
- **[Runbook Documentation Practice](practices/runbook-documentation.md)** - Standards for creating runbooks

---

## Maintenance

**Owner:** DevOps Team
**Update:** After every session (MANDATORY)
**Review:** Weekly for completeness

**🚨 CRITICAL:** Every session must have a runbook. No exceptions.

---

**Last Updated:** 2026-02-12
```

### Example 3: Scripts Directory README

```markdown
# Scripts

**Purpose:** Executable scripts for infrastructure automation, ECR uploads, and operational tasks.

---

## Contents

### ECR Upload Scripts
- **[20260130-2218-upload-otel-operator-env.sh](20260130-2218-upload-otel-operator-env.sh)** - Upload OTel Operator images
- **[20260201-1045-upload-jaeger-images-env.sh](20260201-1045-upload-jaeger-images-env.sh)** - Upload Jaeger images

### Deployment Scripts
- **[deploy-grafana-dashboard.sh](deploy-grafana-dashboard.sh)** - Deploy single Grafana dashboard via API
- **[deploy-all-grafana-dashboards.sh](deploy-all-grafana-dashboards.sh)** - Batch deploy all dashboards

### Utility Scripts
- **[check-otel-operator-version.sh](check-otel-operator-version.sh)** - Verify OTel Operator version

---

## Naming Convention

### ECR Scripts

**Format:** `YYYYMMDD-HHMM-description-env.sh`

Scripts ending with `-env.sh` are for CloudShell/VPS use and:
- Use AWS environment variables (not profiles)
- Use non-interactive Docker login
- Require: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN`

### Other Scripts

**Format:** `descriptive-name.sh`

Use clear, descriptive names with hyphens.

---

## Usage

### ECR Upload Scripts (CloudShell/VPS)

```bash
# Set AWS credentials
export AWS_ACCESS_KEY_ID="..."
export AWS_SECRET_ACCESS_KEY="..."
export AWS_SESSION_TOKEN="..."  # If using temporary creds

# Run script
bash 20260130-2218-upload-otel-operator-env.sh
```

### Deployment Scripts (Bastion)

```bash
# Set required environment variables
export GRAFANA_URL="http://localhost:3001"
export GRAFANA_USER="admin"
export GRAFANA_PASS="admin123"

# Run script
bash deploy-grafana-dashboard.sh docs/grafana-logs-dashboard.json
```

---

## Best Practices

- **Always** test scripts in dev before production
- **Document** required environment variables in script header
- **Include** error handling and validation
- **Provide** usage examples in script header
- **Use** `set -e` for safe failure

---

## Related

- **[docs/guides/](../docs/guides/)** - Deployment guides that reference these scripts
- **[docs/RUNBOOKS/](../docs/RUNBOOKS/)** - Session logs showing script usage

---

**Last Updated:** 2026-02-12
```

---

## Proactive README Creation

**Claude should create or update READMEs when:**

1. **Creating new directories**
   ```bash
   mkdir -p docs/new-category
   # Immediately create README
   vim docs/new-category/README.md
   ```

2. **Reorganizing structure**
   ```bash
   git mv docs/old-location docs/new-location
   # Update README in new location
   vim docs/new-location/README.md
   ```

3. **Adding multiple new files**
   ```bash
   # After adding 3+ files
   vim directory/README.md
   ```

4. **Archiving content**
   ```bash
   git mv docs/file.md docs/archive/
   # Update archive/README.md
   vim docs/archive/README.md
   ```

---

## Quality Checklist

Before committing a new/updated README:

- [ ] Purpose statement is clear and concise
- [ ] Contents list is complete and up-to-date
- [ ] Naming conventions are explained (if applicable)
- [ ] Usage guidance is provided
- [ ] Related links are working
- [ ] Last updated date is current
- [ ] Markdown formatting is correct
- [ ] No typos or unclear language

---

## Common Mistakes to Avoid

❌ **Generic descriptions** - "This folder has files"
❌ **Outdated contents** - README doesn't match actual contents
❌ **Missing READMEs** - Directories with 5+ files but no README
❌ **Broken links** - Links to files/directories that don't exist
❌ **No maintenance date** - Can't tell if README is current

---

## Tools and Helpers

### Automatic README Generation (Future)

Consider creating scripts to auto-generate README skeletons:

```bash
#!/bin/bash
# generate-readme.sh - Create README skeleton

DIR=$1
cat > "$DIR/README.md" <<EOF
# ${DIR##*/}

**Purpose:** [Describe purpose]

## Contents

[List contents]

## When to Use

[Describe usage]

**Last Updated:** $(date +%Y-%m-%d)
EOF
```

### README Validation

Check if directories need READMEs:

```bash
# Find directories with 3+ files but no README
find . -type d -exec sh -c '
  count=$(find "$1" -maxdepth 1 -type f | wc -l)
  if [ $count -ge 3 ] && [ ! -f "$1/README.md" ]; then
    echo "Missing README: $1"
  fi
' sh {} \;
```

---

## Examples

See example project for real-world examples:
- `docs/guides/README.md` - Comprehensive guide index
- `docs/RUNBOOKS/README.md` - Session log index
- `docs/reports/README.md` - Report types and conventions

---

## Related Practices

- **[documentation-standards.md](documentation-standards.md)** - Overall documentation structure
- **[runbook-documentation.md](runbook-documentation.md)** - RUNBOOKS directory README requirements
- **[configuration-management.md](configuration-management.md)** - configs/ directory README requirements

---

**Remember:** A well-maintained README is a gift to your future self and your team!

---

**Maintained By**: Infrastructure Team
**Last Updated**: 2026-02-13
**Version**: 1.0.0
