-- avante.nvim: Cursor-style AI coding assistant (sidebar + inline edits).
-- Provider: claude-code via ACP (Agent Client Protocol) — uses Claude Code CLI auth,
--   no direct API key. Requires `claude-agent-acp`
--   (npm i -g @agentclientprotocol/claude-agent-acp).
-- Cursor agent runs out-of-band as a floating terminal (cursor-agent CLI), not as an
--   avante provider — avante has no native cursor integration.
-- Build step compiles a Rust tokenizer; needs `make` + `cargo`, or curl+tar for prebuilt.
return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false,
    build = "make",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "folke/snacks.nvim",
      "echasnovski/mini.nvim",
      {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = { insert_mode = true },
            use_absolute_path = true,
          },
        },
      },
    },
    opts = {
      provider = "claude-code",
      acp_providers = {
        ["claude-code"] = {
          command = "claude-agent-acp",
          args = {},
          env = {
            NODE_NO_WARNINGS = "1",
          },
        },
      },
      behaviour = {
        auto_suggestions = false,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        enable_token_counting = true,
        auto_add_current_file = true,
      },
    },
  },

  -- Cursor CLI launcher: floating terminal w/ `cursor-agent`. No avante integration.
  -- Auth: `cursor-agent login` once, or set CURSOR_API_KEY.
  {
    "folke/snacks.nvim",
    optional = true,
    keys = {
      {
        "<leader>ac",
        function()
          require("snacks").terminal({ "cursor-agent" }, {
            cwd = vim.fn.getcwd(),
            win = { style = "terminal", border = "rounded" },
          })
        end,
        desc = "Cursor agent (floating terminal)",
      },
    },
  },

  -- Extend render-markdown to render Avante buffers too (existing spec covers markdown).
  {
    "MeanderingProgrammer/render-markdown.nvim",
    optional = true,
    ft = { "markdown", "Avante" },
    opts = function(_, opts)
      opts.file_types = opts.file_types or {}
      if not vim.tbl_contains(opts.file_types, "Avante") then
        table.insert(opts.file_types, "Avante")
      end
      return opts
    end,
  },
}
