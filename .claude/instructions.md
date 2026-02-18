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

**Last Updated**: 2026-02-18
**Purpose**: Guide Claude when working on the MCP server repository
