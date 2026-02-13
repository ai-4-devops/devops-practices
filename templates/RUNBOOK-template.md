# Session ${SESSION_NUMBER}: ${TITLE}

**Date:** ${DATE}
**Session ID:** ${SESSION_NUMBER}
**Duration:** ~X hours/minutes
**Cluster:** ${CLUSTER_NAME}
**User:** ${USER}
**Status:** ✅ Successful / ⚠️ Partial / ❌ Failed

---

## Objective

${OBJECTIVE_DESCRIPTION}

**Goals:**
- ${GOAL_1}
- ${GOAL_2}
- ${GOAL_3}

---

## Environment Context

**Bastion/System:**
- Access method: ${ACCESS_METHOD}
- User: `${USERNAME}@${HOSTNAME}`
- Working directory: `${WORKING_DIR}`
- Tools available: ${TOOLS}

**Target Environment:**
- Account: ${AWS_ACCOUNT}
- Cluster: ${CLUSTER_NAME}
- Namespace(s): ${NAMESPACES}
- Current state: ${CURRENT_STATE}

---

## Step-by-Step Execution

### Step 1: ${STEP_1_TITLE}

**Command:**
```bash
${COMMAND}
```

**Output:**
```
${OUTPUT}
```

✅ **Result:** ${RESULT_DESCRIPTION}

---

### Step 2: ${STEP_2_TITLE}

**Command:**
```bash
${COMMAND}
```

**Output:**
```
${OUTPUT}
```

✅ **Result:** ${RESULT_DESCRIPTION}

---

### Step 3: ${STEP_3_TITLE}

**Command:**
```bash
${COMMAND}
```

**Output:**
```
${OUTPUT}
```

✅ **Result:** ${RESULT_DESCRIPTION}

---

[Continue with all steps...]

---

## Issues Encountered

### Issue 1: ${ISSUE_TITLE}

**Problem:**
```
${ERROR_MESSAGE}
```

**Root Cause:**
${ROOT_CAUSE_DESCRIPTION}

**Resolution:**
1. ${RESOLUTION_STEP_1}
2. ${RESOLUTION_STEP_2}
3. ${RESOLUTION_STEP_3}

**Command:**
```bash
${RESOLUTION_COMMAND}
```

**Result:** ✅ ${RESOLUTION_RESULT}

---

[Add more issues as needed]

---

## Configuration Changes

### Change 1: ${CHANGE_TITLE}

**Before:**
```yaml
${BEFORE_CONFIG}
```

**After:**
```yaml
${AFTER_CONFIG}
```

**Reason:** ${CHANGE_REASON}

**Backup:** `${BACKUP_FILE_NAME}`

**Rollback Command:**
```bash
${ROLLBACK_COMMAND}
```

---

[Add more changes as needed]

---

## Verification

### 1. ${VERIFICATION_1_TITLE}

**Command:**
```bash
${VERIFICATION_COMMAND}
```

**Output:**
```
${VERIFICATION_OUTPUT}
```

✅ **Result:** ${VERIFICATION_RESULT}

---

### 2. ${VERIFICATION_2_TITLE}

**Command:**
```bash
${VERIFICATION_COMMAND}
```

**Output:**
```
${VERIFICATION_OUTPUT}
```

✅ **Result:** ${VERIFICATION_RESULT}

---

[Add more verification steps as needed]

---

## Summary

### ✅ Successfully Completed

1. ${ACCOMPLISHMENT_1}
2. ${ACCOMPLISHMENT_2}
3. ${ACCOMPLISHMENT_3}

### ⚠️ Partial/Issues

1. ${ISSUE_OR_INCOMPLETE_1}
2. ${ISSUE_OR_INCOMPLETE_2}

### 📊 Metrics

- Total pods deployed: ${POD_COUNT}
- Services configured: ${SERVICE_COUNT}
- Time taken: ${DURATION}
- Images uploaded: ${IMAGE_COUNT}

### 🔑 Key Learnings

1. ${LEARNING_1}
2. ${LEARNING_2}
3. ${LEARNING_3}

### 📋 Next Steps

1. ${NEXT_STEP_1}
2. ${NEXT_STEP_2}
3. ${NEXT_STEP_3}

**Dependencies:**
- ${DEPENDENCY_1}
- ${DEPENDENCY_2}

**Blockers:**
- ${BLOCKER_1}
- ${BLOCKER_2}

---

## Files Referenced

**Created:**
- `${CREATED_FILE_1}`
- `${CREATED_FILE_2}`

**Modified:**
- `${MODIFIED_FILE_1}`
- `${MODIFIED_FILE_2}`

**Uploaded (S3):**
- `s3://${BUCKET}/${FILE_1}`
- `s3://${BUCKET}/${FILE_2}`

**ECR Images:**
- `${ECR_IMAGE_1}`
- `${ECR_IMAGE_2}`

---

## Rollback Plan

If issues occur, rollback with:

```bash
# Step 1: Restore previous configuration
${ROLLBACK_COMMAND_1}

# Step 2: Verify rollback
${ROLLBACK_VERIFICATION_COMMAND}

# Step 3: Clean up failed deployment
${CLEANUP_COMMAND}
```

---

## Related Sessions

- **Previous:** ${PREVIOUS_SESSION_LINK}
- **Next:** ${NEXT_SESSION_LINK}
- **Related:** ${RELATED_SESSION_LINK}

---

## Technical Debt / Known Issues

| # | Issue | Severity | Status | Notes |
|---|-------|----------|--------|-------|
| 1 | ${ISSUE_1} | ${SEVERITY} | ${STATUS} | ${NOTES} |
| 2 | ${ISSUE_2} | ${SEVERITY} | ${STATUS} | ${NOTES} |

---

**Session Completed:** ${COMPLETION_TIMESTAMP}
**Status:** ✅ Successful / ⚠️ Partial / ❌ Failed
**Outcome:** ${OUTCOME_SUMMARY}

---

**Maintained By:** ${TEAM}
**Last Updated:** ${DATE}
