#!/bin/bash

# Update PR Targets - Batch update PR base branches after merges
# Automatically detects dependent PRs and updates their targets

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
MERGED_BRANCH=""
NEW_TARGET=""
SPECIFIC_PRS=()
REBASE=true

# Get script directory for calling stack-rebase.sh
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

show_help() {
  cat << EOF
Update PR Targets - Batch update PR base branches after merges

Usage: update-pr-targets.sh <merged-branch> <new-target> [pr-numbers...] [options]

Arguments:
  merged-branch   Branch that was just merged
  new-target      New target branch (usually main or master)
  pr-numbers      Optional specific PR numbers to update (default: auto-detect)

Options:
  --no-rebase     Only update targets, skip rebasing branches
  --rebase        Also rebase branches (default: true)
  --help          Show this help message

Examples:
  update-pr-targets.sh feat/auth-base main
  update-pr-targets.sh feat/auth-base main 124 125
  update-pr-targets.sh feat/auth-base main --no-rebase

Process:
  1. Auto-detect dependent PRs (or use specified PR numbers)
  2. Validate new target branch exists
  3. For each PR:
     a. Rebase branch onto new target (unless --no-rebase)
     b. Force push with --force-with-lease
     c. Update PR target via gh CLI
  4. Display summary

Requirements:
  - git
  - gh CLI (GitHub CLI)

EOF
}

# Parse arguments
parse_args() {
  if [[ $# -eq 0 ]]; then
    echo -e "${RED}Error: No arguments provided${NC}"
    show_help
    exit 1
  fi

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --no-rebase)
        REBASE=false
        shift
        ;;
      --rebase)
        REBASE=true
        shift
        ;;
      --help)
        show_help
        exit 0
        ;;
      *)
        if [[ -z "$MERGED_BRANCH" ]]; then
          MERGED_BRANCH="$1"
        elif [[ -z "$NEW_TARGET" ]]; then
          NEW_TARGET="$1"
        else
          # Assume it's a PR number
          SPECIFIC_PRS+=("$1")
        fi
        shift
        ;;
    esac
  done

  if [[ -z "$MERGED_BRANCH" ]]; then
    echo -e "${RED}Error: Merged branch required${NC}"
    show_help
    exit 1
  fi

  if [[ -z "$NEW_TARGET" ]]; then
    echo -e "${RED}Error: New target branch required${NC}"
    show_help
    exit 1
  fi
}

# Check for gh CLI
check_gh_cli() {
  if ! command -v gh &> /dev/null; then
    echo -e "${RED}Error: gh CLI not found${NC}"
    echo ""
    echo "GitHub CLI is required for updating PR targets."
    echo "Install from: https://cli.github.com/"
    exit 1
  fi

  # Check if authenticated
  if ! gh auth status &> /dev/null; then
    echo -e "${RED}Error: Not authenticated with GitHub${NC}"
    echo ""
    echo "Run: gh auth login"
    exit 1
  fi
}

# Validate target branch exists
validate_target() {
  echo -e "${BLUE}Validating target branch...${NC}"

  if ! git show-ref --verify --quiet "refs/heads/$NEW_TARGET"; then
    echo -e "${RED}Error: Target branch not found: $NEW_TARGET${NC}"
    exit 1
  fi

  echo -e "${GREEN}✓ Target branch: $NEW_TARGET${NC}"
  echo ""
}

# Auto-detect dependent PRs
detect_dependent_prs() {
  echo -e "${BLUE}Detecting dependent PRs...${NC}"

  local prs=$(gh pr list --base "$MERGED_BRANCH" --json number,headRefName,title --jq '.[] | "\(.number)|\(.headRefName)|\(.title)"')

  if [[ -z "$prs" ]]; then
    echo -e "${YELLOW}No PRs found targeting $MERGED_BRANCH${NC}"
    return
  fi

  echo -e "${GREEN}Found dependent PRs:${NC}"
  echo "$prs" | while IFS='|' read -r pr_num branch title; do
    echo -e "  ${YELLOW}#$pr_num${NC} $branch - $title"
    SPECIFIC_PRS+=("$pr_num")
  done

  echo ""
}

# Get branch name for a PR
get_pr_branch() {
  local pr_num="$1"
  gh pr view "$pr_num" --json headRefName --jq '.headRefName' 2>/dev/null || echo ""
}

# Rebase branch onto new target
rebase_branch() {
  local branch="$1"

  echo -e "${BLUE}Rebasing $branch onto $NEW_TARGET...${NC}"

  # Check if branch exists locally
  if ! git show-ref --verify --quiet "refs/heads/$branch"; then
    echo -e "${YELLOW}Branch not found locally, fetching...${NC}"
    git fetch origin "$branch:$branch" 2>/dev/null || {
      echo -e "${RED}Error: Could not fetch branch: $branch${NC}"
      return 1
    }
  fi

  # Checkout branch
  git checkout "$branch"

  # Update target branch
  git fetch origin "$NEW_TARGET:$NEW_TARGET" 2>/dev/null || true

  # Perform rebase
  if git rebase "$NEW_TARGET"; then
    echo -e "${GREEN}✓ Rebase successful${NC}"
  else
    echo -e "${RED}✗ Rebase failed - conflicts detected${NC}"
    echo ""
    echo -e "${YELLOW}To resolve conflicts:${NC}"
    echo "  1. Fix conflicts in the affected files"
    echo "  2. git add <resolved-files>"
    echo "  3. git rebase --continue"
    echo "  4. git push --force-with-lease"
    echo "  5. gh pr edit $pr_num --base $NEW_TARGET"
    echo ""
    echo -e "${YELLOW}To abort:${NC}"
    echo "  git rebase --abort"
    echo ""
    exit 1
  fi

  # Force push with lease
  echo -e "${BLUE}Pushing to remote...${NC}"

  if git push --force-with-lease; then
    echo -e "${GREEN}✓ Pushed successfully${NC}"
  else
    echo -e "${RED}✗ Push failed${NC}"
    echo -e "${YELLOW}You may need to push manually:${NC}"
    echo "  git push --force-with-lease"
    return 1
  fi

  echo ""
}

# Update PR target
update_pr_target() {
  local pr_num="$1"

  echo -e "${BLUE}Updating PR #$pr_num target to $NEW_TARGET...${NC}"

  if gh pr edit "$pr_num" --base "$NEW_TARGET"; then
    echo -e "${GREEN}✓ PR target updated${NC}"
  else
    echo -e "${RED}✗ Failed to update PR target${NC}"
    return 1
  fi

  echo ""
}

# Process a single PR
process_pr() {
  local pr_num="$1"

  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BLUE}Processing PR #$pr_num${NC}"
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""

  # Get branch name
  local branch=$(get_pr_branch "$pr_num")
  if [[ -z "$branch" ]]; then
    echo -e "${RED}Error: Could not find branch for PR #$pr_num${NC}"
    return 1
  fi

  echo -e "Branch: ${YELLOW}$branch${NC}"
  echo ""

  # Rebase if requested
  if [[ "$REBASE" == "true" ]]; then
    if ! rebase_branch "$branch"; then
      return 1
    fi
  fi

  # Update PR target
  if ! update_pr_target "$pr_num"; then
    return 1
  fi

  echo -e "${GREEN}✓ PR #$pr_num processed successfully${NC}"
  echo ""
}

# Main processing
process_prs() {
  local success_count=0
  local fail_count=0
  local failed_prs=()

  for pr_num in "${SPECIFIC_PRS[@]}"; do
    if process_pr "$pr_num"; then
      success_count=$((success_count + 1))
    else
      fail_count=$((fail_count + 1))
      failed_prs+=("$pr_num")
    fi
  done

  # Print summary
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BLUE}Summary${NC}"
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""

  echo -e "Merged branch: ${YELLOW}$MERGED_BRANCH${NC}"
  echo -e "New target: ${YELLOW}$NEW_TARGET${NC}"
  echo -e "Rebase: ${YELLOW}$REBASE${NC}"
  echo ""

  echo -e "${GREEN}✓ Successful: $success_count${NC}"
  if [[ $fail_count -gt 0 ]]; then
    echo -e "${RED}✗ Failed: $fail_count${NC}"
    echo -e "${RED}Failed PRs: ${failed_prs[*]}${NC}"
  fi

  echo ""

  if [[ $fail_count -gt 0 ]]; then
    exit 1
  fi
}

# Main execution
main() {
  parse_args "$@"

  # Check for gh CLI
  check_gh_cli

  # Validate target
  validate_target

  # Save current branch
  local original_branch=$(git branch --show-current)

  # Auto-detect PRs if none specified
  if [[ ${#SPECIFIC_PRS[@]} -eq 0 ]]; then
    detect_dependent_prs
  fi

  # Check if we have any PRs to process
  if [[ ${#SPECIFIC_PRS[@]} -eq 0 ]]; then
    echo -e "${YELLOW}No PRs to process${NC}"
    exit 0
  fi

  # Update target branch
  echo -e "${BLUE}Updating $NEW_TARGET from remote...${NC}"
  git checkout "$NEW_TARGET"
  git pull origin "$NEW_TARGET" 2>/dev/null || true
  echo ""

  # Process PRs
  process_prs

  # Restore original branch
  if [[ -n "$original_branch" ]] && git show-ref --verify --quiet "refs/heads/$original_branch"; then
    git checkout "$original_branch"
  fi
}

# Run
main "$@"
