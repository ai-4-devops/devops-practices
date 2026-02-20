# DevOps Practices - GG-SS Reorganization Proposal

## Executive Summary

Reorganize 11 practices using **GG-SS** (Group-Sequence) naming pattern for better discoverability and logical grouping.

---

## Current State

| Practice | Lines | Focus |
|----------|-------|-------|
| air-gapped-workflow | 287 | Kubernetes air-gapped deployment |
| configuration-management | 1067 | Infrastructure config, multi-env |
| documentation-standards | 378 | Doc guidelines |
| efficiency-guidelines | 455 | Best practices, anti-patterns |
| git-practices | 1011 | Git workflows, branching |
| issue-tracking | 569 | Issue management |
| readme-maintenance | 663 | README standards |
| runbook-documentation | 471 | Runbooks, operational docs |
| session-continuity | 310 | Claude session management |
| standard-workflow | 336 | Non-air-gapped deployment |
| task-tracking | 322 | Task management |

**Total:** 11 practices, ~6,900 lines

---

## Proposed GG-SS Structure

### Group 01: Workflow & Processes (Session Management)
**Focus:** How to work effectively with DevOps projects and Claude

- **01-01-session-continuity** ← `session-continuity.md`
  - Claude session handoff, CURRENT-STATE.md
  - **Why 01:** Foundation for working with Claude

- **01-02-task-tracking** ← `task-tracking.md`
  - Task management, TODO tracking
  - **Why 01:** Core workflow practice

- **01-03-efficiency-guidelines** ← `efficiency-guidelines.md`
  - Best practices, anti-patterns, patterns
  - **Why 01:** Fundamental working principles

---

### Group 02: Version Control & Project Management
**Focus:** Git, issues, tracking

- **02-01-git-practices** ← `git-practices.md`
  - Git workflows, branching, commits
  - **Why 02:** Version control foundation

- **02-02-issue-tracking** ← `issue-tracking.md`
  - ISSUES.md, issue management, TRACKER relationship
  - **Why 02:** Project tracking

---

### Group 03: Infrastructure & Configuration
**Focus:** Kubernetes, deployments, config management

- **03-01-configuration-management** ← `configuration-management.md`
  - Multi-environment consistency, infrastructure config
  - **Why 03:** Infrastructure foundation

- **03-02-air-gapped-workflow** ← `air-gapped-workflow.md`
  - Kubernetes air-gapped deployment, offline environments
  - **Why 03:** Specialized infrastructure

- **03-03-standard-workflow** ← `standard-workflow.md`
  - Non-air-gapped deployment, standard environments
  - **Why 03:** Standard infrastructure

---

### Group 04: Documentation Standards
**Focus:** Documentation practices, standards, runbooks

- **04-01-documentation-standards** ← `documentation-standards.md`
  - General doc guidelines, standards
  - **Why 04:** Doc foundation

- **04-02-readme-maintenance** ← `readme-maintenance.md`
  - README specific guidelines
  - **Why 04:** README is primary doc

- **04-03-runbook-documentation** ← `runbook-documentation.md`
  - Operational runbooks, procedures
  - **Why 04:** Operational documentation

---

## Group Breakdown

```
01 - Workflow & Processes (3 practices)
├── 01-01-session-continuity
├── 01-02-task-tracking
└── 01-03-efficiency-guidelines

02 - Version Control & Project Management (2 practices)
├── 02-01-git-practices
└── 02-02-issue-tracking

03 - Infrastructure & Configuration (3 practices)
├── 03-01-configuration-management
├── 03-02-air-gapped-workflow
└── 03-03-standard-workflow

04 - Documentation Standards (3 practices)
├── 04-01-documentation-standards
├── 04-02-readme-maintenance
└── 04-03-runbook-documentation
```

---

## Comparison with dev-kit Groups

| dev-kit Groups | devops-practices Groups |
|----------------|-------------------------|
| 01 - Core/Governance | 01 - Workflow/Processes |
| 02 - Project Management | 02 - Version Control/PM |
| 03 - Backend/Infra | 03 - Infrastructure/Config |
| 04 - Frontend | 04 - Documentation |
| 05 - Testing | *(not applicable)* |
| 06 - DevOps | *(merged into 02-03)* |
| 07 - Architecture | *(not applicable)* |
| 08 - Documentation | *(moved to 04)* |

**Rationale:** devops-practices is infrastructure-focused, so we have fewer groups but more depth in infra/config.

---

## Duplicate Analysis

### Overlap with dev-kit

| devops-practices | dev-kit | Duplication? |
|------------------|---------|--------------|
| 02-02-issue-tracking | 02-04-issue-tracking | **Partial** - Different focus |
| 01-01-session-continuity | 02-02-claude-workflow | **Partial** - Complementary |
| 02-01-git-practices | 06-02-git-workflow | **Partial** - DevOps specific |
| 04-01-documentation-standards | 08-01/02 | **Partial** - Different scope |

**Conclusion:** No true duplicates. Content is complementary:
- **dev-kit:** Full-stack development (app dev, testing, frontend, backend)
- **devops-practices:** Infrastructure & operations (Kubernetes, config mgmt, runbooks)

### Internal Duplication

**None found.** Each practice has unique focus:
- `air-gapped-workflow` ≠ `standard-workflow` (different environments)
- `configuration-management` ≠ workflows (config vs. process)
- `task-tracking` ≠ `issue-tracking` (TODOs vs. ISSUES.md)

---

## Migration Plan

### Phase 1: Rename Files with git mv (Preserves History)

**Important:** Use `git mv` to preserve git history!

```bash
# Group 01: Workflow & Processes
git mv practices/session-continuity.md practices/01-01-session-continuity.md
git mv practices/task-tracking.md practices/01-02-task-tracking.md
git mv practices/efficiency-guidelines.md practices/01-03-efficiency-guidelines.md

# Group 02: Version Control & Project Management
git mv practices/git-practices.md practices/02-01-git-practices.md
git mv practices/issue-tracking.md practices/02-02-issue-tracking.md

# Group 03: Infrastructure & Configuration
git mv practices/configuration-management.md practices/03-01-configuration-management.md
git mv practices/air-gapped-workflow.md practices/03-02-air-gapped-workflow.md
git mv practices/standard-workflow.md practices/03-03-standard-workflow.md

# Group 04: Documentation Standards
git mv practices/documentation-standards.md practices/04-01-documentation-standards.md
git mv practices/readme-maintenance.md practices/04-02-readme-maintenance.md
git mv practices/runbook-documentation.md practices/04-03-runbook-documentation.md

# Commit the renames
git commit -m "refactor: Reorganize practices with GG-SS prefix pattern

- GG = Group ID (01-04)
- SS = Sequence ID within group (01-03)
- Groups: Workflow, Version Control, Infrastructure, Documentation
- Preserves git history via git mv"
```

**Note:** GG-SS are **prefixes** to the existing names, not replacements. The practices keep their descriptive names with GG-SS ordering.

### Phase 2: Update References

Files to update:
- `mcp-server-sdk.py` - Update practice loading
- `README.md` - Update practice list
- `health-check.sh` - Update validation
- Documentation - Update examples

### Phase 3: Add Routing Table (Like dev-kit)

Create intelligent routing for common tasks:

```python
ROUTING_TABLE = {
    'kubernetes-deployment': ['03-02-air-gapped-workflow', '03-01-configuration-management'],
    'git-workflow': ['02-01-git-practices', '02-02-issue-tracking'],
    'documentation': ['04-01-documentation-standards', '04-02-readme-maintenance', '04-03-runbook-documentation'],
    'session-start': ['01-01-session-continuity', '01-02-task-tracking'],
    'multi-environment': ['03-01-configuration-management', '03-03-standard-workflow'],
}
```

---

## Benefits

### 1. **Discoverability** ⭐
- Grouped by function (workflow → infra → docs)
- Consistent with dev-kit pattern
- Easy to browse: "03-xx = infrastructure"

### 2. **Scalability** 📈
- Room to grow within groups (01-04, 01-05, etc.)
- Clear where new practices fit
- Group 05+ available for future

### 3. **Intelligence** 🧠
- Routing table enables smart recommendations
- "Working on Kubernetes?" → "Load 03-01, 03-02"
- Context-aware practice loading

### 4. **Professionalism** 💼
- Industry-standard hierarchical structure
- Matches dev-kit conventions
- Better for MCP Registry presentation

---

## Risks & Mitigation

| Risk | Mitigation |
|------|------------|
| Breaking changes for users | Symlinks for backward compatibility |
| PyPI package disruption | Time with v1.4.0 (after registry approval) |
| Search confusion | Update descriptions, add aliases |
| Large PR review | Phase implementation, incremental commits |

---

## Timeline

- **Now:** Get approval on structure
- **Week 1:** Rename files, create symlinks
- **Week 2:** Update code, tests, docs
- **Week 3:** Add routing table feature
- **Week 4:** Release as v1.4.0

---

## Decision

**Approve reorganization?**
- [ ] Yes, proceed with GG-SS structure
- [ ] Modify proposal (specify changes)
- [ ] Defer until after MCP Registry approval

---

**Maintained By:** Uttam Jaiswal
**Proposal Date:** 2026-02-20
**Status:** Pending Review
