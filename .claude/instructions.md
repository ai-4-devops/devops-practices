# Claude Instructions for DevOps Practices MCP

## Project Context

This is the **DevOps Practices MCP Server** repository - a centralized knowledge base that serves best practices and templates to Claude across all DevOps projects.

## Documentation Standards

### 1. Avoid Repetition

**Rule**: Never repeat the same concept in multiple places within a document or across documents.

**Instead**:
- ✅ Define the concept once in the most appropriate location
- ✅ Use cross-references (`[See section](#anchor)`) to link to it
- ✅ Mention "See [practice-name.md](path) for details" when referencing other practices

**Example**:
```markdown
## Configuration Deployment

For step-by-step deployment workflow, see [air-gapped-workflow.md](practices/air-gapped-workflow.md).

**Quick reference**: Laptop → S3 → Bastion → Target environment
```

### 2. Cross-Reference Related Content

**Rule**: Always add cross-references when mentioning related concepts.

**Pattern**:
```markdown
**See also:**
- [practice-name.md](path) - Description
- [Section Name](#section-anchor) - When to use this approach
```

**Where to add cross-references**:
- ✅ At the end of each major section
- ✅ When mentioning a concept covered in another practice
- ✅ In "Related Practices" section at document end

### 3. Section Anchors

Use markdown anchors for internal cross-references:
```markdown
## Multi-Environment Consistency

[See Environment Isolation](#environment-isolation--audit-readiness) for related principles.
```

## Working on Client Projects

### Multi-Environment Installations

**CRITICAL**: When installing the same system across multiple environments (dev → test → uat → prod), **NEVER start fresh each time**. Always build on learnings from previous environments.

#### The Problem

❌ **What NOT to do:**
- Start fresh for test environment (after completing dev)
- Research solutions on internet for same issues already solved in dev
- Encounter identical problems on test, UAT, prod
- Waste hours re-discovering solutions
- No knowledge transfer between environments

This causes:
- 3 hours per environment (12 hours total for 4 environments)
- Same issues repeated 4 times
- Frustration for everyone involved

#### The Solution

✅ **Installation SOP Pattern:**

**1. First Environment (Dev):**
- Create detailed installation runbook: `RUNBOOK-01-System-Installation-Dev.md`
- Document **every step, issue, blocker, and resolution**
- Include troubleshooting decisions and why they were made
- Record time taken and final working configuration

**2. Subsequent Environments (Test, UAT, Prod):**
- **Copy the dev installation SOP** as starting point
- **Apply all learnings** from dev environment proactively
- Skip known issues (already have solutions)
- Document only new issues or environment-specific differences
- Update SOP with improvements

**Example:**

```markdown
# Dev Installation (3 hours):
- Issue 1: CRD version mismatch → Updated to v1beta2
- Issue 2: Resource constraints → Reduced CPU to 1 core
- Issue 3: Network policy blocking → Added ingress rule

# Test Installation (45 minutes):
- Applied learnings:
  ✅ Started with v1beta2 CRD (no version issues)
  ✅ Used 1 CPU from start (no resource issues)
  ✅ Added network policy proactively (no network issues)
- New issue: TLS certificate missing → Added cert-manager step
```

#### Operational Guidelines

**When user assigns multi-environment installation:**

1. **Ask**: "Is this the first environment or have we installed this elsewhere?"

2. **If first environment (dev)**:
   - Create detailed installation SOP
   - Document everything for future environments
   - File: `RUNBOOK-01-{System}-Installation-{Env}.md`

3. **If subsequent environment (test/uat/prod)**:
   - **Read the previous environment's SOP first**
   - Copy the SOP as starting template
   - Apply all learnings proactively
   - Don't repeat solved issues
   - File: `RUNBOOK-02-{System}-Installation-{Env}.md`

4. **Track improvements**:
   - Time saved: "3hrs (dev) → 45min (test)"
   - Issues prevented: "3 issues pre-emptively resolved"
   - New learnings: Document for next environment

#### Benefits

| Metric | Without SOPs | With SOPs |
|--------|-------------|-----------|
| Time per env | 3hrs each (12hrs total) | 3hrs + 3×45min = 5.25hrs total |
| Issues hit | 3 issues × 4 envs = 12 issues | 3 issues (dev) + 1 new (test) = 4 total |
| Knowledge | Lost between envs | Accumulated and improved |
| Quality | Inconsistent | Consistently improving |

**Time savings: ~56% reduction (12hrs → 5.25hrs)**

#### Reference

See [configuration-management.md - Installation SOPs](practices/configuration-management.md#installation-sops-learn-from-previous-environments) for detailed examples and workflow.

## Practices Documentation Guidelines

### Structure

Every practice file must follow this structure:

1. **Title and Overview** - What this practice covers
2. **When to Use** - Scenarios where this applies
3. **Core Concepts** - Main principles with examples
4. **Implementation** - Step-by-step guidance
5. **Common Pitfalls** - What to avoid
6. **Related Practices** - Cross-references to related practices
7. **Metadata Footer** - Maintained By, Last Updated, Version

### Version Management

- **Major version (X.0.0)** - Breaking changes, significant restructuring
- **Minor version (X.Y.0)** - New sections, enhanced guidance, new examples
- **Patch version (X.Y.Z)** - Typos, clarifications, minor updates

Update `Last Updated` to current date when making changes.

## Commit Standards

### Commit Message Format

Follow conventional commits:
```
<type>: <description>

<body>

<footer>
```

**Types**:
- `feat:` - New practice, template, or major feature
- `docs:` - Documentation updates, typo fixes
- `fix:` - Bug fixes, correction of errors
- `refactor:` - Restructuring without changing behavior
- `chore:` - Build, CI/CD, maintenance tasks

**Do NOT include**:
- ❌ AI co-authorship lines (blocked by pre-commit hook)

### Example Commit

```
feat: Add audit readiness principle to configuration-management (v2.0.0 → v2.1.0)

Enhanced the Environment Isolation principle to include audit-ready requirements:
- Self-contained environment folders
- No symbolic links or cross-references
- Standalone deployable configurations
- Compliance considerations (SOC2/ISO27001)

Added cross-references to Multi-Environment Consistency section.

Impact:
- Makes configuration management explicitly audit-friendly
- Addresses security and compliance requirements
- No breaking changes to existing structure
```

## Content Quality Standards

### 1. Generic Examples

**Rule**: Use generic, universally applicable examples.

**Avoid**:
- ❌ Client names (e.g., "example-project")
- ❌ Company-specific references
- ❌ Real AWS account IDs

**Use**:
- ✅ "example-project", "kafka-project"
- ✅ "example-eks-cluster"
- ✅ "123456789012" (generic AWS account ID format)

### 2. Practical Examples

Every principle should include:
- ✅ **Good** example (what to do)
- ❌ **Bad** example (what to avoid)
- 💡 **Why** it matters (rationale)

### 3. Cross-Platform Compatibility

Examples should work across:
- Linux/WSL/macOS
- Bash/Zsh shells
- Different AWS regions

## Remember

**When updating any practice**:
1. ✅ Check for repetition - remove or cross-reference
2. ✅ Add cross-references to related sections
3. ✅ Update version and Last Updated date
4. ✅ Update CHANGELOG.md if it's a significant change
5. ✅ Test health-check.sh passes
6. ✅ Use generic examples (no client references)

---

**Last Updated**: 2026-02-20
**Purpose**: Guide Claude when working on the MCP server repository and client projects
