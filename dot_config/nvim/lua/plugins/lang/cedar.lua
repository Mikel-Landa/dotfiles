-- Cedar (AWS policy language): cedar-language-server + cedar fmt.
--
-- Not in mason/lspconfig/treesitter. Install the server manually:
--   cargo install --git https://github.com/cedar-policy/cedar cedar-language-server --features bin
-- Optional formatter (provides the `cedar` CLI):
--   cargo install cedar-policy-cli
--
-- Filetype (`.cedar`, `.cedarschema`) is registered centrally in
-- lua/config/autocmds.lua so it's set before nvim-lspconfig lazy-loads.
--
-- Heads-up: the server writes hourly logs to `./logs/server.log` relative to
-- nvim's CWD (hardcoded server-side), so a `logs/` dir appears wherever nvim ran.
return {
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        cedar = { "cedar" },
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        -- Full config: cedar has no bundled lspconfig default, so cmd /
        -- filetypes / root_markers must be supplied here. Pure stdio server.
        cedar = {
          cmd = { "cedar-language-server" },
          filetypes = { "cedar" },
          root_markers = { ".git" },
        },
      },
    },
  },
}
