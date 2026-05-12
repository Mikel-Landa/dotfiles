# Recovering from Rebase Mistakes

How to fix rebase errors using reflog and other recovery techniques.

## Overview

Rebasing is powerful but can go wrong. Git reflog is your safety net - it tracks every change to HEAD, allowing you to undo mistakes.

## Understanding Reflog

Reflog records every position your HEAD has been at:

```bash
git reflog

# Output:
# a1b2c3d HEAD@{0}: rebase finished: ...
# e4f5g6h HEAD@{1}: rebase: ...
# i7j8k9l HEAD@{2}: checkout: moving from main to feature
# m0n1o2p HEAD@{3}: commit: Add feature
```

Each `HEAD@{N}` is a snapshot you can return to.

## Common Scenarios

### Scenario 1: Rebase Created Conflicts I Can't Resolve

**Problem:** Conflicts are too complex, want to start over.

**Solution:**
```bash
# Abort the rebase
git rebase --abort

# You're back to pre-rebase state
```

### Scenario 2: Rebase Finished but Lost Commits

**Problem:** After rebase, some commits are missing or changed incorrectly.

**Solution:**
```bash
# View reflog
git reflog

# Find entry before rebase started
# Look for "rebase: checkout" or similar
# Example: HEAD@{5}: checkout: moving from feature to main

# Reset to that point
git reset --hard HEAD@{5}

# Now you're back to before the rebase
```

### Scenario 3: Force Pushed Wrong Branch

**Problem:** Accidentally force pushed and overwrote important commits.

**Solution:**
```bash
# Reflog shows local history, even after force push
git reflog

# Find the commit you want to restore
# Example: HEAD@{10}: commit: Important work

# Create new branch from that point
git checkout -b feature-recovery HEAD@{10}

# Or reset current branch
git reset --hard HEAD@{10}

# Force push to restore
git push --force-with-lease
```

### Scenario 4: Rebased onto Wrong Branch

**Problem:** Rebased `feature-a` onto `feature-b` when you meant to rebase onto `main`.

**Solution:**
```bash
# Find pre-rebase state
git reflog

# Example: HEAD@{3}: checkout: moving from feature-a to feature-b
# The commit before that is your target

# Reset to pre-rebase
git reset --hard HEAD@{4}

# Now rebase onto correct branch
git rebase main
```

### Scenario 5: Squashed Wrong Commits

**Problem:** Used interactive rebase to squash but kept wrong commits.

**Solution:**
```bash
# Find pre-rebase state
git reflog

# Look for "rebase -i (start)"
# Example: HEAD@{7}: rebase -i (start): checkout HEAD~3

# Reset to before interactive rebase
git reset --hard HEAD@{8}

# Try interactive rebase again
git rebase -i HEAD~3
```

## Step-by-Step Recovery Process

### Step 1: Don't Panic

Git reflog keeps history for 90 days by default. Your commits are likely still there.

### Step 2: View Reflog

```bash
git reflog

# For more detail
git reflog show --all

# For specific branch
git reflog show feature-branch
```

### Step 3: Find Target Commit

Look for entries like:
- `checkout: moving from X to Y` - Before branch switches
- `commit:` - Actual commits you made
- `rebase: ...` - Rebase operations
- `reset:` - Previous resets

### Step 4: Test the Commit

Before resetting, verify it's the right commit:

```bash
# View commit details
git show HEAD@{5}

# View log from that point
git log HEAD@{5} --oneline -10

# View files at that point
git ls-tree -r HEAD@{5}
```

### Step 5: Recover

**Option A: Reset current branch**
```bash
git reset --hard HEAD@{5}
```

**Option B: Create new branch (safer)**
```bash
git checkout -b recovery-branch HEAD@{5}
```

**Option C: Cherry-pick specific commits**
```bash
git cherry-pick HEAD@{5}
```

## Advanced Recovery

### Find Dangling Commits

If commit not in reflog:

```bash
# Find all dangling commits
git fsck --lost-found

# View dangling commits
git log --oneline --all --graph --decorate $(git fsck --no-reflogs | grep commit | awk '{print $3}')

# Recover specific commit
git checkout -b recovery <commit-hash>
```

### Recover Deleted Branch

```bash
# Find branch in reflog
git reflog

# Look for last commit on deleted branch
# Example: HEAD@{10}: commit (feature/deleted): Last commit

# Recreate branch
git checkout -b feature/deleted HEAD@{10}
```

### Recover Specific File

```bash
# Find commit with file version
git reflog

# Restore file from that commit
git checkout HEAD@{5} -- path/to/file.js
```

## Prevention Tips

### Before Risky Operations

Create a backup branch:

```bash
# Before rebasing
git branch backup-before-rebase

# If rebase goes wrong
git reset --hard backup-before-rebase
```

### Use --force-with-lease

Instead of `--force`:

```bash
git push --force-with-lease
```

This prevents overwriting others' work and gives you a warning if remote changed.

### Regular Backups

Push WIP branches to remote:

```bash
# Create remote backup
git push origin feature-branch:feature-branch-backup
```

## Reflog Configuration

Extend reflog retention:

```bash
# Keep reflog for 180 days instead of 90
git config gc.reflogExpire 180.days
git config gc.reflogExpireUnreachable 180.days
```

## Complete Recovery Example

```bash
# 1. Situation: Bad rebase, lost commits
git log --oneline
# Only shows 2 commits, should have 5

# 2. Check reflog
git reflog
# Output:
# a1b2c3d HEAD@{0}: rebase finished: ...
# e4f5g6h HEAD@{1}: rebase: ...
# i7j8k9l HEAD@{2}: checkout: moving from feature to main
# m0n1o2p HEAD@{3}: commit (feature): Fifth commit  ← Want this!
# q3r4s5t HEAD@{4}: commit: Fourth commit
# u6v7w8x HEAD@{5}: commit: Third commit

# 3. Verify it's correct
git log HEAD@{3} --oneline -5
# Shows all 5 commits - this is it!

# 4. Reset to that point
git reset --hard HEAD@{3}

# 5. Verify recovery
git log --oneline
# Shows all 5 commits restored!

# 6. Force push if needed
git push --force-with-lease
```

## Troubleshooting

**"Reflog is empty"**

Reflog is local to your clone. If you cloned recently, reflog only tracks changes since clone.

**"Can't find my commits in reflog"**

Try:
```bash
# Check all branches' reflogs
git reflog show --all

# Search for commit message
git log --all --grep="search term"

# Find by content
git log --all -S"specific code"
```

**"Reset didn't work"**

Check you're on the right branch:
```bash
git branch
git log --oneline -10
```

## Summary

Remember:
- **Reflog is your friend** - It tracks everything for 90 days
- **Don't panic** - Commits are rarely truly lost
- **Test before resetting** - Use `git show` to verify
- **Create backups** - Before risky operations, create a backup branch
- **Use force-with-lease** - Safer than regular force push
