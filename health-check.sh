#!/bin/bash
#
# MCP Server Health Check
#
# Tests that the DevOps Practices MCP server is properly configured
# and can load all practices and templates.
#
# Usage: bash health-check.sh
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
TOTAL_CHECKS=0
PASSED_CHECKS=0
FAILED_CHECKS=0

# Function to print section header
print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo
}

# Function to print success
print_success() {
    echo -e "${GREEN}✅ $1${NC}"
    PASSED_CHECKS=$((PASSED_CHECKS + 1))
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
}

# Function to print failure
print_failure() {
    echo -e "${RED}❌ $1${NC}"
    FAILED_CHECKS=$((FAILED_CHECKS + 1))
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
}

# Function to print info
print_info() {
    echo -e "${YELLOW}ℹ️  $1${NC}"
}

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

print_header "DevOps Practices MCP Health Check"

# Check 1: Directory structure
print_info "Checking directory structure..."
if [ -d "practices" ]; then
    print_success "practices/ directory exists"
else
    print_failure "practices/ directory not found"
fi

if [ -d "templates" ]; then
    print_success "templates/ directory exists"
else
    print_failure "templates/ directory not found"
fi

if [ -d "config" ]; then
    print_success "config/ directory exists"
else
    print_failure "config/ directory not found"
fi

if [ -d "tools" ]; then
    print_success "tools/ directory exists"
else
    print_info "tools/ directory not found (optional)"
fi

echo

# Check 2: MCP server file
print_info "Checking MCP server file..."
if [ -f "mcp-server.py" ]; then
    print_success "mcp-server.py exists"

    # Check if executable
    if [ -x "mcp-server.py" ]; then
        print_success "mcp-server.py is executable"
    else
        print_failure "mcp-server.py is not executable (chmod +x mcp-server.py)"
    fi
else
    print_failure "mcp-server.py not found"
fi

if [ -f "requirements.txt" ]; then
    print_success "requirements.txt exists"
else
    print_failure "requirements.txt not found"
fi

echo

# Check 3: Python dependencies
print_info "Checking Python environment..."

if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
    print_success "Python 3 installed (version $PYTHON_VERSION)"
else
    print_failure "Python 3 not found in PATH"
fi

echo

# Check 4: Practice files
print_info "Checking practice files..."

EXPECTED_PRACTICES=(
    "01-01-session-continuity.md"
    "01-02-task-tracking.md"
    "01-03-efficiency-guidelines.md"
    "02-01-git-practices.md"
    "02-02-issue-tracking.md"
    "03-01-configuration-management.md"
    "03-02-air-gapped-workflow.md"
    "03-03-standard-workflow.md"
    "04-01-documentation-standards.md"
    "04-02-readme-maintenance.md"
    "04-03-runbook-documentation.md"
)

PRACTICE_COUNT=0
MISSING_PRACTICES=()

for practice in "${EXPECTED_PRACTICES[@]}"; do
    if [ -f "practices/$practice" ]; then
        PRACTICE_COUNT=$((PRACTICE_COUNT + 1))
    else
        MISSING_PRACTICES+=("$practice")
    fi
done

if [ ${#MISSING_PRACTICES[@]} -eq 0 ]; then
    print_success "All $PRACTICE_COUNT expected practices found"
else
    print_failure "Missing ${#MISSING_PRACTICES[@]} practices: ${MISSING_PRACTICES[*]}"
fi

# Count total practices
TOTAL_PRACTICES=$(ls practices/*.md 2>/dev/null | wc -l)
print_info "Total practice files: $TOTAL_PRACTICES"

echo

# Check 5: Template files
print_info "Checking template files..."

EXPECTED_TEMPLATES=(
    "TRACKER-template.md"
    "CURRENT-STATE-template.md"
    "CLAUDE-template.md"
    "RUNBOOK-template.md"
    "ISSUE-TEMPLATE.md"
    "ISSUES.md"
    "issues-README.md"
)

TEMPLATE_COUNT=0
MISSING_TEMPLATES=()

for template in "${EXPECTED_TEMPLATES[@]}"; do
    if [ -f "templates/$template" ]; then
        TEMPLATE_COUNT=$((TEMPLATE_COUNT + 1))
    else
        MISSING_TEMPLATES+=("$template")
    fi
done

if [ ${#MISSING_TEMPLATES[@]} -eq 0 ]; then
    print_success "All $TEMPLATE_COUNT expected templates found"
else
    print_failure "Missing ${#MISSING_TEMPLATES[@]} templates: ${MISSING_TEMPLATES[*]}"
fi

# Count total templates
TOTAL_TEMPLATES=$(ls templates/*.md 2>/dev/null | wc -l)
print_info "Total template files: $TOTAL_TEMPLATES"

echo

# Check 6: Tool scripts (optional)
print_info "Checking tool scripts..."

if [ -f "tools/issue-manager.sh" ]; then
    print_success "tools/issue-manager.sh exists"

    # Check if executable
    if [ -x "tools/issue-manager.sh" ]; then
        print_success "tools/issue-manager.sh is executable"
    else
        print_info "tools/issue-manager.sh is not executable (chmod +x tools/issue-manager.sh)"
    fi
else
    print_info "tools/issue-manager.sh not found (optional advanced feature)"
fi

echo

# Check 8: Test MCP server can load
print_info "Testing MCP server loading..."

if python3 -c "
import sys
import os
sys.path.insert(0, '.')

try:
    # Import and instantiate server (but don't run it)
    from pathlib import Path

    # Read the file content
    mcp_server_path = os.path.abspath('mcp-server.py')
    with open(mcp_server_path, 'r') as f:
        code = f.read()

    # Compile to check syntax
    compile(code, 'mcp-server.py', 'exec')

    # Test if we can import the MCPServer class
    namespace = {
        '__file__': mcp_server_path,
        '__name__': 'mcp_server_test'  # Not '__main__' to avoid running the server
    }
    exec(code, namespace)

    # Try to instantiate the server class (without running it)
    if 'MCPServer' in namespace:
        server = namespace['MCPServer']()
        print('Server code can be loaded and instantiated')
    else:
        raise Exception('MCPServer class not found')

except Exception as e:
    print(f'Error: {e}')
    sys.exit(1)
" 2>&1 | grep -q "Server code can be loaded and instantiated"; then
    print_success "MCP server code can be loaded"
else
    print_failure "MCP server failed to load (check Python syntax)"
fi

echo

# Check 9: Test practices can be loaded
print_info "Testing practice loading..."

LOAD_TEST=$(python3 << 'EOF'
import sys
from pathlib import Path

BASE_DIR = Path('.')
PRACTICES_DIR = BASE_DIR / 'practices'

try:
    practice_count = 0
    for file_path in PRACTICES_DIR.glob('*.md'):
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
            if len(content) > 0:
                practice_count += 1

    print(f"SUCCESS:{practice_count}")
except Exception as e:
    print(f"ERROR:{e}")
    sys.exit(1)
EOF
)

if echo "$LOAD_TEST" | grep -q "SUCCESS"; then
    LOADED_COUNT=$(echo "$LOAD_TEST" | cut -d: -f2)
    print_success "Successfully loaded $LOADED_COUNT practices"
else
    ERROR_MSG=$(echo "$LOAD_TEST" | cut -d: -f2)
    print_failure "Failed to load practices: $ERROR_MSG"
fi

echo

# Check 10: Test templates can be loaded
print_info "Testing template loading..."

TEMPLATE_LOAD_TEST=$(python3 << 'EOF'
import sys
from pathlib import Path

BASE_DIR = Path('.')
TEMPLATES_DIR = BASE_DIR / 'templates'

try:
    template_count = 0
    for file_path in TEMPLATES_DIR.glob('*.md'):
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
            if len(content) > 0:
                template_count += 1

    print(f"SUCCESS:{template_count}")
except Exception as e:
    print(f"ERROR:{e}")
    sys.exit(1)
EOF
)

if echo "$TEMPLATE_LOAD_TEST" | grep -q "SUCCESS"; then
    LOADED_TEMPLATE_COUNT=$(echo "$TEMPLATE_LOAD_TEST" | cut -d: -f2)
    print_success "Successfully loaded $LOADED_TEMPLATE_COUNT templates"
else
    TEMPLATE_ERROR_MSG=$(echo "$TEMPLATE_LOAD_TEST" | cut -d: -f2)
    print_failure "Failed to load templates: $TEMPLATE_ERROR_MSG"
fi

echo

# Check 11: Documentation files
print_info "Checking documentation files..."

if [ -f "README.md" ]; then
    print_success "README.md exists"
else
    print_failure "README.md not found"
fi

if [ -f "SETUP.md" ]; then
    print_success "SETUP.md exists"
else
    print_info "SETUP.md not found (optional)"
fi

echo

# Summary
print_header "Health Check Summary"

echo "Total checks: $TOTAL_CHECKS"
echo -e "${GREEN}Passed: $PASSED_CHECKS${NC}"
echo -e "${RED}Failed: $FAILED_CHECKS${NC}"
echo

if [ $FAILED_CHECKS -eq 0 ]; then
    echo -e "${GREEN}🎉 All health checks passed!${NC}"
    echo
    echo "MCP Server Status: ✅ HEALTHY"
    echo
    echo "Next steps:"
    echo "  1. Start MCP server: python3 mcp-server.py"
    echo "  2. Test with Claude: 'List available DevOps practices'"
    echo "  3. Roll out to projects"
    exit 0
else
    echo -e "${RED}⚠️  Some health checks failed${NC}"
    echo
    echo "MCP Server Status: ❌ UNHEALTHY"
    echo
    echo "Please fix the issues above before deploying."
    exit 1
fi
