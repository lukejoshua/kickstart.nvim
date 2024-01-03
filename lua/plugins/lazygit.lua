return {
  'kdheepak/lazygit.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  keys = {
    { '<leader>gg', '<CMD>lua require("lazygit").lazygit()<CR>', desc = 'Lazygit' },
  },
}
