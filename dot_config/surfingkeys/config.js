// SurfingKeys config — neovim-flavored, builds on defaults.
//
// Goals:
//   - Mirror neovim muscle memory in browser.
//   - No Ctrl, no leader. Single keys or two-key chords only.
//   - "g"-prefix (vim-style), "[" / "]" unimpaired pair-cyclers, "y" yank
//     additions, "o" omnibar pickers, ";" misc.
//
// Install: SurfingKeys options page → Settings → paste contents → save.
// No filesystem auto-load (Chrome ext can't). Re-paste after edits.
//
// SurfingKeys runtime (verified against repo source):
//   - User code is wrapped: `(api, settings) => { <this file> }` and invoked
//     by the extension. So `api` and `settings` are scoped function params,
//     not globals — call `api.mapkey(...)`, set `settings.X = Y`.
//   - `api.mapkey(keys, annotation, fn, options)` — fn is a function.
//   - `api.RUNTIME(action, args, cb?)` dispatches to background; valid tab
//     actions: nextTab, previousTab, closeTab, openLast, duplicateTab,
//     togglePinTab, muteTab, focusTab, focusTabByIndex, goToLastTab,
//     historyTab, reloadTab, moveTab({step}), moveToWindow, setZoom({zoomFactor}).
//
// Useful defaults already provided by SurfingKeys (do NOT redefine these):
//   Tabs:    gt/gT (MRU last/first), g0/g$ (positional first/last via feedkeys),
//            E/R (positional prev/next), x/X (close/restore), t (URL omnibar),
//            T (choose tab), W (move to other window), <Alt-p>/<Alt-m> (pin/mute)
//   Hints:   f / F / af / cf / ;f / C
//   Edit:    i (focus input), gi (focus first input), I (input → vim editor)
//   History: S (back), D (forward), H (TabURLs omnibar)
//   Reload:  r
//   Yank:    yy (URL), yt (dup tab), yT (dup background), yY (all tabs URL),
//            yv (element text), yh (host), yl (page title), ya (link via hint),
//            yi (input value), ys (page source), yj (settings), yc (table col)
//   Omnibar: oh (history), om (marks), ox (recently closed), oi (incognito),
//            b (bookmarks), : (commands), A (LLM chat)
//   Section: [[ / ]] (rel=prev/next page links)
//   Zoom:    zr / zi / zo (already correct: setZoom)
//   Misc:    v / V (visual), / n N (find), m{a} '{a} (marks), gg G % (scroll)

// ============================================================================
// Settings
// ============================================================================

settings.hintAlign = "left";
settings.smoothScroll = false;
settings.scrollFriction = 0;      // default
// scrollStepSize: leave default (70). Larger steps amplify flicker.
settings.modeAfterYank = "Normal";
settings.focusFirstCandidate = true;
settings.tabsThreshold = 0;
settings.omnibarPosition = "top";
settings.richHintsForKeystroke = 1;
settings.defaultSearchEngine = "g";
settings.hintCharacters = "asdfghjklqwertyuiopzxcvbnm";

settings.blacklistPattern = /(mail\.google\.com|app\.slack\.com|monkeytype\.com|app\.element\.io|figma\.com|excalidraw\.com)/i;

// ============================================================================
// Theme — matches matugen / Snacks.picker palette in nvim
//   bg #141218, surface #211f24 / #2b292f, border #49454e,
//   accent #d0bcff (lavender), fg #e6e0e9, dim #cac4cf
// ============================================================================
settings.theme = `
:root {
  --sk-bg:        #141218;
  --sk-bg-alt:    #1c1a20;
  --sk-surface:   #211f24;
  --sk-surface-2: #2b292f;
  --sk-border:    #49454e;
  --sk-fg:        #e6e0e9;
  --sk-fg-dim:    #cac4cf;
  --sk-muted:     #948f99;
  --sk-accent:    #d0bcff;
  --sk-accent-2:  #ccc2dc;
  --sk-error:     #f2b8b5;
  --sk-radius:    12px;
}

/* base */
.sk_theme {
  font-family: "Inter", "SF Pro Text", -apple-system, BlinkMacSystemFont,
               "Segoe UI", Roboto, "Helvetica Neue", sans-serif;
  font-size: 12pt;
  background: var(--sk-bg);
  color: var(--sk-fg);
}
.sk_theme tbody { color: var(--sk-fg); }
.sk_theme input,
.sk_theme input:focus {
  color: var(--sk-fg);
  background: transparent;
  border: none;
  outline: none;
  caret-color: var(--sk-accent);
}

/* omnibar container — rounded, bordered, floating */
#sk_omnibar {
  background: var(--sk-bg) !important;
  border: 1px solid var(--sk-border) !important;
  border-radius: var(--sk-radius) !important;
  box-shadow: 0 24px 60px rgba(0, 0, 0, 0.55),
              0 0 0 1px rgba(255, 255, 255, 0.02) inset !important;
  padding: 6px !important;
  width: min(820px, 92vw) !important;
  left: 50% !important;
  transform: translateX(-50%) !important;
  margin: 16px 0 0 0 !important;
  overflow: hidden !important;
}

/* search input row */
#sk_omnibar .sk_omnibar_input,
#sk_omnibar > div:first-child {
  background: var(--sk-surface) !important;
  border-radius: calc(var(--sk-radius) - 4px) !important;
  padding: 10px 14px !important;
  margin-bottom: 6px !important;
  border: 1px solid transparent !important;
}
#sk_omnibar input {
  font-size: 13pt !important;
  width: 100% !important;
}

/* results list */
#sk_omnibarSearchResult {
  background: transparent !important;
  padding: 0 !important;
  margin: 0 !important;
  max-height: 60vh !important;
  overflow-y: auto !important;
}
#sk_omnibarSearchResult ul {
  margin: 0 !important;
  padding: 0 !important;
  list-style: none !important;
}
#sk_omnibarSearchResult ul li {
  padding: 8px 14px !important;
  margin: 1px 0 !important;
  border-radius: 8px !important;
  border: none !important;
  line-height: 1.4 !important;
}
#sk_omnibarSearchResult ul li:nth-child(odd) { background: transparent !important; }
.sk_theme #sk_omnibarSearchResult ul li.focused {
  background: var(--sk-surface-2) !important;
  box-shadow: inset 2px 0 0 var(--sk-accent) !important;
}

/* result content colors */
.sk_theme .url           { color: var(--sk-accent); }
.sk_theme .annotation    { color: var(--sk-fg-dim); }
.sk_theme .omnibar_highlight   { color: var(--sk-accent); font-weight: 600; }
.sk_theme .omnibar_timestamp   { color: var(--sk-muted); }
.sk_theme .omnibar_visitcount  { color: var(--sk-accent-2); }
.sk_theme .prefix       { color: var(--sk-muted); }
.sk_theme .title        { color: var(--sk-fg); }

/* status / find / keystroke popups */
#sk_status, #sk_find {
  background: var(--sk-bg) !important;
  border: 1px solid var(--sk-border) !important;
  border-radius: var(--sk-radius) !important;
  padding: 8px 14px !important;
  font-size: 14pt !important;
  color: var(--sk-fg) !important;
  box-shadow: 0 12px 32px rgba(0, 0, 0, 0.5) !important;
}
#sk_keystroke {
  background: var(--sk-bg) !important;
  color: var(--sk-fg) !important;
  border: 1px solid var(--sk-border) !important;
  border-radius: 10px !important;
  padding: 6px 10px !important;
}
#sk_richKeystroke {
  background: var(--sk-bg) !important;
  border: 1px solid var(--sk-border) !important;
  border-radius: var(--sk-radius) !important;
  color: var(--sk-fg) !important;
  box-shadow: 0 16px 40px rgba(0, 0, 0, 0.5) !important;
}

/* hints (link follow markers) */
.sk_theme div.hint {
  background: var(--sk-accent) !important;
  color: var(--sk-bg) !important;
  border: 1px solid var(--sk-border) !important;
  border-radius: 6px !important;
  font-weight: 700 !important;
  padding: 1px 4px !important;
  font-family: "JetBrainsMono Nerd Font", "JetBrains Mono", ui-monospace, monospace !important;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.4) !important;
}

/* scrollbar inside omnibar */
#sk_omnibarSearchResult::-webkit-scrollbar { width: 8px; }
#sk_omnibarSearchResult::-webkit-scrollbar-track { background: transparent; }
#sk_omnibarSearchResult::-webkit-scrollbar-thumb {
  background: var(--sk-border);
  border-radius: 4px;
}
`;

// ============================================================================
// Tabs — unimpaired pair + extras (keep defaults gt/gT MRU, E/R positional)
// ============================================================================
api.mapkey("]t", "#3Next tab",         () => api.RUNTIME("nextTab"));
api.mapkey("[t", "#3Prev tab",         () => api.RUNTIME("previousTab"));
api.mapkey("]b", "#3Next tab (alias)", () => api.RUNTIME("nextTab"));
api.mapkey("[b", "#3Prev tab (alias)", () => api.RUNTIME("previousTab"));
api.mapkey("]T", "#3Move tab right",   () => api.RUNTIME("moveTab", { step:  1 }));
api.mapkey("[T", "#3Move tab left",    () => api.RUNTIME("moveTab", { step: -1 }));
api.mapkey("gn", "#3New blank tab",    () => api.tabOpenLink("about:blank"));
api.mapkey("gd", "#3Duplicate tab",    () => api.RUNTIME("duplicateTab"));
api.mapkey(";p", "#3Pin/unpin tab",    () => api.RUNTIME("togglePinTab"));
api.mapkey(";m", "#3Mute/unmute tab",  () => api.RUNTIME("muteTab"));

// ============================================================================
// History — h back, l forward (override defaults: scroll left/right)
// ============================================================================
api.mapkey("h", "#4Go back in history",    () => history.go(-1), { repeatIgnore: true });
api.mapkey("l", "#4Go forward in history", () => history.go( 1), { repeatIgnore: true });

// ============================================================================
// URL hierarchy — vim-tree-of-fugitive flavor
// ============================================================================
api.mapkey("gh", "#4Go to homepage", () => { window.location.href = "about:newtab"; });
api.mapkey("gu", "#4Go up one URL segment", () => {
  const u = new URL(window.location.href);
  u.hash = "";
  u.search = "";
  u.pathname = u.pathname.replace(/\/?[^/]+\/?$/, "/");
  window.location.href = u.toString();
});
api.mapkey("gU", "#4Go to URL root", () => { window.location.href = window.location.origin; });

// ============================================================================
// Yank additions (defaults occupy most of y_ — only add non-conflicting)
// ============================================================================
api.mapkey("ymd", "#7Yank as markdown link", () =>
  api.Clipboard.write(`[${document.title}](${window.location.href})`)
);
api.mapkey("yu",  "#7Yank page title + URL", () =>
  api.Clipboard.write(`${document.title} — ${window.location.href}`)
);
api.mapkey("yI",  "#7Yank image src", () =>
  api.Hints.create("img", (el) => api.Clipboard.write(el.src))
);

// ============================================================================
// Hints — extras (defaults cover f/F/af/cf/;f/C/I/L)
// ============================================================================
api.mapkey(";h", "#1Hover element", () =>
  api.Hints.create("", api.Hints.dispatchMouseClick, { mouseEvents: ["mouseover"] })
);
api.mapkey(";U", "#1Un-hover element", () =>
  api.Hints.create("", api.Hints.dispatchMouseClick, { mouseEvents: ["mouseout"] })
);

// ============================================================================
// Omnibar — `o`-prefix additions only. Defaults already bind:
//   t  → URL omnibar (new tab)        b  → bookmarks
//   T  → choose tab                   H  → TabURLs (open tabs)
//   oh → history                      om → marks
//   ox → recently closed              oi → incognito
//   :  → commands                     A  → LLM chat
//   go → URL omnibar (current tab)
// (Don't bind `o` alone — would shadow the o-prefix chords.)
// ============================================================================
api.mapkey("ob", "#8Omnibar: bookmarks", () => api.Front.openOmnibar({ type: "Bookmarks" }));
api.mapkey("ot", "#8Omnibar: tabs",      () => api.Front.openOmnibar({ type: "Tabs" }));
api.mapkey("oc", "#8Omnibar: commands",  () => api.Front.openOmnibar({ type: "Commands" }));

// `e` = focus address bar (URL omnibar, current tab, current URL pre-filled).
// Same as default `go`. Mirrors browser convention "edit URL".
api.map("e", "go");

// ============================================================================
// Omnibar navigation — vim-flavored Ctrl-j/k cycle (defaults: Ctrl-n/Ctrl-p
// and arrows already work; this adds Ctrl-j/k aliases)
// ============================================================================
api.cmap("<Ctrl-j>", "<Ctrl-n>");
api.cmap("<Ctrl-k>", "<Ctrl-p>");

// ============================================================================
// Search engine aliases — `o{alias}<query>` filters omnibar to that engine
// (default leader for direct search is `s`, e.g. `sh` searches selection on github)
// ============================================================================
api.addSearchAlias("h", "github", "https://github.com/search?q=");
api.addSearchAlias("n", "npm", "https://www.npmjs.com/search?q=");
api.addSearchAlias("m", "mdn", "https://developer.mozilla.org/en-US/search?q=");
api.addSearchAlias("w", "wikipedia", "https://en.wikipedia.org/w/index.php?search=");
api.addSearchAlias("y", "youtube", "https://www.youtube.com/results?search_query=");
api.addSearchAlias("a", "archwiki", "https://wiki.archlinux.org/index.php?search=");
api.addSearchAlias("d", "duckduckgo", "https://duckduckgo.com/?q=");
