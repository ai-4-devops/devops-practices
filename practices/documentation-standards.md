# Documentation Standards

**Purpose**: Standard documentation structure for all infrastructure projects.

**Principle**: Clear separation of HOW, WHAT, and WHY for maximum clarity and maintainability.

---

## Directory Structure

Every example-project project follows this standard structure:

```
/                           # Repo root
├── CLAUDE.md               # Project instructions for Claude
├── CURRENT-STATE.md        # Session handoff state
├── TRACKER.md              # Task tracking with history
├── PENDING-CHANGES.md      # Infrastructure changes tracker
├── README.md               # Project overview
├── docs/
│   ├── README.md           # Navigation hub
│   ├── env-details.md      # Live environment state (endpoints, creds)
│   ├── ecr-manifest.md     # Images staged in ECR
│   ├── guides/             # HOW to deploy (step-by-step procedures)
│   ├── RUNBOOKS/           # WHAT we did (session activity logs)
│   ├── reports/            # WHY we did it (reference & management reports)
│   ├── archive/            # Historical documents
│   ├── plans/              # Architecture plans, designs
│   ├── application/        # Developer guides
│   └── templates/          # Request templates
├── configs/
│   └── <environment>/      # Environment-specific configs
├── scripts/                # Executable scripts
└── k8s-manifests/          # Kubernetes manifests (if applicable)
    └── <environment>/
```

---

## Documentation Types

### 1. Guides (docs/guides/) - "HOW to Deploy"

**Purpose**: Step-by-step deployment procedures and SoPs.

**Content**:
- Deployment guides (end-to-end process)
- Environment comparison matrices
- Topic creation process
- Troubleshooting procedures
- Configuration guides

**Characteristics**:
- Imperative tone ("Deploy X", "Run Y")
- Step-by-step instructions
- Copy/paste command blocks
- Pre-flight checks included
- Rollback procedures included

**Naming**: `<SERVICE>-DEPLOYMENT-GUIDE.md`, `<PROCESS>-PROCESS.md`

**Examples**:
- `KAFKA-DEPLOYMENT-GUIDE.md`
- `TOPIC-CREATION-PROCESS.md`
- `ENVIRONMENT-COMPARISON.md`

---

### 2. RUNBOOKS (docs/RUNBOOKS/) - "WHAT We Did"

**Purpose**: Detailed per-session activity logs capturing every command, output, and decision.

**Content**:
- Session metadata (date, session number, objectives)
- Every command executed (laptop, CloudShell/VPS, bastion)
- Complete output from each command
- Issues encountered with resolutions
- Configuration changes (before/after)
- Verification steps and results
- Timestamps and context

**Characteristics**:
- Raw and complete (nothing omitted)
- Chronological order
- Verbatim command outputs
- Technical depth
- Reproducible

**Naming**: `YYYYMMDDTHHMMSSZ-<session-description>.md`

**Examples**:
- `20260203T143000Z-SESSION8-PHASE2-COMPLETE-RECORD.md`
- `20260121-1510-UAT-DEPLOYMENT-SESSION.md`

**Critical**: Do NOT miss ANY command or output. These are the single source of truth for troubleshooting and reproduction.

---

### 3. Reports (docs/reports/) - "WHY We Did It"

**Purpose**: Context, decisions, lessons learned, and summaries for two audiences.

#### Type A: Detailed Reference Reports (Technical)

**Audience**: DevOps team, for future troubleshooting

**Content**:
- Troubleshooting journeys and lessons learned
- Architectural decisions and rationale
- Root cause analysis and technical deep dives
- Configuration discoveries and gotchas
- Why certain approaches were chosen over alternatives

**Report Types**:

1. **Lessons Learned Reports** (`*-LESSONS-LEARNED-*.md`)
   - Complete troubleshooting timeline (6+ hours debugging)
   - What was attempted and why it failed
   - Root cause analysis with technical depth
   - Configuration syntax discoveries
   - Comparison of approaches (pros/cons)
   - When: After resolving complex technical issues

2. **Architectural Decision Records** (`*-ARCHITECTURAL-DECISIONS.md`)
   - Why specific architectural choices were made
   - Options considered with trade-offs
   - Security, compliance, and cost considerations
   - Decision matrices with scoring
   - When: After making significant architecture decisions

3. **Technical Deep Dive Reports** (various naming)
   - Bug analysis with exact root cause
   - Workarounds and long-term solutions
   - Complex installation/setup documentation
   - When: Discovering bugs, requiring non-standard workarounds

#### Type B: Management Reports (Non-Technical)

**Audience**: Management, stakeholders, executives

**Content**:
- Blockers, status updates, executive summaries
- High-level, non-technical language
- Business value and ROI focus
- Timeline and budget impact

**Report Types**:

1. **Blocker & Effort Summary** (`*-blockers.md`)
   - Timeline of blockers (high-level, non-technical)
   - Time spent and project impact
   - External dependencies or delays
   - When: Complex deployment with significant delays, budget discussions

2. **Project Status Report** (`*-status.md`)
   - High-level progress (completed, in-progress, pending)
   - Key metrics and success indicators
   - Budget status and timeline variance
   - When: Monthly updates, milestone completion

3. **Executive Summary** (`*-summary.md`)
   - Non-technical overview of work
   - Business value and ROI
   - When: Project completion, major milestones

---

### 4. Plans (docs/plans/) - "Architecture & Decisions"

**Purpose**: Architecture plans, design decisions, task breakdowns.

**Content**:
- Architecture Decision Records (ADRs)
- Infrastructure design documents
- Capacity planning
- Security architecture
- Disaster recovery plans

**Naming**: `ADR-<number>-<title>.md`, `<COMPONENT>-ARCHITECTURE.md`

**Examples**:
- `ADR-001_Kafka_Platform_Decision_example-project.md`
- `OBSERVABILITY-ARCHITECTURE.md`

---

### 5. Archive (docs/archive/) - "Historical"

**Purpose**: Historical documents no longer actively used but kept for reference.

**Content**:
- Deprecated documentation
- Old session notes
- Historical file indexes
- Superseded guides

**Move documents here when**:
- New version created
- Process changed significantly
- No longer relevant but may be referenced

---

### 6. Application Docs (docs/application/) - "Developer Guides"

**Purpose**: Configuration guides for application developers.

**Content**:
- Connection strings and endpoints
- Authentication methods
- Code examples (Spring Boot, Python, etc.)
- Environment-specific configurations
- Troubleshooting for developers

**Naming**: `APPLICATION-<SERVICE>-CONFIGURATION-<ENV>.md`

**Examples**:
- `APPLICATION-KAFKA-CONFIGURATION-UAT.md`
- `APPLICATION-KAFKA-CONFIGURATION-DEV.md`

---

## Living Documents

### env-details.md (Real-Time Environment State)

**Purpose**: Live environment-specific details that change over time.

**Content**:
- Endpoints and URLs
- Credentials (where to find them)
- Service states and versions
- Resource counts (brokers, pods, topics)
- Current configuration

**Update Protocol**:
- Update whenever environment details discovered
- Update whenever details change during session
- Update whenever existing information found incorrect
- Keep factual, current, well-organized

**NOT a log** - Replace outdated info with current info.

### ecr-manifest.md (ECR Image Tracking)

**Purpose**: Track all images currently staged in ECR with tags.

**Content**:
- Repository names
- Image tags
- Upload dates
- Purpose/component

**Update Protocol**:
- Update whenever images pushed to ECR
- Update whenever images discovered in ECR
- Organized by environment

**Benefit**: Prevents "ImagePullBackOff" surprises during deployment.

---

## File Naming Conventions

### Timestamped Files

Use UTC timestamp prefix for session logs and reports:

```bash
$(date -u +%Y%m%dT%H%M%SZ)-<descriptive-name>.<ext>
```

**Examples**:
- `docs/RUNBOOKS/20260203T143000Z-SESSION8-PHASE2-COMPLETE-RECORD.md`
- `docs/reports/20260127-LESSONS-LEARNED-Jaeger-v2-Deployment.md`

**Rule**: Same file updated throughout task lifecycle. New timestamp only for new task/subtask.

### Scripts

Scripts use simplified timestamp:

```bash
YYYYMMDD-HHMM-description.sh
```

**Examples**:
- `scripts/20260130-2155-check-otel-operator-version.sh`
- `scripts/20260130-2218-upload-otel-operator-mandatory-only.sh`

### Guides (Non-Timestamped)

Guides use descriptive names without timestamps:

**Examples**:
- `docs/guides/KAFKA-DEPLOYMENT-GUIDE.md`
- `docs/guides/TOPIC-CREATION-PROCESS.md`

---

## README Maintenance

**CRITICAL PRACTICE**: Every directory with multiple files or subdirectories must have a `README.md`.

### Purpose
- Self-documenting structure
- Easy navigation for team members
- Clear handover documentation
- Audit-friendly organization

### Required READMEs

```
docs/
├── README.md              # Overview of docs structure
├── guides/README.md       # Summary of all guides
├── RUNBOOKS/README.md     # Session log index
├── reports/README.md      # Report types
├── archive/README.md      # Historical content
├── plans/README.md        # Architecture docs
├── application/README.md  # Developer guides
└── templates/README.md    # Request templates

scripts/
└── README.md              # Script categories

configs/
└── README.md              # Configuration structure
```

### README Contents Should Include

1. **Purpose** - What this directory is for
2. **Contents Overview** - What's inside (with brief descriptions)
3. **Naming Conventions** - How files are named
4. **When to Use** - Use cases for the contents
5. **Navigation Links** - Links to related directories/files
6. **Maintenance Notes** - How to keep directory organized

### When to Create/Update READMEs

- ✅ When creating a new directory with multiple files
- ✅ When directory structure changes significantly
- ✅ When adding new file types or categories
- ✅ When archiving or reorganizing content
- ✅ During handover preparation

Claude should **proactively** create or update READMEs when working with directory structures.

---

## Configuration Management

### Folder Structure

```
configs/
├── <environment>/                  # e.g., dev, staging, production
│   ├── k8s/                        # Kubernetes resources
│   │   ├── <namespace>/            # e.g., kafka, observability
│   │   │   ├── <service>/          # e.g., kafka, otel-collector
│   │   │   │   ├── values.yaml     # Helm values or config
│   │   │   │   ├── deployment.yaml
│   │   │   │   └── ...
│   ├── ec2/                        # EC2-hosted services
│   │   ├── <service>/              # e.g., elasticsearch
│   │   │   ├── config/             # Service configuration
│   │   │   └── setup/              # Installation scripts
│   └── shared/                     # Cross-cutting configs
```

### Principles

- **Environment isolation**: Each environment fully self-contained
- **Service grouping**: Configs grouped by service, not file type
- **No hardcoded values**: Use placeholders (e.g., `${ECR_REGISTRY}`)
- **Version-controlled**: All configs live in git

---

## Key Distinctions

| Directory | Purpose | Content Type | Audience |
|-----------|---------|--------------|----------|
| **guides/** | HOW to deploy | Step-by-step procedures | DevOps executing |
| **RUNBOOKS/** | WHAT we did | Session activity logs | DevOps troubleshooting |
| **reports/** | WHY we did it | Context & decisions | DevOps + Management |
| **plans/** | Architecture | Design & decisions | Architects + DevOps |
| **archive/** | Historical | Deprecated docs | Reference only |
| **application/** | Developer config | Connection strings | Developers |

---

## Best Practices

### For Claude

1. **Proactively create documentation** when working on tasks
2. **Update living documents** (env-details.md, ecr-manifest.md) when state changes
3. **Create READMEs** for new directories
4. **Use correct directory** for document type (HOW vs WHAT vs WHY)
5. **Include complete outputs** in RUNBOOKS (never truncate)
6. **Timestamp correctly** using UTC format
7. **Cross-reference** related documents with markdown links

### For Uttam Jaiswal

1. **Follow the structure** - Don't create new top-level directories
2. **Update living documents** when you discover changes
3. **Create READMEs** when adding directories
4. **Archive superseded docs** instead of deleting
5. **Link documents** for easy navigation
6. **Keep TRACKER.md current** with task status

---

**Maintained By**: Infrastructure Team
**Last Updated**: 2026-02-13
**Version**: 1.0.0