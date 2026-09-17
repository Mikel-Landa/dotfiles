-- Helm templates and chart values; helm-ls delegates YAML support to yamlls.
return {
  {
    "qvalentin/helm-ls.nvim",
    ft = { "helm", "yaml.helm-values" },
    opts = {
      conceal_templates = { enabled = false },
      indent_hints = { enabled = false },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "helm-ls" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        helm_ls = {
          settings = {
            ["helm-ls"] = {
              yamlls = { path = "yaml-language-server" },
            },
          },
        },
        -- Helm LS owns values files too; avoid two competing YAML clients.
        yamlls = { filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" } },
      },
    },
  },
}
