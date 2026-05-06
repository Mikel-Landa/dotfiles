# PR Comments Overlay — Domain Glossary

Vocabulary used inside `lua/config/my/diff/`. Add a term here before introducing it
in code; sharpen a term here whenever a conversation reveals it was fuzzy.

## Core terms

- **PR comments overlay** — the feature: surface a PR's review comments as signs in the
  signcolumn of a Diffview session, with keymaps to add/reply/resolve.
- **Diffview session** — the (tabpage, view, layout, buffers) tuple the overlay
  observes. Constructed by `current_session()` from `diffview.lib`.
- **Provider / adapter** — module under `providers/` that knows one PR host
  (Bitbucket, GitHub…). Implements `can_handle`, `find_pr`, `fetch_diff_files`,
  `fetch_comments`, `add_comment`, `reply`, `submit_review`, `delete_comment`,
  `pr_url`. Emits comments in the **normalized comment shape** below.
- **Normalized comment** — `{ id, anchor = { side, line }, path, body, user,
  created_at, pending, in_reply_to_id, _raw }`. The *only* shape the orchestrator
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

- `init.lua` — orchestrator: per-tabpage session map, async refresh state machine,
  user commands, autocmd wiring. No comment-shape knowledge beyond passing the
  list to `sign_plan`.
- `sign_plan.lua` — pure planner. No vim APIs.
- `render.lua` — buffer effects + per-buffer memo of last-applied plan.
- `hunks.lua` — pure hunk parser + range check.
- `comments_ui.lua` — floating-window helper (input + thread popup). Shallow but
  shared across two call sites.
- `providers/<name>.lua` — adapter, must emit normalized comments.
