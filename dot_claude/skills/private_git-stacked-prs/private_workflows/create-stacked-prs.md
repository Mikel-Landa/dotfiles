# Creating Stacked PRs from Changes

Step-by-step workflow for organizing unstaged changes into logical stacked PRs.

## Overview

This workflow takes your current unstaged changes and organizes them into a stack of small, reviewable PRs that build on each other.

## Prerequisites

- Unstaged or uncommitted changes in your working directory
- Clean git history (or willingness to create new branches)

## Workflow

### Step 1: Analyze Changes

View all changes and identify logical groupings:

```bash
git status
git diff
```

Group related changes by:
- **Type**: Config changes, dependencies, features, tests
- **Layer**: Infrastructure, backend, frontend
- **Domain**: Authentication, API, UI components

### Step 2: Plan the Stack

Create a mental map of dependencies. Example:

```
Changes:
- package.json (add dependencies)
- .env.example (add config)
- src/auth/models.ts (new file)
- src/auth/api.ts (new file)
- src/auth/ui.tsx (new file)

Stack plan:
1. Setup: package.json, .env.example
2. Models: src/auth/models.ts
3. API: src/auth/api.ts
4. UI: src/auth/ui.tsx
```

### Step 3: Create Base Branch

```bash
git checkout -b feature/auth-setup
```

### Step 4: Stage First Group

```bash
git add package.json .env.example
git commit -m "Add authentication dependencies and config

- Add bcrypt and jsonwebtoken packages
- Add JWT_SECRET to environment config"
```

### Step 5: Create Subsequent Branches

```bash
# Second branch (stacked on first)
git checkout -b feature/auth-models
git add src/auth/models.ts
git commit -m "Add authentication models

- Create User model with password hashing
- Add session token model"

# Third branch (stacked on second)
git checkout -b feature/auth-api
git add src/auth/api.ts
git commit -m "Add authentication API endpoints

- POST /auth/login - User login
- POST /auth/logout - User logout
- GET /auth/me - Current user"

# Fourth branch (stacked on third)
git checkout -b feature/auth-ui
git add src/auth/ui.tsx
git commit -m "Add authentication UI components

- LoginForm component with validation
- LogoutButton component
- AuthProvider context"
```

### Step 6: Push All Branches

```bash
git push -u origin feature/auth-setup
git push -u origin feature/auth-models
git push -u origin feature/auth-api
git push -u origin feature/auth-ui
```

### Step 7: Create PRs in Order

```bash
# PR 1: Setup → main
gh pr create --base main --head feature/auth-setup \
  --title "Add authentication dependencies and config" \
  --body "Part of stacked PRs: 1/4"

# PR 2: Models → Setup
gh pr create --base feature/auth-setup --head feature/auth-models \
  --title "Add authentication models" \
  --body "Stacked on #1. Part of stacked PRs: 2/4"

# PR 3: API → Models
gh pr create --base feature/auth-models --head feature/auth-api \
  --title "Add authentication API endpoints" \
  --body "Stacked on #2. Part of stacked PRs: 3/4"

# PR 4: UI → API
gh pr create --base feature/auth-api --head feature/auth-ui \
  --title "Add authentication UI components" \
  --body "Stacked on #3. Part of stacked PRs: 4/4"
```

## Visualizing Your Stack

After creating branches, use the stack status script to verify structure:

```bash
${CLAUDE_PLUGIN_ROOT}/skills/git-stacked-prs/scripts/stack-status.sh --pr-status
```

This will show:
```
main
├─ feature/auth-setup (PR #123: under review)
│  └─ feature/auth-models (PR #124: draft)
│     └─ feature/auth-api (PR #125: draft)
│        └─ feature/auth-ui (PR #126: draft)
```

## Tips

- **Keep PRs small** - Aim for < 400 lines per PR
- **Test each commit** - Ensure each branch works independently
- **Document dependencies** - Always mention "Stacked on #N" in PR descriptions
- **Use force-with-lease** - When rebasing, use `--force-with-lease` not `--force`
- **Create backups** - Before complex operations: `${CLAUDE_PLUGIN_ROOT}/skills/git-stacked-prs/scripts/stack-backup.sh create feature/auth-setup feature/auth-models`

## Common Patterns

### Pattern 1: By File Type

```
1. Config files and dependencies
2. Backend models and database
3. Backend API and business logic
4. Frontend components
5. Integration tests
```

### Pattern 2: By Layer

```
1. Infrastructure (Docker, CI/CD)
2. Database schema and migrations
3. Backend services
4. API endpoints
5. Frontend integration
```

### Pattern 3: By Feature Increment

```
1. Basic read-only implementation
2. Add write operations
3. Add validation and error handling
4. Add advanced features
5. Add comprehensive tests
```

## Troubleshooting

**"I staged changes across multiple groups"**
```bash
# Unstage everything
git reset HEAD

# Re-stage selectively
git add package.json .env.example
git commit -m "..."
```

**"I committed to the wrong branch"**
```bash
# Move commit to new branch
git checkout -b correct-branch
git checkout previous-branch
git reset --hard HEAD~1
```

**"I need to reorder commits in my stack"**
```bash
# Use interactive rebase
git rebase -i HEAD~3  # Adjust number as needed
# Reorder commits in editor
```
