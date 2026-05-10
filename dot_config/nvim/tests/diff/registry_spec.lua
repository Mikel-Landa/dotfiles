-- Drives registry.refresh against stub provider + stub diffview_session reader.
-- Verifies state-machine invariants: loading_key lifecycle, race guards,
-- dual-fetch join, error paths, destroy.
local function fresh_registry()
  package.loaded["config.my.diff.registry"] = nil
  return require("config.my.diff.registry")
end

local function make_view_session(opts)
  opts = opts or {}
  return {
    git_root = opts.git_root or "/repo",
    modified_revision = opts.modified_revision or "abc123",
    original_revision = opts.original_revision or "",
    modified_path = opts.modified_path or "/repo/src/a.lua",
    original_path = opts.original_path or "/repo/src/a.lua",
    modified_bufnr = nil,
    original_bufnr = nil,
  }
end

local function stub_diffview(view_session)
  return {
    read = function(_) return view_session end,
    has_revision = function(s)
      if not s then return false end
      local r = tostring(s.modified_revision or "")
      return r ~= "" and r ~= "WORKING" and r ~= "STAGED"
    end,
    session_key = function(s, name)
      if not s or s.modified_revision == "" or s.git_root == "" then return nil end
      return ("%s:%s:%s"):format(name, s.git_root, s.modified_revision)
    end,
    rel_file_path = function(s) return s and s.modified_path or nil end,
    tabpage_from_event = function() return 1 end,
  }
end

local function deferred_provider(name)
  local p = {
    name = name,
    pending = { find_pr = {}, diff = {}, comments = {} },
    can_handle = function() return true end,
  }
  function p.find_pr(_, cb) table.insert(p.pending.find_pr, cb) end
  function p.fetch_diff_files(_, cb) table.insert(p.pending.diff, cb) end
  function p.fetch_comments(_, cb) table.insert(p.pending.comments, cb) end
  function p.flush_pr(pr, err)
    local cb = table.remove(p.pending.find_pr, 1)
    if cb then cb(pr, err) end
  end
  function p.flush_diff(files)
    local cb = table.remove(p.pending.diff, 1)
    if cb then cb(files) end
  end
  function p.flush_comments(comments, err)
    local cb = table.remove(p.pending.comments, 1)
    if cb then cb(comments, err) end
  end
  return p
end

describe("registry.refresh — happy path", function()
  local registry, provider
  before_each(function()
    registry = fresh_registry()
    registry._set_diffview_session(stub_diffview(make_view_session()))
    provider = deferred_provider("bitbucket")
    registry.set_providers({ provider })
  end)

  it("loads pr → diff + comments → clears loading_key, populates session", function()
    registry.refresh(1)
    assert.is_not_nil(registry.get(1))
    assert.equals("bitbucket:/repo:abc123", registry.get(1).session_key)
    assert.equals("bitbucket:/repo:abc123", registry.get(1).loading_key)
    assert.is_nil(registry.get(1).pr)

    provider.flush_pr({ id = 99 })
    assert.is_not_nil(registry.get(1).pr)
    assert.equals(99, registry.get(1).pr.id)
    -- Loading still set until both fetches finish.
    assert.equals("bitbucket:/repo:abc123", registry.get(1).loading_key)

    provider.flush_diff({ ["src/a.lua"] = { hunks = {} } })
    -- Comments not yet finished: loading still set.
    assert.equals("bitbucket:/repo:abc123", registry.get(1).loading_key)

    provider.flush_comments({ { id = 1, body = "hi" } })
    assert.is_nil(registry.get(1).loading_key)
    assert.equals(1, #registry.get(1).comments)
    assert.is_not_nil(registry.get(1).diff_files["src/a.lua"])
  end)
end)

describe("registry.refresh — guards", function()
  local registry, provider
  before_each(function()
    registry = fresh_registry()
    registry._set_diffview_session(stub_diffview(make_view_session()))
    provider = deferred_provider("bitbucket")
    registry.set_providers({ provider })
  end)

  it("second refresh while loading same key is a no-op", function()
    registry.refresh(1)
    registry.refresh(1)
    -- Only one find_pr in flight.
    assert.equals(1, #provider.pending.find_pr)
  end)

  it("force=true reissues even if pr already loaded", function()
    registry.refresh(1)
    provider.flush_pr({ id = 1 })
    provider.flush_diff({})
    provider.flush_comments({})
    assert.is_nil(registry.get(1).loading_key)

    registry.refresh(1, { force = true })
    assert.equals(1, #provider.pending.find_pr)
  end)

  it("drops stale callbacks when session_key changes mid-flight", function()
    registry.refresh(1)
    -- Simulate the tab switching to a different revision before find_pr returns.
    local stale_session = registry.get(1)
    registry.__sessions[1] = nil
    registry._set_diffview_session(stub_diffview(make_view_session({ modified_revision = "def456" })))
    registry.refresh(1)

    -- Flush the original (stale) find_pr — must not corrupt the new session.
    provider.flush_pr({ id = "stale" })
    local current = registry.get(1)
    assert.are_not.equal(stale_session, current)
    assert.is_nil(current.pr) -- new session pr still pending
  end)

  it("drops stale comments callback when session changes after pr returns", function()
    registry.refresh(1)
    provider.flush_pr({ id = 1 })
    -- Replace session: simulates tab/rev change.
    registry.__sessions[1] = { provider = provider, session_key = "other", loading_key = "other",
      pr = nil, comments = {}, diff_files = {} }
    -- Original comments callback fires now — must be ignored.
    provider.flush_comments({ { id = 1 } })
    assert.equals(0, #registry.get(1).comments)
  end)
end)

describe("registry.refresh — error paths", function()
  local registry, provider
  before_each(function()
    registry = fresh_registry()
    registry._set_diffview_session(stub_diffview(make_view_session()))
    provider = deferred_provider("bitbucket")
    registry.set_providers({ provider })
  end)

  it("clears loading_key on find_pr error", function()
    registry.refresh(1)
    provider.flush_pr(nil, "boom")
    assert.is_nil(registry.get(1).loading_key)
    assert.is_nil(registry.get(1).pr)
  end)

  it("clears loading_key when find_pr returns nil pr", function()
    registry.refresh(1)
    provider.flush_pr(nil, nil)
    assert.is_nil(registry.get(1).loading_key)
  end)

  it("clears state on fetch_comments error", function()
    registry.refresh(1)
    provider.flush_pr({ id = 1 })
    provider.flush_diff({})
    provider.flush_comments(nil, "comments boom")
    local s = registry.get(1)
    assert.is_nil(s.loading_key)
    assert.is_nil(s.pr)
    assert.is_nil(s.session_key)
  end)
end)

describe("registry.destroy", function()
  it("removes the entry for the tabpage", function()
    local registry = fresh_registry()
    registry._set_diffview_session(stub_diffview(make_view_session()))
    local provider = deferred_provider("bitbucket")
    registry.set_providers({ provider })

    registry.refresh(1)
    provider.flush_pr({ id = 1 })
    provider.flush_diff({})
    provider.flush_comments({})
    assert.is_not_nil(registry.get(1))

    registry.destroy(1)
    assert.is_nil(registry.get(1))
  end)
end)

describe("registry.provider_for", function()
  it("returns first provider whose can_handle is true", function()
    local registry = fresh_registry()
    registry._set_diffview_session(stub_diffview(make_view_session()))
    local p1 = { name = "p1", can_handle = function() return false end }
    local p2 = { name = "p2", can_handle = function() return true end }
    local p3 = { name = "p3", can_handle = function() return true end }
    registry.set_providers({ p1, p2, p3 })

    local picked, view_session = registry.provider_for(1)
    assert.equals("p2", picked.name)
    assert.equals("/repo", view_session.git_root)
  end)

  it("returns nil provider when no view session", function()
    local registry = fresh_registry()
    registry._set_diffview_session({ read = function() return nil end })
    local picked = registry.provider_for(1)
    assert.is_nil(picked)
  end)
end)

describe("registry.provider_for_origin_url", function()
  it("returns the first provider whose parse_origin_url matches", function()
    local registry = fresh_registry()
    local p1 = { name = "p1", parse_origin_url = function() return nil end }
    local p2 = { name = "p2", parse_origin_url = function() return "ws", "repo" end }
    registry.set_providers({ p1, p2 })

    local picked, ws, repo = registry.provider_for_origin_url("git@github.com:ws/repo.git")
    assert.equals("p2", picked.name)
    assert.equals("ws", ws)
    assert.equals("repo", repo)
  end)

  it("returns nil when no provider claims the URL", function()
    local registry = fresh_registry()
    local p1 = { name = "p1", parse_origin_url = function() return nil end }
    registry.set_providers({ p1 })
    assert.is_nil(registry.provider_for_origin_url("https://example.com/x/y.git"))
  end)

  it("skips providers without parse_origin_url", function()
    local registry = fresh_registry()
    local p1 = { name = "p1" } -- no parse_origin_url
    local p2 = { name = "p2", parse_origin_url = function() return "ws", "repo" end }
    registry.set_providers({ p1, p2 })
    local picked = registry.provider_for_origin_url("git@github.com:ws/repo.git")
    assert.equals("p2", picked.name)
  end)
end)
