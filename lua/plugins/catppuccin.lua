return {
  'catppuccin/nvim',
  priority = 1000,
  name = 'catppuccin',
  opts = { flavor = 'mocha' },
  config = function()
    vim.cmd.colorscheme 'catppuccin'
  end,
}
