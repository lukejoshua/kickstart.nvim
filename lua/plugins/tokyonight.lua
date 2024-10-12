return {
  "folke/tokyonight.nvim",
  opts = { style = 'night' },
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme 'tokyonight-night'
  end,
}
