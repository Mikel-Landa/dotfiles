# Stacked PRs Workflow

Comprehensive guide to working with stacked (dependent) pull requests.

## Table of Contents

- [What Are Stacked PRs](#what-are-stacked-prs)
- [When to Use Stacked PRs](#when-to-use-stacked-prs)
- [Creating a Stack](#creating-a-stack)
- [Managing Stack Updates](#managing-stack-updates)
- [Handling Conflicts](#handling-conflicts)
- [Merging Strategy](#merging-strategy)
- [Tools and Automation](#tools-and-automation)

## What Are Stacked PRs

Stacked PRs (also called dependent PRs or stacked diffs) is a workflow where you create multiple pull requests that build on top of each other. Each PR in the stack depends on the changes from the previous PR.

**Traditional workflow:**
```
main → feature-branch (large PR)
```

**Stacked workflow:**
```
main → feature-part-1 → feature-part-2 → feature-part-3
       (small PR)        (small PR)        (small PR)
```

### Benefits

- **Faster reviews** - Small PRs are easier and quicker to review
- **Parallel work** - Continue building while earlier PRs are in review
- **Easier debugging** - Smaller changes make issues easier to isolate
- **Better collaboration** - Team can review and merge incrementally
- **Clearer history** - Each PR represents a logical unit of work

### Challenges

- **Rebase complexity** - Changes to earlier PRs require rebasing later ones
- **Merge conflicts** - More opportunities for conflicts
- **Coordination** - Need to track dependencies between PRs
- **Tooling** - Requires discipline and sometimes additional tools

## When to Use Stacked PRs

### Good Use Cases

**Large features that can be broken down:**
```
Authentication system:
1. Add user model and database schema
2. Implement JWT token generation
3. Add authentication middleware
4. Add login/logout endpoints
5. Add password reset flow
```

**Refactoring with new features:**
```
Dashboard redesign:
1. Extract dashboard components
2. Update component styling
3. Add new metrics widgets
4. Integrate real-time updates
```

**Database migrations with code changes:**
```
Schema update:
1. Add new database columns
2. Migrate existing data
3. Update models and queries
4. Remove old columns
```

### When NOT to Use Stacked PRs

- Small features that fit comfortably in one PR
- Hotfixes that need to be merged immediately
- Changes that cannot be logically separated
- When team is not familiar with the workflow

## Creating a Stack

### Step 1: Plan the Stack

Break down the feature into logical, reviewable chunks:

```
Feature: User Profile System

Stack plan:
1. feat/profile/model      - Database schema and model
2. feat/profile/api        - CRUD API endpoints
3. feat/profile/validation - Input validation and tests
4. feat/profile/ui         - Frontend components
5. feat/profile/integration - Full integration and E2E tests
```

**Branch Naming Pattern:** `feat/<stack-name>/<component>`

Where:
- `feat` is the type (or `fix`, `refactor`, etc.)
- `<stack-name>` groups related branches (e.g., `profile`, `auth`, `dashboard`)
- `<component>` describes the specific part (e.g., `model`, `api`, `ui`)

**Example:**
```
feat/auth/base           # First PR in auth stack
feat/auth/middleware     # Second PR in auth stack
feat/auth/endpoints      # Third PR in auth stack
feat/auth/ui             # Fourth PR in auth stack
```

**Each PR should:**
- Be independently reviewable
- Have passing tests
- Not break the application
- Represent a complete logical unit

### Step 2: Create Base Branch

Start from the base branch (usually main):

```bash
git checkout main
git pull origin main
```

### Step 3: Create First PR in Stack

```bash
# Create first branch
git checkout -b feat/profile/model

# Implement changes
# ... edit files ...

# Commit changes
git add models/profile.py migrations/
git commit -m "Add user profile model and schema

- Add Profile model with fields: bio, avatar, location
- Create database migration
- Add model tests"

# Push branch
git push -u origin feat/profile/model
```

Create PR on GitHub/GitLab targeting main.

### Step 4: Create Second PR (Stacked on First)

```bash
# Create second branch FROM first branch
git checkout -b feat/profile/api

# Implement changes
# ... edit files ...

# Commit changes
git add api/profile.py tests/
git commit -m "Add profile CRUD API endpoints

- GET /api/profile/:id - Get profile
- PUT /api/profile/:id - Update profile
- Includes validation and error handling
- Add API integration tests"

# Push branch
git push -u origin feat/profile/api
```

**Important:** Create PR targeting `feat/profile/model`, NOT main.

### PR Title and Description Format

**Title Format:**
```
[<Stack Name> X/Y] Feature description
```

Where:
- Stack Name = name of the stack
- X = Position in stack (1, 2, 3...)
- Y = Total PRs in stack
- Feature description = What this PR does

**Examples:**
```
[Profile 1/4] Add user profile model and schema
[Profile 2/4] Add profile CRUD API endpoints
[Profile 3/4] Add input validation and tests
[Profile 4/4] Add frontend components and integration
```

**Description Template:**

See [pr-description.md](../templates/pr-description.md) for a complete template.

### Step 5: Continue the Stack

Repeat for each subsequent PR, always branching from and targeting the previous branch in the stack.

```bash
# Third PR stacked on second
git checkout -b feat/profile/validation

# ... implement and commit ...

git push -u origin feat/profile/validation
```

Create PR targeting `feat/profile/api`.

## Managing Stack Updates

### When Base Branch Changes

When someone updates main, you need to rebase your entire stack:

```bash
# Update main
git checkout main
git pull origin main

# Rebase first branch
git checkout feat/profile/model
git rebase main

# Force push (your branch, safe to force push)
git push --force-with-lease

# Rebase each subsequent branch
git checkout feat/profile/api
git rebase feat/profile/model
git push --force-with-lease

git checkout feat/profile/validation
git rebase feat/profile/api
git push --force-with-lease
```

### When First PR Gets Feedback

When you need to update the first PR in the stack:

```bash
# Make changes to first PR
git checkout feat/profile/model

# Edit files based on feedback
# ... edit files ...

git add models/profile.py
git commit -m "Address review feedback

- Rename bio field to description
- Add character limit validation
- Update tests"

git push

# Now rebase all dependent branches
git checkout feat/profile/api
git rebase feat/profile/model
git push --force-with-lease

git checkout feat/profile/validation
git rebase feat/profile/api
git push --force-with-lease
```

### When Middle PR Gets Feedback

```bash
# Make changes to middle PR
git checkout feat/profile/api

# Edit files
git commit -m "Address review feedback"
git push

# Rebase only branches that come AFTER
git checkout feat/profile/validation
git rebase feat/profile/api
git push --force-with-lease

# Branches before (feat/profile/model) are unaffected
```

## Handling Conflicts

### Conflict During Rebase

When rebasing a stacked branch, conflicts may occur:

```bash
git checkout feat/profile/api
git rebase feat/profile/model

# If conflicts occur:
# Auto-merging api/profile.py
# CONFLICT (content): Merge conflict in api/profile.py
```

**Resolution steps:**

```bash
# 1. View conflicted files
git status

# 2. Open and edit conflicted files
# Look for conflict markers:
# <<<<<<< HEAD
# =======
# >>>>>>>

# 3. After resolving, mark as resolved
git add api/profile.py

# 4. Continue rebase
git rebase --continue

# 5. If more conflicts, repeat steps 2-4
# If you want to abort: git rebase --abort

# 6. Force push when done
git push --force-with-lease
```

### Preventing Conflicts

**Best practices:**
- Keep stack depth reasonable (3-5 PRs max)
- Make changes in isolated files when possible
- Communicate with team about changes to shared files
- Rebase frequently to catch conflicts early
- Use small, focused PRs

## Merging Strategy

### Option 1: Sequential Merge (Recommended)

Merge PRs from bottom to top, one at a time:

```bash
# 1. Merge first PR into main
#    (feat/profile/model → main)
#    Use GitHub/GitLab UI or:
git checkout main
git merge feat/profile/model
git push

# 2. Update second PR to target main
#    Change PR target from feat/profile/model to main
#    Rebase onto main:
git checkout feat/profile/api
git rebase main
git push --force-with-lease

# 3. Merge second PR into main
git checkout main
git merge feat/profile/api
git push

# 4. Repeat for remaining PRs
```

**Advantages:**
- Each PR is reviewed independently
- Easy to halt if issues are found
- Clear history in main branch

### Option 2: Squash and Merge

Squash each PR when merging to keep main history clean:

```bash
# Merge with squash (GitHub UI or):
git checkout main
git merge --squash feat/profile/model
git commit -m "Add user profile model (#123)"
git push

# Update and rebase next PR
git checkout feat/profile/api
git rebase main
# Resolve any conflicts
git push --force-with-lease
```

**Advantages:**
- Cleaner main branch history
- Each feature is one commit
- Easier to revert if needed

**Disadvantages:**
- Loses detailed commit history
- Harder to debug within a feature

### Option 3: Merge Entire Stack at Once

Merge only the final PR after all PRs in stack are approved:

```bash
# Approve all PRs in stack
# Merge final PR (feat/profile/integration → main)
# This brings in all changes from the stack

git checkout main
git merge feat/profile/integration
git push
```

**Advantages:**
- Deploy entire feature at once
- Simpler merge process

**Disadvantages:**
- Delays feedback on early PRs
- Harder to isolate issues
- All-or-nothing deployment

## Tools and Automation

### Built-in Automation Scripts

The git-stacked-prs skill includes powerful automation scripts:

#### Stack Status
Display visual tree of stack structure with PR status:
```bash
${CLAUDE_PLUGIN_ROOT}/skills/git-stacked-prs/scripts/stack-status.sh --pr-status --detail
```

Output:
```
main
├─ feat/auth-base (PR #123: ✓ approved)
│  └─ feat/auth-middleware (PR #124: under review)
│     └─ feat/auth-api (PR #125: draft)
```

#### Stack Rebase
Automate sequential rebasing with safety features:
```bash
${CLAUDE_PLUGIN_ROOT}/skills/git-stacked-prs/scripts/stack-rebase.sh main feat/auth-base feat/auth-middleware feat/auth-api
```

Features:
- Creates automatic backups
- Updates base branch
- Rebases each branch sequentially
- Runs tests after each rebase
- Uses `--force-with-lease` for safety

#### Update PR Targets
Batch update PR targets after merging:
```bash
${CLAUDE_PLUGIN_ROOT}/skills/git-stacked-prs/scripts/update-pr-targets.sh feat/auth-base main
```

Auto-detects dependent PRs and:
- Rebases branches onto new target
- Updates PR targets via `gh` CLI
- Handles conflicts gracefully

#### Stack Backup
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

### GitHub CLI

```bash
# Create stacked PRs with gh CLI
gh pr create --base main --head feat/profile/model \
  --title "Add user profile model" \
  --body "First PR in profile system stack"

gh pr create --base feat/profile/model --head feat/profile/api \
  --title "Add profile API endpoints" \
  --body "Stacked on #123"
```

### Git Aliases

Add to `.gitconfig`:

```ini
[alias]
  # Rebase entire stack
  rebase-stack = "!f() { \
    git rebase $1 && \
    for branch in $(git branch --contains HEAD | grep -v '^*'); do \
      git checkout $branch && git rebase HEAD@{1}; \
    done; \
  }; f"

  # Push all branches in stack with force-with-lease
  push-stack = "!git push --force-with-lease --all origin"
```

### Stacked Diff Tools

Consider using specialized tools:

- **Graphite** - CLI tool for stacked changes
- **git-stack** - Manage stacks of git branches
- **Gerrit** - Code review system with native stack support
- **Phabricator** - Review tool with differential revisions

## Best Practices

### Do's

✅ Plan the entire stack before starting
✅ Keep each PR small and focused (< 400 lines)
✅ Ensure each PR has passing tests
✅ Document dependencies in PR descriptions
✅ Rebase frequently to avoid large conflicts
✅ Use force-with-lease, not force
✅ Communicate stack status with team
✅ Add "Stacked on #123" in PR descriptions

### Don'ts

❌ Don't create stacks deeper than 5-6 PRs
❌ Don't stack if feature is small enough for one PR
❌ Don't forget to update PR targets after merging
❌ Don't merge PRs out of order
❌ Don't let stacks sit too long without merging
❌ Don't force push without force-with-lease
❌ Don't stack hotfixes (merge directly)

## Example: Complete Stack Workflow

```bash
# Starting position
git checkout main
git pull

# PR 1: Database schema
git checkout -b feat/auth/user-model
# ... implement ...
git commit -m "Add User model and database schema"
git push -u origin feat/auth/user-model
# Create PR: feat/auth/user-model → main

# PR 2: Token generation (depends on PR 1)
git checkout -b feat/auth/jwt-tokens
# ... implement ...
git commit -m "Add JWT token generation and validation"
git push -u origin feat/auth/jwt-tokens
# Create PR: feat/auth/jwt-tokens → feat/auth/user-model

# PR 3: Middleware (depends on PR 2)
git checkout -b feat/auth/middleware
# ... implement ...
git commit -m "Add authentication middleware"
git push -u origin feat/auth/middleware
# Create PR: feat/auth/middleware → feat/auth/jwt-tokens

# Review feedback on PR 1
git checkout feat/auth/user-model
# ... make changes ...
git commit -m "Address review feedback"
git push

# Rebase dependent PRs
git checkout feat/auth/jwt-tokens
git rebase feat/auth/user-model
git push --force-with-lease

git checkout feat/auth/middleware
git rebase feat/auth/jwt-tokens
git push --force-with-lease

# PR 1 approved and merged into main
# Update PR 2 to target main
git checkout feat/auth/jwt-tokens
git rebase main
git push --force-with-lease
# Update PR target: feat/auth/jwt-tokens → main

# PR 2 approved and merged into main
# Update PR 3 to target main
git checkout feat/auth/middleware
git rebase main
git push --force-with-lease
# Update PR target: feat/auth/middleware → main

# PR 3 approved and merged into main
# Stack complete!
```

## Troubleshooting

### "I lost track of my stack"

```bash
# View all branches with their upstream
git branch -vv

# Visualize branch structure
git log --oneline --graph --all --decorate
```

### "I rebased wrong and broke everything"

```bash
# Find the commit before the bad rebase
git reflog

# Reset to that commit
git reset --hard HEAD@{5}  # Adjust number as needed
```

### "Conflicts in every PR after updating first one"

This usually means the first PR changed shared code heavily. Options:

1. **Resolve conflicts one by one** - Time consuming but safe
2. **Recreate dependent branches** - Fresh start if conflicts are severe
3. **Merge first PR and rebuild stack** - If changes are fundamental

### "PR targets wrong branch after merge"

After merging PR 1 into main, PR 2 should target main:

```bash
# Update PR 2
git checkout pr_2
git rebase main
git push --force-with-lease

# Update PR target on GitHub/GitLab:
# Change base branch from pr_1 to main
```
