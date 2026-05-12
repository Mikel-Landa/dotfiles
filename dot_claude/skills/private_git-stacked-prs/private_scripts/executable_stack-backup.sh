#!/bin/bash

# Stack Backup - Create and restore backups before risky operations
# Manages branch backups with metadata for easy recovery

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get repo root
GIT_ROOT=$(git rev-parse --show-toplevel)
BACKUP_DIR="$GIT_ROOT/.git/stack-backups"
METADATA_FILE="$BACKUP_DIR/metadata.txt"

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo -e "${RED}Error: Not in a git repository${NC}"
  exit 1
fi

show_help() {
  cat << EOF
Stack Backup - Create and restore backups before risky operations

Usage: stack-backup.sh <command> [options]

Commands:
  create <branches...>            Create backups of specified branches
  list                            List all available backups
  restore <branch>                Restore branch from most recent backup
  clean [--older-than N]          Remove old backups (default: 30 days)
  help                            Show this help message

Options:
  --force                         Skip confirmation prompts (use with caution)
  --older-than N                  For clean: remove backups older than N days

Examples:
  stack-backup.sh create feat/auth-base feat/auth-middleware
  stack-backup.sh list
  stack-backup.sh restore feat/auth-base
  stack-backup.sh clean --older-than 30
  stack-backup.sh clean --older-than 7 --force

Backup Storage:
  Backups are stored in .git/stack-backups/
  Each backup includes:
  - Branch reference with timestamp
  - Commit hash
  - Creation date
  - Original branch name

EOF
}

# Initialize backup directory and metadata file
init_backup_dir() {
  if [[ ! -d "$BACKUP_DIR" ]]; then
    mkdir -p "$BACKUP_DIR"
    echo "# Stack Backup Metadata" > "$METADATA_FILE"
    echo "# Format: backup_branch|original_branch|commit_hash|timestamp|date" >> "$METADATA_FILE"
  fi
}

# Create backup of a branch
backup_branch() {
  local branch="$1"

  # Check if branch exists
  if ! git show-ref --verify --quiet "refs/heads/$branch"; then
    echo -e "${RED}Error: Branch not found: $branch${NC}"
    return 1
  fi

  # Get current commit
  local commit_hash=$(git rev-parse "$branch")
  local timestamp=$(date +%Y%m%d-%H%M%S)
  local backup_name="${branch//\//-}-backup-$timestamp"

  # Create backup branch
  git branch "$backup_name" "$branch" 2>/dev/null || {
    echo -e "${RED}Error: Failed to create backup branch: $backup_name${NC}"
    return 1
  }

  # Record metadata
  echo "$backup_name|$branch|$commit_hash|$timestamp|$(date)" >> "$METADATA_FILE"

  echo -e "${GREEN}✓ Created backup: $backup_name${NC}"
  echo -e "  Original: $branch"
  echo -e "  Commit: ${commit_hash:0:8}"
}

# Create backups for multiple branches
create_backups() {
  local branches=("$@")

  if [[ ${#branches[@]} -eq 0 ]]; then
    echo -e "${RED}Error: No branches specified${NC}"
    show_help
    exit 1
  fi

  init_backup_dir

  echo -e "${BLUE}Creating backups...${NC}"
  echo ""

  local success_count=0
  local fail_count=0

  for branch in "${branches[@]}"; do
    if backup_branch "$branch"; then
      success_count=$((success_count + 1))
    else
      fail_count=$((fail_count + 1))
    fi
  done

  echo ""
  echo -e "${BLUE}Backup summary:${NC}"
  echo -e "  ${GREEN}✓ Successful: $success_count${NC}"
  if [[ $fail_count -gt 0 ]]; then
    echo -e "  ${RED}✗ Failed: $fail_count${NC}"
  fi
}

# List all backups
list_backups() {
  init_backup_dir

  if [[ ! -f "$METADATA_FILE" ]] || [[ $(wc -l < "$METADATA_FILE") -le 2 ]]; then
    echo -e "${YELLOW}No backups found${NC}"
    return
  fi

  echo -e "${BLUE}Available backups:${NC}"
  echo ""
  printf "%-40s %-30s %-12s %s\n" "Backup Branch" "Original Branch" "Commit" "Date"
  printf "%-40s %-30s %-12s %s\n" "-------------" "---------------" "------" "----"

  # Skip header lines and read metadata
  tail -n +3 "$METADATA_FILE" | while IFS='|' read -r backup_name original_branch commit_hash timestamp date; do
    # Check if backup branch still exists
    if git show-ref --verify --quiet "refs/heads/$backup_name"; then
      printf "%-40s %-30s %-12s %s\n" "$backup_name" "$original_branch" "${commit_hash:0:8}" "$date"
    fi
  done

  echo ""
}

# Restore branch from backup
restore_branch() {
  local branch="$1"
  local force="${2:-false}"

  if [[ -z "$branch" ]]; then
    echo -e "${RED}Error: Branch name required${NC}"
    show_help
    exit 1
  fi

  init_backup_dir

  # Find most recent backup
  local backup_name=""
  local commit_hash=""

  if [[ -f "$METADATA_FILE" ]]; then
    # Search for backups of this branch (most recent first)
    while IFS='|' read -r backup original_branch backup_commit timestamp date; do
      if [[ "$original_branch" == "$branch" ]]; then
        # Check if backup branch exists
        if git show-ref --verify --quiet "refs/heads/$backup"; then
          backup_name="$backup"
          commit_hash="$backup_commit"
          break
        fi
      fi
    done < <(tail -n +3 "$METADATA_FILE" | tac)
  fi

  if [[ -z "$backup_name" ]]; then
    echo -e "${RED}Error: No backup found for branch: $branch${NC}"
    echo ""
    echo -e "Available backups:"
    list_backups
    exit 1
  fi

  # Check for uncommitted changes
  if [[ -n $(git status -s) ]]; then
    echo -e "${RED}Error: You have uncommitted changes${NC}"
    echo "Please commit or stash changes before restoring"
    exit 1
  fi

  # Check if branch exists
  local branch_exists=false
  if git show-ref --verify --quiet "refs/heads/$branch"; then
    branch_exists=true
  fi

  # Confirm restore
  if [[ "$force" != "true" ]]; then
    echo -e "${YELLOW}⚠️  Warning: This will reset $branch to backup${NC}"
    echo -e "  Backup: $backup_name"
    echo -e "  Commit: ${commit_hash:0:8}"
    echo ""

    if [[ "$branch_exists" == "true" ]]; then
      local current_commit=$(git rev-parse "$branch")
      echo -e "  Current commit: ${current_commit:0:8}"
      echo -e "  ${RED}Current state will be lost unless you create another backup!${NC}"
      echo ""
    fi

    echo -e "Proceed with restore? (y/n)"
    read -r response

    if [[ "$response" != "y" ]]; then
      echo -e "${YELLOW}Restore cancelled${NC}"
      exit 0
    fi
  fi

  # Perform restore
  echo -e "${BLUE}Restoring branch...${NC}"

  if [[ "$branch_exists" == "true" ]]; then
    # Reset existing branch
    git checkout "$branch"
    git reset --hard "$commit_hash"
  else
    # Create new branch from backup
    git checkout -b "$branch" "$commit_hash"
  fi

  echo -e "${GREEN}✓ Branch restored successfully${NC}"
  echo -e "  Branch: $branch"
  echo -e "  Commit: ${commit_hash:0:8}"
  echo -e "  Source: $backup_name"
}

# Clean old backups
clean_backups() {
  local days="${1:-30}"
  local force="${2:-false}"

  init_backup_dir

  if [[ ! -f "$METADATA_FILE" ]] || [[ $(wc -l < "$METADATA_FILE") -le 2 ]]; then
    echo -e "${YELLOW}No backups to clean${NC}"
    return
  fi

  echo -e "${BLUE}Finding backups older than $days days...${NC}"
  echo ""

  local to_remove=()
  local cutoff_date=$(date -v-${days}d +%s 2>/dev/null || date -d "$days days ago" +%s 2>/dev/null)

  # Find old backups
  tail -n +3 "$METADATA_FILE" | while IFS='|' read -r backup_name original_branch commit_hash timestamp date; do
    # Parse timestamp (format: YYYYMMDD-HHMMSS)
    local year=${timestamp:0:4}
    local month=${timestamp:4:2}
    local day=${timestamp:6:2}
    local backup_date=$(date -j -f "%Y%m%d" "${year}${month}${day}" +%s 2>/dev/null || date -d "${year}-${month}-${day}" +%s 2>/dev/null)

    if [[ $backup_date -lt $cutoff_date ]]; then
      # Check if backup branch exists
      if git show-ref --verify --quiet "refs/heads/$backup_name"; then
        to_remove+=("$backup_name")
        echo -e "  ${YELLOW}$backup_name${NC} (from $original_branch, $date)"
      fi
    fi
  done

  if [[ ${#to_remove[@]} -eq 0 ]]; then
    echo -e "${GREEN}No old backups found${NC}"
    return
  fi

  # Confirm deletion
  if [[ "$force" != "true" ]]; then
    echo ""
    echo -e "${YELLOW}Remove ${#to_remove[@]} backup(s)? (y/n)${NC}"
    read -r response

    if [[ "$response" != "y" ]]; then
      echo -e "${YELLOW}Clean cancelled${NC}"
      exit 0
    fi
  fi

  # Delete backup branches
  echo ""
  echo -e "${BLUE}Cleaning backups...${NC}"

  local removed_count=0
  for backup_name in "${to_remove[@]}"; do
    if git branch -D "$backup_name" &>/dev/null; then
      echo -e "${GREEN}✓ Removed: $backup_name${NC}"
      removed_count=$((removed_count + 1))
    else
      echo -e "${RED}✗ Failed to remove: $backup_name${NC}"
    fi
  done

  # Clean metadata file
  if [[ $removed_count -gt 0 ]]; then
    local temp_file=$(mktemp)
    head -n 2 "$METADATA_FILE" > "$temp_file"

    tail -n +3 "$METADATA_FILE" | while IFS='|' read -r backup_name rest; do
      if git show-ref --verify --quiet "refs/heads/$backup_name"; then
        echo "$backup_name|$rest" >> "$temp_file"
      fi
    done

    mv "$temp_file" "$METADATA_FILE"
  fi

  echo ""
  echo -e "${GREEN}Cleaned $removed_count backup(s)${NC}"
}

# Main command handler
main() {
  local command="${1:-help}"
  shift || true

  local force=false
  local older_than=30

  # Parse global options
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --force)
        force=true
        shift
        ;;
      --older-than)
        older_than="$2"
        shift 2
        ;;
      --help)
        show_help
        exit 0
        ;;
      *)
        break
        ;;
    esac
  done

  case "$command" in
    create)
      create_backups "$@"
      ;;
    list|ls)
      list_backups
      ;;
    restore)
      restore_branch "$1" "$force"
      ;;
    clean|cleanup)
      clean_backups "$older_than" "$force"
      ;;
    help|--help)
      show_help
      ;;
    *)
      echo -e "${RED}Unknown command: $command${NC}"
      echo ""
      show_help
      exit 1
      ;;
  esac
}

# Run
main "$@"
