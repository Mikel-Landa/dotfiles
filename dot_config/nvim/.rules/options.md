# Options

Set globals in `lua/config/options.lua`. Two APIs:

- `vim.opt.x = ...` — table interface, supports `:append`/`:prepend`/`:remove` for list/map options. Use for `shortmess`, `wildignore`, `formatoptions`, etc.
- `vim.o.x = ...` — plain scalar setter. Slightly faster, fine for `shiftwidth`, `number`, `relativenumber`, etc.

Pick the simpler one. The codebase uses `vim.opt` consistently — keep that, but don't religiously avoid `vim.o`.

Filetype-specific overrides → `ftplugin/<ft>.lua` with `vim.opt_local` (auto-loaded by nvim on `FileType`). Avoid putting filetype branching in `autocmds.lua`.
