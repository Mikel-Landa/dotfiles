-- DAP base wiring. Per-language adapters / configurations live in `lang/<name>.lua`.
--
-- This file owns: nvim-dap, nvim-dap-ui, virtual text, mason-nvim-dap, signs, keymaps.
-- Adapter binaries (codelldb, delve, debugpy, js-debug-adapter) install via
-- mason-tool-installer entries in lang files.

local sign = vim.fn.sign_define
sign("DapBreakpoint",          { text = "●", texthl = "DiagnosticError", linehl = "", numhl = "" })
sign("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticError", linehl = "", numhl = "" })
sign("DapBreakpointRejected",  { text = "", texthl = "DiagnosticError", linehl = "", numhl = "" })
sign("DapLogPoint",            { text = "◉", texthl = "DiagnosticInfo",  linehl = "", numhl = "" })
sign("DapStopped",             { text = "▶", texthl = "DiagnosticWarn",  linehl = "DapStoppedLine", numhl = "" })

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
      "jay-babu/mason-nvim-dap.nvim",
    },
    keys = {
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Breakpoint condition" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end,         desc = "Toggle breakpoint" },
      { "<leader>dc", function() require("dap").continue() end,                  desc = "Run/Continue" },
      { "<leader>dC", function() require("dap").run_to_cursor() end,             desc = "Run to cursor" },
      { "<leader>dg", function() require("dap").goto_() end,                     desc = "Go to line (no execute)" },
      { "<leader>di", function() require("dap").step_into() end,                 desc = "Step into" },
      { "<leader>dj", function() require("dap").down() end,                      desc = "Down (stack)" },
      { "<leader>dk", function() require("dap").up() end,                        desc = "Up (stack)" },
      { "<leader>dl", function() require("dap").run_last() end,                  desc = "Run last" },
      { "<leader>do", function() require("dap").step_out() end,                  desc = "Step out" },
      { "<leader>dO", function() require("dap").step_over() end,                 desc = "Step over" },
      { "<leader>dp", function() require("dap").pause() end,                     desc = "Pause" },
      { "<leader>dr", function() require("dap").repl.toggle() end,               desc = "Toggle REPL" },
      { "<leader>ds", function() require("dap").session() end,                   desc = "Session" },
      { "<leader>dt", function() require("dap").terminate() end,                 desc = "Terminate" },
      { "<leader>dw", function() require("dap.ui.widgets").hover() end,          desc = "Widgets hover" },
      { "<leader>du", function() require("dapui").toggle({}) end,                desc = "Toggle DAP UI" },
      { "<leader>de", function() require("dapui").eval() end, mode = { "n", "v" }, desc = "Eval" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open({}) end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close({}) end
      dap.listeners.before.event_exited["dapui_config"]     = function() dapui.close({}) end

      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      -- Allow comments in launch.json (VS Code style)
      local ok, plenary_json = pcall(require, "plenary.json")
      if ok then
        require("dap.ext.vscode").json_decode = function(str)
          return vim.json.decode(plenary_json.json_strip_comments(str))
        end
      end
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-neotest/nvim-nio" },
    opts = {},
  },

  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap" },
    opts = {},
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
    cmd = { "DapInstall", "DapUninstall" },
    opts = {
      -- Adapters install via mason-tool-installer (lang files). This plugin only
      -- exposes the :DapInstall UI and default config templates for some langs.
      automatic_installation = false,
      handlers = {
        function(config) require("mason-nvim-dap").default_setup(config) end,
        -- Skip python: nvim-dap-python sets up debugpy itself
        python = function() end,
      },
    },
  },
}
