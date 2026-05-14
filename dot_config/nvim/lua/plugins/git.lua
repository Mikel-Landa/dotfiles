-- git: neogit magit-style UI, gitsigns gutter+hunks,
-- codediff for diffs (VSCode-parity, inline by default, 3-way merge).

-- Resolve the upstream default branch. Tries origin/HEAD (set via
-- `git remote set-head origin -a`), falling back to common names.
local function resolve_base_branch()
	local function run(cmd)
		local r = vim.system(cmd, { text = true }):wait()
		return r and r.code == 0 and vim.trim(r.stdout) or nil
	end

	local base = run({ "git", "symbolic-ref", "--short", "refs/remotes/origin/HEAD" })
	if base then
		return base
	end
	for _, candidate in ipairs({ "origin/main", "origin/master", "origin/develop", "origin/trunk" }) do
		if run({ "git", "rev-parse", "--verify", candidate }) then
			return candidate
		end
	end
	return nil
end

return {
	-- Magit-style git UI. Day-to-day diff viewer: codediff.
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"esmuellert/codediff.nvim",
		},
		cmd = "Neogit",
		keys = {
			{ "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit status" },
			{ "<leader>gc", "<cmd>Neogit commit<cr>", desc = "Neogit commit" },
			{ "<leader>gP", "<cmd>Neogit push<cr>", desc = "Neogit push" },
		},
		opts = {
			disable_hint = true,
			graph_style = "unicode",
			diff_viewer = "codediff",
			integrations = {
				codediff = true,
				diffview = false,
			},
		},
	},

	-- Git signs in gutter
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		keys = {
			{
				"<leader>gti",
				function()
					local gs = require("gitsigns")
					vim.g.my_inline_diff = not vim.g.my_inline_diff
					gs.toggle_linehl(vim.g.my_inline_diff)
					gs.toggle_deleted(vim.g.my_inline_diff)
					gs.toggle_word_diff(vim.g.my_inline_diff)
				end,
				desc = "Toggle inline diff (linehl+deleted+word)",
			},
		},
		opts = {
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
				untracked = { text = "▎" },
			},
			signs_staged = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
			},
			current_line_blame = true,
			current_line_blame_opts = { delay = 300, virt_text_pos = "eol" },
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns
				local map = function(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
				end

				-- Navigation (fall back to native ]c/[c in diff mode)
				map("n", "]c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gs.nav_hunk("next")
					end
				end, "Next hunk")
				map("n", "[c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gs.nav_hunk("prev")
					end
				end, "Prev hunk")

				-- Stage / reset
				map("n", "<leader>gs", gs.stage_hunk, "Stage hunk")
				map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
				map("v", "<leader>gs", function()
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, "Stage selection")
				map("v", "<leader>gr", function()
					gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, "Reset selection")
				map("n", "<leader>gS", gs.stage_buffer, "Stage buffer")
				map("n", "<leader>gR", gs.reset_buffer, "Reset buffer")
				map("n", "<leader>gu", gs.undo_stage_hunk, "Undo stage hunk")

				-- Inspect
				map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
				map("n", "<leader>gb", function()
					gs.blame_line({ full = true })
				end, "Blame line (full)")
				map(
					"n",
					"<leader>gd",
					"<cmd>CodeDiff file HEAD<cr>",
					"Diff file vs HEAD (codediff)"
				)
				map(
					"n",
					"<leader>gD",
					"<cmd>CodeDiff file HEAD~<cr>",
					"Diff file vs HEAD~ (codediff)"
				)

				-- Toggles
				map("n", "<leader>gtb", gs.toggle_current_line_blame, "Toggle inline blame")
				map("n", "<leader>gtd", gs.toggle_deleted, "Toggle deleted lines")
				map("n", "<leader>gtw", gs.toggle_word_diff, "Toggle word diff")

				-- Text object
				map({ "o", "x" }, "ih", gs.select_hunk, "inner hunk")
			end,
		},
	},

	-- VSCode-parity diff viewer. Default day-to-day diff; inline layout, 3-way
	-- merge layout, char-level highlights. Neogit and the unstaged-qf list both
	-- route through this.
	{
		"esmuellert/codediff.nvim",
		cmd = { "CodeDiff" },
		keys = {
			{
				"<leader>gvo",
				"<cmd>CodeDiff<cr>",
				desc = "CodeDiff explorer (working tree)",
			},
			{
				"<leader>gvc",
				function()
					require("codediff.ui.lifecycle").cleanup()
				end,
				desc = "CodeDiff close",
			},
			{ "<leader>gvh", "<cmd>CodeDiff history<cr>", desc = "File history (repo)" },
			{ "<leader>gvf", "<cmd>CodeDiff history %<cr>", desc = "File history (current)" },
			{
				"<leader>gvp",
				function()
					local base = resolve_base_branch()
					if not base then
						vim.notify(
							"Could not resolve origin's default branch. Run: git remote set-head origin -a",
							vim.log.levels.WARN
						)
						return
					end
					vim.cmd(("CodeDiff %s..."):format(base))
				end,
				desc = "PR-like diff vs origin default branch (merge-base)",
			},
			{
				"<leader>gG",
				function()
					local lifecycle = require("codediff.ui.lifecycle")
					if lifecycle.get_session(vim.api.nvim_get_current_tabpage()) then
						lifecycle.cleanup()
						return
					end
					local base = resolve_base_branch()
					if not base then
						vim.notify(
							"Could not resolve origin's default branch. Run: git remote set-head origin -a",
							vim.log.levels.WARN
						)
						return
					end
					vim.cmd(("CodeDiff %s...HEAD"):format(base))
				end,
				desc = "Toggle codediff vs origin default branch (PR overlay)",
			},
		},
		opts = {
			diff = {
				layout = "inline",
				conflict_result_position = "center",
			},
			explorer = {
				view_mode = "tree",
			},
		},
	},
}
