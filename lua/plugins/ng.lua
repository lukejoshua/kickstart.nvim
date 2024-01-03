return {
  'joeveiga/ng.nvim',
  keys = {
    {
      'gat',
      function()
        require('ng').goto_template_for_component()
      end,
      desc = '[g]o to [a]ngular [t]emplate',
    },
    {
      'gac',
      function()
        require('ng').goto_component_with_template_file()
      end,
      desc = '[g]o to [a]ngular [c]omponent',
    },
  },
}
