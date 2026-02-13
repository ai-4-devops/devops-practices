# Efficiency Guidelines

**Purpose**: Optimize workflow in air-gapped environments.

**Principle**: Don't over-engineer. Optimize for the constraint (S3 transfer overhead).

---

## Copy-Paste vs Script Decision

**⚠️ DO NOT over-engineer simple tasks into scripts.**

Transferring scripts via S3 to bastion has real overhead:
```
create → tar → upload → download → extract → chmod → run
```

### Decision Framework

#### Give Direct Copy-Paste Commands When:

- ✅ One-off checks or verifications
  ```bash
  kubectl get pods -n tracing
  ```

- ✅ Simple operations under ~15 lines with no complex logic
  ```bash
  kubectl apply -f deployment.yaml
  kubectl rollout status deployment/app
  kubectl get pods
  ```

- ✅ Sequential commands that are straightforward to paste
  ```bash
  # ---- Deploy Application ----
  kubectl create namespace app
  kubectl apply -f config.yaml -n app
  kubectl apply -f deployment.yaml -n app
  kubectl get pods -n app
  ```

- ✅ Commands unlikely to be reused
  ```bash
  kubectl describe pod app-pod-xyz -n app
  ```

#### Create a Script When:

- ✅ Reusable across sessions, environments, or team
  ```bash
  # create-topics-runtime-v2.sh
  # Used for any environment, any topic list
  ```

- ✅ Complex logic: loops, conditionals, error handling, retries
  ```bash
  for attempt in $(seq 1 $MAX_RETRIES); do
    if kubectl apply ...; then
      break
    else
      echo "Retry $attempt..."
      sleep 10
    fi
  done
  ```

- ✅ Needs to be auditable/versioned artifact in `scripts/`
  ```bash
  # scripts/20260130-2218-upload-kafka-images-env.sh
  # Tracked in git, referenced in documentation
  ```

- ✅ Multi-step operation where partial failure needs cleanup
  ```bash
  # Deploy with cleanup on failure
  if ! deploy_app; then
    rollback_changes
    exit 1
  fi
  ```

- ✅ ECR image upload workflows (ALWAYS scripted)
  ```bash
  # ECR uploads always need:
  # - Environment variable checks
  # - Non-interactive login
  # - Multiple images
  # - Error handling
  ```

### Rule of Thumb

**If it's faster to copy-paste than to transfer via S3, just give the commands directly.**

**Time Comparison**:
```
Copy-paste 10 commands: 30 seconds
Create script + tar + S3 + extract: 3-5 minutes
```

---

## Command Batching for Bastion

Group related commands into single copy-paste blocks:

### Good Batching ✅

```bash
# ---- Deploy Kafka Cluster (paste entire block) ----
# Pre-flight checks
kubectl get namespace kafka || echo "⚠️ Namespace missing"
kubectl get storageclass gp3 || echo "⚠️ Storage class missing"

# Deploy
kubectl apply -f kafka-cluster.yaml -n kafka
kubectl rollout status deployment/kafka -n kafka --timeout=120s

# Verify
kubectl get pods -n kafka
kubectl get kafkanodepool -n kafka

echo "✅ Kafka deployment complete"
```

**Benefits**:
- One paste instead of 7 separate commands
- Logical grouping (check → deploy → verify)
- Clear outcome message
- Reduces round-trips

### Use Comment Headers

```bash
# ---- Section 1: Pre-flight Checks ----
[commands]

# ---- Section 2: Deployment ----
[commands]

# ---- Section 3: Verification ----
[commands]
```

---

## Pre-flight Checks

**Always provide verification commands BEFORE deployment.**

### Why?
Avoids costly cycle: deploy → fail → debug → redeploy

Especially painful in air-gapped environments where you can't quickly pull missing images.

### What to Check

```bash
# ---- Pre-flight Checks (paste entire block) ----
echo "=== Checking Prerequisites ==="

# 1. Namespace exists
kubectl get namespace kafka || echo "⚠️ MISSING: namespace kafka"

# 2. Secrets exist
kubectl get secret ecr-credentials -n kafka || echo "⚠️ MISSING: ecr-credentials"

# 3. ECR images available
aws ecr describe-images --repository-name strimzi/operator --image-ids imageTag=0.50.0 \
  || echo "⚠️ MISSING: strimzi/operator:0.50.0 not in ECR"

# 4. Storage class available
kubectl get storageclass gp3 || echo "⚠️ MISSING: storage class gp3"

# 5. Required ConfigMaps
kubectl get configmap kafka-metrics -n kafka || echo "⚠️ MISSING: kafka-metrics configmap"

echo "=== Pre-flight Checks Complete ==="
```

### Result
All issues identified BEFORE attempting deployment, saving time and frustration.

---

## Rollback Plans

**Every significant change must include rollback path.**

### What to Provide

1. **Backup commands** (run BEFORE change)
2. **Change commands** (the actual change)
3. **Rollback commands** (undo if needed)
4. **Verification commands** (confirm success or rollback)

### Example

```bash
# ---- Backup Current State ----
kubectl get deployment kafka -n kafka -o yaml > kafka-backup-$(date -u +%Y%m%dT%H%MZ).yaml
echo "Backup saved: kafka-backup-$(date -u +%Y%m%dT%H%MZ).yaml"

# ---- Apply Changes ----
kubectl apply -f kafka-new-config.yaml -n kafka
kubectl rollout status deployment/kafka -n kafka --timeout=120s

# ---- Verify Success ----
kubectl get pods -n kafka
kubectl logs -n kafka deployment/kafka --tail=50

# ---- Rollback (if needed) ----
# If something goes wrong, run:
# kubectl apply -f kafka-backup-YYYYMMDDTHHMMSSZ.yaml -n kafka
# kubectl rollout status deployment/kafka -n kafka
# kubectl get pods -n kafka
```

### For Helm

```bash
# ---- Backup Current Values ----
helm get values kafka-operator -n kafka > kafka-operator-backup-$(date -u +%Y%m%dT%H%MZ).yaml

# ---- Upgrade ----
helm upgrade kafka-operator ./strimzi-operator -f new-values.yaml -n kafka

# ---- Rollback (if needed) ----
# Option 1: Helm rollback
# helm rollback kafka-operator -n kafka

# Option 2: Restore from backup
# helm upgrade kafka-operator ./strimzi-operator -f kafka-operator-backup-YYYYMMDDTHHMMSSZ.yaml -n kafka
```

---

## Image Manifest Maintenance

**Keep `docs/ecr-manifest.md` current** - prevents surprises.

### Why?
Deploying to air-gapped EKS? Need to know if image is in ECR BEFORE attempting deployment.

### What to Track

```markdown
# ECR Image Manifest

## UAT (315860845274)
| Repository | Tag | Upload Date | Purpose |
|------------|-----|-------------|---------|
| strimzi/operator | 0.50.0 | 2026-01-21 | Kafka operator |
| strimzi/kafka | 0.50.0-kafka-4.1.1 | 2026-01-21 | Kafka brokers |

## DEV (747030889179)
| Repository | Tag | Upload Date | Purpose |
|------------|-----|-------------|---------|
| strimzi/operator | 0.50.0 | 2026-01-22 | Kafka operator |
```

### Update Protocol
- Update whenever images pushed to ECR
- Update whenever images discovered in ECR
- Check before any deployment

---

## Diff-First Approach

**Show changes BEFORE applying.**

### Why?
Changes are reviewable, user can spot issues, builds trust.

### How

**For File Changes**:
```markdown
**Before**:
```yaml
partitions: 1
```

**After**:
```yaml
partitions: 3
```

**For Configuration Updates**:
```bash
# Current configuration
kubectl get kafkatopic quote-requested -n kafka -o yaml

# Proposed change
cat kafka-topic-quote-requested-updated.yaml

# Show diff
diff <(kubectl get kafkatopic quote-requested -n kafka -o yaml) kafka-topic-quote-requested-updated.yaml
```

---

## Conciseness Toggle

**Read the room** - adjust verbosity to user preference.

### User Says "Just the Commands" or "Quick"
Provide only commands, no explanation:

```bash
kubectl apply -f deployment.yaml -n kafka
kubectl rollout status deployment/kafka -n kafka
kubectl get pods -n kafka
```

### User Asks "Why" or "Explain"
Provide full context and rationale:

```bash
# We're deploying the Kafka cluster with 3 brokers to provide high availability.
# KRaft mode is used instead of ZooKeeper to reduce operational complexity.
kubectl apply -f kafka-cluster.yaml -n kafka

# Wait for the deployment to complete. This typically takes 2-3 minutes as
# persistent volumes are provisioned and brokers start up.
kubectl rollout status deployment/kafka -n kafka --timeout=300s

# Verify all 3 brokers are running. You should see 3 pods in "Running" state.
kubectl get pods -n kafka -l app=kafka
```

### Default (No Preference Stated)
Commands with brief inline comments:

```bash
# Deploy Kafka cluster (3 brokers, KRaft mode)
kubectl apply -f kafka-cluster.yaml -n kafka

# Wait for deployment to complete
kubectl rollout status deployment/kafka -n kafka --timeout=300s

# Verify brokers are running
kubectl get pods -n kafka -l app=kafka
```

Save detailed explanations for docs/reports/.

---

## Efficiency Mindset

### Ask Yourself

1. **Does this need to be a script?**
   - If < 15 lines and no complex logic → No
   - If reusable or has complex logic → Yes

2. **Can I batch these commands?**
   - If related commands → Yes, batch them
   - If independent checks → Yes, but separate sections

3. **Did I provide pre-flight checks?**
   - For any deployment → Always yes

4. **Did I provide rollback path?**
   - For any significant change → Always yes

5. **Is the user asking for brevity or detail?**
   - Adjust verbosity accordingly

### Time Savers

**Good** ✅:
```bash
# Single paste block with all related commands
kubectl apply -f app.yaml && \
kubectl rollout status deployment/app && \
kubectl get pods
```

**Less Efficient** ⚠️:
```
"Please run: kubectl apply -f app.yaml"
[user pastes, waits for response]
"Now run: kubectl rollout status deployment/app"
[user pastes, waits for response]
"Now run: kubectl get pods"
[user pastes, waits for response]
```

### Complexity Budget

Reserve scripting for where it matters:
- ECR uploads: Always script (complex, reusable)
- Deployments with retry logic: Script
- Simple checks: Copy-paste
- One-time configs: Copy-paste

---

## Anti-Patterns

### ❌ Over-Engineering
Creating a 50-line script for a 3-line operation that's only used once.

### ❌ Under-Engineering
Providing 20 individual commands instead of a batched block for related operations.

### ❌ No Pre-flight Checks
Deploying without verifying prerequisites, leading to predictable failures.

### ❌ No Rollback Plan
Making changes without backup, leaving no recovery path.

### ❌ Verbose When User Wants Brief
User says "quick" but you provide paragraph explanations for each command.

---

## Quick Reference

```bash
# Decision: Script or Copy-Paste?
Lines < 15 AND no complex logic → Copy-paste
Reusable OR complex logic → Script

# Command batching (use &&)
cmd1 && cmd2 && cmd3

# Pre-flight checks (always provide)
kubectl get namespace kafka || echo "⚠️ Missing"

# Backup before changes (UTC timestamp)
kubectl get resource -o yaml > backup-$(date -u +%Y%m%dT%H%MZ).yaml

# Conciseness levels
"quick" → Commands only
"explain" → Full context
Default → Commands + brief comments
```

---

## Related Practices

- **[air-gapped-workflow.md](air-gapped-workflow.md)** - S3 transfer overhead drives copy-paste vs script decisions
- **[standard-workflow.md](standard-workflow.md)** - Efficiency considerations for direct access environments
- **[runbook-documentation.md](runbook-documentation.md)** - Document commands regardless of delivery method

---

**Maintained By**: Infrastructure Team
**Last Updated**: 2026-02-13
**Version**: 1.0.0