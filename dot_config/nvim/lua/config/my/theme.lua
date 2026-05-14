-- Theme switcher: persisted colorscheme choice + theme-agnostic highlight tweaks.
--
-- Adds `:ThemePick` / `<leader>uT` to switch between matugen, catppuccin and
-- monokai-pro flavours. The choice is persisted to stdpath("state") and
-- re-applied on next launch. Highlight tweaks that should survive across
-- themes (transparent bg, indent guides, git-status colors, diagnostic
-- undercurl) live here as ColorScheme autocmds. Matugen-only call/module
-- highlight boosting is gated on the active scheme.

local M = {}

local STATE_FILE = vim.fn.stdpath("state") .. "/last-theme.txt"

M.themes = {
  { label = "matugen (wallpaper)",    scheme = "matugen" },
  { label = "catppuccin mocha",       scheme = "catppuccin-mocha" },
  { label = "catppuccin macchiato",   scheme = "catppuccin-macchiato" },
  { label = "catppuccin frappe",      scheme = "catppuccin-frappe" },
  { label = "monokai-pro",            scheme = "monokai-pro" },
  { label = "monokai-pro spectrum",   scheme = "monokai-pro-spectrum" },
  { label = "monokai-pro machine",    scheme = "monokai-pro-machine" },
  { label = "monokai-pro octagon",    scheme = "monokai-pro-octagon" },
  { label = "monokai-pro ristretto",  scheme = "monokai-pro-ristretto" },
}

local function read_persisted()
  local f = io.open(STATE_FILE, "r")
  if not f then return nil end
  local s = f:read("*l")
  f:close()
  if s and #s > 0 then return s end
end

local function write_persisted(scheme)
  local f = io.open(STATE_FILE, "w")
  if not f then return end
  f:write(scheme)
  f:close()
end

-- Transparent-bg fixups for floats / snacks surfaces.
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
    local hl = vim.api.nvim_get_hl(0, { name = g, link = false })
    hl.bg = "NONE"
    vim.api.nvim_set_hl(0, g, hl)
  end
end

-- VSCode-style faint indent guides (snacks.indent).
local function apply_indent_hl()
  vim.api.nvim_set_hl(0, "SnacksIndent", { link = "NonText", default = false })
  vim.api.nvim_set_hl(0, "SnacksIndentScope", { link = "Comment", default = false })
end

-- VSCode-style git colors in snacks explorer/picker (untracked = green).
local function apply_git_status_hl()
  vim.api.nvim_set_hl(0, "SnacksPickerGitStatusUntracked", { link = "Added", default = false })
end

-- Colored undercurl for diagnostics (kitty Smulx). Has to run after every
-- ColorScheme — most schemes set plain `underline = true`.
local function apply_diagnostic_undercurl()
  for _, name in ipairs({
    "DiagnosticUnderlineError",
    "DiagnosticUnderlineWarn",
    "DiagnosticUnderlineInfo",
    "DiagnosticUnderlineHint",
  }) do
    local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
    hl.undercurl = true
    hl.underline = nil
    vim.api.nvim_set_hl(0, name, hl)
  end
end

-- Matugen-only: matugen's "ember" palette caps fn / module / property chroma so
-- low (~0.03–0.05) that on most wallpapers `fmt.Fprintf(...)` reads as all
-- white — no separation between module, call, and variable. Build
-- higher-chroma colors from the existing palette hues (so they still
-- harmonize with the wallpaper) and apply to calls + module names.
local function apply_matugen_call_hl()
  local matugen = package.loaded["matugen"]
  local pal = matugen and matugen._palette
  if not pal then return end
  local ok, color = pcall(require, "matugen.color")
  if not ok then return end
  local fn_lch   = color.hex_to_oklch(pal.fn)
  local type_lch = color.hex_to_oklch(pal.type)
  local prop_lch = color.hex_to_oklch(pal.prop)
  local L = math.max(fn_lch.L, 0.78)
  local C = 0.09
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

local function apply_all_tweaks()
  apply_transparent_bg()
  apply_indent_hl()
  apply_git_status_hl()
  apply_diagnostic_undercurl()
  if vim.g.colors_name == "matugen" then
    apply_matugen_call_hl()
  end
end

function M.apply(scheme)
  local ok, err = pcall(vim.cmd.colorscheme, scheme)
  if not ok then
    vim.notify(("theme: failed to load %q: %s"):format(scheme, err), vim.log.levels.ERROR)
    return false
  end
  write_persisted(scheme)
  return true
end

function M.current()
  return vim.g.colors_name or read_persisted() or "matugen"
end

function M.pick()
  vim.ui.select(M.themes, {
    prompt = "Theme",
    format_item = function(t) return t.label end,
  }, function(choice)
    if not choice then return end
    M.apply(choice.scheme)
  end)
end

-- Register autocmds + user command. Idempotent.
local function register()
  local group = vim.api.nvim_create_augroup("MyTheme", { clear = true })

  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = apply_all_tweaks,
  })
  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "VeryLazy",
    once = true,
    callback = apply_transparent_bg,
  })
  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "MatugenReloaded",
    callback = function()
      if vim.g.colors_name == "matugen" then apply_matugen_call_hl() end
    end,
  })

  vim.api.nvim_create_user_command("ThemePick", function() M.pick() end, { desc = "Pick colorscheme" })
end

-- Called from init.lua after `lazy.setup`. Reads persisted scheme (default
-- "matugen") and applies it — lazy.nvim's colorscheme handler then loads the
-- one plugin that provides it. Unused theme plugins never start up.
function M.bootstrap()
  register()
  local scheme = read_persisted() or "matugen"
  M.apply(scheme)
end

return M
