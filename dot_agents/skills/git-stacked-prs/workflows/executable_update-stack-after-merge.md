# Updating Stack After PR Merge

How to update PR targets and rebase remaining branches after merging stacked PRs.

## Overview

When a PR in a stack merges to main, subsequent PRs need their base branches updated and rebased.

## Scenario

You have this stack:
```
main → PR#1 (auth-setup) → PR#2 (auth-models) → PR#3 (auth-api)
```

PR#1 just merged to main. Now you need to update PR#2 and PR#3.

## Workflow

### Step 1: Update Local Main

```bash
git checkout main
git pull origin main
```

### Step 2: Rebase Next PR onto Main

```bash
# Switch to the branch that was targeting the merged PR
git checkout feature/auth-models

# Rebase onto main
git rebase main

# Force push (use force-with-lease for safety)
git push --force-with-lease
```

### Step 3: Update PR Target on GitHub/GitLab

**GitHub UI:**
1. Go to PR#2
2. Click "Edit" next to the base branch
3. Change from `feature/auth-setup` to `main`

**GitHub CLI:**
```bash
gh pr edit 2 --base main
```

### Step 4: Rebase Remaining PRs

```bash
# Third PR now rebases onto the second branch
git checkout feature/auth-api
git rebase feature/auth-models
git push --force-with-lease
```

The third PR's target stays as `feature/auth-models` until that PR merges.

## Complete Example

Starting state:
```
main (has PR#1)
  ↓
PR#2 (feature/auth-models) targeting feature/auth-setup
  ↓
PR#3 (feature/auth-api) targeting feature/auth-models
  ↓
PR#4 (feature/auth-ui) targeting feature/auth-api
```

After PR#1 merges:

```bash
# Update main
git checkout main
git pull

# Update PR#2
git checkout feature/auth-models
git rebase main
git push --force-with-lease
gh pr edit 2 --base main

# Update PR#3 (rebase on PR#2, keep same target)
git checkout feature/auth-api
git rebase feature/auth-models
git push --force-with-lease

# Update PR#4 (rebase on PR#3, keep same target)
git checkout feature/auth-ui
git rebase feature/auth-api
git push --force-with-lease
```

After PR#2 merges:

```bash
# Update main
git checkout main
git pull

# Update PR#3
git checkout feature/auth-api
git rebase main
git push --force-with-lease
gh pr edit 3 --base main

# Update PR#4
git checkout feature/auth-ui
git rebase feature/auth-api
git push --force-with-lease
```

## Handling Conflicts

If conflicts occur during rebase:

```bash
# View conflicted files
git status

# Edit files to resolve conflicts
# Remove conflict markers: <<<<<<<, =======, >>>>>>>

# Mark as resolved
git add <resolved-files>

# Continue rebase
git rebase --continue

# If more conflicts, repeat
# To abort: git rebase --abort

# Push when done
git push --force-with-lease
```

## Automation Scripts

### Automated Stack Rebase

Use the built-in `stack-rebase.sh` script to automate the entire rebase process:

```bash
${CLAUDE_PLUGIN_ROOT}/skills/git-stacked-prs/scripts/stack-rebase.sh main feature/auth-models feature/auth-api feature/auth-ui
```

Features:
- Creates automatic backups before rebasing
- Updates base branch from remote
- Rebases each branch sequentially
- Runs tests after each rebase
- Uses `--force-with-lease` for safety
- Provides detailed progress output

### Update PR Targets

Use the `update-pr-targets.sh` script to automatically update PR targets after a merge:

```bash
${CLAUDE_PLUGIN_ROOT}/skills/git-stacked-prs/scripts/update-pr-targets.sh feature/auth-setup main
```

This script will:
- Auto-detect all PRs targeting the merged branch
- Rebase each branch onto the new target
- Update PR targets via `gh` CLI
- Handle conflicts gracefully

Options:
- `--no-rebase` - Only update PR targets, skip rebasing
- Specify PR numbers: `update-pr-targets.sh feature/auth-setup main 2 3 4`

## Tips

- **Always pull main first** - Ensure you have latest changes
- **Use force-with-lease** - Safer than `--force`, prevents overwriting others' work
- **Update PR targets immediately** - Don't let PRs point to merged branches
- **Rebase frequently** - Smaller, more frequent rebases have fewer conflicts
- **Test after rebase** - Ensure tests still pass

## Common Issues

**"My PR shows duplicate commits from the merged PR"**

You forgot to update the PR base. The PR is comparing against the old base which now includes duplicate commits.

Fix:
```bash
gh pr edit <pr-number> --base main
```

**"Force push rejected"**

Someone else pushed to your branch or your local is outdated.

Check:
```bash
git fetch origin
git log HEAD..origin/your-branch

# If safe, force push with lease
git push --force-with-lease
```

**"Rebase conflicts are overwhelming"**

Too many conflicts? Consider recreating the branch:

```bash
# Create new branch from main
git checkout main
git checkout -b feature/auth-api-v2

# Cherry-pick your commits
git cherry-pick <commit-hash>

# Push new branch
git push -u origin feature/auth-api-v2
```
