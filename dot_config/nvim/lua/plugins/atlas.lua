-- atlas.nvim: GitHub + Bitbucket PR browser, Jira issue browser
-- Bitbucket/Jira tokens via env vars (see ~/.config/zsh/secrets.zsh).
-- GitHub auth via `gh auth login`.
-- After install, fill in `views` for workspaces/repos and JQL.

local function review_action(event, label)
  return function(_, ctx, done)
    local pr = ctx and ctx.pr
    if not pr then done(false, "No PR selected"); return end

    local atlas_client = require("config.my.diff.providers.atlas_client").new()
    local provider = atlas_client and require("config.my.diff.providers.bitbucket").new(atlas_client)
    if not provider or not provider.submit_review then
      done(false, "Bitbucket provider unavailable"); return
    end

    require("config.my.diff.comments_ui").input({
      title = (" %s review "):format(label),
      on_empty = function() done(false, "Empty review, cancelled") end,
      on_close = function() done(false, "Cancelled") end,
      on_submit = function(body)
        provider.submit_review(pr, event, body, function(_, err)
          if err then done(false, err); return end
          done(true, ("%s submitted"):format(label))
        end)
      end,
    })
  end
end

return {
  {
    "emrearmagan/atlas.nvim",
    cmd = { "AtlasPulls", "AtlasIssues", "AtlasJqlSearch", "AtlasClearCache", "AtlasLogs" },
    dependencies = {
      "MeanderingProgrammer/render-markdown.nvim",
      "sindrets/diffview.nvim",
    },
    opts = {
      pulls = {
        diff = { open_cmd = "DiffviewOpen" },
        repo_config = {
          -- Maps `workspace/repo` to local paths. Used for checkout and custom actions.
          paths = {
            ["ifs-pd/*"] = "~/repos/*",
          },
        },
        custom_actions = {
          {
            id = "approve",
            label = "Approve PR",
            confirmation = true,
            run = review_action("APPROVE", "Approve"),
          },
          {
            id = "request_changes",
            label = "Request changes",
            confirmation = true,
            run = review_action("REQUEST_CHANGES", "Request changes"),
          },
        },
        providers = {
          github = {
            cache_ttl = 300,
            views = {
              {
                name = "Mine",
                key = "1",
                search = "author:@me sort:updated-desc",
              },
              {
                name = "Review requests",
                key = "2",
                search = "review-requested:@me sort:updated-desc",
              },
            },
          },
          bitbucket = {
            user      = os.getenv("BITBUCKET_USER") or "",
            token     = os.getenv("BITBUCKET_TOKEN") or "",
            cache_ttl = 300,
            views     = {
              {
                name = "Mine",
                key = "1",
                layout = "compact",
                repos = { { workspace = "ifs-pd", repo = "nexus-control-plane" } },
                filter = function(pr, ctx)
                  local user = ctx.user or {}
                  return pr.author and pr.author.account_id == user.account_id
                end,
              },
              {
                name = "Reviewing",
                key = "2",
                layout = "compact",
                repos = { { workspace = "ifs-pd", repo = "nexus-control-plane" } },
                filter = function(pr, ctx)
                  local user = ctx.user or {}
                  for _, r in ipairs(pr.reviewers or {}) do
                    if r.account_id == user.account_id then
                      return true
                    end
                  end
                  return false
                end,
              },
            },
          },
        },
      },
      issues = {
        providers = {
          jira = {
            base_url  = os.getenv("JIRA_BASE_URL") or "",
            email     = os.getenv("JIRA_EMAIL") or "",
            token     = os.getenv("JIRA_TOKEN") or "",
            cache_ttl = 300,
            views     = {
              {
                name = "Odin",
                key = "M",
                jql =
                "project = PLAT AND assignee = currentUser() AND sprint in openSprints() AND statusCategory != Done ORDER BY updated DESC",
              },
            },
          },
        },
      },
    },
  },
}
