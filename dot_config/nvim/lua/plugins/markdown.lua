-- render-markdown.nvim: in-buffer markdown rendering (headers, code blocks, callouts).
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "echasnovski/mini.icons",
    },
    opts = {
      file_types = { "markdown" },
      completions = { lsp = { enabled = true } },
    },
  },
}
