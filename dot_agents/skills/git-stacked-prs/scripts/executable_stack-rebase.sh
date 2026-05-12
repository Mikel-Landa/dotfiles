#!/bin/bash

# Stack Rebase - Automate sequential rebasing of all branches in a stack
# Safely rebases each branch with automatic backups and conflict handling

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DRY_RUN=false
SKIP_TESTS=false
ORIGINAL_BRANCH=""
BASE_BRANCH=""
STACK_BRANCHES=()

# Get script directory for calling stack-backup.sh
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

show_help() {
  cat << EOF
Stack Rebase - Automate sequential rebasing of all branches in a stack

Usage: stack-rebase.sh <base-branch> <branch1> <branch2> ... [options]

Arguments:
  base-branch     Base branch to rebase onto (e.g., main, master)
  branch1...      Stack branches to rebase (bottom to top order)

Options:
  --dry-run       Preview operations without executing
  --skip-tests    Skip running tests after each rebase
  --help          Show this help message

Examples:
  stack-rebase.sh main feat/auth-base feat/auth-middleware feat/auth-api
  stack-rebase.sh main feat/auth-base feat/auth-middleware --dry-run
  stack-rebase.sh master feat/payments feat/payments-ui --skip-tests

Process:
  1. Validates all branches exist
  2. Creates automatic backups of all branches
  3. Updates base branch from remote
  4. Rebases each branch sequentially
  5. Force pushes with --force-with-lease for safety
  6. Runs tests after each rebase (unless --skip-tests)
  7. Reports summary of all operations

Safety Features:
  - Checks for uncommitted changes before starting
  - Creates automatic backups (use stack-backup.sh to restore)
  - Uses --force-with-lease to prevent overwriting remote changes
  - Pauses on conflicts with recovery instructions
  - Preserves original branch on completion

Requirements:
  - git
  - stack-backup.sh (in same directory)

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
      --dry-run)
        DRY_RUN=true
        shift
        ;;
      --skip-tests)
        SKIP_TESTS=true
        shift
        ;;
      --help)
        show_help
        exit 0
        ;;
      *)
        if [[ -z "$BASE_BRANCH" ]]; then
          BASE_BRANCH="$1"
        else
          STACK_BRANCHES+=("$1")
        fi
        shift
        ;;
    esac
  done

  if [[ -z "$BASE_BRANCH" ]]; then
    echo -e "${RED}Error: Base branch required${NC}"
    show_help
    exit 1
  fi

  if [[ ${#STACK_BRANCHES[@]} -eq 0 ]]; then
    echo -e "${RED}Error: At least one stack branch required${NC}"
    show_help
    exit 1
  fi
}

# Validate branches exist
validate_branches() {
  echo -e "${BLUE}Validating branches...${NC}"

  # Check base branch
  if ! git show-ref --verify --quiet "refs/heads/$BASE_BRANCH"; then
    echo -e "${RED}Error: Base branch not found: $BASE_BRANCH${NC}"
    exit 1
  fi
  echo -e "${GREEN}✓ Base branch: $BASE_BRANCH${NC}"

  # Check stack branches
  for branch in "${STACK_BRANCHES[@]}"; do
    if ! git show-ref --verify --quiet "refs/heads/$branch"; then
      echo -e "${RED}Error: Branch not found: $branch${NC}"
      exit 1
    fi
    echo -e "${GREEN}✓ Stack branch: $branch${NC}"
  done

  echo ""
}

# Check for uncommitted changes
check_uncommitted_changes() {
  if [[ -n $(git status -s) ]]; then
    echo -e "${RED}Error: You have uncommitted changes${NC}"
    echo ""
    git status -s
    echo ""
    echo "Please commit or stash changes before rebasing"
    exit 1
  fi
}

# Create backups
create_backups() {
  echo -e "${BLUE}Creating backups...${NC}"

  if [[ "$DRY_RUN" == "true" ]]; then
    echo -e "${YELLOW}[DRY RUN] Would create backups for:${NC}"
    for branch in "${STACK_BRANCHES[@]}"; do
      echo -e "  - $branch"
    done
    echo ""
    return
  fi

  # Call stack-backup.sh
  if [[ -x "$SCRIPT_DIR/stack-backup.sh" ]]; then
    "$SCRIPT_DIR/stack-backup.sh" create "${STACK_BRANCHES[@]}"
  else
    echo -e "${YELLOW}Warning: stack-backup.sh not found or not executable${NC}"
    echo -e "${YELLOW}Creating manual backups...${NC}"

    for branch in "${STACK_BRANCHES[@]}"; do
      local timestamp=$(date +%Y%m%d-%H%M%S)
      local backup_name="${branch//\//-}-backup-$timestamp"
      git branch "$backup_name" "$branch"
      echo -e "${GREEN}✓ Created backup: $backup_name${NC}"
    done
  fi

  echo ""
}

# Update base branch
update_base_branch() {
  echo -e "${BLUE}Updating base branch: $BASE_BRANCH${NC}"

  if [[ "$DRY_RUN" == "true" ]]; then
    echo -e "${YELLOW}[DRY RUN] Would execute:${NC}"
    echo "  git checkout $BASE_BRANCH"
    echo "  git pull origin $BASE_BRANCH"
    echo ""
    return
  fi

  git checkout "$BASE_BRANCH"

  # Try to pull, but don't fail if no remote
  if git pull origin "$BASE_BRANCH" 2>/dev/null; then
    echo -e "${GREEN}✓ Updated $BASE_BRANCH from remote${NC}"
  else
    echo -e "${YELLOW}⚠️  Could not pull from remote (continuing anyway)${NC}"
  fi

  echo ""
}

# Run tests for a branch
run_tests() {
  local branch="$1"

  if [[ "$SKIP_TESTS" == "true" ]]; then
    echo -e "${YELLOW}Skipping tests (--skip-tests flag)${NC}"
    return 0
  fi

  echo -e "${BLUE}Running tests...${NC}"

  # Try common test commands
  if [[ -f "package.json" ]]; then
    if command -v npm &> /dev/null && npm run test --dry-run &>/dev/null; then
      npm test
      return $?
    elif command -v yarn &> /dev/null; then
      yarn test
      return $?
    fi
  elif [[ -f "Makefile" ]] && grep -q "^test:" Makefile; then
    make test
    return $?
  elif [[ -f "pytest.ini" ]] || [[ -f "setup.py" ]]; then
    pytest
    return $?
  fi

  echo -e "${YELLOW}No test command found, skipping...${NC}"
  return 0
}

# Rebase a single branch
rebase_branch() {
  local branch="$1"
  local parent_branch="$2"

  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BLUE}Rebasing: $branch onto $parent_branch${NC}"
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""

  if [[ "$DRY_RUN" == "true" ]]; then
    echo -e "${YELLOW}[DRY RUN] Would execute:${NC}"
    echo "  git checkout $branch"
    echo "  git rebase $parent_branch"
    echo "  git push --force-with-lease"
    echo ""
    return 0
  fi

  # Checkout branch
  git checkout "$branch"

  # Show what will be rebased
  local commit_count=$(git rev-list --count "$parent_branch..$branch" 2>/dev/null || echo "0")
  echo -e "Commits to rebase: ${YELLOW}$commit_count${NC}"

  # Perform rebase
  if git rebase "$parent_branch"; then
    echo -e "${GREEN}✓ Rebase successful${NC}"
  else
    echo -e "${RED}✗ Rebase failed - conflicts detected${NC}"
    echo ""
    echo -e "${YELLOW}To resolve conflicts:${NC}"
    echo "  1. Fix conflicts in the affected files"
    echo "  2. git add <resolved-files>"
    echo "  3. git rebase --continue"
    echo ""
    echo -e "${YELLOW}To abort and restore from backup:${NC}"
    echo "  1. git rebase --abort"
    echo "  2. $SCRIPT_DIR/stack-backup.sh restore $branch"
    echo ""
    echo -e "${YELLOW}Current status:${NC}"
    git status
    exit 1
  fi

  # Run tests
  if ! run_tests "$branch"; then
    echo -e "${RED}✗ Tests failed${NC}"
    echo ""
    echo -e "${YELLOW}Options:${NC}"
    echo "  1. Fix issues and run tests again"
    echo "  2. Continue anyway with --skip-tests"
    echo "  3. Restore from backup: $SCRIPT_DIR/stack-backup.sh restore $branch"
    exit 1
  fi

  # Force push with lease
  echo -e "${BLUE}Pushing to remote...${NC}"

  if git push --force-with-lease 2>&1; then
    echo -e "${GREEN}✓ Pushed successfully${NC}"
  else
    echo -e "${YELLOW}⚠️  Could not push (possibly no remote or remote has new changes)${NC}"
    echo -e "${YELLOW}Review and push manually if needed:${NC}"
    echo "  git push --force-with-lease"
  fi

  echo ""
}

# Main rebase process
rebase_stack() {
  local parent_branch="$BASE_BRANCH"

  for branch in "${STACK_BRANCHES[@]}"; do
    rebase_branch "$branch" "$parent_branch"
    parent_branch="$branch"
  done
}

# Print summary
print_summary() {
  echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${GREEN}✓ Stack rebase complete!${NC}"
  echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""

  echo -e "${BLUE}Rebased branches:${NC}"
  echo -e "  Base: $BASE_BRANCH"

  local parent_branch="$BASE_BRANCH"
  for branch in "${STACK_BRANCHES[@]}"; do
    local commit_count=$(git rev-list --count "$parent_branch..$branch" 2>/dev/null || echo "0")
    echo -e "  └─ $branch ${YELLOW}(+$commit_count commits)${NC}"
    parent_branch="$branch"
  done

  echo ""
  echo -e "${BLUE}Current branch: ${YELLOW}$(git branch --show-current)${NC}"

  if [[ "$DRY_RUN" == "true" ]]; then
    echo ""
    echo -e "${YELLOW}This was a dry run. No changes were made.${NC}"
    echo -e "${YELLOW}Run without --dry-run to perform the rebase.${NC}"
  fi

  echo ""
}

# Main execution
main() {
  parse_args "$@"

  # Save current branch
  ORIGINAL_BRANCH=$(git branch --show-current)

  if [[ "$DRY_RUN" == "true" ]]; then
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}DRY RUN MODE - No changes will be made${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
  fi

  # Pre-flight checks
  validate_branches
  check_uncommitted_changes

  # Create backups
  create_backups

  # Update base
  update_base_branch

  # Rebase stack
  rebase_stack

  # Restore original branch
  if [[ -n "$ORIGINAL_BRANCH" ]] && git show-ref --verify --quiet "refs/heads/$ORIGINAL_BRANCH"; then
    if [[ "$DRY_RUN" != "true" ]]; then
      git checkout "$ORIGINAL_BRANCH"
    fi
  fi

  # Print summary
  print_summary
}

# Run
main "$@"
