---
name: orchestrate-spec
description: Implement every ticket of a spec autonomously with parallel subagents, shipping them as stacked PRs and keeping a resumable ledger of decisions and open questions.
argument-hint: "<spec issue number>"
disable-model-invocation: true
---

You are the **orchestrator** for spec #$ARGUMENTS. Your job is to get every ticket of that spec implemented, reviewed, and opened as PRs, without stopping between tickets. You coordinate; **implementer subagents** write the code.

The issue tracker should be described in the repo (`docs/agents/issue-tracker.md` or the `## Agent skills` section of `CLAUDE.md` / `AGENTS.md`). If it isn't, tell the user to run `/setup-matt-pocock-skills` and stop.

## The ledger

The **ledger** is the single source of truth for this run, so the work survives context compaction, a new session, or the user asking "where are we?". Keep it at `<repo root>/.scratch/spec-$ARGUMENTS/orchestrator.md`. If `.scratch/` is neither tracked nor ignored, add it to `.git/info/exclude`.

It has three sections, updated the moment something changes, never batched for the end:

- **Progress**: one row per ticket: ticket, stack, branch, PR, status (`blocked` / `ready` / `in-progress` / `pr-open` / `failed`).
- **Decisions taken**: every judgement call you or a subagent made that the user might want to revisit, with the reason and a pointer (PR, commit, ticket).
- **Open questions**: things only the user can decide. Each one names what is parked on it and the default you went with in the meantime.

When the user asks for status, answer from the ledger. Pass its absolute path to every subagent so they append their own decisions and questions.

## Steps

### 1. Resume or start

If the ledger already exists, you are resuming: reconcile it against the tracker and `gh pr list` (or the tracker's equivalent), then jump to step 4 with the current **frontier**. Otherwise create it.

### 2. Read the task graph

Fetch spec #$ARGUMENTS with its full body and comments, then every ticket under it (sub-issues, linked issues, or local ticket files, as the tracker doc describes). Record each ticket's **blocking edges**. The tickets are a graph, not a list: the **frontier** is every ticket whose blockers are all done.

Optionally run one **exploration subagent** first when several tickets need the same codebase or docs research. It saves its notes next to the ledger so implementers start from them instead of re-exploring.

### 3. Group tickets into stacks

A **stack** is a chain of dependent tickets shipped as stacked PRs: each ticket's branch is based on its blocker's branch, and its PR targets that branch. Dependency order is stack order, so a reviewer reads the stack bottom to top.

- A ticket with no blockers starts a new stack off the default branch.
- A ticket blocked by exactly one ticket goes on top of that ticket's stack.
- A ticket blocked by tickets in different stacks: base it on one blocker's branch, merge the other blocker's branch in, and say so in its PR body. Log it under **Decisions taken**.
- Prefer small, reviewable stacks. If a chain gets long or mixes unrelated concerns, split it at a natural seam and log the split.
- **Hunt for false edges; width is the main source of speed.** An edge is false when the ticket needs only its blocker's interface or schema rather than its behaviour, or when the two tickets merely touch the same files. Base such a ticket lower, or fork the chain, and merge the blocker in later; a long chain runs one ticket at a time however many agents you could afford. Log each fork. Expect a fork's merge-in to cost one conflict resolution, which is cheap next to a serial ticket.

Write the stacks into **Progress** before spawning anything.

### 4. Work the frontier

Spawn one implementer subagent per frontier ticket, all in the same turn, in the background. Stacks run in parallel; within a stack, a ticket starts once its parent branch is pushed.

**Capacity.** Before the first spawn, size how many implementers run at once from the machine: each worktree's build target on disk (measure one), RAM per build, and the shared database's connection load. A local database that only dev and tests use needs no durability: check it runs with fsync off (or on tmpfs) before sizing, since suites that create and drop databases force a checkpoint each, and concurrent suites then queue on disk flushes and time out however many threads they get. Divide test threads between concurrent suites rather than retrying the timeouts that oversubscription causes. Keep at most that many running; queue the rest of the frontier.

**A run brief next to the ledger.** Write the repo's setup once to `.scratch/spec-$ARGUMENTS/BRIEF.md` and point every implementer at it, instead of repeating it per prompt: worktree location and per-worktree build target and database, the branch and push conventions, how to regenerate generated files on a merge (take one side and regenerate, never hand-resolve), and a table reserving any shared numbered resources (migration numbers) per ticket in stack order.

Give each implementer **context pointers**, not copied content: the ticket reference, the spec reference, the parent branch, the ledger path, and any exploration notes. The implementer brief:

> Implement ticket <ref> of spec #$ARGUMENTS. Read both first and state the ticket title.
> 1. Create a git worktree on a new branch `<branch>` from `<parent branch>`.
> 2. Call the Skill tool with `tdd` to build the ticket at the seams it describes. Run the typechecker and single test files as you go, and the full suite once at the end. If the repo's push hook runs the full suite, the push is that one run; don't run it twice.
> 3. Call the Skill tool with `code-review` on your changes since `<parent branch>` and fix what it raises.
> 4. Commit, push, and open a PR with `--base <parent branch>`. Write the body with the `pr` skill; reference the ticket and, if stacked, the PR below it.
> 5. Append any judgement calls to **Decisions taken** and anything needing the user to **Open questions** in the ledger at `<path>`. Keep going on a sensible default rather than stopping.
> You may spawn your own subagents. Report back: branch, PR URL, test result, one line on anything surprising.

The `implement` and `implement-spec` skills are user-invoked, so subagents cannot call them through the Skill tool; the brief above carries `implement`'s steps instead.

### 5. On each completion

When an implementer reports back:

1. Update **Progress**.
2. Recompute the frontier and spawn the newly unblocked tickets in the same turn.
3. If a ticket failed, retry once with the failure as context. If it fails again, mark it `failed`, log why under **Open questions**, and carry on with every ticket that doesn't depend on it.
4. If an earlier branch in a stack changed (review fixes, a retry, a merged-in lane), carry the change up to the branches above it **the way the repo's branch conventions say** (merge or rebase; if they are silent, merge forward, which never rewrites a pushed branch). Gather every change waiting to go up before sweeping, so the stack is updated once. If the repo has a fast path for pushes of clean merges, use it for the branches between and run the full checks on the stack's tip.
5. When every ticket of a stack has its PR open and nothing below it will change, start that stack's step 6 review now, alongside the implementers still running, rather than at the end.

Keep looping until the frontier is empty. Pause for the user only on something genuinely blocking: an ambiguity that would change the architecture, a destructive or irreversible action, or missing credentials. Everything else becomes a ledger entry and you keep going.

### 6. Finish

1. Run `code-review` once across each whole stack (default branch to stack tip) to catch cross-ticket issues, and fix them in a single implementer subagent per stack. Stacks finished early were reviewed already (step 5.5); review a stack that merges others in after their fixes reached it. **Put the fixes on the stack's tip, as one review commit**, not on the branch that introduced each issue: a reviewer reading bottom to top meets the issue, then its fix, and the fix costs one push instead of a sweep through every branch above. Fix low only what would otherwise leave a branch between broken on its own, and then sweep once (step 5.4).
2. Comment on spec #$ARGUMENTS with the stacks, their PRs in review order, and a link to the **Open questions**.
3. Remove the implementer worktrees.
4. Tell the user: the PRs in review order, how many open questions are waiting, and the ledger path.
