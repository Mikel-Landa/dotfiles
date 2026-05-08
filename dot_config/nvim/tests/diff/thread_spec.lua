-- Thread finder. Pure: drives (comments, location) -> { root, replies } | nil.
package.loaded["config.my.diff.thread"] = nil
local thread = require("config.my.diff.thread")

local function root(id, path, side, line, extra)
  local c = {
    id = id, path = path, body = "x",
    anchor = { side = side, line = line },
    in_reply_to_id = nil,
  }
  for k, v in pairs(extra or {}) do c[k] = v end
  return c
end
local function reply(id, parent_id, extra)
  local c = { id = id, in_reply_to_id = parent_id, body = "r" }
  for k, v in pairs(extra or {}) do c[k] = v end
  return c
end

describe("thread.at", function()
  it("returns nil when comments is not a table", function()
    assert.is_nil(thread.at(nil, { file_path = "a", side = "RIGHT", line = 1 }))
    assert.is_nil(thread.at("nope", { file_path = "a", side = "RIGHT", line = 1 }))
  end)

  it("returns nil when location is not a table", function()
    assert.is_nil(thread.at({}, nil))
  end)

  it("returns nil when no root matches the location", function()
    local comments = { root(1, "a.lua", "RIGHT", 5) }
    assert.is_nil(thread.at(comments, { file_path = "b.lua", side = "RIGHT", line = 5 }))
    assert.is_nil(thread.at(comments, { file_path = "a.lua", side = "LEFT",  line = 5 }))
    assert.is_nil(thread.at(comments, { file_path = "a.lua", side = "RIGHT", line = 6 }))
  end)

  it("finds a root with empty replies", function()
    local comments = { root(1, "a.lua", "RIGHT", 5) }
    local out = thread.at(comments, { file_path = "a.lua", side = "RIGHT", line = 5 })
    assert.is_not_nil(out)
    assert.equals(1, out.root.id)
    assert.equals(0, #out.replies)
  end)

  it("collects replies whose in_reply_to_id matches the root id", function()
    local comments = {
      root(1, "a.lua", "RIGHT", 5),
      reply(2, 1),
      reply(3, 1),
      reply(4, 99),  -- different thread
      root(5, "b.lua", "RIGHT", 7), -- different file
    }
    local out = thread.at(comments, { file_path = "a.lua", side = "RIGHT", line = 5 })
    assert.equals(1, out.root.id)
    assert.equals(2, #out.replies)
    assert.equals(2, out.replies[1].id)
    assert.equals(3, out.replies[2].id)
  end)

  it("sorts replies by stringified id", function()
    -- string-sort: "10" < "2" alphabetically
    local comments = {
      root(1, "a.lua", "RIGHT", 5),
      reply(2, 1),
      reply(10, 1),
    }
    local out = thread.at(comments, { file_path = "a.lua", side = "RIGHT", line = 5 })
    assert.equals(10, out.replies[1].id)
    assert.equals(2, out.replies[2].id)
  end)

  it("ignores comments without anchors as roots", function()
    local comments = {
      { id = 1, path = "a.lua", body = "no anchor" },
      root(2, "a.lua", "RIGHT", 5),
    }
    local out = thread.at(comments, { file_path = "a.lua", side = "RIGHT", line = 5 })
    assert.equals(2, out.root.id)
  end)
end)
