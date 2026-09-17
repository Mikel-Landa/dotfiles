# Neovim setup review

Reviewed 2026-09-17 against installed Neovim 0.12.2, local configuration, and
maintainer documentation. Recommendations implemented on 2026-09-17.
Upstream requirements are distinguished from optional simplifications.

Implemented: project-owned formatting, preserved Markdown hard breaks, a
chezmoi-managed lockfile, native snippets/comments, one owner per popup and
ShellCheck diagnostics, consolidated icons, fff rename, no cursor/scroll
animations, large-file protection, chart-scoped Helm detection, compound YAML
indent guides, and corrected agent rules. The findings below record the original
audit and rationale.

## Fix first

1. **Fix prettierd arguments; respect project formatting.** The configured
   `--print-width 100` passes `100` as a positional filename; prettierd then rejects
   the actual filename. Its parser accepts `--print-width=100`, but removing the
   global width override is simpler: Prettier CLI options override project
   settings by default. Keep formatting policy in project configuration.
   [prettierd argument parser](https://github.com/fsouza/prettierd/blob/main/src/service.ts),
   [Prettier precedence](https://prettier.io/docs/cli#--config-precedence).
2. **Stop stripping every trailing space on save.** The unconditional
   mini.trailspace trim removes Markdown's two-space hard breaks. Keep whitespace
   highlighting; let language-aware formatters handle edits, or trim explicitly.
   [CommonMark hard breaks](https://spec.commonmark.org/0.31.2/#hard-line-breaks).
3. **Track the plugin lockfile.** The deployed lockfile exists, but the chezmoi
   source lacks it. Capture and commit the tested revisions; restore them on new
   machines. This is lazy.nvim's explicit recommendation.
   [lazy.nvim lockfile](https://lazy.folke.io/usage/lockfile).
4. **Give each popup one owner.** Noice defaults enable LSP progress and automatic
   signatures; Fidget also displays progress, while Blink signatures are enabled.
   Remove Fidget if keeping Noice progress, and disable either Noice or Blink
   signatures. Remove Noice's unused nvim-cmp documentation override. Snacks
   notifications can remain; Fidget does not replace `vim.notify` by default.
   [Noice defaults](https://github.com/folke/noice.nvim#%EF%B8%8F-configuration),
   [Fidget defaults](https://github.com/j-hui/fidget.nvim#options),
   [Blink signatures](https://cmp.saghen.dev/configuration/signature).

## Remove or simplify

| Candidate | Recommendation | Basis |
| --- | --- | --- |
| `mini.comment` setup | Remove unless its custom hooks are needed; none are configured. Keep the other mini modules. | Native `gc`, `gcc`, visual commenting and comment text objects already exist, with Treesitter-aware comment strings. [Neovim](https://neovim.io/doc/user/various/#commenting) |
| LuaSnip and its build step | Optional removal: use Blink's native snippet engine, retaining friendly-snippets. Keep LuaSnip only for advanced snippets actually used. | Blink directly loads friendly-snippets with `vim.snippet`. [Blink](https://cmp.saghen.dev/configuration/snippets) |
| Separate mini.icons dependency | Remove the standalone copy; render-markdown can depend on the already installed mini.nvim collection. | Maintainer documents both alternatives. [render-markdown](https://github.com/MeanderingProgrammer/render-markdown.nvim#installation) |
| ShellCheck through nvim-lint | Remove this wiring while retaining the ShellCheck executable and bashls. Keep nvim-lint for other languages. | bashls automatically invokes installed ShellCheck; the current setup configures both routes. [bash-language-server](https://github.com/bash-lsp/bash-language-server#dependencies) |
| Blanket legacy syntax highlighting | Remove its unconditional reactivation; retain only for a demonstrated language/plugin need. | Treesitter disables regex syntax by default; running both is an explicit exception. [Neovim](https://neovim.io/doc/user/treesitter/#vim.treesitter.start()) |
| Insert-mode pane-navigation bindings | Separate from completion/snippet navigation. Both currently claim `Ctrl-j/k`. | Blink's action chain delegates to other mappings on fallback; context therefore changes the action. [Blink keymaps](https://cmp.saghen.dev/configuration/keymap) |
| smear-cursor and Snacks scroll | Optional removal if the goal is a calmer, leaner editor. | Preference aligned with the local no-animation policy; no measured performance claim. |

These are simplification recommendations, not evidence that the plugins are
abandoned or universally unnecessary.

## Maintenance and performance

- **Update fff's repository name** to `dmtrKovalenko/fff`; upstream explicitly
  documents the rename and recommends `lazy = false` because the plugin performs
  its own lazy initialization. Review the resulting lockfile and remove the old
  managed plugin entry through Lazy's normal cleanup.
  [fff installation](https://github.com/dmtrKovalenko/fff#fffnvim).
- **Consider Snacks bigfile**, already available in the installed suite, if large
  generated/minified files are common. It suppresses LSP/Treesitter attachment
  based on file size or average line length. Optional, not a measured speedup.
  [Snacks bigfile](https://github.com/folke/snacks.nvim/blob/main/docs/bigfile.md).
- **Correct the local eager-loading rule.** Its blanket prohibition contradicts
  Snacks' documented `lazy = false`, `priority = 1000` installation. Follow each
  maintainer's lifecycle requirements, then profile.
  [Snacks installation](https://github.com/folke/snacks.nvim#-usage).
- **Check specialized YAML detection.** The indent-guide allowlist matches only
  plain YAML. Conform already understands dotted filetype components, so duplicate
  formatter entries are unnecessary. Restrict Helm detection to actual charts;
  an arbitrary `templates/` directory does not establish Helm semantics.
  [Conform filetype resolution](https://github.com/stevearc/conform.nvim/blob/master/lua/conform/init.lua).

## Keep

- **Native LSP configuration plus nvim-lspconfig.** The old setup API is deprecated;
  the maintained collection of server configurations is not. This setup already
  uses the recommended native API.
  [nvim-lspconfig maintainers](https://github.com/neovim/nvim-lspconfig#important-%EF%B8%8F).
- **Treesitter main, eager loading and parser updates.** These follow upstream
  instructions. Current main requires Neovim 0.12 and tree-sitter CLI 0.26.1+;
  check both when updating. No need to replace this with another parser manager.
  [Treesitter requirements](https://github.com/nvim-treesitter/nvim-treesitter#quickstart).
- **Lazy, Blink, Conform and the existing modular language bundles.** No evidence
  here warrants rewriting them. Snacks and fff serve distinct configured picker
  roles; browser Markdown preview and in-buffer rendering also serve different
  purposes. Remove either only if unused.

## Validation

Eight Atlas tests pass; keymap documentation covers all 135 declared leader
bindings. Runtime checks pass for project print width, Markdown hard breaks on
save, native snippet expansion and bidirectional Blink jumps, pane-map ownership,
ordinary versus Helm YAML, compound YAML indent guides, large-file LSP/Treesitter/
completion suppression, and initialization of the renamed fff native backend.

The deployed config also contained an unmanaged Octo spec left from an earlier
setup. Chezmoī now removes that file, and Lazy cleaned its unused plugin directory.
Tree-sitter CLI was upgraded from 0.25.8 to 0.27.0 using the already-declared Cargo
package in metapac.

Scoped health checks (Lazy, Blink, Conform, fff, Treesitter) report no errors after
loading Mason. Remaining warnings: missing Cedar/Packer executables and optional
Prettier fallback (prettierd is ready), Markdown formatters whose conditions do
not apply to the health buffer, Blink's informational provider warning, and an
existing native package directory noted by Lazy.

Three real-terminal startup runs measured 579, 480 and 509 ms (median 509 ms).
This remains above the 80 ms target. Profiling identified clipboard-provider
initialization as the largest delay on this WSL host; no startup speedup is claimed.

Follow-up: WSL now selects its clipboard provider explicitly (tmux inside tmux,
Windows clipboard commands otherwise). Native Linux retains automatic detection.
Provider initialization dropped from 646 ms to 2–5 ms; a simulated non-WSL run
confirmed no provider override. Three subsequent terminal startups measured
165, 178 and 178 ms (median 178 ms), down from the earlier 509 ms median.
The WSL check itself measured 0.009 ms, so no detection cache was introduced.

Further profiling disabled mason-tool-installer's optional name integrations:
all 31 configured tools already use Mason package names. The integrations were
loading LSP and the debugger during `VeryLazy`, even on an empty dashboard.
Tool installation remains automatic; debugging still loads on demand.
[Installer integration settings](https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim#configuration).

Five interleaved warm-cache terminal runs per case measured:

| Measurement | Before | After |
| --- | ---: | ---: |
| Empty first draw | 54 ms | 56 ms |
| Empty through `VeryLazy` callbacks | 467 ms | 117 ms |
| Lua file first draw | 188 ms | 172 ms |
| Lua file through `VeryLazy` callbacks | 559 ms | 249 ms |

The meaningful improvement is reduced work after the first draw. The harness
answered terminal background/DSR queries; without responses, even `--clean`
incurred an artificial ~110 ms wait. Earlier terminal measurements may include
that wait and are not directly comparable. `VeryLazy` timing starts at an early
`--cmd` hook and ends in a scheduled callback after event handlers complete;
it excludes language-server readiness and the install check delayed by 3 seconds.
Validation confirmed all package names resolve and codelldb/delve adapters load
on demand. Further startup micro-optimization is low priority; empty first draw
already meets the 80 ms budget.
