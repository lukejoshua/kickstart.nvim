return {
  "nvim-telescope/telescope-frecency.nvim",
  config = function()
    require("telescope").load_extension "frecency"
  end,
  -- TODO: also include files I've never searched
  keys = {
    { "<leader>ft",      "<cmd>Neotree toggle<cr>",     desc = "NeoTree" },
    { '<leader><space>', "<cmd>Telescope frecency<cr>", desc = '[ ] Find frecent files' }
  }
}
