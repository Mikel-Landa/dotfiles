# SurfingKeys Config — Agent Instructions

Vim-flavored Chrome extension for keyboard-driven browsing.

This folder ships **`config.js`** — paste manually into the SurfingKeys options
page (Chrome extensions cannot auto-load from the filesystem). Re-paste after
edits.

For internals (runtime model, exported API surface, file layout, source
references, common foot-guns), read **[INTERNALS.md](INTERNALS.md)** before
making non-trivial changes. It exists so you don't have to re-read the
SurfingKeys source each time.

## Philosophy

- **Mirror neovim muscle memory.** When choosing chord shapes for a new feature,
  first ask "what does nvim use?" — then use that. Browser-specific tweaks are
  fine where the metaphor breaks down (no splits in browsers, etc).
- **No Ctrl, no leader.** Single keys or two-key chords only. Chrome reserves
  Ctrl-combos and they conflict with site shortcuts. SurfingKeys defaults
  follow this too — keep it consistent.
- **Lean on defaults; do not redefine them.** SurfingKeys has rich defaults
  for `y_`, `o_`, `g_`, hints, history, omnibar. Inspect them before adding a
  binding (see INTERNALS.md → "Default mappings cheat-sheet"). Override only
  when the default is wrong for nvim flavor (e.g. `h`/`l` history, defaults
  use them for horizontal scroll).
- **Two-key chords use thematic prefixes:**
  - `g_` — vim-style misc actions (homepage, URL nav, new tab)
  - `[_` / `]_` — unimpaired-style pair-cycling (tabs, sections)
  - `y_` — yank (extends defaults; uppercase / 3-char chords avoid collision)
  - `o_` — omnibar pickers
  - `;_` — misc (pin tab, mute, hover element)
  - `z_` — zoom (already a default)
- **Every `mapkey` annotation gets a `#N` feature_group prefix** so it lands
  under the right heading in `?` help. Numbers used: `#1` mouse/hints,
  `#3` tabs, `#4` history/nav, `#7` clipboard/yank, `#8` omnibar.
- **Theme matches matugen palette** (see `~/.config/matugen/colors.json`)
  so the omnibar feels like Snacks.picker in nvim.
- **Don't bind a single key that's also a chord prefix.** Binding `o` alone
  would shadow `ob`/`ot`/`oc` etc. Same applies to `g`, `y`, `[`, `]`, `;`, `z`.

## Editing Workflow

1. Edit `config.js` here in the chezmoi source.
2. `chezmoi apply` to sync to `~/.config/surfingkeys/config.js`.
3. Open the SurfingKeys options page, paste the file's contents into the
   Settings editor, click **Save**.
4. Reload any open tab to pick up the new bindings.

There is no auto-load. Browser extensions cannot read from `~/.config/`.

## Constraints That Have Already Bitten Us

These are sharp edges that look fixable but aren't — re-read INTERNALS.md
before claiming you've found a workaround.

- **Omnibar cannot have a "normal mode" (vim-Snacks-picker style two-mode
  behavior).** The omnibar runs in a cross-origin extension iframe; user
  scripts skip the iframe (`src/user_scripts/index.js:304`). `<Esc>` is
  hardcoded to `front.hidePopup()`. Only static `cmap` remappings reach the
  omnibar. Don't keep trying.
- **`Front.showUsage` and `Hints.createInputLayer` are NOT exposed on `api`.**
  Use `Front.openOmnibar` / `Hints.create(getCssSelectorsOfEditable, ...)`
  patterns instead.
- **`RUNTIME` action names are easy to get wrong.** Real names: `nextTab`,
  `previousTab`, `closeTab`, `openLast`, `duplicateTab`, `togglePinTab`,
  `muteTab`, `moveTab` (with `{step: ±1}`), `setZoom` (with `{zoomFactor}`),
  `historyTab`, `focusTab`, `focusTabByIndex`, `goToLastTab`, `moveToWindow`,
  `reloadTab`. There is **no** `moveTabRight`, `zoomIn`, `firstTab`, etc.

## Maintaining This File

If you change the philosophy or add a new convention prefix, update both this
file and the comments at the top of `config.js`. Keep INTERNALS.md focused on
"what the SurfingKeys source actually does" — design choices belong here.
