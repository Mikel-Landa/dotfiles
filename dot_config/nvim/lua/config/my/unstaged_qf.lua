-- <leader>gq: quickfix list of files with unstaged changes.
-- Stays in sync with the index: stages, commits, and discards drop entries out
-- of the list automatically. Refresh is no-op unless our list is the active qf.
-- Inside the list, <CR> opens the file in codediff against HEAD instead of the
-- default plain buffer open.

local TITLE = "Unstaged changes"

local function unstaged_files()
  local result = vim.system({ "git", "status", "--porcelain", "-z" }, { text = true }):wait()
  if result.code ~= 0 then return nil end
  -- Porcelain v1 with -z: NUL-separated `XY path` entries; renamed/copied (R/C)
  -- entries are followed by an extra NUL-terminated original-path field.
  local entries = vim.split(result.stdout, "\0", { plain = true, trimempty = true })
  local files, i = {}, 1
  while i <= #entries do
    local entry = entries[i]
    if #entry >= 3 then
      local x, y, path = entry:sub(1, 1), entry:sub(2, 2), entry:sub(4)
      if x == "R" or x == "C" then i = i + 1 end
      if y ~= " " then table.insert(files, path) end
    end
    i = i + 1
  end
  return files
end

local function refresh(open)
  local is_ours = vim.fn.getqflist({ title = 0 }).title == TITLE
  if not open and not is_ours then return end
  local files = unstaged_files()
  if not files then return end
  local items = vim.tbl_map(function(f)
    return { filename = f, lnum = 1, text = f }
  end, files)
  -- Initial open pushes a new list onto the qf stack (so :colder restores
  -- whatever list the user had before). Background refresh replaces in place
  -- to avoid spamming the stack on every gitsigns/neogit event.
  local action = open and " " or "r"
  vim.fn.setqflist({}, action, { title = TITLE, items = items })
  if open then vim.cmd("copen") end
end

-- Coalesce bursts (gitsigns fires per-buffer on attach/update).
local pending = false
local function debounced()
  if pending then return end
  pending = true
  vim.defer_fn(function() pending = false; refresh(false) end, 200)
end

-- Open the qf entry under cursor in codediff (current buffer vs HEAD).
-- Untracked files have no HEAD revision; fall back to plain open.
local function open_in_codediff()
  local idx = vim.fn.line(".")
  local items = vim.fn.getqflist()
  local item = items[idx]
  if not item or item.bufnr == 0 and (item.filename == nil or item.filename == "") then return end
  local path = item.filename or vim.api.nvim_buf_get_name(item.bufnr)
  if path == "" then return end

  local in_index = vim.system({ "git", "ls-files", "--error-unmatch", "--", path }, { text = true }):wait()
  if in_index.code ~= 0 then
    vim.cmd("wincmd p")
    vim.cmd("edit " .. vim.fn.fnameescape(path))
    return
  end

  vim.cmd("wincmd p")
  vim.cmd("edit " .. vim.fn.fnameescape(path))
  vim.cmd("CodeDiff file HEAD")
end

vim.keymap.set("n", "<leader>gq", function() refresh(true) end,
  { desc = "Unstaged files → quickfix" })

local group = vim.api.nvim_create_augroup("my_unstaged_qf", { clear = true })
vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = { "GitSignsUpdate", "NeogitStatusRefreshed", "NeogitCommitComplete" },
  callback = debounced,
})

-- Bind <CR> to codediff inside the "Unstaged changes" qf list only.
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "qf",
  callback = function(args)
    if vim.fn.getqflist({ title = 0 }).title ~= TITLE then return end
    vim.keymap.set("n", "<CR>", open_in_codediff,
      { buffer = args.buf, desc = "Open in CodeDiff vs HEAD" })
  end,
})
