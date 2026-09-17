return {
  {
    "nvim-neotest/neotest",
    cmd = "Neotest",
    dependencies = { "nvim-neotest/nvim-nio", "nvim-lua/plenary.nvim" },
    opts = { adapters = {} },
    keys = {
      { "<leader>Tr", function() require("neotest").run.run() end, desc = "Run nearest test" },
      { "<leader>Tf", function() require("neotest").run.run(vim.api.nvim_buf_get_name(0)) end, desc = "Run file tests" },
      { "<leader>Tl", function() require("neotest").run.run_last() end, desc = "Rerun last test" },
      { "<leader>Td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug nearest test" },
      { "<leader>Ts", function() require("neotest").summary.toggle() end, desc = "Test summary" },
      { "<leader>To", function() require("neotest").output.open({ enter = true }) end, desc = "Test output" },
      { "<leader>Tx", function() require("neotest").run.stop() end, desc = "Stop test" },
    },
  },
}
