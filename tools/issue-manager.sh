#!/bin/bash
#
# Issue Manager - CLI tool for managing project issues
# Usage: ./issue-manager.sh [command] [options]
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
ISSUES_DIR="$PROJECT_ROOT/issues"
ISSUES_INDEX="$PROJECT_ROOT/ISSUES.md"

# Helper functions
error() {
    echo -e "${RED}ERROR: $1${NC}" >&2
    exit 1
}

success() {
    echo -e "${GREEN}$1${NC}"
}

warning() {
    echo -e "${YELLOW}$1${NC}"
}

info() {
    echo -e "${BLUE}$1${NC}"
}

# Get next issue number
get_next_issue_number() {
    local last_issue=$(ls -1 "$ISSUES_DIR"/ISSUE-*.md 2>/dev/null | sort -V | tail -1 | sed 's/.*ISSUE-0*\([0-9]*\).*/\1/')
    if [ -z "$last_issue" ]; then
        echo "001"
    else
        printf "%03d" $((10#$last_issue + 1))
    fi
}

# List issues
cmd_list() {
    local status_filter=""
    local priority_filter=""
    local type_filter=""

    while [[ $# -gt 0 ]]; do
        case $1 in
            --status)
                status_filter="$2"
                shift 2
                ;;
            --priority)
                priority_filter="$2"
                shift 2
                ;;
            --type)
                type_filter="$2"
                shift 2
                ;;
            *)
                error "Unknown option: $1"
                ;;
        esac
    done

    info "Listing issues..."
    echo ""

    for issue_file in "$ISSUES_DIR"/ISSUE-*.md; do
        [ -f "$issue_file" ] || continue

        local issue_num=$(basename "$issue_file" .md | sed 's/ISSUE-//')
        local title=$(grep "^# ISSUE-" "$issue_file" | sed 's/^# ISSUE-[0-9]*: //')
        local status=$(grep "^**Status**:" "$issue_file" | sed 's/^**Status**: //')
        local priority=$(grep "^**Priority**:" "$issue_file" | sed 's/^**Priority**: //')
        local type=$(grep "^**Type**:" "$issue_file" | sed 's/^**Type**: //')

        # Apply filters
        if [ -n "$status_filter" ] && [ "$status" != "$status_filter" ]; then
            continue
        fi
        if [ -n "$priority_filter" ] && [ "$priority" != "$priority_filter" ]; then
            continue
        fi
        if [ -n "$type_filter" ] && [ "$type" != "$type_filter" ]; then
            continue
        fi

        # Color code by status
        local status_color="$NC"
        case "$status" in
            "Open") status_color="$YELLOW" ;;
            "In Progress") status_color="$BLUE" ;;
            "Blocked") status_color="$RED" ;;
            "Resolved") status_color="$GREEN" ;;
            "Closed") status_color="$NC" ;;
        esac

        printf "%-10s ${status_color}%-15s${NC} %-10s %-20s %s\n" \
            "ISSUE-$issue_num" "$status" "$priority" "$type" "$title"
    done
}

# Show issue details
cmd_show() {
    local issue_num="$1"
    [ -z "$issue_num" ] && error "Issue number required. Usage: show ISSUE-001"

    # Remove ISSUE- prefix if provided
    issue_num=$(echo "$issue_num" | sed 's/ISSUE-//')

    # Pad to 3 digits
    issue_num=$(printf "%03d" "$issue_num")

    local issue_file="$ISSUES_DIR/ISSUE-$issue_num.md"
    [ ! -f "$issue_file" ] && error "Issue ISSUE-$issue_num not found"

    cat "$issue_file"
}

# Create new issue
cmd_create() {
    info "Creating new issue..."
    echo ""

    local issue_num=$(get_next_issue_number)
    info "Issue number: ISSUE-$issue_num"
    echo ""

    # Prompt for details
    read -p "Title: " title
    [ -z "$title" ] && error "Title is required"

    echo "Type: 1) Bug  2) Feature  3) Task  4) Deployment  5) Documentation  6) Technical Debt  7) Improvement"
    read -p "Select type (1-7): " type_choice
    case "$type_choice" in
        1) type="Bug" ;;
        2) type="Feature" ;;
        3) type="Task" ;;
        4) type="Deployment" ;;
        5) type="Documentation" ;;
        6) type="Technical Debt" ;;
        7) type="Improvement" ;;
        *) error "Invalid type" ;;
    esac

    echo "Priority: 1) Critical  2) High  3) Medium  4) Low"
    read -p "Select priority (1-4): " priority_choice
    case "$priority_choice" in
        1) priority="Critical" ;;
        2) priority="High" ;;
        3) priority="Medium" ;;
        4) priority="Low" ;;
        *) error "Invalid priority" ;;
    esac

    read -p "Assigned to (or press Enter for Unassigned): " assigned
    [ -z "$assigned" ] && assigned="Unassigned"

    read -p "Description: " description

    local today=$(date +%Y-%m-%d)
    local issue_file="$ISSUES_DIR/ISSUE-$issue_num.md"

    # Create issue file
    cat > "$issue_file" <<EOF
# ISSUE-$issue_num: $title

**Status**: Open
**Type**: $type
**Priority**: $priority
**Created**: $today
**Updated**: $today
**Assigned**: $assigned
**Related**: None

## Description

$description

## Context

[Add background information and context]

## Tasks

- [ ] Task 1
- [ ] Task 2

## Related Files

- [file1.yaml](../path/to/file1.yaml)

## Notes

[Additional notes]

## Resolution

[To be filled when resolved]

---

**History**:
- $today: Created
EOF

    success "Created issue: ISSUE-$issue_num"
    info "File: $issue_file"
    echo ""
    warning "Don't forget to:"
    echo "  1. Edit the issue file to add details"
    echo "  2. Add entry to ISSUES.md"
}

# Update issue status
cmd_update() {
    local issue_num="$1"
    shift

    [ -z "$issue_num" ] && error "Issue number required. Usage: update ISSUE-001 --status resolved"

    # Remove ISSUE- prefix if provided
    issue_num=$(echo "$issue_num" | sed 's/ISSUE-//')
    issue_num=$(printf "%03d" "$issue_num")

    local issue_file="$ISSUES_DIR/ISSUE-$issue_num.md"
    [ ! -f "$issue_file" ] && error "Issue ISSUE-$issue_num not found"

    local status=""

    while [[ $# -gt 0 ]]; do
        case $1 in
            --status)
                status="$2"
                shift 2
                ;;
            *)
                error "Unknown option: $1"
                ;;
        esac
    done

    [ -z "$status" ] && error "Status required. Usage: update ISSUE-001 --status resolved"

    # Validate status
    case "$status" in
        open|Open) status="Open" ;;
        in_progress|"In Progress") status="In Progress" ;;
        blocked|Blocked) status="Blocked" ;;
        resolved|Resolved) status="Resolved" ;;
        closed|Closed) status="Closed" ;;
        *) error "Invalid status. Valid: Open, In Progress, Blocked, Resolved, Closed" ;;
    esac

    # Update status in file
    local today=$(date +%Y-%m-%d)
    sed -i "s/^\*\*Status\*\*: .*$/\*\*Status\*\*: $status/" "$issue_file"
    sed -i "s/^\*\*Updated\*\*: .*$/\*\*Updated\*\*: $today/" "$issue_file"

    # Add to history
    echo "- $today: Status changed to $status" >> "$issue_file"

    success "Updated ISSUE-$issue_num status to: $status"
    warning "Don't forget to update ISSUES.md to reflect the change"
}

# Search issues
cmd_search() {
    local query="$1"
    [ -z "$query" ] && error "Search query required. Usage: search 'keyword'"

    info "Searching for: $query"
    echo ""

    grep -r -i -l "$query" "$ISSUES_DIR"/ISSUE-*.md | while read issue_file; do
        local issue_num=$(basename "$issue_file" .md | sed 's/ISSUE-//')
        local title=$(grep "^# ISSUE-" "$issue_file" | sed 's/^# ISSUE-[0-9]*: //')
        local status=$(grep "^**Status**:" "$issue_file" | sed 's/^**Status**: //')

        printf "%-10s %-15s %s\n" "ISSUE-$issue_num" "$status" "$title"

        # Show matching lines
        grep -i -n --color=always "$query" "$issue_file" | head -3
        echo ""
    done
}

# Stats
cmd_stats() {
    info "Issue Statistics"
    echo ""

    local total=0
    local open=0
    local in_progress=0
    local blocked=0
    local resolved=0
    local closed=0

    for issue_file in "$ISSUES_DIR"/ISSUE-*.md; do
        [ -f "$issue_file" ] || continue
        ((total++))

        local status=$(grep "^**Status**:" "$issue_file" | sed 's/^**Status**: //')
        case "$status" in
            "Open") ((open++)) ;;
            "In Progress") ((in_progress++)) ;;
            "Blocked") ((blocked++)) ;;
            "Resolved") ((resolved++)) ;;
            "Closed") ((closed++)) ;;
        esac
    done

    echo "Total Issues:      $total"
    echo "Open:              $open"
    echo "In Progress:       $in_progress"
    echo "Blocked:           $blocked"
    echo "Resolved:          $resolved"
    echo "Closed:            $closed"
    echo ""
    echo "Active (Open+In Progress+Blocked): $((open + in_progress + blocked))"
}

# Help
cmd_help() {
    cat <<EOF
Issue Manager - CLI tool for managing project issues

USAGE:
    ./issue-manager.sh [COMMAND] [OPTIONS]

COMMANDS:
    list [OPTIONS]              List all issues
        --status STATUS         Filter by status (Open, In Progress, Blocked, Resolved, Closed)
        --priority PRIORITY     Filter by priority (Critical, High, Medium, Low)
        --type TYPE             Filter by type (Bug, Feature, Task, etc.)

    show ISSUE-NUM              Show details of an issue

    create                      Create a new issue (interactive)

    update ISSUE-NUM [OPTIONS]  Update an issue
        --status STATUS         Update issue status

    search QUERY                Search issues by keyword

    stats                       Show issue statistics

    help                        Show this help message

EXAMPLES:
    # List all open issues
    ./issue-manager.sh list --status open

    # List all high priority issues
    ./issue-manager.sh list --priority high

    # Show issue details
    ./issue-manager.sh show ISSUE-001

    # Create new issue
    ./issue-manager.sh create

    # Update issue status
    ./issue-manager.sh update ISSUE-001 --status "in_progress"

    # Search for keyword
    ./issue-manager.sh search "prometheus"

    # Show statistics
    ./issue-manager.sh stats

FILES:
    issues/              Individual issue files
    ISSUES.md            Main issue index

NOTES:
    - After creating or updating issues, remember to update ISSUES.md
    - Use quotes around multi-word arguments
    - Issue numbers are automatically padded to 3 digits

EOF
}

# Main
main() {
    local command="${1:-help}"
    shift || true

    case "$command" in
        list)
            cmd_list "$@"
            ;;
        show)
            cmd_show "$@"
            ;;
        create)
            cmd_create "$@"
            ;;
        update)
            cmd_update "$@"
            ;;
        search)
            cmd_search "$@"
            ;;
        stats)
            cmd_stats "$@"
            ;;
        help|--help|-h)
            cmd_help
            ;;
        *)
            error "Unknown command: $command. Use 'help' for usage information."
            ;;
    esac
}

main "$@"
