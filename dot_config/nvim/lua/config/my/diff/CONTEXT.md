# PR Comments Overlay — Domain Glossary

Vocabulary used inside `lua/config/my/diff/`. Add a term here before introducing it
in code; sharpen a term here whenever a conversation reveals it was fuzzy.

## Core terms

- **PR comments overlay** — the feature: surface a PR's review comments as signs in the
  signcolumn of a CodeDiff session, with keymaps to add/reply/resolve. The
  overlay is **sticky**: it never auto-loads on `CodeDiffOpen`; the first
  fetch must come from an explicit invocation (`qf.open` via `<leader>oc`
  seeds the registry). Once a tabpage has a registry session,
  `CodeDiffFileSelect` re-fetches so signs stay in sync with the new file;
  closing the tab tears the session down.
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
  race guards via `loading_key` + identity checks. `set_providers` accepts
  either provider tables or factory functions (`() -> provider | nil`);
  factories are resolved on each `provider_for*` call, with successful
  results cached and nil results re-probed on the next lookup. This lets
  `init.lua` register adapters whose plugin deps are still `cmd`-lazy at
  config-load time.
- **Provider / adapter** — module under `providers/` that knows one PR host
  (Bitbucket, GitHub…). Implements `name`, `parse_origin_url`, `can_handle`,
  `find_pr` (CodeDiff path), `find_pr_for_branch` (working-tree path),
  `fetch_diff_files`, `fetch_comments`, `add_comment`, `reply`,
  `submit_review`, `delete_comment`, `edit_comment`, `fetch_current_user`,
  `pr_url`. Emits comments in the **normalized comment shape** below. Built
  via `providers/<host>.new(deps)` so dependencies are injected; `init.lua`
  registers each provider as a **factory** (`function () -> provider | nil`)
  on `registry.set_providers` so probes run after `lazy.setup()` packadds
  plugin deps.
- **Atlas client** — `providers/atlas_client.lua`. Single adapter onto
  `atlas.nvim`. Probed lazily through the Bitbucket factory in `init.lua`:
  the factory force-loads `atlas.nvim` via `lazy.core.loader.load` (atlas is
  `cmd`-lazy and `config.my` loads before plugin specs register), then calls
  `atlas_client.new()` which returns nil if `atlas.pulls.providers.bitbucket.api.*`
  is still unavailable. Methods return `(result, err)` uniformly.
- **gh client** — `providers/gh_client.lua`. Single adapter onto the `gh` CLI
  for GitHub PR review-comment endpoints (atlas.nvim's GitHub provider only
  handles issue comments). Returns nil if `gh` isn't installed. Methods
  shell out via `vim.system({"gh", "api", …})` and return `(result, err)`
  uniformly.
- **Bitbucket links** — `providers/bitbucket_links.lua`. Pure module that
  extracts URLs from a PR's `_raw` payload. Owns the Bitbucket link schema
  (key forks like `request-changes` vs `request_changes`, defensive
  nil-walking) so call sites read as routing.
- **Sign painter** — `sign_painter.lua`. State-driven module that paints
  sign-column extmarks on working-tree code buffers given a
  `{ root, threads_by_path }` snapshot, plus a `threads_for_buffer(bufnr)`
  query used by the qf code-buffer K binding. No autocmds, no provider
  knowledge — `qf.lua` drives it.
- **Normalized comment** — `{ id, anchor = { side, line }, range = { start_line,
  end_line }, path, body, user, user_id, created_at, pending, in_reply_to_id,
  _raw }`. The *only* shape the registry and planner know. Adapters translate
  to/from host-specific schemas. `range` covers multi-line review comments
  and collapses to `start_line == end_line == anchor.line` for single-line
  comments; `sign_plan` only reads `anchor.line`, but `qf.lua`'s sign painter
  paints over the full range.
- **Anchor** — `{ side: "LEFT"|"RIGHT", line: integer }`. Single source of truth
  for which file line a comment attaches to.
- **Sign plan** — pure output of `sign_plan.plan(comments, path, side, line_count)`:
  a `{ line → SignSpec }` map. Tells `render` what to draw.
- **Hunk** — `{ left_start, left_count, right_start, right_count }` parsed from the
  adapter's diff representation. `hunks.contains(...)` decides whether a comment
  range is inside the diff (gates `add_comment`).
- **Thread root** — a comment with `in_reply_to_id == nil`. Only roots place signs;
  replies inherit anchor/path from their root inside the adapter.

## Module roles

- `init.lua` — thin glue. Wires keymaps → qf and autocmds → registry. No state.
- `registry.lua` — **Session registry**.
- `codediff_session.lua` — **CodeDiff session reader**.
- `qf.lua` — working-tree quickfix browser. `<leader>oc` opens; cursor on a
  qf entry renders the thread as `virt_lines` and auto-previews the code in
  the adjacent window. Inside the qf: `r`/`d`/`e` scope to the entry's root;
  `K` opens the full per-comment popup; `<CR>` jumps focus to the previewed
  code window. In code buffers with PR threads loaded, `K` peeks the thread
  under cursor (falls through to `vim.lsp.buf.hover()` off-thread).
- `sign_plan.lua` — pure planner. No vim APIs.
- `render.lua` — buffer effects + per-buffer memo of last-applied plan.
- `hunks.lua` — pure hunk parser + range check.
- `comments_ui.lua` — three entry points:
  - `M.input` — floating prompt for write/edit/reply bodies.
  - `M.open` — floating thread popup; per-comment `r`/`e`/`d` keymaps.
  - `M.thread_virt_lines` — pure helper returning chunked virt_lines.
- `providers/<name>.lua` — adapter, must emit normalized comments. Exposes
  `new(deps)` factory; module-level state forbidden.
- `providers/atlas_client.lua` — **Atlas client**.
- `providers/gh_client.lua` — **gh client**.
- `providers/bitbucket_links.lua` — **Bitbucket links**.
- `sign_painter.lua` — **Sign painter**.
- `lib.lua` — `notify`, memoized `git.origin_url`, `dedup_comments`.
