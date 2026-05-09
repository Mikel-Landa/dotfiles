# Diagnostics

- VSCode-style: `underline` on (red undercurl), `virtual_text` off, signs in gutter — config in `lua/config/autocmds.lua`
- Float auto-opens on `CursorHold` (`updatetime = 250`) at cursor scope; suppressed if any other float is open
- Manual float: `<leader>dd`. Panel: `<leader>xx` (Trouble)
- Tmux requires `Smulx` + `Setulc` in `terminal-overrides` for colored undercurl — see `~/.config/tmux/tmux.conf`
