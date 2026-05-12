---
name: git-stacked-prs
description: Stacked (dependent) pull request workflow. Use when creating, managing, or troubleshooting stacked PRs, or when user mentions stacked diffs, dependent PRs, PR stacks, or breaking large features into smaller PRs.
allowed-tools: Bash(git:*), Read, Edit, Write
---

# Git Stacked PRs

Expert guidance for creating and managing stacked (dependent) pull requests.

## Current Git Context

- Current git status: !`git status`
- Staged changes: !`git diff --staged`
- Unstaged changes: !`git diff`
- Current branch: !`git branch --show-current`
- Recent commits on current branch: !`git log --oneline -10`
- Branch tree: !`git log --oneline --graph --all -20`

## What Are Stacked PRs?

Stacked PRs (also called dependent PRs or stacked diffs) is a workflow where you create multiple pull requests that build on top of each other. Each PR in the stack depends on the changes from the previous PR.

**Traditional workflow:**

```
main → feature-branch (large PR, 2000+ lines)
```

**Stacked workflow:**

```
main → feature-part-1 → feature-part-2 → feature-part-3
       (small PR)        (small PR)        (small PR)
       200 lines         200 lines         200 lines
```

### Benefits

- **Faster reviews** - Small PRs (< 400 lines) are easier and quicker to review
- **Parallel work** - Continue building while earlier PRs are in review
- **Easier debugging** - Smaller changes make issues easier to isolate
- **Better collaboration** - Team can review and merge incrementally
- **Clearer history** - Each PR represents a logical unit of work

### When to Use Stacked PRs

✅ **Good use cases:**

- Large features that can be broken into logical increments
- Features with clear dependency chains
- Projects with active code reviews
- Teams practicing continuous integration

❌ **Avoid when:**

- Feature is already small (< 400 lines)
- Changes are tightly coupled and can't be separated
- Working alone without code review
- Deadlines are extremely tight

## Quick Start Workflows

### Create Stacked PRs from Scratch

See [workflows/create-stacked-prs.md](workflows/create-stacked-prs.md) for step-by-step instructions on organizing unstaged changes into a reviewable stack.

**Quick overview:**

1. Plan your stack structure
2. Create base branch from main
3. Stage and commit related changes
4. Create PR targeting main
5. Create next branch from base
6. Repeat for each layer
7. Update PR targets to form stack

### Update Stack After Merge

See [workflows/update-stack-after-merge.md](workflows/update-stack-after-merge.md) for instructions on rebasing and updating PR targets after merging base PRs.

**Quick overview:**

1. Checkout the branch above merged PR
2. Rebase onto new base (usually main)
3. Force push with lease
4. Update PR target if needed
5. Repeat for each remaining branch in stack

### Recover from Rebase Mistakes

See [workflows/recover-from-rebase.md](workflows/recover-from-rebase.md) for instructions on using reflog to recover from rebase errors.

**Quick overview:**

1. Find previous HEAD with `git reflog`
2. Reset to previous state
3. Retry rebase with correct base

## Best Practices

### Planning Your Stack

**Plan before you start:**

1. Identify logical boundaries in your feature
2. Ensure each layer can work independently
3. Keep each PR < 400 lines
4. Define clear dependencies

**Example stack plan:**

```
feat/auth/base        - Core auth models and utilities
feat/auth/middleware  - Auth middleware (depends on base)
feat/auth/endpoints   - API endpoints (depends on middleware)
feat/auth/ui          - Frontend UI (depends on endpoints)
```

### Branch Naming

Use consistent naming that shows hierarchy:

```
feat/<stack-name>/<component>
fix/<stack-name>/<component>
refactor/<stack-name>/<component>
```

**Examples:**

- `feat/auth/base`
- `feat/auth/middleware`
- `feat/payments/stripe-integration`
- `feat/payments/payment-ui`

### Testing Requirements

**Each PR in the stack must:**

- Have its own tests
- Pass all existing tests
- Be independently testable
- Not break functionality

**Example test strategy:**

```
PR 1 (base):      Tests for models and utilities
PR 2 (middleware): Tests for middleware + integration tests
PR 3 (endpoints):  Tests for endpoints + E2E tests
PR 4 (ui):        UI tests + full E2E flow tests
```

### PR Descriptions

Use clear PR descriptions that document dependencies:

```markdown
## Summary
Adds JWT authentication middleware for protecting routes.

## Stack Information
- **Stack:** User Authentication
- **Position:** 2/4 (depends on #123, required by #125)
- **Base PR:** #123 (Core auth models)
- **Depends on:** #123

## Changes
- Authentication middleware
- Token validation logic
- Protected route decorators

## Testing
- Unit tests for middleware
- Integration tests with routes
- All tests pass

## Review Notes
This PR can be reviewed independently, but depends on #123 being merged first.
```

See [templates/pr-description.md](templates/pr-description.md) for a reusable template.

## Automated Operations

The git-stacked-prs skill includes scripts to automate common workflows:

### Rebase Entire Stack

Automatically rebase all branches in a stack with safety features:

```bash
${CLAUDE_PLUGIN_ROOT}/skills/git-stacked-prs/scripts/stack-rebase.sh main feat/auth-base feat/auth-middleware feat/auth-api
```

Features:
- Creates automatic backups before rebasing
- Updates base branch from remote
- Rebases each branch sequentially
- Runs tests after each rebase
- Uses `--force-with-lease` for safety
- Supports `--dry-run` for preview

### View Stack Status

Display visual tree of stack structure with PR status:

```bash
${CLAUDE_PLUGIN_ROOT}/skills/git-stacked-prs/scripts/stack-status.sh --pr-status
```

Options:
- `--detail` - Show commit summaries
- `--pr-status` - Include GitHub PR status (requires `gh` CLI)
- `--json` - JSON output for parsing

### Update PR Targets After Merge

Batch update PR base branches after merging a base PR:

```bash
${CLAUDE_PLUGIN_ROOT}/skills/git-stacked-prs/scripts/update-pr-targets.sh feat/auth-base main
```

Features:
- Auto-detects dependent PRs
- Rebases branches onto new target
- Updates PR targets via `gh` CLI
- Handles conflicts gracefully
- Supports `--no-rebase` to only update targets

### Backup and Restore Stack

Create backups before risky operations:

```bash
# Create backups
${CLAUDE_PLUGIN_ROOT}/skills/git-stacked-prs/scripts/stack-backup.sh create feat/auth-base feat/auth-middleware

# List backups
${CLAUDE_PLUGIN_ROOT}/skills/git-stacked-prs/scripts/stack-backup.sh list

# Restore from backup
${CLAUDE_PLUGIN_ROOT}/skills/git-stacked-prs/scripts/stack-backup.sh restore feat/auth-base

# Clean old backups
${CLAUDE_PLUGIN_ROOT}/skills/git-stacked-prs/scripts/stack-backup.sh clean --older-than 30
```

## Common Operations

### View Stack Structure

```bash
# Visual branch tree
git log --oneline --graph --all -20

# See what branches exist
git branch -a

# Compare branches
git log main..feat/auth/base --oneline
git log feat/auth/base..feat/auth/middleware --oneline

# Or use the automated script
${CLAUDE_PLUGIN_ROOT}/skills/git-stacked-prs/scripts/stack-status.sh
```

### Rebase a Stack

Use the automated script for safe, sequential rebasing:

```bash
${CLAUDE_PLUGIN_ROOT}/skills/git-stacked-prs/scripts/stack-rebase.sh main feat/auth/base feat/auth/middleware feat/auth/api
```

Or manually rebase each branch:

```bash
# Update base branch
git checkout feat/auth/base
git rebase main
git push --force-with-lease

# Update next branch
git checkout feat/auth/middleware
git rebase feat/auth/base
git push --force-with-lease

# Repeat for each branch
```

### Handle Merge Conflicts During Rebase

```bash
# During rebase, conflicts occur
git status                    # Identify conflicted files

# Edit files to resolve conflicts
# Remove conflict markers: <<<<<<<, =======, >>>>>>>

git add <resolved-files>      # Stage resolved files
git rebase --continue         # Continue rebase

# If things go wrong
git rebase --abort            # Abort and start over
git reflog                    # Find previous HEAD to recover
```

### Change PR Targets

After merging a base PR, update the next PR's target:

1. Go to GitHub PR page
2. Click "Edit" next to the base branch
3. Change target from merged branch to new base (usually main)
4. GitHub will update the diff automatically

## Troubleshooting

### Stack Got Out of Sync

**Symptoms:** Commits appearing in wrong PRs, conflicts everywhere

**Solution:**

1. List all branches in stack
2. Rebase each branch in order from bottom to top
3. Force push each branch after rebase
4. Verify PR diffs on GitHub

### Lost Commits During Rebase

**Solution:** Use reflog to recover (see [workflows/recover-from-rebase.md](workflows/recover-from-rebase.md))

```bash
git reflog                    # Find lost commit
git cherry-pick <commit>      # Apply lost commit
```

### Merge Conflicts in Multiple Layers

**Solution:** Resolve conflicts layer by layer, starting from base:

1. Rebase and fix conflicts in base branch
2. Rebase and fix conflicts in next branch (may be fewer conflicts now)
3. Continue up the stack

### PR Shows Too Many Commits

**Symptom:** PR includes commits from base branch that are already merged

**Solution:** Update PR target to point to main instead of the merged branch:

1. Edit PR base branch on GitHub
2. Change from merged branch to main
3. Diff will update automatically

## Tools and Automation

### Git Aliases

Add to `~/.gitconfig`:

```ini
[alias]
  stack-status = log --oneline --graph --all -20
  stack-rebase = "!f() { git rebase $1 && git push --force-with-lease; }; f"
```

### GitHub CLI

```bash
# View PR status
gh pr status

# View specific PR
gh pr view 123

# Check PR checks/tests
gh pr checks 123
```

## References

- **[Complete guide](references/stacked-prs.md)** - Comprehensive stacked PR workflow documentation
- **[Create workflow](workflows/create-stacked-prs.md)** - Step-by-step stack creation
- **[Update workflow](workflows/update-stack-after-merge.md)** - Update stack after merges
- **[Recovery workflow](workflows/recover-from-rebase.md)** - Recover from rebase mistakes
- **[PR template](templates/pr-description.md)** - Stacked PR description template

## Related Skills

- For commit message guidelines, see `@git-commits`
- For rebase and conflict resolution details, see `@git-advanced`

## Key Takeaways

1. **Plan your stack** before starting - identify logical boundaries
2. **Keep PRs small** (< 400 lines) for faster reviews
3. **Test each layer** independently
4. **Document dependencies** in PR descriptions
5. **Rebase frequently** to avoid conflicts
6. **Use --force-with-lease** instead of --force for safety
7. **Update PR targets** after merging base PRs
