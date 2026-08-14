-- atlas.nvim: GitHub + Bitbucket PR browser, GitHub + Jira issue browser
-- Bitbucket/Jira tokens via env vars (see ~/.config/zsh/secrets.zsh).
-- GitHub auth via `gh auth login`.
-- After install, fill in `views` for workspaces/repos and JQL.

return {
  {
    "emrearmagan/atlas.nvim",
    cmd = {
      "AtlasPulls",
      "AtlasIssues",
      "AtlasJqlSearch",
      "AtlasDiff",
      "AtlasNotes",
      "AtlasNotesClearAll",
      "AtlasCreatePR",
      "AtlasCreateIssue",
      "AtlasSearch",
      "AtlasOpen",
      "AtlasClearCache",
      "AtlasLogs",
    },
    dependencies = {
      "MeanderingProgrammer/render-markdown.nvim",
      "esmuellert/codediff.nvim",
    },
    opts = {
      pulls = {
        diff = {
          open_cmd = "CodeDiff",
          show_review_panel = true,
        },
        repo_config = {
          -- Maps `workspace/repo` to local paths. Used for checkout and custom actions.
          paths = {
            ["ifs-pd/*"] = "~/repos/*",
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
          github = {
            cache_ttl = 300,
            views = {
              {
                name = "Assigned",
                key = "1",
                search = "assignee:@me is:open",
              },
              {
                name = "Created",
                key = "2",
                search = "author:@me is:open",
              },
            },
          },
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
