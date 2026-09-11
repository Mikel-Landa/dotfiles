-- atlas.nvim: GitHub + Bitbucket PR browser, GitHub + Jira issue browser
-- Bitbucket/Jira tokens via env vars (see ~/.config/zsh/secrets.zsh).
-- GitHub auth via `gh auth login`.

return {
  {
    "emrearmagan/atlas.nvim",
    cmd = { "Atlas", "AtlasDiff" },
    dependencies = {
      "MeanderingProgrammer/render-markdown.nvim",
      "esmuellert/codediff.nvim",
    },
    opts = {
      providers = {
        github = {
          cache_ttl = 300,
        },
        bitbucket = {
          user      = os.getenv("BITBUCKET_USER") or "",
          token     = os.getenv("BITBUCKET_TOKEN") or "",
          cache_ttl = 300,
        },
        jira = {
          base_url  = os.getenv("JIRA_BASE_URL") or "",
          email     = os.getenv("JIRA_EMAIL") or "",
          token     = os.getenv("JIRA_TOKEN") or "",
          cache_ttl = 300,
        },
      },
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
        github = {
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
          views = {
            {
              name = "Mine",
              key = "1",
              layout = "compact",
              search = 'repo:ifs-pd/nexus-control-plane author.nickname = "Mikel Landa"',
            },
            {
              name = "Reviewing",
              key = "2",
              layout = "compact",
              search = 'repo:ifs-pd/nexus-control-plane reviewers.nickname = "Mikel Landa"',
            },
          },
        },
      },
      issues = {
        github = {
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
          views = {
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
}
