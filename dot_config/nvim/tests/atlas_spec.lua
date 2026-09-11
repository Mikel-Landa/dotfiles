package.loaded["plugins.atlas"] = nil
local spec = require("plugins.atlas")[1]
local opts = spec.opts

describe("atlas plugin spec", function()
  it("lazy-loads on Atlas 0.7 commands", function()
    assert.same({ "Atlas", "AtlasDiff" }, spec.cmd)
  end)

  it("puts auth under providers and views under pulls/issues", function()
    assert.is_table(opts.providers.github)
    assert.is_table(opts.providers.bitbucket)
    assert.is_table(opts.providers.jira)
    assert.is_table(opts.pulls.github.views)
    assert.is_table(opts.pulls.bitbucket.views)
    assert.is_table(opts.issues.github.views)
    assert.is_table(opts.issues.jira.views)
    assert.is_nil(opts.pulls.providers)
    assert.is_nil(opts.issues.providers)
  end)

  it("uses Atlas Bitbucket search with nickname, not auth email", function()
    for _, view in ipairs(opts.pulls.bitbucket.views) do
      assert.is_string(view.search)
      assert.is_nil(view.repos)
      assert.is_nil(view.filter)
      assert.truthy(view.search:find("repo:ifs-pd/nexus-control-plane", 1, true))
      assert.is_nil(view.search:find("@", 1, true))
      assert.is_nil(view.search:find("author.uuid", 1, true))
      assert.is_nil(view.search:find("reviewers.uuid", 1, true))
    end
    local searches = {}
    for _, view in ipairs(opts.pulls.bitbucket.views) do
      searches[view.name] = view.search
    end
    assert.truthy(searches.Mine:find("author.nickname =", 1, true))
    assert.truthy(searches.Reviewing:find("reviewers.nickname =", 1, true))
  end)

  it("keeps GitHub mine/review on @me", function()
    local searches = {}
    for _, view in ipairs(opts.pulls.github.views) do
      searches[view.name] = view.search
    end
    assert.truthy(searches.Mine:find("author:@me", 1, true))
    assert.truthy(searches["Review requests"]:find("review-requested:@me", 1, true))
  end)
end)
