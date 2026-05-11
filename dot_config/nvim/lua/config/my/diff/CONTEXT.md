# PR Comments Overlay — Domain Glossary

Vocabulary used inside `lua/config/my/diff/`. Add a term here before introducing it
in code; sharpen a term here whenever a conversation reveals it was fuzzy.

## Core terms

- **PR comments overlay** — the feature: surface a PR's review comments as signs in the
  signcolumn of a CodeDiff session, with keymaps to add/reply/resolve.
- **CodeDiff session** — the (tabpage, view, layout, buffers) tuple the overlay
  observes. Read by the **CodeDiff session reader** from
  `codediff.ui.lifecycle`.
- **CodeDiff session reader** — `codediff_session.lua`. The single seam that
  reads codediff internals (`lifecycle.get_session(tabpage)` →
  `original_bufnr`, `modified_bufnr`, `original_revision`,
  `modified_revision`, `git_root`, paths) and shapes them into the **CodeDiff
  session** record. Isolates codediff API brittleness; mockable in tests.
- **Session registry** — `registry.lua`. Owns the per-tabpage `sessions` map and
  the async refresh state machine (`refresh`, `show`, `destroy`). Drives
  provider fetches, joins dual results (diff files + comments), and enforces
  race guards via `loading_key` + identity checks. Takes provider list and
  CodeDiff session reader as dependencies — no autocmd or UI knowledge.
- **Provider / adapter** — module under `providers/` that knows one PR host
  (Bitbucket, GitHub…). Implements `name`, `parse_origin_url`, `can_handle`,
  `find_pr` (CodeDiff path), `find_pr_for_branch` (working-tree path),
  `fetch_diff_files`, `fetch_comments`, `add_comment`, `reply`,
  `submit_review`, `delete_comment`, `edit_comment`, `fetch_current_user`,
  `pr_url`. Emits comments in the **normalized comment shape** below. Built
  via `providers/<host>.new(deps)` so dependencies (e.g. **Atlas client**,
  **gh client**) are injected; `init.lua` skips registering the provider if
  `new` returns nil. The seam is real now (two adapters: Bitbucket via
  atlas.nvim, GitHub via the `gh` CLI).
- **Atlas client** — single adapter onto `atlas.nvim`. Probed once at module
  load via `atlas_client.new()`; returns nil if `atlas.pulls.providers.bitbucket.api.*` is
  unavailable, in which case `init.lua` skips registering the Bitbucket
  provider. Methods (`fetch_open_prs`, `fetch_diff`, `create_comment`,
  `reply_comment`, `delete_comment`, `approve`, `request_changes`) all return
  `(result, err)` uniformly. Replaces the inline `safe_require` dance that
  used to live across the Bitbucket provider.
- **gh client** — single adapter onto the `gh` CLI for GitHub PR review-comment
  endpoints (atlas.nvim's GitHub provider only handles issue comments).
  Probed once at module load via `gh_client.new()`; returns nil if `gh` isn't
  installed, in which case `init.lua` skips registering the GitHub provider.
  Methods (`fetch_open_prs`, `fetch_pr_files`, `fetch_review_comments`,
  `create_review_comment`, `reply_review_comment`, `edit_review_comment`,
  `delete_review_comment`, `submit_review`, `fetch_current_user`) shell out
  via `vim.system({"gh", "api", …})` and return `(result, err)` uniformly.
- **Bitbucket links** — pure module that extracts URLs from a PR's `_raw`
  payload: `diff(pr)`, `comments(pr)`, `approve(pr)`, `request_changes(pr)`,
  `html(pr)`, `self(comment)`. Owns the Bitbucket link schema (key forks like
  `request-changes` vs `request_changes`, defensive nil-walking) so call
  sites read as routing, not table archaeology.
- **Sign painter** — `sign_painter.lua`. State-driven module that paints
  sign-column extmarks on working-tree code buffers given a
  `{ root, threads_by_path }` snapshot, plus a `threads_for_buffer(bufnr)`
  query used by the qf code-buffer K binding. No autocmds, no provider
  knowledge — `qf.lua` drives it. Replaces the inline sign-column code that
  used to live in `qf.lua`.
- **Thread finder** — pure module mapping `(comments, location)` to
  `{ root, replies } | nil` where `location = { file_path, side, line }`.
  Centralizes the thread-matching invariants (root has `in_reply_to_id ==
  nil`, anchor matches location, replies sorted by id) currently inlined in
  `commands.get_thread_at_cursor`. Vim cursor reads stay in `commands.lua`.
- **Mutation runner** — helper inside `commands.lua`:
  `run_mutation(tabpage, op, success_msg)`. Wraps every provider mutation
  (`add_comment`, `reply`, `submit_review`, `delete_comment`) with the
  err-or-notify-then-`registry.refresh(force=true)` contract, so adding a
  new mutation can't silently skip the refresh.
- **Normalized comment** — `{ id, anchor = { side, line }, range = { start_line,
  end_line }, path, body, user, user_id, created_at, pending, in_reply_to_id,
  _raw }`. The *only* shape the registry and planner know. Adapters translate
  to/from host-specific schemas. `range` covers multi-line review comments
  and collapses to `start_line == end_line == anchor.line` for single-line
  comments; `sign_plan` only reads `anchor.line`, but `qf.lua`'s sign painter
  paints over the full range.
- **Anchor** — `{ side: "LEFT"|"RIGHT", line: integer }`. Single source of truth
  for which file line a comment attaches to. Replaces the older
  `line` / `original_line` dual fields.
- **Sign plan** — pure output of `sign_plan.plan(comments, path, side, line_count)`:
  a `{ line → SignSpec }` map. Tells `render` what to draw, without doing any
  drawing.
- **Hunk** — `{ left_start, left_count, right_start, right_count }` parsed from the
  adapter's diff representation. `hunks.contains(...)` decides whether a comment
  range is inside the diff (gates `add_comment`).
- **Thread root** — a comment with `in_reply_to_id == nil`. Only roots place signs;
  replies inherit anchor/path from their root inside the adapter.

## Module roles

- `init.lua` — thin glue. Wires keymaps → commands and autocmds → registry.
  No state, no logic.
- `registry.lua` — **Session registry** (see above). Test surface: drive with
  stub provider + stub CodeDiff reader; assert state transitions, race guards,
  dual-fetch join.
- `codediff_session.lua` — **CodeDiff session reader** (see above). Test surface:
  stub `codediff.ui.lifecycle`; assert revision normalization, session-key build,
  path stripping.
- `commands.lua` — user-facing actions (`add_comment`, `view_thread`,
  `submit_review`, `reload`) plus their context helpers (`current_context`,
  `visual_context`, `get_thread_at_cursor`, `in_diff`, `ensure_ready`,
  `open_comment_popup`). Imports registry + `comments_ui` + providers.
- `sign_plan.lua` — pure planner. No vim APIs.
- `render.lua` — buffer effects + per-buffer memo of last-applied plan.
- `hunks.lua` — pure hunk parser + range check.
- `comments_ui.lua` — UI helper with three entry points:
  - `M.input` — floating prompt for write/edit/reply bodies.
  - `M.open` — floating thread popup (centered or `relative_to_cursor`); per-comment
    `r`/`e`/`d` keymaps. Used by `commands.view_thread` (CodeDiff) and the qf
    `K` peek binding.
  - `M.thread_virt_lines` — pure helper: returns a chunked virt_lines payload
    (one inner array per virtual line) for a thread, ready to feed to
    `nvim_buf_set_extmark{virt_lines=…}`. Used by `qf.lua` to expand the
    selected entry inline. Action footer is suppressed by default
    (`opts.no_actions = true`).
- `providers/<name>.lua` — adapter, must emit normalized comments. Exposes
  `new(deps)` factory; module-level state forbidden.
- `providers/atlas_client.lua` — **Atlas client** (see above). Test surface:
  inject fake atlas modules; assert `(result, err)` shape and missing-dep
  routing.
- `providers/gh_client.lua` — **gh client** (see above). Test surface: inject
  a fake `runner` (the `gh api` shell-out) via `gh_client.new({ runner = … })`;
  assert endpoint routing and `(result, err)` shape on stdout/stderr/exit-code
  combinations.
- `providers/bitbucket_links.lua` — **Bitbucket links** (see above). Test
  surface: feed fixture `pr._raw` payloads, assert URL extraction and key-fork
  handling.
- `sign_painter.lua` — **Sign painter** (see above). Test surface: drive
  `set_state`/`refresh_buffer`/`threads_for_buffer` with stub buffers and
  assert extmark and query behaviour.
- `thread.lua` — **Thread finder** (see above). Test surface: pure, fixture
  comments + location records.
