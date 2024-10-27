return {
  "folke/tokyonight.nvim",
  opts = { style = 'night' },
  lazy = false,
  priority = 1000,
  config = function()
    require("tokyonight").setup { transparent = vim.g.transparent_enabled }
    vim.cmd.colorscheme 'tokyonight-night'
  end,
}
