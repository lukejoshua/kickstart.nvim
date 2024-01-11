--- @param n number
local function select(n)
  return function()
    print('Navigated to harpoon[' .. n .. ']')
    require('harpoon.ui').nav_file(n)
  end
end

return {
  'ThePrimeagen/harpoon',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
  },
  lazy = false,
  config = function()
    require('harpoon').setup {}
  end,
  keys = {
    { '<leader>1', select(1), desc = 'Harpoon: Select 1' },
    { '<leader>2', select(2), desc = 'Harpoon: Select 2' },
    { '<leader>3', select(3), desc = 'Harpoon: Select 3' },
    { '<leader>4', select(4), desc = 'Harpoon: Select 4' },
    {
      '<leader>nn',
      function()
        require('harpoon.ui').toggle_quick_menu()
      end,
      desc = 'Harpoon: Toggle quick menu',
    },
    {
      '<leader>na',
      function()
        print 'Added file to harpoon'
        require('harpoon.mark').add_file()
      end,
      desc = 'Harpoon: Add file',
    },
    -- TODO: telescope integration?
    -- TODO: next and prev
  },
}
