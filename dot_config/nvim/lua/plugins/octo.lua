-- octo.nvim: kept for GitHub *issues* only (atlas.nvim handles GitHub PRs).
-- Auth via `gh auth login`.
return {
  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/snacks.nvim",
      "echasnovski/mini.nvim",
    },
    opts = {
      enable_builtin = true,
      picker = "snacks",
      use_local_fs = true,
    },
  },
}
