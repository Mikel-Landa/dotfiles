-- Sign painter. Drives M.set_state / refresh_buffer / threads_for_buffer
-- against scratch buffers and asserts extmark + query behaviour.
local function fresh()
  package.loaded["config.my.diff.sign_painter"] = nil
  return require("config.my.diff.sign_painter")
end

-- Generate a unique repo root per test so buffer names don't collide across
-- specs running in the same nvim process.
local root_counter = 0
local function fresh_root()
  root_counter = root_counter + 1
  return ("/tmp/sign_painter_spec/%d"):format(root_counter)
end

-- Make a buffer at <root>/<rel> with `lines` lines (default 20). Note that
-- scratch buffers default to buftype="nofile", which sign_painter rejects, so
-- we clear buftype to mimic an ordinary code buffer.
local function make_buffer(root, rel, lines)
  lines = lines or 20
  local bufnr = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_buf_set_name(bufnr, root .. "/" .. rel)
  vim.bo[bufnr].buftype = ""
  local content = {}
  for i = 1, lines do content[i] = "line " .. i end
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, content)
  return bufnr
end

local function thread(line, opts)
  opts = opts or {}
  return {
    root = {
      id = opts.id or line,
      anchor = { side = "RIGHT", line = line },
      pending = opts.pending == true,
    },
    replies = {},
    range = { start_line = line, end_line = opts.end_line or line },
    line = line,
  }
end

describe("sign_painter.threads_for_buffer", function()
  local sp
  before_each(function() sp = fresh() end)

  it("returns nil when no state", function()
    local bufnr = make_buffer(fresh_root(), "a.lua")
    assert.is_nil(sp.threads_for_buffer(bufnr))
  end)

  it("returns nil for buffers outside the repo root", function()
    local root = fresh_root()
    sp.set_state({ root = root, threads_by_path = { ["a.lua"] = { thread(5) } } })
    local bufnr = make_buffer("/elsewhere/" .. root_counter, "a.lua")
    assert.is_nil(sp.threads_for_buffer(bufnr))
  end)

  it("returns nil when path has no threads", function()
    local root = fresh_root()
    sp.set_state({ root = root, threads_by_path = { ["a.lua"] = { thread(5) } } })
    local bufnr = make_buffer(root, "b.lua")
    assert.is_nil(sp.threads_for_buffer(bufnr))
  end)

  it("returns the thread list for matching path", function()
    local root = fresh_root()
    local t = thread(5)
    sp.set_state({ root = root, threads_by_path = { ["a.lua"] = { t } } })
    local bufnr = make_buffer(root, "a.lua")
    local result = sp.threads_for_buffer(bufnr)
    assert.is_not_nil(result)
    assert.equals(1, #result)
    assert.equals(t, result[1])
  end)

  it("returns nil for non-normal buftype", function()
    local root = fresh_root()
    sp.set_state({ root = root, threads_by_path = { ["a.lua"] = { thread(5) } } })
    local bufnr = vim.api.nvim_create_buf(false, true)
    vim.bo[bufnr].buftype = "nofile"
    vim.api.nvim_buf_set_name(bufnr, root .. "/a.lua")
    assert.is_nil(sp.threads_for_buffer(bufnr))
  end)
end)

describe("sign_painter.refresh_buffer", function()
  local sp
  before_each(function() sp = fresh() end)

  local function sign_count(bufnr)
    local ns = vim.api.nvim_get_namespaces()["pr_comments_signs"]
    if not ns then return 0 end
    return #vim.api.nvim_buf_get_extmarks(bufnr, ns, 0, -1, {})
  end

  it("places one extmark per line in the thread range", function()
    local root = fresh_root()
    local t = thread(5, { end_line = 7 })
    sp.set_state({ root = root, threads_by_path = { ["a.lua"] = { t } } })
    local bufnr = make_buffer(root, "a.lua")
    sp.refresh_buffer(bufnr)
    assert.equals(3, sign_count(bufnr))
  end)

  it("clears extmarks when state goes away", function()
    local root = fresh_root()
    sp.set_state({ root = root, threads_by_path = { ["a.lua"] = { thread(5) } } })
    local bufnr = make_buffer(root, "a.lua")
    sp.refresh_buffer(bufnr)
    assert.equals(1, sign_count(bufnr))

    sp.set_state(nil)
    sp.refresh_buffer(bufnr)
    assert.equals(0, sign_count(bufnr))
  end)

  it("skips lines beyond buffer line count", function()
    local root = fresh_root()
    local t = thread(50)
    sp.set_state({ root = root, threads_by_path = { ["a.lua"] = { t } } })
    local bufnr = make_buffer(root, "a.lua", 10)
    sp.refresh_buffer(bufnr)
    assert.equals(0, sign_count(bufnr))
  end)
end)
