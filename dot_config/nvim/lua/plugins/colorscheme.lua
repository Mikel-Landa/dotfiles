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

      local function apply_transparent_bg()
        local groups = {
          "Normal", "NormalNC", "NormalFloat", "FloatBorder", "FloatTitle",
          "SnacksNormal", "SnacksNormalNC",
          "SnacksPicker", "SnacksPickerInput", "SnacksPickerList", "SnacksPickerPreview",
          "SnacksPickerBox", "SnacksPickerBorder", "SnacksPickerTitle", "SnacksPickerFooter",
          "SnacksPickerInputBorder", "SnacksPickerInputTitle",
          "SnacksPickerListBorder", "SnacksPickerListTitle",
          "SnacksPickerPreviewBorder", "SnacksPickerPreviewTitle",
          "SnacksPickerBoxBorder", "SnacksPickerBoxTitle",
          "SnacksPickerNormalFloat",
        }
        for _, g in ipairs(groups) do
          vim.api.nvim_set_hl(0, g, { bg = "NONE" })
        end
      end

      -- Apply immediately and re-apply after all plugins have loaded.
      apply_transparent_bg()
      vim.api.nvim_create_autocmd("ColorScheme", { callback = apply_transparent_bg })
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        once = true,
        callback = apply_transparent_bg,
      })

      -- VSCode-style faint indent guides (snacks.indent). Link to NonText so
      -- the lines stay barely visible regardless of matugen palette shifts.
      local function apply_indent_hl()
        vim.api.nvim_set_hl(0, "SnacksIndent", { link = "NonText", default = false })
        vim.api.nvim_set_hl(0, "SnacksIndentScope", { link = "Comment", default = false })
      end
      apply_indent_hl()
      vim.api.nvim_create_autocmd("ColorScheme", { callback = apply_indent_hl })

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
