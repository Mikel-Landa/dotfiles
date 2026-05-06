vim.g.use_pr_comments = true
package.loaded["config.my.diff.providers.bitbucket"] = nil
local bitbucket = require("config.my.diff.providers.bitbucket")
local normalize = bitbucket._normalize_comments

describe("bitbucket normalize_comments", function()
  it("translates inline.to into anchor RIGHT", function()
    local out = normalize({
      { id = 1, inline = { path = "src/a.lua", to = 42 }, content = { raw = "hi" }, user = { nickname = "alice" } },
    })
    assert.equals(1, #out)
    assert.are.same({ side = "RIGHT", line = 42 }, out[1].anchor)
    assert.equals("src/a.lua", out[1].path)
    assert.equals("hi", out[1].body)
    assert.equals("alice", out[1].user)
    assert.is_nil(out[1].in_reply_to_id)
  end)

  it("translates inline.from into anchor LEFT when inline.to absent", function()
    local out = normalize({
      { id = 2, inline = { path = "src/a.lua", ["from"] = 7 }, content = { raw = "x" } },
    })
    assert.equals(1, #out)
    assert.are.same({ side = "LEFT", line = 7 }, out[1].anchor)
  end)

  it("inherits anchor + path on replies (no inline of their own)", function()
    local out = normalize({
      { id = 1, inline = { path = "src/a.lua", to = 5 }, content = { raw = "root" } },
      { id = 2, parent = { id = 1 }, content = { raw = "reply" } },
    })
    assert.equals(2, #out)
    local reply = out[2]
    assert.equals(2, reply.id)
    assert.equals(1, reply.in_reply_to_id)
    assert.equals("src/a.lua", reply.path)
    assert.are.same({ side = "RIGHT", line = 5 }, reply.anchor)
  end)

  it("drops orphan comments with neither inline nor a known parent", function()
    local out = normalize({
      { id = 99, content = { raw = "orphan" } },
    })
    assert.equals(0, #out)
  end)

  it("uses parent_id field when parent table is absent", function()
    local out = normalize({
      { id = 1, inline = { path = "x.lua", to = 10 }, content = { raw = "root" } },
      { id = 2, parent_id = 1, content = { raw = "reply via parent_id" } },
    })
    assert.equals(2, #out)
    assert.equals(1, out[2].in_reply_to_id)
  end)

  it("marks pending=true when comment.pending is true", function()
    local out = normalize({
      { id = 1, inline = { path = "x.lua", to = 1 }, content = { raw = "p" }, pending = true },
    })
    assert.is_true(out[1].pending)
  end)

  it("marks pending=true when comment.state == 'PENDING'", function()
    local out = normalize({
      { id = 1, inline = { path = "x.lua", to = 1 }, content = { raw = "p" }, state = "PENDING" },
    })
    assert.is_true(out[1].pending)
  end)

  it("prefers content_raw over content.raw", function()
    local out = normalize({
      { id = 1, inline = { path = "x.lua", to = 1 }, content_raw = "primary", content = { raw = "fallback" } },
    })
    assert.equals("primary", out[1].body)
  end)

  it("resolves user from nickname > name > display_name", function()
    local out = normalize({
      { id = 1, inline = { path = "x.lua", to = 1 }, content = { raw = "x" }, author = { nickname = "alice", name = "Alice", display_name = "A" } },
      { id = 2, inline = { path = "x.lua", to = 2 }, content = { raw = "x" }, author = { nickname = "", name = "Bob", display_name = "B" } },
      { id = 3, inline = { path = "x.lua", to = 3 }, content = { raw = "x" }, author = { display_name = "C" } },
    })
    assert.equals("alice", out[1].user)
    assert.equals("Bob", out[2].user)
    assert.equals("C", out[3].user)
  end)

  it("conforms to the normalized comment shape (required fields)", function()
    local out = normalize({
      { id = 1, inline = { path = "f.lua", to = 1 }, content = { raw = "x" } },
    })
    local c = out[1]
    assert.is_not_nil(c.id)
    assert.is_not_nil(c.anchor)
    assert.is_not_nil(c.anchor.side)
    assert.is_not_nil(c.anchor.line)
    assert.is_not_nil(c.path)
    assert.is_not_nil(c.body)
    assert.is_not_nil(c.pending)
    assert.is_not_nil(c._raw)
    -- Forbidden legacy fields:
    assert.is_nil(c.line)
    assert.is_nil(c.original_line)
    assert.is_nil(c.side)
  end)
end)
