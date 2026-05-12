#!/bin/bash

# Stack Status - Display stack structure, PR status, and branch relationships
# Shows visual tree of stacked branches with commit counts and PR status

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
SHOW_DETAIL=false
SHOW_PR_STATUS=false
JSON_OUTPUT=false
ROOT_BRANCH=""

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo -e "${RED}Error: Not in a git repository${NC}"
  exit 1
fi

# Parse arguments
parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --detail)
        SHOW_DETAIL=true
        shift
        ;;
      --pr-status)
        SHOW_PR_STATUS=true
        shift
        ;;
      --json)
        JSON_OUTPUT=true
        shift
        ;;
      --help)
        show_help
        exit 0
        ;;
      *)
        if [[ -z "$ROOT_BRANCH" ]]; then
          ROOT_BRANCH="$1"
        else
          echo -e "${RED}Error: Unknown argument: $1${NC}"
          show_help
          exit 1
        fi
        shift
        ;;
    esac
  done
}

show_help() {
  cat << EOF
Stack Status - Display stack structure and PR status

Usage: stack-status.sh [root-branch] [options]

Arguments:
  root-branch     Base branch for stack (default: auto-detect from current branch)

Options:
  --detail        Show commit summaries for each branch
  --pr-status     Include GitHub PR status (requires gh CLI)
  --json          Output in JSON format
  --help          Show this help message

Examples:
  stack-status.sh                           # Auto-detect and show basic status
  stack-status.sh --detail                  # Show with commit details
  stack-status.sh main --pr-status          # Show with PR status
  stack-status.sh --detail --pr-status      # Show all details
  stack-status.sh main --json               # JSON output for scripting

Output:
  main (merged)
  ├─ feat/auth-base (PR #123: ✓ approved)
  │  └─ feat/auth-middleware (PR #124: under review)
  │     └─ feat/auth-api (PR #125: draft)

Requirements:
  - git
  - gh CLI (optional, for --pr-status)

EOF
}

# Check if gh CLI is available
has_gh_cli() {
  command -v gh &> /dev/null
}

# Get PR number for a branch
get_pr_number() {
  local branch="$1"
  if ! has_gh_cli; then
    echo ""
    return
  fi

  # Try to get PR number
  local pr_num=$(gh pr list --head "$branch" --json number --jq '.[0].number' 2>/dev/null || echo "")
  echo "$pr_num"
}

# Get PR status for a branch
get_pr_status() {
  local branch="$1"
  if ! has_gh_cli; then
    echo "unknown"
    return
  fi

  local pr_data=$(gh pr list --head "$branch" --json number,state,isDraft,reviewDecision 2>/dev/null || echo "")

  if [[ -z "$pr_data" || "$pr_data" == "[]" ]]; then
    echo "no-pr"
    return
  fi

  local state=$(echo "$pr_data" | jq -r '.[0].state' 2>/dev/null || echo "")
  local is_draft=$(echo "$pr_data" | jq -r '.[0].isDraft' 2>/dev/null || echo "false")
  local review_decision=$(echo "$pr_data" | jq -r '.[0].reviewDecision' 2>/dev/null || echo "")

  if [[ "$state" == "MERGED" ]]; then
    echo "merged"
  elif [[ "$is_draft" == "true" ]]; then
    echo "draft"
  elif [[ "$review_decision" == "APPROVED" ]]; then
    echo "approved"
  elif [[ "$review_decision" == "CHANGES_REQUESTED" ]]; then
    echo "changes-requested"
  elif [[ "$state" == "OPEN" ]]; then
    echo "in-review"
  else
    echo "unknown"
  fi
}

# Get base branch for a PR
get_pr_base() {
  local branch="$1"
  if ! has_gh_cli; then
    echo ""
    return
  fi

  gh pr list --head "$branch" --json baseRefName --jq '.[0].baseRefName' 2>/dev/null || echo ""
}

# Get commit count between branches
get_commit_count() {
  local from_branch="$1"
  local to_branch="$2"
  git rev-list --count "$from_branch..$to_branch" 2>/dev/null || echo "0"
}

# Get recent commits for a branch
get_commits() {
  local from_branch="$1"
  local to_branch="$2"
  git log "$from_branch..$to_branch" --oneline --no-decorate 2>/dev/null || echo ""
}

# Detect root branch (main or master)
detect_root_branch() {
  if git show-ref --verify --quiet refs/heads/main; then
    echo "main"
  elif git show-ref --verify --quiet refs/heads/master; then
    echo "master"
  else
    echo "main"
  fi
}

# Build stack structure recursively
build_stack() {
  local current_branch="$1"
  local indent="$2"
  local is_last="${3:-true}"
  local parent="${4:-}"

  # Get branch info
  local commit_count=0
  if [[ -n "$parent" ]]; then
    commit_count=$(get_commit_count "$parent" "$current_branch")
  fi

  # Get PR info
  local pr_num=""
  local pr_status=""
  local pr_display=""

  if [[ "$SHOW_PR_STATUS" == "true" ]]; then
    pr_num=$(get_pr_number "$current_branch")
    if [[ -n "$pr_num" ]]; then
      pr_status=$(get_pr_status "$current_branch")

      case "$pr_status" in
        merged)
          pr_display=" ${GREEN}(PR #$pr_num: ✓ merged)${NC}"
          ;;
        approved)
          pr_display=" ${GREEN}(PR #$pr_num: ✓ approved)${NC}"
          ;;
        in-review)
          pr_display=" ${YELLOW}(PR #$pr_num: under review)${NC}"
          ;;
        draft)
          pr_display=" ${CYAN}(PR #$pr_num: draft)${NC}"
          ;;
        changes-requested)
          pr_display=" ${RED}(PR #$pr_num: changes requested)${NC}"
          ;;
        no-pr)
          pr_display=" ${YELLOW}(no PR)${NC}"
          ;;
      esac
    else
      pr_display=" ${YELLOW}(no PR)${NC}"
    fi
  fi

  # Build tree connector
  local connector=""
  if [[ -n "$parent" ]]; then
    if [[ "$is_last" == "true" ]]; then
      connector="└─ "
    else
      connector="├─ "
    fi
  fi

  # Print branch info
  local branch_display="${BLUE}$current_branch${NC}"
  if [[ -n "$parent" ]]; then
    branch_display="$branch_display ${CYAN}(+$commit_count commits)${NC}"
  fi

  echo -e "${indent}${connector}${branch_display}${pr_display}"

  # Show commit details if requested
  if [[ "$SHOW_DETAIL" == "true" && -n "$parent" ]]; then
    local commits=$(get_commits "$parent" "$current_branch")
    if [[ -n "$commits" ]]; then
      local new_indent="$indent"
      if [[ "$is_last" == "true" ]]; then
        new_indent="${indent}    "
      else
        new_indent="${indent}│   "
      fi

      while IFS= read -r commit; do
        echo -e "${new_indent}${commit}"
      done <<< "$commits"
    fi
  fi

  # Find child branches
  local children=()
  local all_branches=$(git for-each-ref --format='%(refname:short)' refs/heads/)

  while IFS= read -r branch; do
    if [[ -n "$branch" && "$branch" != "$current_branch" ]]; then
      # Check if this branch's base is current_branch
      local base=$(get_pr_base "$branch")
      if [[ "$base" == "$current_branch" ]]; then
        children+=("$branch")
      fi
    fi
  done <<< "$all_branches"

  # Recursively process children
  local child_count=${#children[@]}
  for i in "${!children[@]}"; do
    local child="${children[$i]}"
    local new_indent="$indent"
    local child_is_last=false

    if [[ -n "$parent" ]]; then
      if [[ "$is_last" == "true" ]]; then
        new_indent="${indent}   "
      else
        new_indent="${indent}│  "
      fi
    fi

    if [[ $((i + 1)) -eq $child_count ]]; then
      child_is_last=true
    fi

    build_stack "$child" "$new_indent" "$child_is_last" "$current_branch"
  done
}

# Check for warnings
check_warnings() {
  local warnings=()

  # Check for diverged branches
  local all_branches=$(git for-each-ref --format='%(refname:short)' refs/heads/)

  while IFS= read -r branch; do
    if [[ -n "$branch" ]]; then
      # Check if branch has upstream
      local upstream=$(git rev-parse --abbrev-ref "$branch@{upstream}" 2>/dev/null || echo "")
      if [[ -n "$upstream" ]]; then
        local behind=$(git rev-list --count "$branch..$upstream" 2>/dev/null || echo "0")
        local ahead=$(git rev-list --count "$upstream..$branch" 2>/dev/null || echo "0")

        if [[ "$behind" -gt 0 ]]; then
          warnings+=("${YELLOW}⚠️  Branch $branch is $behind commits behind $upstream${NC}")
        fi
      fi

      # Check if PR target matches expected base
      if [[ "$SHOW_PR_STATUS" == "true" ]]; then
        local pr_base=$(get_pr_base "$branch")
        if [[ -n "$pr_base" ]]; then
          # Check if base branch still exists
          if ! git show-ref --verify --quiet "refs/heads/$pr_base"; then
            warnings+=("${RED}⚠️  Branch $branch PR targets deleted branch: $pr_base${NC}")
          fi
        fi
      fi
    fi
  done <<< "$all_branches"

  # Print warnings
  if [[ ${#warnings[@]} -gt 0 ]]; then
    echo ""
    echo -e "${YELLOW}Warnings:${NC}"
    for warning in "${warnings[@]}"; do
      echo -e "  $warning"
    done
  fi
}

# Main execution
main() {
  parse_args "$@"

  # Check for gh CLI if PR status requested
  if [[ "$SHOW_PR_STATUS" == "true" ]] && ! has_gh_cli; then
    echo -e "${YELLOW}Warning: gh CLI not found. Install it to see PR status.${NC}"
    echo -e "${YELLOW}Install: https://cli.github.com/${NC}"
    echo ""
    SHOW_PR_STATUS=false
  fi

  # Detect root branch if not specified
  if [[ -z "$ROOT_BRANCH" ]]; then
    ROOT_BRANCH=$(detect_root_branch)
  fi

  # Verify root branch exists
  if ! git show-ref --verify --quiet "refs/heads/$ROOT_BRANCH"; then
    echo -e "${RED}Error: Branch not found: $ROOT_BRANCH${NC}"
    exit 1
  fi

  # JSON output
  if [[ "$JSON_OUTPUT" == "true" ]]; then
    echo -e "${RED}Error: JSON output not yet implemented${NC}"
    exit 1
  fi

  # Display stack
  echo -e "${BLUE}Stack structure from ${YELLOW}$ROOT_BRANCH${BLUE}:${NC}"
  echo ""

  build_stack "$ROOT_BRANCH" "" true ""

  # Check for warnings
  check_warnings

  echo ""
}

# Run
main "$@"
