# Configuration Management Practice

**Purpose**: Standards for organizing and managing environment-specific configurations across infrastructure projects.

**Goal**: Ensure clarity, reproducibility, and no ambiguity in configuration management.

---

## Directory Structure

### Hybrid Resource-Type-First Approach

Separates **configuration** (declarative state), **scripts** (automation), and **documentation** (knowledge) at the top level, with environment-specific configurations nested under `configs/`:

```
configs/
├── <environment>/                  # e.g., dev, test, uat, production
│   ├── k8s/                        # Kubernetes resources
│   │   ├── <namespace>/            # e.g., observability, tracing, monitoring
│   │   │   ├── <component>/        # e.g., jaeger, otel-collector, prometheus
│   │   │   │   ├── values.yaml     # Helm values
│   │   │   │   ├── deployment.yaml
│   │   │   │   ├── service.yaml
│   │   │   │   ├── configmap.yaml
│   │   │   │   └── ...
│   │   │   └── ...
│   │   └── ...
│   ├── ecs/                        # ECS task definitions & services
│   │   ├── <service>/              # e.g., api-gateway, worker-service
│   │   │   ├── task-definition.json
│   │   │   ├── service-definition.json
│   │   │   └── container-config.json
│   │   └── ...
│   ├── rds/                        # RDS configurations
│   │   ├── <database>/             # e.g., postgres, mysql
│   │   │   ├── parameter-group.json
│   │   │   ├── option-group.json
│   │   │   └── init-scripts/
│   │   └── ...
│   ├── ec2/                        # EC2-hosted services
│   │   ├── <service>/              # e.g., elasticsearch, clickhouse
│   │   │   ├── config/             # Service configuration files
│   │   │   │   ├── elasticsearch.yml
│   │   │   │   ├── jvm.options
│   │   │   │   └── ...
│   │   │   └── setup/              # Installation/setup scripts
│   │   │       ├── install.sh
│   │   │       └── configure.sh
│   │   └── ...
│   ├── terraform/                  # Terraform configurations
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── modules/
│   ├── helm-values/                # Helm chart value overrides
│   │   ├── <chart-name>/           # e.g., kafka, nginx-ingress
│   │   │   └── values.yaml
│   │   └── ...
│   └── ...
├── shared/                         # Shared configs across all environments
│   ├── iam/                        # IAM policies, roles (templates)
│   ├── secrets/                    # Secret templates (not actual secrets!)
│   ├── network/                    # Security groups, NACLs (templates)
│   └── ...
└── ...

scripts/                            # Parameterized, reusable automation
├── deploy.sh                       # Takes --env parameter
├── backup.sh
├── rollback.sh
└── lib/                            # Shared script libraries
    └── helpers.sh

docs/                               # Shared documentation
├── guides/                         # HOW-TO deployment procedures
│   ├── deployment-guide.md
│   └── troubleshooting-guide.md
└── runbooks/                       # Session logs (env-specific if needed)
    ├── dev/
    ├── test/
    ├── uat/
    └── shared/
```

### Service Types Reference

The structure supports multiple infrastructure service types:

| Service Type | Purpose | Typical Contents |
|--------------|---------|------------------|
| **k8s/** | Kubernetes manifests | Deployments, Services, ConfigMaps, Helm values |
| **ecs/** | ECS configurations | Task definitions, service definitions |
| **rds/** | Database configurations | Parameter groups, option groups, init scripts |
| **ec2/** | EC2 instance configs | Service configs, installation scripts |
| **terraform/** | Infrastructure as Code | .tf files, modules, state configs |
| **helm-values/** | Helm value overrides | values.yaml files per chart |
| **lambda/** | Serverless functions | Function configs, IAM roles |
| **s3/** | S3 bucket configs | Bucket policies, lifecycle rules |

Add new service types as needed - the structure is extensible.

### Rationale: Why This Structure?

**1. Separation of Concerns**
- **Config** = Declarative state (what infrastructure should look like)
- **Scripts** = Imperative automation (how to deploy/manage)
- **Docs** = Knowledge and procedures (why and how-to)

**2. Prevents Duplication**
- Scripts are **reusable** across environments (take `--env` parameter)
- Docs are **mostly shared** (guides, troubleshooting)
- Config **truly differs** per environment (different values/sizing)

**3. Clear Boundaries**
- Configuration never gets confused with executable code
- Executable scripts are clearly separated from declarative config
- Documentation is centralized, not scattered across environment folders

**4. Scalable**
- Easy to add new service types under `config/$env/`
- Easy to add new environments (`staging/`, `dr/`, `sandbox/`)
- Easy to find all automation in one place (`scripts/`)

**5. Access Control Friendly**
- Grant read-only to `config/` for auditors
- Grant write access to `scripts/` for automation team
- Separate sensitive configs from general documentation

---

## Naming Conventions

### Environment Names

Use consistent environment names across all projects:

- `dev` - Development environment
- `test` (or `sit`) - Testing/SIT environment
- `staging` (or `uat`) - Staging/UAT environment
- `production` (or `prod`) - Production environment

**Example:**
```
configs/
├── dev/
├── test/
├── staging/
└── production/
```

### Namespace Names

Group resources by purpose:

- `observability` - Monitoring, metrics, alerts
- `tracing` - Distributed tracing (Jaeger, etc.)
- `logging` - Log collection and aggregation
- `monitoring` - Prometheus, Grafana
- `security` - Security tools, scanners
- `ingress` - Ingress controllers, ALBs

### Service Names

Use descriptive, lowercase names with hyphens:

- `otel-collector` (not `OTel-Collector` or `otelcollector`)
- `kube-state-metrics` (not `kube_state_metrics`)
- `node-exporter` (not `NodeExporter`)

---

## Configuration File Examples

### Example 1: Kubernetes Deployment

**Path:** `configs/production/k8s/observability/jaeger/deployment.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: jaeger
  namespace: tracing
  labels:
    app: jaeger
    environment: production
    cluster: ${CLUSTER_NAME}
spec:
  replicas: 2
  selector:
    matchLabels:
      app: jaeger
  template:
    metadata:
      labels:
        app: jaeger
    spec:
      containers:
        - name: jaeger
          image: ${ECR_REGISTRY}/jaeger:${JAEGER_VERSION}
          ports:
            - containerPort: 16686
              name: ui
            - containerPort: 4317
              name: otlp-grpc
          env:
            - name: SPAN_STORAGE_TYPE
              value: elasticsearch
            - name: ES_SERVER_URLS
              value: ${ES_ENDPOINT}
```

### Example 2: Helm Values

**Path:** `configs/production/k8s/observability/otel-collector/values.yaml`

```yaml
# OTel Collector Helm Values - Production
image:
  repository: ${ECR_REGISTRY}/opentelemetry-collector
  tag: ${OTEL_VERSION}

config:
  receivers:
    otlp:
      protocols:
        grpc:
          endpoint: 0.0.0.0:4317

  processors:
    resource:
      attributes:
        - key: cluster
          value: ${CLUSTER_NAME}
          action: upsert
        - key: environment
          value: production
          action: upsert

  exporters:
    prometheusremotewrite:
      endpoint: ${PROMETHEUS_ENDPOINT}/api/v1/write

    elasticsearch:
      endpoints:
        - ${ES_ENDPOINT}

  service:
    pipelines:
      metrics:
        receivers: [otlp, prometheus]
        processors: [resource, batch]
        exporters: [prometheusremotewrite]

      traces:
        receivers: [otlp]
        processors: [resource, batch]
        exporters: [elasticsearch]
```

### Example 3: EC2 Service Configuration

**Path:** `configs/production/ec2/elasticsearch/config/elasticsearch.yml`

```yaml
# Elasticsearch Configuration - Production
cluster.name: ${ES_CLUSTER_NAME}
node.name: ${NODE_NAME}

network.host: 0.0.0.0
http.port: 9200

discovery.seed_hosts:
  - ${ES_NODE_1}
  - ${ES_NODE_2}
  - ${ES_NODE_3}

xpack.security.enabled: true
xpack.security.http.ssl.enabled: true
xpack.security.http.ssl.keystore.path: ${KEYSTORE_PATH}
```

---

## Principles

### 1. Environment Isolation & Audit Readiness

Each environment is **fully self-contained and audit-ready** under its folder.

**Rule**: Each environment folder must be:
- ✅ **Self-contained** - All manifests specific to that environment
- ✅ **Account-specific** - All scripts/configs with environment-specific account IDs
- ✅ **No cross-references** - No symbolic links or references to other environments
- ✅ **Standalone deployable** - Can be deployed/audited without accessing other environment folders
- ✅ **Compliance-ready** - Auditors can review one environment folder independently

**Why This Matters:**
- **Security audits** - Auditors can review production configs without seeing dev/test
- **Access control** - Grant environment-specific permissions without exposing others
- **Deployment isolation** - Deploy one environment without dependencies on others
- **Change tracking** - Git history shows changes per environment clearly
- **Compliance** - Meets SOC2/ISO27001 requirements for environment separation

**✅ Good:**
```yaml
# configs/production/k8s/observability/jaeger/deployment.yaml
spec:
  containers:
  - name: jaeger
    image: 123456789012.dkr.ecr.ap-south-1.amazonaws.com/jaeger:v2.14  # Production AWS account
    env:
    - name: ES_ENDPOINT
      value: "https://prod-es.internal:9200"  # Production endpoint
```

```yaml
# configs/dev/k8s/observability/jaeger/deployment.yaml
spec:
  containers:
  - name: jaeger
    image: 987654321098.dkr.ecr.ap-south-1.amazonaws.com/jaeger:v2.14  # Dev AWS account
    env:
    - name: ES_ENDPOINT
      value: "https://dev-es.internal:9200"  # Dev endpoint
```

**❌ Bad:**
```bash
# Using symlinks or references
configs/production/jaeger/ -> ../shared/jaeger/  # ❌ Not self-contained
configs/production/scripts/deploy.sh  # ❌ References ../dev/config.yaml
```

**❌ Bad:**
```yaml
# Mixing environments in one file
configs/jaeger/deployment.yaml
  # if ENV=prod then account=123456789012  # ❌ Not audit-friendly
  # if ENV=dev then account=987654321098   # ❌ Can't isolate environments
```

**See also:** [Multi-Environment Consistency](#multi-environment-consistency) for keeping environments synchronized

### 2. Service Grouping

Configs are grouped **by service**, not by file type.

**✅ Good:**
```
configs/production/k8s/tracing/jaeger/
├── deployment.yaml
├── service.yaml
├── configmap.yaml
├── ingress.yaml
└── values.yaml
```

**❌ Bad:**
```
configs/production/k8s/
├── deployments/
│   └── jaeger-deployment.yaml
├── services/
│   └── jaeger-service.yaml
└── configmaps/
    └── jaeger-configmap.yaml
```

### 3. No Hardcoded Values

Use **placeholders** for environment-specific values.

**Placeholder Syntax:**
- Format: `${VARIABLE_NAME}`
- Uppercase with underscores
- Descriptive and unambiguous

**Common Placeholders:**
- `${ECR_REGISTRY}` - ECR registry URL (e.g., `123456789012.dkr.ecr.ap-south-1.amazonaws.com`)
- `${CLUSTER_NAME}` - Cluster identifier (e.g., `example-eks-prod`)
- `${ES_ENDPOINT}` - Elasticsearch endpoint (e.g., `https://es.example.com:9200`)
- `${PROMETHEUS_ENDPOINT}` - Prometheus endpoint (e.g., `http://prometheus:9090`)
- `${AWS_REGION}` - AWS region (e.g., `ap-south-1`)
- `${VERSION}` - Component version (e.g., `0.114.0`)
- `${CLICKHOUSE_HOST}` - ClickHouse host (e.g., `10.251.10.172`)
- `${CLICKHOUSE_PORT}` - ClickHouse port (e.g., `8124`)

**✅ Good:**
```yaml
image: ${ECR_REGISTRY}/otel-collector:${OTEL_VERSION}
endpoint: ${PROMETHEUS_ENDPOINT}/api/v1/write
cluster: ${CLUSTER_NAME}
clickhouse:
  host: ${CLICKHOUSE_HOST}
  port: ${CLICKHOUSE_PORT}
```

**❌ Bad:**
```yaml
image: 123456789012.dkr.ecr.ap-south-1.amazonaws.com/otel-collector:0.114.0
endpoint: https://prometheus-prod.example.com/api/v1/write
cluster: example-eks-cluster-prod
clickhouse:
  host: 10.251.10.172
  port: 8124
```

### 4. Version Control

All configs live in git - **the repo is the single source of truth**.

**Rules:**
- ✅ Commit all configuration files
- ✅ Use meaningful commit messages
- ✅ Tag releases (e.g., `v1.0.0-production`)
- ❌ Never store actual secrets (use placeholders)
- ❌ Never store generated files (.terraform/)

---

## Working with Configurations

### Deploying Configurations

**From Laptop (where Claude runs):**

1. **Edit config files** in git repo under `configs/`
2. **Use scripts** from `scripts/` directory (parameterized for environment)
3. **Upload to S3** for bastion transfer
4. **Execute on bastion** (copy/paste commands)

**Example workflow:**

```bash
# 1. On Laptop - Edit config
vim configs/production/k8s/observability/jaeger/deployment.yaml

# 2. Use deployment script (takes environment as parameter)
./scripts/deploy.sh --env production --service k8s/observability/jaeger

# Or manually: Generate actual config (replace placeholders)
export ECR_REGISTRY="123456789012.dkr.ecr.ap-south-1.amazonaws.com"
export JAEGER_VERSION="v2.14.1"
export CLUSTER_NAME="example-eks-cluster-prod"
export ES_ENDPOINT="https://10.254.0.186:9200"

envsubst < configs/production/k8s/observability/jaeger/deployment.yaml \
  > /tmp/jaeger-deployment-prod.yaml

# 3. Upload to S3
aws s3 cp /tmp/jaeger-deployment-prod.yaml s3://example-bucket/jaeger/

# 4. On Bastion - Download and apply
aws s3 cp s3://example-bucket/jaeger/jaeger-deployment-prod.yaml .
kubectl apply -f jaeger-deployment-prod.yaml -n observability
```

### Updating Configurations

**ALWAYS backup before changes:**

```bash
# Backup current state
kubectl get deployment jaeger -n tracing -o yaml \
  > jaeger-deployment-backup-$(date +%Y%m%d-%H%M).yaml

# Apply changes
kubectl apply -f jaeger-deployment-new.yaml -n tracing

# Rollback if needed
kubectl apply -f jaeger-deployment-backup-YYYYMMDD-HHMM.yaml -n tracing
```

---

## Configuration Templates

### Creating a New Service

**Steps:**

1. Create directory structure:
   ```bash
   mkdir -p configs/{dev,test,staging,production}/k8s/{namespace}/{service}
   ```

2. Add base configuration files:
   ```bash
   # For each environment
   touch configs/production/k8s/observability/new-service/deployment.yaml
   touch configs/production/k8s/observability/new-service/service.yaml
   touch configs/production/k8s/observability/new-service/configmap.yaml
   ```

3. Use placeholders for environment-specific values

4. Document in `configs/README.md`

### Reusing Configurations Across Environments

**Option A: Copy and Modify**
```bash
# Copy dev config to test
cp -r configs/dev/k8s/observability/service configs/test/k8s/observability/

# Update test-specific values
vim configs/test/k8s/observability/service/deployment.yaml
```

**Option B: Use Helm/Kustomize**
- Create base configuration
- Use overlays for environment-specific changes
- More advanced, but more maintainable

---

## Common Patterns

### Pattern 1: Multi-Environment Service

```
configs/
├── dev/
│   └── k8s/
│       └── observability/
│           └── otel-collector/
│               ├── values.yaml          # Dev-specific values
│               ├── deployment.yaml
│               └── configmap.yaml
├── test/
│   └── k8s/
│       └── observability/
│           └── otel-collector/
│               ├── values.yaml          # Test-specific values
│               ├── deployment.yaml
│               └── configmap.yaml
└── production/
    └── k8s/
        └── observability/
            └── otel-collector/
                ├── values.yaml          # Production-specific values
                ├── deployment.yaml
                └── configmap.yaml
```

### Pattern 2: Shared Configurations

```
configs/
├── shared/
│   ├── iam/
│   │   ├── otel-collector-role.json    # IAM role (all envs)
│   │   └── monitoring-policy.json      # IAM policy (all envs)
│   └── secrets/
│       └── es-credentials-template.yaml # Secret template
└── production/
    └── k8s/
        └── ...
```

### Pattern 3: EC2 Services

```
configs/
└── production/
    └── ec2/
        ├── elasticsearch/
        │   ├── config/
        │   │   ├── elasticsearch.yml
        │   │   ├── jvm.options
        │   │   └── log4j2.properties
        │   └── setup/
        │       ├── install.sh
        │       ├── configure.sh
        │       └── systemd/
        │           └── elasticsearch.service
        └── kibana/
            ├── config/
            │   └── kibana.yml
            └── setup/
                └── install.sh
```

---

## Multi-Environment Consistency

### Purpose

When deploying the same service across multiple environments (dev → test → production), maintain consistency by copying working configurations and customizing only environment-specific values.

### Workflow: Copy and Customize

**Instead of:** Creating configurations from scratch or exports for each environment

**Do this:** Copy a proven reference environment and customize systematically

**Steps:**

1. **Identify Reference Environment**
   - Use the most recently deployed/tested environment (usually dev or test)
   - Ensure reference config is working and verified

2. **Copy Configuration Files**
   ```bash
   # Example: Deploy to test using dev as reference
   cp configs/dev/k8s/observability/otel-collector.yaml \
      configs/test/k8s/observability/otel-collector.yaml

   # Or copy entire service directory
   cp -r configs/dev/k8s/observability/service-name \
         configs/test/k8s/observability/
   ```

3. **Customize Environment-Specific Values**

   Use `sed` for bulk replacements:
   ```bash
   # In the new environment's files
   cd configs/test/k8s/observability/

   # Replace cluster labels
   sed -i 's/cluster: example-eks-cluster-dev/cluster: example-eks-cluster-test/g' *.yaml

   # Replace environment labels
   sed -i 's/environment: dev/environment: test/g' *.yaml

   # Replace ECR registry (account-specific)
   sed -i 's/747030889179/877559199145/g' *.yaml

   # Replace other environment-specific values
   sed -i 's/prometheus-dev/prometheus-test/g' *.yaml
   ```

4. **Verify Changes with Diff**

   **Critical:** Always diff to confirm only expected changes:
   ```bash
   diff -u configs/dev/k8s/observability/service.yaml \
           configs/test/k8s/observability/service.yaml
   ```

   **Expected differences only:**
   - ✅ Cluster name/labels (`dev` → `test`)
   - ✅ Environment labels (`dev` → `test`)
   - ✅ ECR registry (different AWS account IDs)
   - ✅ Endpoint URLs (environment-specific)
   - ❌ **Anything else is unexpected** - investigate!

5. **Document Improvements**

   If the new environment has better configuration than the reference:
   - Track in `TRACKER.md` under "Improvements to Backport"
   - Apply back to reference environment later
   - Example:
     ```markdown
     ## Improvements to Backport

     | # | Improvement | From → To | Status | Notes |
     |---|-------------|-----------|--------|-------|
     | 1 | Add serviceaccounts RBAC | Test → Dev | Pending | More complete permissions |
     ```

### Installation SOPs: Learn From Previous Environments

**Critical Pattern**: When installing the same system across multiple environments (dev → test → uat → prod), create an **Installation SOP** during the first environment and reuse it for subsequent environments.

**Problem This Solves:**

❌ **Without Installation SOPs:**
- Start fresh for each environment installation
- Encounter same issues on dev, test, UAT, prod repeatedly
- Re-discover solutions each time
- Waste hours debugging identical problems
- No knowledge transfer between environments

✅ **With Installation SOPs:**
- Document installation process during first environment (dev)
- Copy and improve SOP for each subsequent environment
- Learn from blockers and issues encountered
- Accelerate subsequent installations (test, UAT, prod)
- Build institutional knowledge

**Workflow:**

**1. First Environment (Dev):**

Create detailed installation runbook:

```markdown
# RUNBOOK-01-Kafka-Installation-Dev.md

## Environment: dev
## Date: 2026-02-18
## Objective: Install Kafka cluster on dev environment

### Pre-requisites
- [x] EKS cluster ready: example-eks-cluster-dev
- [x] IAM roles created: kafka-service-account-role
- [x] S3 bucket exists: example-dev-kafka-data

### Installation Steps

1. Create namespace
   bash
   kubectl create namespace kafka --context dev

   **Issue Encountered**: Namespace already existed
   **Resolution**: Used `kubectl get ns` to verify, proceeded

2. Apply Kafka operator
   bash
   kubectl apply -f configs/dev/k8s/kafka/operator.yaml

   **Issue Encountered**: CRD validation failed - version mismatch
   **Resolution**: Updated CRD to v1beta2, reapplied successfully

3. Deploy Kafka cluster
   bash
   kubectl apply -f configs/dev/k8s/kafka/kafka-cluster.yaml

   **Blocker**: Pods stuck in Pending - insufficient CPU
   **Resolution**: Reduced resource requests from 2CPU to 1CPU per pod
   **Learning**: Dev environment has limited resources

### Post-Installation Validation
- [x] All pods running: kubectl get pods -n kafka
- [x] Kafka accessible: telnet kafka-bootstrap.kafka.svc 9092
- [x] Created test topic successfully

### Issues & Resolutions Summary
1. ❌ CRD version mismatch → ✅ Updated to v1beta2
2. ❌ Resource constraints → ✅ Reduced CPU requests
3. ❌ NetworkPolicy blocking → ✅ Added ingress rule

### Time Taken: 3 hours
```

**2. Second Environment (Test):**

Copy dev SOP, apply learnings:

```markdown
# RUNBOOK-02-Kafka-Installation-Test.md

## Environment: test
## Date: 2026-02-19
## Based On: RUNBOOK-01-Kafka-Installation-Dev.md
## Objective: Install Kafka cluster on test environment

### Pre-requisites
- [x] EKS cluster ready: example-eks-cluster-test
- [x] IAM roles created: kafka-service-account-role
- [x] S3 bucket exists: example-test-kafka-data

### Installation Steps

**Learning from Dev**: Apply CRD v1beta2 directly (skip v1beta1)

1. Create namespace
   bash
   kubectl create namespace kafka --context test

   **Pre-emptive check**: Verified namespace doesn't exist first
   **Status**: ✅ Created successfully

2. Apply Kafka operator (v1beta2)
   bash
   kubectl apply -f configs/test/k8s/kafka/operator.yaml

   **Learning applied**: Used v1beta2 CRD from start
   **Status**: ✅ No CRD issues

3. Deploy Kafka cluster
   bash
   kubectl apply -f configs/test/k8s/kafka/kafka-cluster.yaml

   **Learning applied**: Set CPU requests to 1CPU (not 2CPU)
   **Status**: ✅ Pods started immediately

   **Learning applied**: Added NetworkPolicy ingress rule from start
   **Status**: ✅ No network issues

### Post-Installation Validation
- [x] All pods running
- [x] Kafka accessible
- [x] Test topic created

### Improvements Over Dev
1. ✅ No CRD version issues (started with v1beta2)
2. ✅ No resource constraints (used learnings)
3. ✅ No network issues (added policy proactively)

### Time Taken: 45 minutes (vs 3 hours in dev)
```

**3. Subsequent Environments (UAT, Prod):**

Continue improving SOP:
- Add any new learnings from test environment
- Document environment-specific differences
- Update known issues list
- Track time savings

**Key Principle:**

> **"The plan for new environment installation should be based on learnings from previous environment SOPs, not from internet research or starting fresh."**

**Benefits:**

| Aspect | Without SOPs | With SOPs |
|--------|-------------|-----------|
| **Time** | 3hrs per environment | 3hrs (first) + 45min (subsequent) |
| **Issues** | Same issues repeated | Issues resolved once |
| **Knowledge** | Lost between sessions | Documented and reusable |
| **Quality** | Inconsistent | Consistent and improving |
| **Onboarding** | Start from scratch | Read previous SOPs |

**See also:**
- [runbook-documentation.md](runbook-documentation.md) - How to document installation procedures
- [session-continuity.md](session-continuity.md) - Maintaining context across sessions

### Common Environment-Specific Values

Values that typically differ between environments:

| Value Type | Example | Pattern |
|------------|---------|---------|
| Cluster Labels | `example-eks-cluster-dev` | `example-eks-cluster-{env}` |
| Environment Labels | `environment: dev` | `environment: {env}` |
| ECR Registry | `123456789012.dkr.ecr...` | `{account-id}.dkr.ecr...` |
| Endpoint URLs | `prometheus-dev.example.com` | `prometheus-{env}.example.com` |
| Replica Counts | `replicas: 1` (dev) vs `replicas: 3` (prod) | Scale based on env |
| Resource Limits | Lower in dev, higher in prod | Adjust per environment needs |
| Namespace | `observability` | Usually same, but verify |

### Example: Full Workflow

Deploying kube-state-metrics from dev to test:

```bash
# 1. Copy dev config as starting point
cp configs/dev/k8s/kube-state-metrics.yaml \
   configs/test/k8s/kube-state-metrics.yaml

# 2. Customize for test environment
cd configs/test/k8s/
sed -i 's/example-eks-cluster-dev/example-eks-cluster-test/g' kube-state-metrics.yaml
sed -i 's/environment: dev/environment: test/g' kube-state-metrics.yaml
sed -i 's/747030889179/877559199145/g' kube-state-metrics.yaml

# 3. Verify only expected changes
diff -u ../dev/k8s/kube-state-metrics.yaml kube-state-metrics.yaml

# Expected output:
# -    cluster: example-eks-cluster-dev
# +    cluster: example-eks-cluster-test
# -    environment: dev
# +    environment: test
# -    image: 747030889179.dkr.ecr.ap-south-1.amazonaws.com/...
# +    image: 877559199145.dkr.ecr.ap-south-1.amazonaws.com/...

# 4. If verification passes, commit
git add configs/test/k8s/kube-state-metrics.yaml
git commit -m "feat: Add kube-state-metrics config for test environment"
```

### Benefits

**Consistency:**
- Same RBAC permissions across environments
- Same resource configurations
- Same annotations and labels (except environment-specific)
- No missing fields or components

**Efficiency:**
- Faster deployment preparation (seconds vs minutes)
- Less error-prone than manual creation
- Easy verification with diff

**Maintainability:**
- Single reference for "correct" configuration
- Clear diff shows environment-specific changes
- Improvements can flow both directions

### Anti-Patterns to Avoid

**❌ Creating from scratch for each environment**
- Risk of missing RBAC rules, annotations, or fields
- Wastes time recreating known-good configs

**❌ Creating from kubectl exports without reference**
- Exports may have cluster-specific runtime state
- Hard to know what's intentional vs auto-generated

**❌ Not verifying with diff**
- May introduce unintended differences
- Hard to debug inconsistencies later

**❌ Not tracking improvements**
- Better configs in newer environments get lost
- Reference environments become stale

### When to Backport Improvements

If you discover during deployment that:
1. New environment has better/more complete config
2. Reference environment is missing something
3. Configuration has evolved since reference was created

**Action:** Track and backport to maintain consistency

---

## Best Practices

### 1. Keep It Simple

- Flat structure within service directories
- Avoid deep nesting
- Group related files together

### 2. Use Descriptive Names

- File names should indicate what they configure
- Example: `otel-collector-daemonset.yaml` not `ds.yaml`

### 3. Document Placeholders

In each config directory, add a `README.md`:

```markdown
# OTel Collector Configuration

## Placeholders

- `${ECR_REGISTRY}`: ECR registry URL (e.g., 123456789012.dkr.ecr.ap-south-1.amazonaws.com)
- `${OTEL_VERSION}`: OTel Collector version (e.g., 0.114.0)
- `${CLUSTER_NAME}`: Cluster identifier (e.g., example-eks-cluster-prod)
- `${PROMETHEUS_ENDPOINT}`: Prometheus remote_write endpoint

## Deployment

[Instructions for deploying this configuration]
```

### 4. Version Everything

- Tag releases: `git tag v1.0.0-production`
- Document changes in commit messages
- Link configs to deployment runbooks

### 5. Test Before Production

- Always test configurations in dev/test first
- Use dry-run mode: `kubectl apply --dry-run=client`
- Validate YAML syntax before applying

---

## Tools and Helpers

### Placeholder Replacement

**Using `envsubst`:**
```bash
export ECR_REGISTRY="123456789012.dkr.ecr.ap-south-1.amazonaws.com"
export OTEL_VERSION="0.114.0"

envsubst < deployment-template.yaml > deployment.yaml
```

**Using `sed`:**
```bash
sed -e "s/\${ECR_REGISTRY}/123456789012.dkr.ecr.ap-south-1.amazonaws.com/g" \
    -e "s/\${OTEL_VERSION}/0.114.0/g" \
    deployment-template.yaml > deployment.yaml
```

### Configuration Validation

**Kubernetes:**
```bash
# Validate YAML syntax
kubectl apply --dry-run=client -f deployment.yaml

# Check against cluster
kubectl apply --dry-run=server -f deployment.yaml
```

**Helm:**
```bash
# Lint chart
helm lint ./chart

# Template and check
helm template ./chart --values values.yaml
```

---

## Troubleshooting

### Issue: Placeholder Not Replaced

**Problem:** `${ECR_REGISTRY}` appears in deployed config

**Solution:** Ensure environment variable is set before `envsubst`:
```bash
echo $ECR_REGISTRY  # Should show value, not empty
```

### Issue: Wrong Configuration Applied

**Problem:** Deployed dev config to production

**Solution:**
1. Immediately rollback: `kubectl rollback deployment/...`
2. Use namespace checks in scripts
3. Add environment labels to all resources

### Issue: Configuration Drift

**Problem:** Config in cluster doesn't match git

**Solution:**
1. Export current config: `kubectl get deployment -o yaml > current.yaml`
2. Compare with git: `diff current.yaml configs/prod/.../deployment.yaml`
3. Update git or reapply from git

---

## Examples

See example project for real-world examples:
- `configs/dev/k8s/` - Development configurations
- `configs/monitoring/k8s/` - Monitoring account configurations
- `configs/production/ec2/` - EC2 service configurations

---

## Related Practices

- **[documentation-standards.md](documentation-standards.md)** - Overall repository organization
- **[air-gapped-workflow.md](air-gapped-workflow.md)** - Deploying configurations in air-gapped environments
- **[standard-workflow.md](standard-workflow.md)** - Deploying configurations with direct access
- **[git-practices.md](git-practices.md)** - Version control and backup best practices

---

## Summary

**Key Principles:**
1. **Separate concerns**: `configs/` (declarative state), `scripts/` (automation), `docs/` (knowledge)
2. **Environment-first under configs**: `configs/$env/$service/`
3. **Reusable scripts**: Scripts take `--env` parameter, not duplicated per environment
4. **Shared docs**: Documentation centralized in `docs/`, not scattered per environment
5. **Service types**: `k8s/`, `ecs/`, `rds/`, `ec2/`, `terraform/`, `helm-values/`, etc.

**Remember:** Configurations are code - treat them with the same care!

---

**Maintained By**: Infrastructure Team
**Last Updated**: 2026-02-18
**Version**: 2.2.0
