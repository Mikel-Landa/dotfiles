local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
autocmd("TextYankPost", {
  group = augroup("highlight_yank", { clear = true }),
  callback = function() (vim.hl or vim.highlight).on_yank() end,
})

-- Restore cursor position on file open
autocmd("BufReadPost", {
  group = augroup("restore_cursor", { clear = true }),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Close certain filetypes with q
autocmd("FileType", {
  group = augroup("close_with_q", { clear = true }),
  pattern = { "help", "man", "qf", "lspinfo", "checkhealth" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Auto-resize splits when window is resized
autocmd("VimResized", {
  group = augroup("resize_splits", { clear = true }),
  callback = function() vim.cmd("tabdo wincmd =") end,
})

-- VSCode-style: auto-show diagnostic float when cursor hovers a problem.
-- Fires after `updatetime` ms idle. Skip if a float already open (avoids
-- stealing focus from hover docs / completion popups).
autocmd("CursorHold", {
  group = augroup("diagnostic_hover", { clear = true }),
  callback = function()
    for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      if vim.api.nvim_win_get_config(winid).relative ~= "" then return end
    end
    vim.diagnostic.open_float(nil, { focus = false, scope = "cursor", border = "rounded" })
  end,
})

-- Diagnostic display: underlines on (default), virtual_text off (float replaces it),
-- signs in gutter, sorted by severity.
vim.diagnostic.config({
  underline = true,
  virtual_text = false,
  signs = true,
  severity_sort = true,
  float = { border = "rounded", source = "if_many" },
})
