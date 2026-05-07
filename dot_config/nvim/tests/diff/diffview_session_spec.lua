package.loaded["config.my.diff.diffview_session"] = nil
local diffview_session = require("config.my.diff.diffview_session")

describe("diffview_session.has_revision", function()
  it("returns false for nil", function()
    assert.is_false(diffview_session.has_revision(nil))
  end)
  it("returns false for empty modified_revision", function()
    assert.is_false(diffview_session.has_revision({ modified_revision = "" }))
  end)
  it("returns false for WORKING / STAGED sentinels", function()
    assert.is_false(diffview_session.has_revision({ modified_revision = "WORKING" }))
    assert.is_false(diffview_session.has_revision({ modified_revision = "STAGED" }))
  end)
  it("returns true for a sha", function()
    assert.is_true(diffview_session.has_revision({ modified_revision = "abc123" }))
  end)
end)

describe("diffview_session.session_key", function()
  it("returns nil without revision", function()
    assert.is_nil(diffview_session.session_key({ modified_revision = "" }, "bitbucket"))
  end)
  it("returns nil without git_root", function()
    assert.is_nil(diffview_session.session_key({ modified_revision = "abc", git_root = "" }, "bitbucket"))
  end)
  it("composes provider:root:revision", function()
    local key = diffview_session.session_key(
      { modified_revision = "abc", git_root = "/repo" }, "bitbucket")
    assert.equals("bitbucket:/repo:abc", key)
  end)
end)

describe("diffview_session.rel_file_path", function()
  it("strips git_root prefix from original_path", function()
    local p = diffview_session.rel_file_path({
      git_root = "/repo",
      original_path = "/repo/src/a.lua",
      modified_path = "/repo/src/a.lua",
    })
    assert.equals("src/a.lua", p)
  end)
  it("falls back to modified_path when original is empty", function()
    local p = diffview_session.rel_file_path({
      git_root = "/repo",
      original_path = "",
      modified_path = "/repo/src/b.lua",
    })
    assert.equals("src/b.lua", p)
  end)
  it("returns nil when neither path set", function()
    local p = diffview_session.rel_file_path({
      git_root = "/repo",
      original_path = "",
      modified_path = "",
    })
    assert.is_nil(p)
  end)
end)

describe("diffview_session.tabpage_from_event", function()
  it("returns event.data.tabpage when present", function()
    assert.equals(7, diffview_session.tabpage_from_event({ data = { tabpage = 7 } }))
  end)
  it("falls back to current tabpage otherwise", function()
    local cur = vim.api.nvim_get_current_tabpage()
    assert.equals(cur, diffview_session.tabpage_from_event({}))
    assert.equals(cur, diffview_session.tabpage_from_event(nil))
  end)
end)

describe("diffview_session.read", function()
  it("returns nil when diffview lib unavailable", function()
    diffview_session._set_lib_loader(function() return nil end)
    assert.is_nil(diffview_session.read(1))
  end)
end)
