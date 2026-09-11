-- Dump Atlas review comments into the quickfix list.
-- Atlas has no qf API; this reads `atlas.pulls.diff.session.get()`.
-- Atlas 0.7 stores comments on `session.review.data.comments`.
local M = {}

local QF_TITLE = "Atlas PR Comments"

local function first_line(body)
  if type(body) ~= "string" then return "" end
  for line in body:gmatch("[^\r\n]+") do return line end
  return ""
end

local function author_name(author)
  if type(author) ~= "table" then return "" end
  local name = author.nickname or author.username or author.name
  return type(name) == "string" and name or ""
end

---Pure: atlas PullsComment[] → qf items. Thread roots only.
function M.qf_items(root, comments)
  local items = {}
  root = tostring(root or "")
  for _, c in ipairs(comments or {}) do
    local inline = c.inline
    if not c.parent_id and c.state ~= "DELETED"
      and type(inline) == "table" and inline.path then
      local who = author_name(c.author)
      local body = first_line(c.content_raw or c.content_display or "")
      local text = who ~= "" and (who .. ": " .. body) or body
      if c.state == "PENDING" then text = "[pending] " .. text end
      items[#items + 1] = {
        filename = root ~= "" and (root .. "/" .. inline.path) or inline.path,
        lnum = tonumber(inline.to) or tonumber(inline.from) or 1,
        text = text,
      }
    end
  end
  return items
end

local function session()
  pcall(function()
    require("lazy.core.loader").load("atlas.nvim", { cmd = "Atlas PR comments qf" })
  end)
  local ok, api = pcall(require, "atlas.pulls.diff.session")
  if not ok then return nil end
  return api.get()
end

function M.open()
  local s = session()
  if not s or not s.review then
    vim.notify("No Atlas review attached. Open a PR: <leader>op, then gd.", vim.log.levels.WARN)
    return
  end
  local comments = s.review.data and s.review.data.comments
  local items = M.qf_items(s.source and s.source.root, comments)
  if #items == 0 then
    vim.notify("No inline review comments", vim.log.levels.INFO)
    return
  end
  vim.fn.setqflist({}, "r", { title = QF_TITLE, items = items })
  vim.cmd("copen")
end

function M.close()
  local info = vim.fn.getqflist({ title = 1 })
  if info.title == QF_TITLE then
    vim.fn.setqflist({}, "r")
  end
  vim.cmd("cclose")
end

vim.keymap.set("n", "<leader>oc", M.open, { desc = "Atlas PR comments → quickfix" })
vim.keymap.set("n", "<leader>oC", M.close, { desc = "Atlas PR comments: close qf" })

return M
