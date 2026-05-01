return {
  {
    "daedlock/matugen.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("matugen").setup({
        colors_path = "~/.config/matugen/colors.json",
      })
      vim.cmd.colorscheme("matugen")

      -- Clear backgrounds so kitty's background_opacity shows through.
      vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })

      -- Re-apply undercurl style so diagnostic underlines use colored undercurl,
      -- not plain underline (kitty supports Smulx undercurl natively).
      for name, _ in pairs({
        DiagnosticUnderlineError = true,
        DiagnosticUnderlineWarn = true,
        DiagnosticUnderlineInfo = true,
        DiagnosticUnderlineHint = true,
      }) do
        local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
        hl.undercurl = true
        hl.underline = nil
        vim.api.nvim_set_hl(0, name, hl)
      end
    end,
  },
}
