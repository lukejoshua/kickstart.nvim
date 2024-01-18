return {
  'folke/persistence.nvim',
  event = 'BufReadPre', -- this will only start session saving when an actual file was opened
  keys = {
    {
      '<leader>P',
      function()
        require('persistence').load()
      end,
      desc = 'Restore session',
    },
  },
  opts = {},
}
