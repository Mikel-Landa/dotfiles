return {
  {
    "ramilito/kubectl.nvim",
    -- The downloader requires a tagged release for matching native binaries.
    version = "2.*",
    dependencies = { "saghen/blink.download" },
    cmd = { "Kubectl", "Kubectx", "Kubens", "K" },
    keys = {
      { "<leader>kk", function() require("kubectl").toggle() end, desc = "Kubernetes cluster" },
      { "<leader>kc", "<cmd>Kubectx<cr>", desc = "Kubernetes context" },
      { "<leader>kn", "<cmd>Kubens<cr>", desc = "Kubernetes namespace" },
    },
    opts = {},
  },
}
