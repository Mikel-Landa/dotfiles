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

-- Tmux/window nav from snacks picker buffers (sidebar explorer + floating pickers).
-- Picker windows are floats: `wincmd h/l` from a float warps to the last non-float
-- window regardless of direction, breaking vim-tmux-navigator's edge detection.
-- Strategy: pick the target window by screen X position. If none on that side,
-- forward to tmux directly.
autocmd("FileType", {
  group = augroup("snacks_picker_tmux_nav", { clear = true }),
  pattern = { "snacks_picker_list", "snacks_picker_input" },
  callback = function(event)
    local function nav(dir) -- dir: "h" or "l"
      local cur = vim.api.nvim_get_current_win()
      local cur_col = vim.api.nvim_win_get_position(cur)[2]
      local target, target_col
      for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if w ~= cur then
          local cfg = vim.api.nvim_win_get_config(w)
          if cfg.focusable ~= false then
            local col = vim.api.nvim_win_get_position(w)[2]
            local ok = (dir == "h" and col < cur_col) or (dir == "l" and col > cur_col)
            if ok and (target_col == nil
                  or (dir == "h" and col > target_col)
                  or (dir == "l" and col < target_col)) then
              target, target_col = w, col
            end
          end
        end
      end
      if target then
        vim.api.nvim_set_current_win(target)
      elseif vim.env.TMUX then
        local d = dir == "h" and "L" or "R"
        vim.fn.system({ "tmux", "select-pane", "-t", vim.env.TMUX_PANE or "", "-" .. d })
      end
    end
    local map = function(mode, lhs, fn)
      vim.keymap.set(mode, lhs, fn, { buffer = event.buf, nowait = true, silent = true })
    end
    map({ "n", "i" }, "<C-h>", function() nav("h") end)
    map({ "n", "i" }, "<C-l>", function() nav("l") end)
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
