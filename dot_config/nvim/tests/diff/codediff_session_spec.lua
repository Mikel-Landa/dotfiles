package.loaded["config.my.diff.codediff_session"] = nil
local codediff_session = require("config.my.diff.codediff_session")

describe("codediff_session.has_revision", function()
  it("returns false for nil", function()
    assert.is_false(codediff_session.has_revision(nil))
  end)
  it("returns false for empty modified_revision", function()
    assert.is_false(codediff_session.has_revision({ modified_revision = "" }))
  end)
  it("returns false for WORKING / STAGED sentinels", function()
    assert.is_false(codediff_session.has_revision({ modified_revision = "WORKING" }))
    assert.is_false(codediff_session.has_revision({ modified_revision = "STAGED" }))
  end)
  it("returns true for a sha", function()
    assert.is_true(codediff_session.has_revision({ modified_revision = "abc123" }))
  end)
end)

describe("codediff_session.session_key", function()
  it("returns nil without revision", function()
    assert.is_nil(codediff_session.session_key({ modified_revision = "" }, "bitbucket"))
  end)
  it("returns nil without git_root", function()
    assert.is_nil(codediff_session.session_key({ modified_revision = "abc", git_root = "" }, "bitbucket"))
  end)
  it("composes provider:root:revision", function()
    local key = codediff_session.session_key(
      { modified_revision = "abc", git_root = "/repo" }, "bitbucket")
    assert.equals("bitbucket:/repo:abc", key)
  end)
end)

describe("codediff_session.rel_file_path", function()
  it("strips git_root prefix from original_path", function()
    local p = codediff_session.rel_file_path({
      git_root = "/repo",
      original_path = "/repo/src/a.lua",
      modified_path = "/repo/src/a.lua",
    })
    assert.equals("src/a.lua", p)
  end)
  it("falls back to modified_path when original is empty", function()
    local p = codediff_session.rel_file_path({
      git_root = "/repo",
      original_path = "",
      modified_path = "/repo/src/b.lua",
    })
    assert.equals("src/b.lua", p)
  end)
  it("returns nil when neither path set", function()
    local p = codediff_session.rel_file_path({
      git_root = "/repo",
      original_path = "",
      modified_path = "",
    })
    assert.is_nil(p)
  end)
end)

describe("codediff_session.tabpage_from_event", function()
  it("returns event.data.tabpage when present", function()
    assert.equals(7, codediff_session.tabpage_from_event({ data = { tabpage = 7 } }))
  end)
  it("falls back to current tabpage otherwise", function()
    local cur = vim.api.nvim_get_current_tabpage()
    assert.equals(cur, codediff_session.tabpage_from_event({}))
    assert.equals(cur, codediff_session.tabpage_from_event(nil))
  end)
end)

describe("codediff_session.read", function()
  it("returns nil when codediff lifecycle unavailable", function()
    codediff_session._set_lifecycle_loader(function() return nil end)
    assert.is_nil(codediff_session.read(1))
  end)
  it("returns nil when lifecycle has no session for tabpage", function()
    codediff_session._set_lifecycle_loader(function()
      return { get_session = function(_) return nil end }
    end)
    assert.is_nil(codediff_session.read(1))
  end)
  it("shapes the session record from lifecycle output", function()
    local fake_buf = vim.api.nvim_create_buf(false, true)
    codediff_session._set_lifecycle_loader(function()
      return {
        get_session = function(_)
          return {
            git_root = "/repo",
            original_revision = "deadbeef",
            modified_revision = "cafebabe",
            original_path = "/repo/a.lua",
            modified_path = "/repo/a.lua",
            original_bufnr = fake_buf,
            modified_bufnr = fake_buf,
          }
        end,
      }
    end)
    codediff_session._set_branch_resolver(function(_, sha)
      if sha == "cafebabe" then return "feature/x" end
      if sha == "deadbeef" then return "main" end
      return nil
    end)
    local s = codediff_session.read(1)
    assert.is_table(s)
    assert.equals("/repo", s.git_root)
    assert.equals("cafebabe", s.modified_revision)
    assert.equals("deadbeef", s.original_revision)
    assert.equals("feature/x", s.modified_branch)
    assert.equals("main", s.original_branch)
    assert.equals("/repo/a.lua", s.modified_path)
    assert.equals(fake_buf, s.modified_bufnr)
  end)

  it("leaves branch fields nil when resolver returns nil", function()
    codediff_session._set_lifecycle_loader(function()
      return {
        get_session = function(_)
          return {
            git_root = "/repo",
            original_revision = "deadbeef",
            modified_revision = "cafebabe",
            original_path = "/repo/a.lua",
            modified_path = "/repo/a.lua",
          }
        end,
      }
    end)
    codediff_session._set_branch_resolver(function() return nil end)
    local s = codediff_session.read(1)
    assert.is_nil(s.modified_branch)
    assert.is_nil(s.original_branch)
  end)
end)
