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

      -- matugen's "ember" palette caps fn / module / property chroma so low
      -- (~0.03–0.05) that on most wallpapers `fmt.Fprintf(...)` reads as all
      -- white — no separation between module, call, and variable. Build
      -- higher-chroma colors from the existing palette hues (so they still
      -- harmonize with the wallpaper) and apply to calls + module names.
      local function apply_call_hl()
        local matugen = package.loaded["matugen"]
        local pal = matugen and matugen._palette
        if not pal then return end
        local color = require("matugen.color")
        local fn_lch    = color.hex_to_oklch(pal.fn)
        local type_lch  = color.hex_to_oklch(pal.type)
        local prop_lch  = color.hex_to_oklch(pal.prop)
        -- Boost chroma well above cast/whisper caps (0.05 / 0.035) so the
        -- hue is actually perceptible. Lightness is held >= 0.78 for
        -- readability on dark surfaces.
        local L = math.max(fn_lch.L, 0.78)
        local C = 0.09 -- subtle but perceptible; tweak 0.07–0.12 to taste
        local fn_color   = color.oklch(L, C, fn_lch.h)
        local mod_color  = color.oklch(L, C * 0.85, type_lch.h)
        local prop_color = color.oklch(L, C * 0.55, prop_lch.h)
        vim.api.nvim_set_hl(0, "@function",             { fg = fn_color })
        vim.api.nvim_set_hl(0, "@function.call",        { fg = fn_color })
        vim.api.nvim_set_hl(0, "@function.method",      { fg = fn_color })
        vim.api.nvim_set_hl(0, "@function.method.call", { fg = fn_color })
        vim.api.nvim_set_hl(0, "Function",              { fg = fn_color })
        vim.api.nvim_set_hl(0, "@module",               { fg = mod_color })
        vim.api.nvim_set_hl(0, "@variable.member",      { fg = prop_color })
        vim.api.nvim_set_hl(0, "@property",             { fg = prop_color })
      end
      apply_call_hl()
      vim.api.nvim_create_autocmd("ColorScheme", { callback = apply_call_hl })
      vim.api.nvim_create_autocmd("User", {
        pattern = "MatugenReloaded",
        callback = apply_call_hl,
      })

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
