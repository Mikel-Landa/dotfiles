return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "black",
      })
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason.nvim" },
    opts = function(_, opts)
      local null_ls = require("null-ls")
      return {
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
        sources = vim.list_extend(opts.sources, {
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.terraform_fmt,
          null_ls.builtins.diagnostics.terraform_validate,
          -- nls.builtins.formatting.packer,
        }),
      }
    end,
  },
}
