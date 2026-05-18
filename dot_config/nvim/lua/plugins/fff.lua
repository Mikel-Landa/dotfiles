-- fff.nvim: Rust-backed fuzzy file picker + live grep with frecency.
-- Binary auto-installs via `build` hook (prebuilt download, falls back to cargo).
-- Keymaps for ff/fg/fc live in lua/config/keymaps.lua.

return {
	{
		"dmtrKovalenko/fff.nvim",
		build = function()
			require("fff.download").download_or_build_binary()
		end,
		event = "VeryLazy",
		opts = {
			prompt = "> ",
			title = "FFFiles",
			layout = {
				prompt_position = "top",
				preview_position = "right",
			},
			frecency = { enabled = true },
			git = { status_text_color = true },
		},
	},
}
