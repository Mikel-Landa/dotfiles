-- TypeScript / JavaScript: vtsls (LSP) + prettierd + js-debug-adapter (DAP)
return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = { ensure_install = { "javascript", "typescript", "tsx", "jsdoc" } },
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = {
      ensure_installed = {
        "vtsls",
        "prettierd",
        "js-debug-adapter",
      },
    },
  },

  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        javascript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        jsonc = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "prettierd", "prettier", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        vtsls = {
          filetypes = {
            "javascript", "javascriptreact", "javascript.jsx",
            "typescript", "typescriptreact", "typescript.tsx",
          },
          settings = {
            complete_function_calls = true,
            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = {
                maxInlayHintLength = 30,
                completion = { enableServerSideFuzzyMatch = true },
              },
            },
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              suggest = { completeFunctionCalls = true },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
            },
          },
          keys = function(client, bufnr)
            local map = function(lhs, rhs, desc)
              vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = "LSP: " .. desc })
            end
            local function exec(action)
              vim.lsp.buf.code_action({
                apply = true,
                context = { only = { action }, diagnostics = {} },
              })
            end
            map("gD", function()
              local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
              client:exec_cmd({
                title = "gotoSourceDefinition",
                command = "typescript.goToSourceDefinition",
                arguments = { params.textDocument.uri, params.position },
              }, { bufnr = bufnr })
            end, "Goto source definition")
            map("gR", function()
              client:exec_cmd({
                title = "fileReferences",
                command = "typescript.findAllFileReferences",
                arguments = { vim.uri_from_bufnr(0) },
              }, { bufnr = bufnr })
            end, "File references")
            map("<leader>co", function()
              exec("source.organizeImports")
              require("conform").format({ async = true, lsp_format = "fallback" })
            end, "Organize imports + format")
            map("<leader>cM", function() exec("source.addMissingImports.ts") end, "Add missing imports")
            map("<leader>cD", function() exec("source.fixAll.ts") end, "Fix all")
            map("<leader>cu", function() exec("source.removeUnused.ts") end, "Remove unused")
          end,
        },
      },
    },
  },

  -- DAP: vscode-js-debug adapters (pwa-* plus aliases). Side-effect via opts so
  -- multiple lang files can register their own adapters without overriding each other.
  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function()
      local dap = require("dap")
      for _, adapter in ipairs({ "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal" }) do
        if not dap.adapters[adapter] then
          dap.adapters[adapter] = {
            type = "server",
            host = "localhost",
            port = "${port}",
            executable = {
              command = "js-debug-adapter",
              args = { "${port}" },
            },
          }
        end
      end
      for _, alias in ipairs({ "node", "chrome", "msedge" }) do
        if not dap.adapters[alias] then
          dap.adapters[alias] = function(cb, config)
            local nat = dap.adapters["pwa-" .. alias]
            if type(nat) == "function" then nat(cb, config) else cb(nat) end
          end
        end
      end
      for _, lang in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
        dap.configurations[lang] = dap.configurations[lang] or {}
        vim.list_extend(dap.configurations[lang], {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
            runtimeExecutable = (vim.fn.executable("tsx") == 1) and "tsx" or "ts-node",
            skipFiles = { "<node_internals>/**", "node_modules/**" },
            resolveSourceMapLocations = {
              "${workspaceFolder}/**",
              "!**/node_modules/**",
            },
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
        })
      end
    end,
  },
}
