# Practice Index - Quick Reference

**Purpose:** Quick lookup guide showing which practice to use in different scenarios.

---

## By Task Type

### 🚀 When Deploying Infrastructure

**Must Use:**
- **[Air-Gapped Workflow](practices/air-gapped-workflow.md)** - Understand laptop/bastion/CloudShell separation
- **[Runbook Documentation](practices/runbook-documentation.md)** - Document EVERY command and output (MANDATORY)
- **[Configuration Management](practices/configuration-management.md)** - Organize environment-specific configs

**Should Use:**
- **[Efficiency Guidelines](practices/efficiency-guidelines.md)** - Copy-paste vs script decisions
- **[Task Tracking](practices/task-tracking.md)** - Track deployment progress

**Related Templates:**
- **[RUNBOOK-template.md](templates/RUNBOOK-template.md)** - Session log template

---

### 📝 When Documenting Work

**Must Use:**
- **[Documentation Standards](practices/documentation-standards.md)** - File naming, report types, structure
- **[README Maintenance](practices/readme-maintenance.md)** - Keep directories self-documenting

**Should Use:**
- **[Runbook Documentation](practices/runbook-documentation.md)** - Session logs (WHAT we did)
- **[Session Continuity](practices/session-continuity.md)** - Ensure work is resumable

**Related Templates:**
- **[RUNBOOK-template.md](templates/RUNBOOK-template.md)** - Session log structure
- **[TRACKER-template.md](templates/TRACKER-template.md)** - Task tracking structure

---

### 🔄 When Starting/Ending Sessions

**Must Use:**
- **[Session Continuity](practices/session-continuity.md)** - Handoff protocol, what to commit
- **[Task Tracking](practices/task-tracking.md)** - Update TRACKER.md with current status

**Should Use:**
- **[Runbook Documentation](practices/runbook-documentation.md)** - Complete session log before ending
- **[Documentation Standards](practices/documentation-standards.md)** - Proper file naming for new docs

**Related Templates:**
- **[CURRENT-STATE-template.md](templates/CURRENT-STATE-template.md)** - Session handoff template
- **[TRACKER-template.md](templates/TRACKER-template.md)** - Progress tracking

---

### 📂 When Organizing Files

**Must Use:**
- **[Configuration Management](practices/configuration-management.md)** - Environment-specific configs
- **[README Maintenance](practices/readme-maintenance.md)** - Document directory structure

**Should Use:**
- **[Documentation Standards](practices/documentation-standards.md)** - File naming conventions
- **[Git Practices](practices/git-practices.md)** - Use git mv for reorganization

**Related Templates:**
- None specifically, but see README examples in practices

---

### 🔧 When Troubleshooting

**Must Use:**
- **[Runbook Documentation](practices/runbook-documentation.md)** - Capture all debugging steps
- **[Documentation Standards](practices/documentation-standards.md)** - Create lessons-learned report

**Should Use:**
- **[Efficiency Guidelines](practices/efficiency-guidelines.md)** - Pre-flight checks to avoid issues
- **[Configuration Management](practices/configuration-management.md)** - Check config organization

**Related Templates:**
- **[RUNBOOK-template.md](templates/RUNBOOK-template.md)** - Document troubleshooting session

---

### 🎯 When Setting Up New Projects

**Must Use:**
- **[Standard Workflow](practices/standard-workflow.md)** - Overall approach and structure
- **[Configuration Management](practices/configuration-management.md)** - Set up configs/ directory
- **[README Maintenance](practices/readme-maintenance.md)** - Create READMEs for all directories

**Should Use:**
- **[Task Tracking](practices/task-tracking.md)** - Set up TRACKER.md
- **[Session Continuity](practices/session-continuity.md)** - Set up CURRENT-STATE.md
- **[Git Practices](practices/git-practices.md)** - Initialize repo properly

**Related Templates:**
- **[CLAUDE-template.md](templates/CLAUDE-template.md)** - Project instructions for AI assistant
- **[TRACKER-template.md](templates/TRACKER-template.md)** - Task tracking setup
- **[CURRENT-STATE-template.md](templates/CURRENT-STATE-template.md)** - Session handoff setup

---

### 📊 When Managing Complex Projects (Advanced)

**Use Issue Tracking When:**
- Project has >20 work items beyond high-level milestones
- Need granular tracking of bugs, features, technical debt
- Want complete historical record for reports/reviews
- Team needs searchable, filterable work item management
- Project duration >1 month with many moving parts

**Practice:**
- **[Issue Tracking](practices/issue-tracking.md)** 🆕 - In-repository Jira-like issue system

**Related Templates:**
- **[ISSUE-TEMPLATE.md](templates/ISSUE-TEMPLATE.md)** - Individual issue template
- **[ISSUES.md](templates/ISSUES.md)** - Issue index with dashboard
- **[issues/README.md](templates/issues-README.md)** - How to use the system

**Tool:**
- **[issue-manager.sh](tools/issue-manager.sh)** - CLI for creating, listing, updating issues

**Relationship to TRACKER.md:**
- TRACKER.md: High-level milestones (e.g., "Deploy Test environment")
- ISSUES.md: Granular work items (e.g., "Fix OTLP bug", "Deploy kube-state-metrics")
- Use together: TRACKER for "where we are", ISSUES for "what needs doing"

---

## By Practice

### Core Practices (Use on Every Project)

1. **[Air-Gapped Workflow](practices/air-gapped-workflow.md)**
   - **When:** Any work involving AWS/EKS in air-gapped environments
   - **Why:** Prevents assuming direct access from laptop
   - **Key concept:** Laptop (Claude) → S3 → Bastion → EKS
   - **Related:** Efficiency Guidelines

2. **[Runbook Documentation](practices/runbook-documentation.md)** 🚨 CRITICAL
   - **When:** EVERY session (MANDATORY, zero exceptions)
   - **Why:** Single source of truth for troubleshooting and reproducibility
   - **Key concept:** Capture ALL commands and outputs verbatim
   - **Related:** Documentation Standards, Session Continuity
   - **Template:** RUNBOOK-template.md

3. **[Configuration Management](practices/configuration-management.md)**
   - **When:** Managing environment-specific configs
   - **Why:** Clarity, reproducibility, no ambiguity
   - **Key concept:** `configs/<env>/k8s/` and `configs/<env>/ec2/` structure
   - **Related:** README Maintenance

4. **[Session Continuity](practices/session-continuity.md)**
   - **When:** Starting/ending sessions, switching systems
   - **Why:** Work must be resumable after `git push`
   - **Key concept:** Everything lives in git, no local-only state
   - **Related:** Task Tracking, Documentation Standards
   - **Template:** CURRENT-STATE-template.md

5. **[Task Tracking](practices/task-tracking.md)**
   - **When:** Multi-task projects, tracking progress over time
   - **Why:** Single source of truth for project status
   - **Key concept:** TRACKER.md with ✅ ⏳ ⚠️ status indicators
   - **Related:** Session Continuity
   - **Template:** TRACKER-template.md

---

### Supporting Practices (Use as Needed)

6. **[Documentation Standards](practices/documentation-standards.md)**
   - **When:** Creating any documentation
   - **Why:** Consistent structure and naming across projects
   - **Key concept:** UTC timestamps, report types, file organization
   - **Related:** Runbook Documentation, README Maintenance

7. **[README Maintenance](practices/readme-maintenance.md)**
   - **When:** Creating directories with 3+ files, reorganizing structure
   - **Why:** Self-documenting repositories
   - **Key concept:** Every directory must have README explaining contents
   - **Related:** Configuration Management, Documentation Standards

8. **[Git Practices](practices/git-practices.md)**
   - **When:** Any git operations
   - **Why:** Preserve history, avoid losing work
   - **Key concept:** Use `git mv` for moves, commit only when requested
   - **Related:** Session Continuity

9. **[Efficiency Guidelines](practices/efficiency-guidelines.md)**
   - **When:** Deciding how to provide commands/scripts to user
   - **Why:** Balance simplicity vs reusability, minimize overhead
   - **Key concept:** Copy-paste vs script decision framework
   - **Related:** Air-Gapped Workflow

10. **[Standard Workflow](practices/standard-workflow.md)**
    - **When:** Setting up new projects, onboarding team members
    - **Why:** Consistent approach across all infrastructure projects
    - **Key concept:** Overall structure and best practices
    - **Related:** All practices (this is the overview)

11. **[Issue Tracking](practices/issue-tracking.md)** 🆕 **ADVANCED**
    - **When:** Complex projects with >20 work items, long duration (>1 month)
    - **Why:** Granular tracking beyond TRACKER.md milestones, complete history
    - **Key concept:** In-repository Jira-like system with CLI tool
    - **Related:** Task Tracking (complements, not replaces)
    - **Templates:** ISSUE-TEMPLATE.md, ISSUES.md, issues-README.md
    - **Tool:** issue-manager.sh (CLI for management)
    - **Note:** Optional - only use for complex projects needing detailed tracking

---

## By Criticality

### 🚨 CRITICAL (Mandatory - Must Never Skip)

1. **Runbook Documentation** - EVERY session must have a runbook (zero exceptions)
2. **Air-Gapped Workflow** - Missing this causes commands to fail (laptop has no AWS access)

### ⚠️ HIGH PRIORITY (Should Always Use)

3. **Configuration Management** - Prevents config confusion across environments
4. **Session Continuity** - Required for resuming work on different systems
5. **Task Tracking** - Essential for multi-session projects

### ℹ️ RECOMMENDED (Use as Needed)

6. **Documentation Standards** - Improves consistency but not blocking
7. **README Maintenance** - Helps onboarding but not immediately critical
8. **Git Practices** - Prevents mistakes but recoverable
9. **Efficiency Guidelines** - Optimizes workflow but not blocking
10. **Standard Workflow** - Good for new projects, less critical mid-project

---

## Common Scenarios

### Scenario: New Infrastructure Deployment

**Practices to use:**
1. Air-Gapped Workflow (understand environment constraints)
2. Runbook Documentation (document every step)
3. Configuration Management (organize deployment configs)
4. Task Tracking (track deployment progress)
5. Efficiency Guidelines (pre-flight checks)

**Templates:**
- RUNBOOK-template.md
- TRACKER-template.md (if new project)

---

### Scenario: Troubleshooting Production Issue

**Practices to use:**
1. Runbook Documentation (capture all debugging steps)
2. Air-Gapped Workflow (understand access paths)
3. Documentation Standards (create lessons-learned report if complex)
4. Session Continuity (ensure findings are preserved)

**Templates:**
- RUNBOOK-template.md

---

### Scenario: Handover to Another Team Member

**Practices to use:**
1. Session Continuity (complete handoff state)
2. Task Tracking (update TRACKER.md with current status)
3. Runbook Documentation (complete session logs)
4. README Maintenance (ensure all directories are documented)
5. Documentation Standards (organize all reports/guides)

**Templates:**
- CURRENT-STATE-template.md

---

### Scenario: Starting New Project

**Practices to use:**
1. Standard Workflow (overall structure)
2. Configuration Management (set up configs/ directory)
3. README Maintenance (create README for all directories)
4. Task Tracking (initialize TRACKER.md)
5. Session Continuity (set up CURRENT-STATE.md)
6. Git Practices (initialize repo with proper structure)

**Templates:**
- CLAUDE-template.md
- TRACKER-template.md
- CURRENT-STATE-template.md

---

### Scenario: Documentation Review/Cleanup

**Practices to use:**
1. Documentation Standards (check file naming, organization)
2. README Maintenance (ensure all directories have READMEs)
3. Git Practices (use git mv for reorganization)
4. Session Continuity (preserve links and references)

**Templates:**
- None specifically

---

## Practice Dependencies

```
Standard Workflow (overview)
├── Air-Gapped Workflow (environment-specific)
│   └── Efficiency Guidelines (optimization)
├── Runbook Documentation (mandatory)
│   └── Documentation Standards (structure)
├── Configuration Management (configs)
│   └── README Maintenance (documentation)
├── Session Continuity (handoffs)
│   └── Task Tracking (progress)
└── Git Practices (version control)
```

---

## Quick Decision Tree

**Question: Should I use this practice now?**

```
Are you deploying infrastructure?
├─ YES → Air-Gapped Workflow, Runbook Documentation, Configuration Management
└─ NO
    └─ Are you documenting work?
        ├─ YES → Documentation Standards, README Maintenance
        └─ NO
            └─ Are you starting/ending a session?
                ├─ YES → Session Continuity, Task Tracking
                └─ NO
                    └─ Are you organizing files?
                        ├─ YES → Configuration Management, README Maintenance
                        └─ NO
                            └─ Are you troubleshooting?
                                ├─ YES → Runbook Documentation, Documentation Standards
                                └─ NO → See Standard Workflow for guidance
```

---

## Templates Quick Reference

| Template | Use When | Related Practices |
|----------|----------|-------------------|
| [CLAUDE-template.md](templates/CLAUDE-template.md) | Setting up new project | Standard Workflow, All Practices |
| [TRACKER-template.md](templates/TRACKER-template.md) | Need task tracking | Task Tracking, Session Continuity |
| [CURRENT-STATE-template.md](templates/CURRENT-STATE-template.md) | Ending session, handoff | Session Continuity |
| [RUNBOOK-template.md](templates/RUNBOOK-template.md) | EVERY session (MANDATORY) | Runbook Documentation |

---

## Practice Relationships

### Practices that Work Together

- **Air-Gapped Workflow** + **Efficiency Guidelines** = Optimized commands for air-gapped environments
- **Runbook Documentation** + **Documentation Standards** = Well-structured session logs
- **Configuration Management** + **README Maintenance** = Self-documenting config structure
- **Session Continuity** + **Task Tracking** = Resumable work with clear status

### Practices that Build on Each Other

1. **Standard Workflow** provides the overall structure
2. **Air-Gapped Workflow** adds environment-specific constraints
3. **Runbook Documentation** captures what you did
4. **Documentation Standards** organizes your documentation
5. **Session Continuity** ensures everything is resumable

---

## Tips

### For AI Assistants (Claude)

- **Always check:** Runbook documentation after every session (MANDATORY)
- **Before deploying:** Review Air-Gapped Workflow and Efficiency Guidelines
- **When creating directories:** Immediately create README (README Maintenance)
- **End of session:** Update TRACKER.md and CURRENT-STATE.md
- **File operations:** Use `git mv` not `mv` (Git Practices)

### For Human Users

- **If Claude forgets runbook:** Remind: "Update the runbook with these commands"
- **If commands fail:** Check: "Are we following air-gapped workflow?"
- **If configs confusing:** Reference: Configuration Management practice
- **If resuming work:** Read: CURRENT-STATE.md and TRACKER.md first

---

**Last Updated:** 2026-02-20
**Related:** [README.md](README.md) | [CHANGELOG.md](CHANGELOG.md)
