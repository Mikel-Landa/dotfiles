package.loaded["config.my.atlas_qf"] = nil
local atlas_qf = require("config.my.atlas_qf")

describe("atlas_qf.qf_items", function()
  it("keeps thread roots with inline path", function()
    local items = atlas_qf.qf_items("/repo", {
      {
        author = { nickname = "ada" },
        content_raw = "please fix\nmore",
        inline = { path = "lua/foo.lua", to = 12 },
      },
    })
    assert.equals(1, #items)
    assert.equals("/repo/lua/foo.lua", items[1].filename)
    assert.equals(12, items[1].lnum)
    assert.equals("ada: please fix", items[1].text)
  end)

  it("skips replies, deleted, and comments without inline path", function()
    local items = atlas_qf.qf_items("/repo", {
      { parent_id = 1, inline = { path = "a.lua", to = 1 }, content_raw = "reply" },
      { state = "DELETED", inline = { path = "a.lua", to = 2 }, content_raw = "gone" },
      { content_raw = "general comment" },
    })
    assert.equals(0, #items)
  end)

  it("marks pending and falls back to from-line", function()
    local items = atlas_qf.qf_items("", {
      {
        state = "PENDING",
        author = { name = "bob" },
        content_display = "nits",
        inline = { path = "x.rs", from = 4 },
      },
    })
    assert.equals("x.rs", items[1].filename)
    assert.equals(4, items[1].lnum)
    assert.equals("[pending] bob: nits", items[1].text)
  end)

  it("reads comments from atlas 0.7 review.data", function()
    local review = {
      data = {
        comments = {
          {
            author = { nickname = "ada" },
            content_raw = "please fix",
            inline = { path = "lua/foo.lua", to = 12 },
          },
        },
      },
    }
    local items = atlas_qf.qf_items("/repo", review.data.comments)
    assert.equals(1, #items)
    assert.equals("/repo/lua/foo.lua", items[1].filename)
  end)
end)
