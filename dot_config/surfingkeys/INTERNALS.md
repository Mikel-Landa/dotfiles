# SurfingKeys Internals — Reference for Editors

Notes harvested from the SurfingKeys source (cloned at `~/personal/Surfingkeys`,
upstream: https://github.com/brookhong/Surfingkeys). Read this before editing
`config.js` so you don't have to re-walk the codebase.

All file paths below are relative to the SurfingKeys repo root.

---

## How user code is evaluated

User snippet (the thing pasted into the Settings editor) is wrapped and run by
the extension as a function:

```js
(api, settings) => {
  /* contents of config.js */
}
```

Two evaluation paths:

- **MV2 / Firefox:** `src/content_scripts/content.js:129`
  ```js
  (new Function('settings', 'api', rs.snippets))(settings, api);
  ```
- **MV3 / Chrome:** `src/background/start.js:1252`
  ```js
  const code = `import('./api.js').then((module) => {module.default("${chrome.runtime.getURL("/")}", (api, settings) => {${snippets}\n})});`;
  chrome.userScripts.register([{ allFrames: true, id: userScriptId, ... js:[{code}] }], ...);
  ```

Consequences:

- `api` and `settings` are **function parameters**, not globals. Don't try to
  destructure from `window` or expect them on `globalThis`.
- The wrapper runs in **page context for top frame only** — see `index.js:304`
  `if (isInUIFrame()) return;`. The omnibar / popups live in a separate
  cross-origin extension iframe that user code cannot reach.
- `settings` starts as `{}` and is read back by the extension via
  `applyUserSettings({settings, error})` (`index.js:312`) after the snippet
  returns. So mutate fields synchronously at top level.

---

## What `api` actually exposes

Authoritative list — `src/user_scripts/index.js:166-300`:

```text
api.RUNTIME(action, args, callback?)        // dispatch to background
api.tabOpenLink(url, simultaneousness?)     // open in new tab
api.map(newKey, oldKey, domain?, annot?)    // alias one keystroke to another
api.mapkey(keys, annotation, fn, options?)  // bind keys to a function
api.unmap(keystroke, domain?)
api.unmapAllExcept(keystrokes[], domain?)
api.imap / api.imapkey / api.iunmap         // insert mode
api.cmap                                    // omnibar (Command mode)
api.vmap / api.vmapkey / api.vunmap         // visual mode
api.lmap                                    // lurk mode
api.addCommand(name, description, action)
api.addSearchAlias(alias, prompt, search_url, search_leader_key?,
                   suggestion_url?, parse_callback?, only_this_site_key?,
                   options?)
api.removeSearchAlias(alias, leader?, only_this_site_key?)
api.searchSelectedWith(se, onlyThisSite, interactive, alias)
api.aceVimMap, api.addVimMapKey
api.readText(text, options)
api.getBrowserName(), api.getClickableElements(),
api.isElementPartiallyInViewport(el)

api.Clipboard.{read(cb), write(text)}
api.Hints.{click, create, dispatchMouseClick, style,
           setNumeric, setCharacters}
api.Normal.{feedkeys, jumpVIMark, passThrough, scroll}
api.Visual.{style}
api.Front.{openOmnibar, registerInlineQuery, showEditor,
           showBanner, showPopup}
```

**Not on `api` (common foot-guns):**

- `Front.showUsage` — does not exist as user-facing API. The default `?` key
  (bound by SurfingKeys itself) shows help; don't try to call it from a
  mapping.
- `Hints.createInputLayer` — internal-only. For "focus an input": use
  `api.Hints.create("input, textarea, [contenteditable]", api.Hints.dispatchMouseClick)`.
  (The default `i` and `gi` already do this.)
- No `top.X` / `window.X` hooks for any of the above. Always go through `api`.

### `mapkey` signature details

`api.mapkey(keys, annotation, fn, options?)`:

- `keys` — the chord, e.g. `"]t"`, `"gn"`, `"<Ctrl-y>"`.
- `annotation` — string. **Prefix with `#N`** to slot into a feature group
  in the `?` help (see "Feature groups" below).
- `fn` — a real JavaScript function, **not** a string. (Older docs sometimes
  show string form for SurfingKeys; the user-script API only accepts
  functions.)
- `options.repeatIgnore: true` if `5gx` shouldn't repeat the action.
- `options.domain: /youtube\.com/i` to scope to a single site.

### Feature groups for `?` help

Annotations like `"#3Move tab right"` slot under feature group 3. Numbers
in use across `default.js`:

| #  | Group |
|----|-------|
| 1  | Mouse / hints / inputs |
| 2  | Scroll |
| 3  | Tabs |
| 4  | Page navigation / history |
| 5  | Sessions / quit |
| 7  | Clipboard / yank |
| 8  | Omnibar |
| 9  | Visual mode |
| 11 | Misc tools |
| 12 | Misc tools (page source, etc.) |
| 14 | History data |

Skip the prefix and the binding shows up in an "uncategorized" bucket.

---

## `RUNTIME` action names

`api.RUNTIME("name", args, callback?)` posts a message to the background
script. Handlers live in `src/background/start.js` as `self.<name> = ...`.

### Tab / window actions

| Action | Args | Notes |
|--------|------|-------|
| `nextTab` | — | Positional, wraps |
| `previousTab` | — | |
| `closeTab` | — | Closes current |
| `openLast` | — | Restore last closed (X by default) |
| `duplicateTab` | — | |
| `togglePinTab` | — | |
| `muteTab` | — | |
| `moveTab` | `{ step: ±1, repeats: n }` | Move N positions; **the only mover** — there is no `moveTabLeft` / `moveTabRight` |
| `moveToWindow` | — | Opens omnibar to pick target window |
| `historyTab` | `{ backward: bool }` or `{ index: n }` | MRU navigation. `gt`/`gT` defaults use this with `index: -1`/`0`. |
| `focusTab` | `{ tabId, windowId? }` | |
| `focusTabByIndex` | `{ index: n }` | |
| `goToLastTab` | — | Alt-Tab equivalent |
| `reloadTab` | `{ nocache: bool }` | |
| `tabOnly`, `closeAudibleTab`, `closeTabLeft/Right`, `closeTabsToLeft/Right` | — | Bulk close variants |
| `getTabs` | `{ queryInfo: {...} }` | Async via callback |

### Zoom

There is **one** zoom action: `setZoom`.

| Action | Args |
|--------|------|
| `setZoom` | `{ zoomFactor: 0 }` reset · `{ zoomFactor: 0.1 }` in · `{ zoomFactor: -0.1 }` out |

`zoomIn` / `zoomOut` / `zoomReset` do **not** exist.

### History / page

| Action | Args |
|--------|------|
| `getHistory` | `{}` async |
| `deleteHistoryOlderThan` | `{ days: n }` |
| `getDownloads` | `{ query: { state } }` async |

For "next page link" / "previous page link" (`]]` / `[[`): SurfingKeys uses
`hints.previousPage` / `hints.nextPage` directly inside the content script.
**Not** a RUNTIME action.

### Misc

| Action | Args |
|--------|------|
| `openLink` | `{ url, tab: { tabbed, active } }` |
| `openIncognito` | `{ url }` |
| `viewSource` | `{ tab: { tabbed: true } }` |
| `gatherWindows` | — |
| `setSurfingkeysIcon` | — |

When in doubt: `grep -n "self\." ~/personal/Surfingkeys/src/background/start.js`.

---

## Default mappings cheat-sheet

Defaults you should **not** redefine (or be intentional about overriding).
Source: `src/content_scripts/common/default.js`.

### Tabs

| Key | Action |
|-----|--------|
| `gt` / `gT` | MRU last / first activated tab (NOT positional) |
| `g0` / `g$` | Positional first / last (via `:feedkeys 99E`/`99R`) |
| `E` / `R` | Positional prev / next tab |
| `B` / `F` | Tab history backward / forward |
| `<Ctrl-6>` | Last used tab |
| `t` | URL omnibar (new tab) |
| `T` | Choose tab |
| `go` | URL omnibar (current tab) |
| `H` | Open-tabs omnibar (`TabURLs`) |
| `W` | Move tab to another window |
| `x` / `X` | Close / restore tab |
| `<Alt-p>` / `<Alt-m>` | Pin / mute |
| `r` | Reload |
| `S` / `D` | History back / forward |
| `gx0` / `gx$` / `gxt` / `gxT` | Close left/right/this-left/this-right of current |

### Hints / clicking

| Key | Action |
|-----|--------|
| `f` / `F` | Click hint / hint in new tab |
| `af` | Hint in new active tab |
| `cf` | Multi-hint click |
| `gf` | Hint in incognito |
| `C` | Open in new tab (link under cursor?) |
| `;f` | Multi-hint mode |
| `i` | Focus an editable element (uses `getCssSelectorsOfEditable`) |
| `gi` | Focus first editable |
| `I` | Focus editable + open vim editor |
| `L` | Regional hints mode (NOT forward history) |

### Yank (most single + double `y_` chords are taken)

| Key | Action |
|-----|--------|
| `yy` | Page URL |
| `yt` / `yT` | Duplicate tab / in background |
| `yY` | All tabs URLs |
| `yv` / `ymv` | Element text / multiple |
| `yh` | Page host |
| `yl` | Page **title** (NOT a link) |
| `ya` / `yma` | Pick link via hint / multiple |
| `yi` | Yank an input's value |
| `yc` / `ymc` | Table column / multiple |
| `ys` | Page source |
| `yj` | Current settings |
| `yq` | `<pre>` text |
| `yg` | Capture page |

Add new yank shortcuts under three-char `ym_` chords or with capitalized
suffix, e.g. `yI`, to avoid collisions.

### Omnibar

| Key | Action |
|-----|--------|
| `t` | URL (new tab) |
| `go` | URL (current tab) |
| `b` | Bookmarks |
| `T` | Choose tab |
| `H` | TabURLs |
| `:` | Commands |
| `A` | LLM chat |
| `oh` | History |
| `om` | VIMarks |
| `ox` | Recently closed |
| `oi` | Open incognito window |
| `on` | Open new tab (some browsers) |
| `ab` | Add bookmark |
| `;x` | Close tabs by URL |

`o` alone is **not** bound by default. Don't bind it — it would shadow all
`o_` chords.

### Misc

- `?` shows the help popup (lists all `mapkey` annotations grouped by `#N`).
- `Esc` cancels modes / closes popups.
- `m{a-z}` set local mark, `'{a-z}` jump (cross-tab via `M`/`'A-Z`).
- `[[` / `]]` follow rel=prev / rel=next page links.

---

## Omnibar internals (when you need to theme or extend)

- Rendered in a cross-origin iframe served from `pages/frontend.html`.
  User code does **not** run inside it (`src/user_scripts/index.js:304`).
- Key handling is in `src/content_scripts/ui/omnibar.js`. The `<Esc>` close
  handler at line ~344 is hardcoded; `cmap` cannot replace it.
- Omnibar default key remaps live in `default.js:436-437`:
  `cmap('<ArrowDown>', '<Ctrl-n>')` / `cmap('<ArrowUp>', '<Ctrl-p>')`.
  We add `cmap('<Ctrl-j>', '<Ctrl-n>')` / `cmap('<Ctrl-k>', '<Ctrl-p>')`.

### CSS selectors that matter for theming

| Selector | What it is |
|----------|------------|
| `.sk_theme` | Base wrapper applied to all SurfingKeys UI surfaces |
| `#sk_omnibar` | Omnibar container |
| `#sk_omnibarSearchArea` | Input row inside omnibar |
| `#sk_omnibarSearchResult` | Results list container |
| `#sk_omnibarSearchResult ul li.focused` | Highlighted row |
| `.sk_theme .url` / `.title` / `.annotation` / `.prefix` | Result columns |
| `.sk_theme .omnibar_highlight` / `.omnibar_timestamp` / `.omnibar_visitcount` | Match / metadata |
| `#sk_status` | Status line at bottom of viewport |
| `#sk_find` | Find-in-page banner |
| `#sk_keystroke` / `#sk_richKeystroke` | Pending keystroke popups |
| `.sk_theme div.hint` | Link-follow hint markers |

`settings.theme` is a CSS string, injected into the iframe's `<style>`.
You can set CSS custom properties at the top (we do — `--sk-bg` etc.) and
reference them throughout.

`settings.omnibarPosition` accepts `"top"` or `"bottom"`.

---

## Settings worth knowing

Defined in `src/content_scripts/common/runtime.js` under
`runtime.conf.<key>`:

| Setting | Default | Notes |
|---------|---------|-------|
| `smoothScroll` | `true` | Setting `false` made flicker on pages with sticky headers / reflows |
| `scrollStepSize` | `70` | Larger = jumpier |
| `scrollFriction` | `0` | Smooth-scroll deceleration |
| `omnibarPosition` | `"middle"` | `"top"` / `"bottom"` also valid |
| `tabsThreshold` | `9` | Show tab picker when count exceeds; `0` = always |
| `defaultSearchEngine` | `"g"` (Google) | Use the alias key |
| `hintCharacters` | `"sadfjklewcmpgh"` | Letters used for hint labels |
| `hintAlign` | `"left"` | |
| `richHintsForKeystroke` | `0` | `1` shows annotation alongside |
| `modeAfterYank` | `"Insert"` | We use `"Normal"` |
| `focusFirstCandidate` | `false` | Pre-select first omnibar result |
| `blacklistPattern` | `null` | Regex of sites where SurfingKeys disables itself |

For the full list: `grep -n "conf\." src/content_scripts/common/runtime.js`.

---

## Debugging

- `console.error("userScripts API error:", chrome.runtime.lastError)` from the
  MV3 path (`start.js:1241`) — check the extension's service worker console
  if your snippet seems to silently fail.
- The `applyUserSettings({settings, error})` flow surfaces a banner on the
  page if your snippet threw at top-level. Read the banner first; common
  causes: typo in `RUNTIME` action name (silently no-ops), referencing a
  non-existent property of `api.Hints` / `api.Front`, undefined identifier
  because `api`/`settings` are scoped function params (the snippet is wrapped
  by the extension).
- When testing rapidly, keep the SurfingKeys options page open in one tab
  and a target page in another. Save in options → reload target → repeat.

---

## Quick recipes

### Add a tab action

```js
api.mapkey("g!", "#3My new tab thing", () => api.RUNTIME("nextTab"));
```

### Yank something custom

```js
api.mapkey("ymX", "#7Yank as X", () => api.Clipboard.write(buildXFor(window.location)));
```

### New omnibar picker

```js
api.mapkey("oX", "#8Omnibar: my picker", () =>
  api.Front.openOmnibar({ type: "URLs", extra: "getAllSites" })
);
```

### Site-scoped binding

```js
api.mapkey("<Space>", "#3Toggle play", () => {
  document.querySelector("video")?.click();
}, { domain: /youtube\.com/i });
```

### Add a search engine

```js
api.addSearchAlias("h", "github", "https://github.com/search?q=");
// Now `oh<query>` searches on github via omnibar; `sh` searches selection.
```
