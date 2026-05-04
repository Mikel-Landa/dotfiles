-- octo.nvim: GitHub PR + issue browser, review flow, inline comments
-- Auth via `gh auth login` (Octo shells out to gh CLI).
return {
  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/snacks.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      enable_builtin = true,
      picker = "snacks",
      use_local_fs = true,
    },
  },
}
