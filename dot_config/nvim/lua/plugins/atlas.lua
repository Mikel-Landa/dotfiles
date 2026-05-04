-- atlas.nvim: Bitbucket PR + Jira issue browser
-- Tokens via env vars (see ~/.config/zsh/secrets.zsh).
-- After install, fill in `views` for Bitbucket workspaces/repos and Jira JQL.
return {
  {
    "emrearmagan/atlas.nvim",
    cmd = { "AtlasJira", "AtlasBitbucket", "AtlasJqlSearch", "AtlasClearCache", "AtlasLogs" },
    dependencies = {
      "MeanderingProgrammer/render-markdown.nvim",
      "sindrets/diffview.nvim",
    },
    opts = {
      bitbucket = {
        user        = os.getenv("BITBUCKET_USER") or "",
        token       = os.getenv("BITBUCKET_TOKEN") or "",
        cache_ttl   = 300,
        diff        = { open_cmd = "DiffviewOpen" },
        repo_config = {
          -- Maps `workspace/repo` to local paths. Used for checkout and custom actions.
          paths = {
            ["ifs-pd/*"] = "~/repos/*",
          },
        },
        views       = {
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
}
