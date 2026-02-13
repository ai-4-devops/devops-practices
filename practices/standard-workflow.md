# Standard Workflow (Non-Air-Gapped)

**Purpose**: Standard workflow for projects with direct cloud/cluster access.

**Applies To**: Projects where laptop has AWS/EKS/cloud access (NOT air-gapped).

---

## Environment Setup

### Laptop (Where Claude Runs)
- **Has**: Git repository, file editing, Claude AI
- ✅ **HAS AWS access** - Can run kubectl, helm, aws cli commands directly
- ✅ **HAS EKS connectivity** - Direct cluster operations from laptop
- **Use For**: Everything - editing files, running commands, deploying

### Cloud Environment
- **Has**: Direct access from laptop
- **Access Method**: Standard kubeconfig, AWS credentials
- **Communication**: Direct - no intermediary required

---

## Standard Workflow

### 1. On Laptop (Where Claude Runs)

**Claude's Role**:
- Create/edit files in git repository
- Run kubectl/helm/aws commands directly
- Deploy directly to cloud/EKS
- Commit changes locally, push to remote

**Example**:
```bash
# Edit file
vim configs/production/k8s/kafka/deployment.yaml

# Deploy directly
kubectl apply -f configs/production/k8s/kafka/deployment.yaml

# Commit
git add configs/production/k8s/kafka/deployment.yaml
git commit -m "Update Kafka deployment configuration"
git push
```

### 2. Direct Deployment

**No file transfer needed** - everything runs from laptop:

```bash
# Edit configuration
vim helm-values/production/app-values.yaml

# Deploy with Helm
helm upgrade my-app ./chart -f helm-values/production/app-values.yaml -n production

# Verify
kubectl get pods -n production

# Commit
git add helm-values/production/app-values.yaml
git commit -m "Update production app configuration"
```

### 3. Image Management

**Direct access to registries**:

```bash
# Pull from public registry
docker pull nginx:latest

# Tag for private registry
docker tag nginx:latest myregistry.io/nginx:latest

# Push to private registry
docker push myregistry.io/nginx:latest

# Deploy to cluster (cluster can pull directly)
kubectl set image deployment/nginx nginx=myregistry.io/nginx:latest -n production
```

**Cluster can pull from**:
- ✅ Docker Hub
- ✅ GitHub Container Registry
- ✅ Private registries (with credentials)
- ✅ ECR (with proper IAM roles)

---

## What Claude Should Do ✅

1. **Run commands directly** - No need for copy/paste workflow
2. **Create and edit files** in git repository
3. **Deploy directly** to cloud/cluster using kubectl, helm, etc.
4. **Verify deployments** with direct kubectl commands
5. **Maintain detailed session logs** in `docs/RUNBOOKS/`
6. **Wait for explicit user request before committing**
7. **Use `git mv` for moving/renaming tracked files**
8. **Backup before changes** using UTC timestamps

---

## What Claude Should NOT Do ❌

1. ❌ Forget that direct access is available (don't overcomplicate)
2. ❌ Create unnecessary file transfer steps
3. ❌ Commit changes without explicit user request
4. ❌ Run destructive commands without confirmation

---

## Simplified Workflow Comparison

### Air-Gapped (Complex):
```
Laptop (edit) → S3 (transfer) → Bastion (copy/paste) → EKS
```

### Standard (Simple):
```
Laptop (edit + deploy directly) → Cloud/EKS
```

---

## Command Examples

### Deployment

**Direct kubectl:**
```bash
# Deploy
kubectl apply -f deployment.yaml -n production

# Wait for rollout
kubectl rollout status deployment/app -n production

# Verify
kubectl get pods -n production
```

**Direct Helm:**
```bash
# Upgrade
helm upgrade app ./chart -f values.yaml -n production

# Status
helm status app -n production

# History
helm history app -n production
```

### Troubleshooting

**Direct access to logs and debugging:**
```bash
# Get logs
kubectl logs deployment/app -n production --tail=100

# Describe pod
kubectl describe pod app-xyz -n production

# Port-forward for testing
kubectl port-forward svc/app 8080:80 -n production
```

---

## Pre-flight Checks

Still important, but simpler with direct access:

```bash
# Check namespace
kubectl get namespace production || kubectl create namespace production

# Check secrets
kubectl get secret app-secrets -n production || echo "⚠️ Secret missing"

# Check image availability (can test pull directly)
docker pull myregistry.io/app:v1.0.0 || echo "⚠️ Image not accessible"

# Check resources
kubectl get nodes
kubectl top nodes
```

---

## Backup & Rollback

Same principles apply, but execution is simpler:

### Backup Before Changes

```bash
# Backup deployment
kubectl get deployment app -n production -o yaml > app-backup-$(date -u +%Y%m%dT%H%M%SZ).yaml

# Backup Helm values
helm get values app -n production > app-values-backup-$(date -u +%Y%m%dT%H%M%SZ).yaml
```

### Rollback

```bash
# Helm rollback
helm rollback app -n production

# Or restore from backup
kubectl apply -f app-backup-20260213T180000Z.yaml -n production
```

---

## Image Management Best Practices

### With Direct Registry Access

**Development workflow:**
```bash
# Build locally
docker build -t myapp:dev .

# Test locally
docker run myapp:dev

# Push to registry
docker tag myapp:dev myregistry.io/myapp:v1.0.0
docker push myregistry.io/myapp:v1.0.0

# Deploy to cluster
kubectl set image deployment/myapp myapp=myregistry.io/myapp:v1.0.0 -n dev
```

**CI/CD workflow:**
- GitHub Actions, GitLab CI, Jenkins, etc. can build and push directly
- Cluster can pull images from registry without pre-staging

---

## Efficiency Considerations

### When to Script vs Direct Commands

Same principles as air-gapped, but threshold is different:

**Direct commands** (even more appropriate):
- Most operations under ~20 lines
- One-off deployments and checks
- Quick fixes and updates

**Scripts** (when really needed):
- Complex multi-step operations with logic
- Reusable across team and environments
- Operations requiring error handling and retries

**Rule of thumb**: Default to direct commands. Only script when complexity justifies it.

---

## Comparison: Air-Gapped vs Standard

| Aspect | Air-Gapped | Standard |
|--------|------------|----------|
| **File Transfer** | Laptop → S3 → Bastion | Direct (no transfer) |
| **Commands** | Copy/paste to bastion | Direct execution |
| **Image Pull** | Pre-stage to ECR | Cluster pulls directly |
| **Debugging** | Via bastion copy/paste | Direct kubectl/logs |
| **Complexity** | High (multiple hops) | Low (direct access) |

---

## Session Logs

Still maintain detailed logs in `docs/RUNBOOKS/`, but format is simpler:

```markdown
# Session: 2026-02-13 - Deploy App to Production

## Command 1
$ kubectl apply -f deployment.yaml -n production
deployment.apps/app created

## Verification
$ kubectl get pods -n production
NAME                   READY   STATUS    RESTARTS   AGE
app-5d4b7c8f9d-abcde   1/1     Running   0          30s

## Result
✅ Deployment successful
```

---

## Key Differences from Air-Gapped

1. **No S3 transfer** - Files edited and used directly
2. **No bastion** - Direct cluster access from laptop
3. **No pre-staging images** - Cluster can pull from registries
4. **Direct debugging** - kubectl logs, describe, exec work directly
5. **Faster iterations** - No transfer overhead

---

## When to Use This Workflow

Use standard workflow when:
- ✅ Laptop has AWS credentials configured
- ✅ EKS cluster security groups allow laptop access
- ✅ Internet access available for image pulls
- ✅ No compliance requirements for air-gapped deployment

Use air-gapped workflow when:
- ⚠️ Security/compliance requires air-gapped infrastructure
- ⚠️ No direct internet access allowed for cluster
- ⚠️ Laptop cannot have AWS/cluster credentials
- ⚠️ Bastion required as security control point

---

## Related Practices

- **[air-gapped-workflow.md](air-gapped-workflow.md)** - Alternative workflow for air-gapped/secure environments
- **[configuration-management.md](configuration-management.md)** - Direct deployment of configs with full access
- **[documentation-standards.md](documentation-standards.md)** - Same documentation standards apply regardless of access method
- **[efficiency-guidelines.md](efficiency-guidelines.md)** - Efficiency considerations without S3 transfer overhead

---

**Maintained By**: Uttam Jaiswal
**Last Updated**: 2026-02-13
**Version**: 1.0.0