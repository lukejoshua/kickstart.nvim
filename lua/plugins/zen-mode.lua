return {
  'folke/zen-mode.nvim',
  keys = {
    {
      '<leader>z',
      function()
        require('zen-mode').toggle()
      end,
      desc = 'Toggle Zen Mode',
    },
  },
  opts = {},
}
