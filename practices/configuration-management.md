# Configuration Management Practice

**Purpose**: Standards for organizing and managing environment-specific configurations across infrastructure projects.

**Goal**: Ensure clarity, reproducibility, and no ambiguity in configuration management.

---

## Directory Structure

All environment-specific configurations are stored in a structured hierarchy:

```
configs/
├── <environment>/                  # e.g., dev, test, staging, production
│   ├── k8s/                        # Kubernetes resources
│   │   ├── <namespace>/            # e.g., observability, tracing, monitoring
│   │   │   ├── <service>/          # e.g., jaeger, otel-collector, prometheus
│   │   │   │   ├── values.yaml     # Helm values or config
│   │   │   │   ├── deployment.yaml
│   │   │   │   ├── service.yaml
│   │   │   │   ├── configmap.yaml
│   │   │   │   └── ...
│   │   │   └── ...
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
│   └── shared/                     # Cross-cutting configs
│       ├── iam/                    # IAM policies, roles
│       ├── secrets/                # Secret templates (not actual secrets!)
│       ├── network/                # Security groups, NACLs
│       └── ...
└── ...
```

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

**Path:** `configs/production/k8s/tracing/jaeger/deployment.yaml`

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

### 1. Environment Isolation

Each environment is **fully self-contained** under its folder.

**✅ Good:**
```
configs/
├── production/
│   ├── k8s/
│   │   └── tracing/
│   │       └── jaeger/
│   │           └── deployment.yaml  # Production config
└── dev/
    ├── k8s/
    │   └── tracing/
    │       └── jaeger/
    │           └── deployment.yaml  # Dev config (different values)
```

**❌ Bad:**
```
configs/
└── k8s/
    └── tracing/
        └── jaeger/
            ├── deployment-prod.yaml  # Mixing environments
            └── deployment-dev.yaml   # Hard to manage
```

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
- `${CLUSTER_NAME}` - Cluster identifier (e.g., `example-eks-cluster-prod`)
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
cluster: example-eks-cluster-cluster-prod
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

1. **Edit config files** in git repo
2. **Replace placeholders** with actual values (via script or sed)
3. **Upload to S3** for bastion transfer
4. **Apply on bastion** (copy/paste commands)

**Example workflow:**

```bash
# 1. On Laptop - Edit config
vim configs/production/k8s/tracing/jaeger/deployment.yaml

# 2. Generate actual config (replace placeholders)
export ECR_REGISTRY="123456789012.dkr.ecr.ap-south-1.amazonaws.com"
export JAEGER_VERSION="v2.14.1"
export CLUSTER_NAME="example-eks-cluster-cluster-prod"
export ES_ENDPOINT="https://10.254.0.186:9200"

envsubst < configs/production/k8s/tracing/jaeger/deployment.yaml \
  > /tmp/jaeger-deployment-prod.yaml

# 3. Upload to S3
aws s3 cp /tmp/jaeger-deployment-prod.yaml s3://example-s3-bucket/jaeger/

# 4. On Bastion - Download and apply
aws s3 cp s3://example-s3-bucket/jaeger/jaeger-deployment-prod.yaml .
kubectl apply -f jaeger-deployment-prod.yaml -n tracing
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
- `${CLUSTER_NAME}`: Cluster identifier (e.g., example-eks-cluster-cluster-prod)
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

See example-project project for real-world examples:
- `configs/dev/k8s/` - Development configurations
- `configs/monitoring/k8s/` - Monitoring account configurations
- `configs/production/ec2/` - EC2 service configurations

---

## Related Practices

- **[documentation-standards.md](documentation-standards.md)** - configs/ directory location and purpose
- **[air-gapped-workflow.md](air-gapped-workflow.md)** - Deploying configurations in air-gapped environments
- **[standard-workflow.md](standard-workflow.md)** - Deploying configurations with direct access
- **[git-practices.md](git-practices.md)** - Version control and backup best practices

---

**Remember:** Configurations are code - treat them with the same care!

---

**Maintained By**: Infrastructure Team
**Last Updated**: 2026-02-13
**Version**: 1.0.0
