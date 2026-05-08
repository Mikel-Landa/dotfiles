# PR Comments Overlay — Domain Glossary

Vocabulary used inside `lua/config/my/diff/`. Add a term here before introducing it
in code; sharpen a term here whenever a conversation reveals it was fuzzy.

## Core terms

- **PR comments overlay** — the feature: surface a PR's review comments as signs in the
  signcolumn of a Diffview session, with keymaps to add/reply/resolve.
- **Diffview session** — the (tabpage, view, layout, buffers) tuple the overlay
  observes. Read by the **Diffview session reader** from `diffview.lib`.
- **Diffview session reader** — `diffview_session.lua`. The single seam that
  reads Diffview internals (`view.cur_entry`, `view.adapter.ctx.toplevel`, …)
  and shapes them into the **Diffview session** record. Isolates Diffview API
  brittleness; mockable in tests.
- **Session registry** — `registry.lua`. Owns the per-tabpage `sessions` map and
  the async refresh state machine (`refresh`, `show`, `destroy`). Drives
  provider fetches, joins dual results (diff files + comments), and enforces
  race guards via `loading_key` + identity checks. Takes provider list and
  Diffview session reader as dependencies — no autocmd or UI knowledge.
- **Provider / adapter** — module under `providers/` that knows one PR host
  (Bitbucket, GitHub…). Implements `can_handle`, `find_pr`, `fetch_diff_files`,
  `fetch_comments`, `add_comment`, `reply`, `submit_review`, `delete_comment`,
  `pr_url`. Emits comments in the **normalized comment shape** below. Built
  via `providers/<host>.new(deps)` so dependencies (e.g. **Atlas client**)
  are injected; `init.lua` skips registering the provider if `new` returns nil.
- **Atlas client** — single adapter onto `atlas.nvim`. Probed once at module
  load via `atlas_client.new()`; returns nil if `atlas.bitbucket.api.*` is
  unavailable, in which case `init.lua` skips registering the Bitbucket
  provider. Methods (`fetch_open_prs`, `fetch_diff`, `create_comment`,
  `reply_comment`, `delete_comment`, `approve`, `request_changes`) all return
  `(result, err)` uniformly. Replaces the inline `safe_require` dance that
  used to live across the Bitbucket provider.
- **Bitbucket links** — pure module that extracts URLs from a PR's `_raw`
  payload: `diff(pr)`, `comments(pr)`, `approve(pr)`, `request_changes(pr)`,
  `html(pr)`, `self(comment)`. Owns the Bitbucket link schema (key forks like
  `request-changes` vs `request_changes`, defensive nil-walking) so call
  sites read as routing, not table archaeology.
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
- **Normalized comment** — `{ id, anchor = { side, line }, path, body, user,
  created_at, pending, in_reply_to_id, _raw }`. The *only* shape the registry
  and planner know. Adapters translate to/from host-specific schemas.
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
  stub provider + stub Diffview reader; assert state transitions, race guards,
  dual-fetch join.
- `diffview_session.lua` — **Diffview session reader** (see above). Test surface:
  stub `diffview.lib`; assert revision normalization, session-key build, path
  stripping.
- `commands.lua` — user-facing actions (`add_comment`, `view_thread`,
  `submit_review`, `reload`) plus their context helpers (`current_context`,
  `visual_context`, `get_thread_at_cursor`, `in_diff`, `ensure_ready`,
  `open_comment_popup`). Imports registry + `comments_ui` + providers.
- `sign_plan.lua` — pure planner. No vim APIs.
- `render.lua` — buffer effects + per-buffer memo of last-applied plan.
- `hunks.lua` — pure hunk parser + range check.
- `comments_ui.lua` — floating-window helper (input + thread popup). Shallow but
  shared across two call sites.
- `providers/<name>.lua` — adapter, must emit normalized comments. Exposes
  `new(deps)` factory; module-level state forbidden.
- `providers/atlas_client.lua` — **Atlas client** (see above). Test surface:
  inject fake atlas modules; assert `(result, err)` shape and missing-dep
  routing.
- `providers/bitbucket_links.lua` — **Bitbucket links** (see above). Test
  surface: feed fixture `pr._raw` payloads, assert URL extraction and key-fork
  handling.
- `thread.lua` — **Thread finder** (see above). Test surface: pure, fixture
  comments + location records.
