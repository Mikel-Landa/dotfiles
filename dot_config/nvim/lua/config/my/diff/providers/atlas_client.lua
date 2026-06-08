-- Atlas client. Single adapter onto atlas.nvim's Bitbucket API.
-- See CONTEXT.md → "Atlas client".
local M = {}

local function default_require(mod)
  local ok, m = pcall(require, mod)
  return ok and m or nil
end

local REQUIRED = {
  service       = "atlas.pulls.providers.bitbucket.api.service",
  mapper        = "atlas.pulls.providers.bitbucket.api.mapper",
  pullrequests  = "atlas.pulls.providers.bitbucket.api.pullrequests",
  comments      = "atlas.pulls.providers.bitbucket.api.comments",
  users         = "atlas.pulls.providers.bitbucket.api.users",
}

---@param opts? { require: fun(mod: string): table|nil }
---@return table|nil
function M.new(opts)
  opts = opts or {}
  local req = opts.require or default_require

  local deps = {}
  for key, mod in pairs(REQUIRED) do
    local m = req(mod)
    if not m then return nil end
    deps[key] = m
  end

  local client = { _deps = deps }

  function client.fetch_open_prs(workspace, repo, cb)
    local endpoint = ("/repositories/%s/%s/pullrequests?state=OPEN&pagelen=50"):format(workspace, repo)
    deps.service.request("GET", endpoint, nil, nil, function(result, err)
      if err then cb(nil, err); return end
      cb(deps.mapper.to_pull_requests_list(result, workspace, repo), nil)
    end)
  end

  function client.fetch_diff(pr, fetch_opts, cb)
    deps.pullrequests.fetch_diff(pr, fetch_opts or {}, function(diff, err)
      if err then cb(nil, err); return end
      cb(diff or {}, nil)
    end)
  end

  function client.fetch_comments(url, cb)
    local sep = url:find("?") and "&" or "?"
    local paged = ("%s%spagelen=100"):format(url, sep)
    deps.service.request("GET", paged, nil, nil, function(result, err)
      if err then cb(nil, err); return end
      cb((result or {}).values or {}, nil)
    end)
  end

  function client.create_comment(pr, body, comment_opts, cb)
    deps.comments.add_comment(pr, body, comment_opts or {}, function(result, err)
      if err then cb(nil, err); return end
      cb(result, nil)
    end)
  end

  function client.reply_comment(pr, parent_id, body, reply_opts, cb)
    deps.comments.reply_comment(pr, parent_id, body, reply_opts, function(result, err)
      if err then cb(nil, err); return end
      cb(result, nil)
    end)
  end

  function client.delete_comment(pr, comment_id, cb)
    deps.comments.delete_comment(pr, comment_id, function(ok, err)
      if err or not ok then cb(nil, err or "delete returned false"); return end
      cb(true, nil)
    end)
  end

  function client.edit_comment(pr, comment_id, body, edit_opts, cb)
    deps.comments.edit_comment(pr, comment_id, body, edit_opts or {}, function(result, err)
      if err then cb(nil, err); return end
      cb(result, nil)
    end)
  end

  function client.fetch_current_user(cb)
    deps.users.fetch_current_user(function(user, err)
      if err then cb(nil, err); return end
      cb(user, nil)
    end)
  end

  function client.approve(url, cb)
    deps.pullrequests.approve(url, function(result, err)
      if err then cb(nil, err); return end
      cb(result or true, nil)
    end)
  end

  function client.request_changes(url, cb)
    deps.pullrequests.request_changes(url, function(result, err)
      if err then cb(nil, err); return end
      cb(result or true, nil)
    end)
  end

  return client
end

return M
