return {
  "ray-x/go.nvim",
  dependencies = { -- optional packages
    "ray-x/guihua.lua",
    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("go").setup(
      {
        lsp_cfg = {
          settings = {
            gopls = {
              hints = {
                parameterNames = true
                -- ... other settings from doc/inlayHints.md ...
              }
            }
          }
        },
        -- max_line_len = 80, -- max line length in golines format, Target maximum line length for golines
      }
    )
  end,
  event = { "CmdlineEnter" },
  ft = { "go", 'gomod' },
  build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
}
