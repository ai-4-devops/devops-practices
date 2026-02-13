# Air-Gapped Environment Workflow

**Purpose**: Standard workflow for working across air-gapped environments in infrastructure.

**CRITICAL**: NEVER FORGET THIS - The laptop where Claude runs has NO AWS access.

---

## Environment Setup

### Laptop (Where Claude Runs)
- **Has**: Git repository, file editing, Claude AI
- ⚠️ **NO AWS access** - Cannot run kubectl, helm, aws cli commands
- ⚠️ **NO EKS connectivity** - All cluster operations via bastion
- **Use For**: Creating files, generating commands, committing to git

### CloudShell/VPS (ECR Image Upload Station)
- **Has**: Fast internet, Docker, AWS credentials via environment variables
- **Purpose**: Pull images from internet, tag, push to ECR
- ⚠️ **NO AWS profiles** - Uses environment variables only:
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`
  - `AWS_SESSION_TOKEN`
- **Authentication**: `aws ecr get-login-password | docker login --password-stdin` (non-interactive)

### Bastion (EKS Access Point)
- **Access Method**: SSM Session Manager (browser-based, NOT SSH)
- **Has**: EKS cluster access, ECR access, S3 bucket access
- **NO Has**: Git, internet access, text editor
- **Use For**: All kubectl, helm, and EKS operations
- **Communication**: Copy/paste commands only

### EKS Cluster (Air-Gapped)
- **Has**: ECR access only
- **NO Has**: Internet access
- **Cannot**: Pull images from Docker Hub or other public registries
- **Must**: Pre-stage all images in ECR before deployment

### Common S3 Bucket (File Bridge)
- **Purpose**: Bridge for file transfers between laptop and bastion
- **Flow**: Laptop → S3 → Bastion
- **Use For**: Transferring configs, scripts, manifests to bastion

---

## Standard Workflow

### 1. On Laptop (Where Claude Runs)

**Claude's Role**:
- Create/edit files in git repository
- Generate commands for bastion (as copy/paste blocks)
- Create ECR upload scripts for CloudShell/VPS
- Generate S3 upload/download commands for file transfers
- Commit changes locally, push to remote

**Example**:
```bash
# Claude creates this file in git repo
vim configs/production/k8s/kafka/deployment.yaml

# Claude provides this command for S3 upload
aws s3 cp configs/production/k8s/kafka/deployment.yaml s3://example-s3-bucket/kafka/
```

### 2. On CloudShell/VPS (ECR Image Uploads)

**Purpose**: Pull images from internet and push to ECR

**Setup**:
```bash
# Set AWS credentials (environment variables, NOT profiles)
export AWS_ACCESS_KEY_ID="..."
export AWS_SECRET_ACCESS_KEY="..."
export AWS_SESSION_TOKEN="..."  # If using temporary credentials
export AWS_REGION="ap-south-1"
```

**Script Naming Convention**:
- Scripts ending with `-env.sh` are for CloudShell/VPS use
- These scripts MUST use environment variables (not AWS profiles)
- These scripts MUST use non-interactive Docker login

**Example ECR Upload Script**:
```bash
#!/bin/bash
# upload-kafka-images-env.sh

# Check required environment variables
: "${AWS_ACCESS_KEY_ID:?Need to set AWS_ACCESS_KEY_ID}"
: "${AWS_SECRET_ACCESS_KEY:?Need to set AWS_SECRET_ACCESS_KEY}"
: "${AWS_REGION:=ap-south-1}"

ECR_REGISTRY="123456789012.dkr.ecr.${AWS_REGION}.amazonaws.com"

# Non-interactive ECR login
aws ecr get-login-password --region ${AWS_REGION} | \
  docker login --username AWS --password-stdin ${ECR_REGISTRY}

# Pull from public registry
docker pull quay.io/strimzi/operator:0.50.0

# Tag for ECR
docker tag quay.io/strimzi/operator:0.50.0 \
  ${ECR_REGISTRY}/strimzi/operator:0.50.0

# Push to ECR
docker push ${ECR_REGISTRY}/strimzi/operator:0.50.0
```

### 3. File Transfer to Bastion

**From Laptop to S3**:
```bash
# Upload single file
aws s3 cp local-file.yaml s3://example-s3-bucket/path/file.yaml

# Upload directory
aws s3 cp configs/ s3://example-s3-bucket/configs/ --recursive

# Upload tarball (for multiple files)
tar -czf kafka-manifests.tar.gz k8s-manifests/ helm-values/
aws s3 cp kafka-manifests.tar.gz s3://example-s3-bucket/
```

**From S3 to Bastion** (user copy/pastes):
```bash
# Download single file
aws s3 cp s3://example-s3-bucket/path/file.yaml ./file.yaml

# Download directory
aws s3 cp s3://example-s3-bucket/configs/ ./configs/ --recursive

# Download and extract tarball
aws s3 cp s3://example-s3-bucket/kafka-manifests.tar.gz .
tar -xzf kafka-manifests.tar.gz
```

### 4. On Bastion (User Copy/Pastes)

**All EKS Operations**:
```bash
# All kubectl commands
kubectl apply -f deployment.yaml
kubectl get pods -n kafka

# All helm commands
helm upgrade kafka-operator ./strimzi-operator --namespace kafka

# All AWS operations (ECR, S3)
aws ecr describe-images --repository-name strimzi/operator
```

**No File Editing** - Transfer pre-edited files from S3 instead

---

## What Claude Should Do ✅

1. **Provide commands as copy/paste blocks** for bastion
2. **Create files in laptop git repo** (Claude has file system access here)
3. **Generate S3 upload/download commands** for file transfers
4. **Assume ECR images are pre-staged** (EKS has no internet)
5. **Create ECR upload scripts** for CloudShell/VPS:
   - Must use environment variables (not AWS profiles)
   - Must use non-interactive Docker login (pipe password)
   - Scripts ending with `-env.sh`
   - Check for required env vars at start of script
6. **Maintain detailed session logs** in `docs/RUNBOOKS/`:
   - Every command executed
   - Complete output from each command
   - Timestamps and context
7. **Wait for explicit user request before committing**
   - User must say: "please commit", "commit this", "commit these changes"
   - NEVER commit proactively
8. **Use `git mv` for moving/renaming tracked files**
   - Preserves full git history
   - Example: `git mv old/path new/path`
9. **ALWAYS backup working configurations before updates**
   - Before helm upgrade: `helm get values <release> -n <namespace> > backup.yaml`
   - Before kubectl apply: `kubectl get <resource> -n <namespace> -o yaml > backup.yaml`
   - Store backups with UTC timestamp: `backup-$(date -u +%Y%m%dT%H%M%SZ).yaml`
   - Provide rollback commands

---

## What Claude Should NOT Do ❌

1. ❌ Run kubectl/helm/aws commands directly (laptop has no AWS access)
2. ❌ Assume direct EKS cluster access from laptop
3. ❌ Run bash commands that need EKS/AWS connectivity
4. ❌ Forget to provide S3 transfer commands
5. ❌ Commit changes without explicit user request
6. ❌ Forget that bastion is accessed via SSM browser session (not SSH)

---

## Command Batching for Bastion

When multiple related commands need to run, batch them into a single copy-paste block:

```bash
# ---- Deploy Kafka Cluster (paste entire block) ----
kubectl create namespace kafka
kubectl apply -f kafka-cluster.yaml -n kafka
kubectl rollout status deployment/kafka -n kafka --timeout=120s
kubectl get pods -n kafka
echo "✅ Kafka deployment complete"
```

Use comment headers to group logical steps.

---

## Pre-flight Checks

Before any deployment, always provide verification commands:

```bash
# ---- Pre-flight Checks (paste entire block) ----
# 1. Check namespace exists
kubectl get namespace kafka || echo "⚠️ Namespace 'kafka' does not exist"

# 2. Check required secrets exist
kubectl get secret ecr-credentials -n kafka || echo "⚠️ Secret 'ecr-credentials' missing"

# 3. Check ECR image availability
aws ecr describe-images --repository-name strimzi/operator --image-ids imageTag=0.50.0 || echo "⚠️ Image not in ECR"

# 4. Check storage class
kubectl get storageclass gp3 || echo "⚠️ Storage class 'gp3' not available"
```

This avoids the costly deploy → fail → debug → redeploy cycle.

---

## Rollback Plans

Every significant change must come with a rollback path:

```bash
# ---- Backup Current State ----
kubectl get deployment kafka -n kafka -o yaml > kafka-backup-$(date -u +%Y%m%dT%H%M%SZ).yaml

# ---- Apply Changes ----
kubectl apply -f kafka-new-config.yaml -n kafka

# ---- Rollback (if needed) ----
kubectl apply -f kafka-backup-20260213T180000Z.yaml -n kafka
kubectl rollout status deployment/kafka -n kafka
kubectl get pods -n kafka
```

---

## Efficiency Guidelines

### When to Create Scripts vs Provide Commands

**Provide Direct Commands** when:
- One-off checks or verifications
- Simple operations under ~15 lines
- Sequential commands that are straightforward to paste
- Commands unlikely to be reused

**Create Scripts** when:
- Reusable across sessions, environments, or team
- Complex logic: loops, conditionals, error handling, retries
- Multi-step operations where partial failure needs cleanup
- ECR image upload workflows (always scripted)

**Rule of thumb**: If it's faster to copy-paste than to transfer via S3, just give the commands directly.

---

**Maintained By**: Infrastructure Team
**Last Updated**: 2026-02-13
**Version**: 1.0.0