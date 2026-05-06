-- nvim-lint base wiring. Lang files extend `opts.linters_by_ft` via opts merging.
--
-- Trigger: lint runs on BufWritePost / BufReadPost / InsertLeave (configurable in opts.events).
return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      events = { "BufWritePost", "BufReadPost", "InsertLeave" },
      linters_by_ft = {}, -- lang files extend
      linters = {},
    },
    config = function(_, opts)
      local lint = require("lint")
      lint.linters_by_ft = opts.linters_by_ft
      for name, cfg in pairs(opts.linters or {}) do
        lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name] or {}, cfg)
      end

      vim.api.nvim_create_autocmd(opts.events, {
        group = vim.api.nvim_create_augroup("nvim_lint", { clear = true }),
        callback = function()
          local names = lint.linters_by_ft[vim.bo.filetype]
          if names and #names > 0 then
            lint.try_lint(names)
          end
        end,
      })
    end,
  },
}
