return {
  "xiyaowong/transparent.nvim",
  lazy = false,

  config = function()
    local extra_groups = {
      "NormalFloat",
      "FloatShadow",
      "FloatBorder",
      "TelescopePromptTitle",
      "TelescopePromptBorder",
      "TelescopeBorder",
      "TelescopeNormal",
      "BufferLineFill",
      "TreesitterContext"
    }
    for name, value in pairs(vim.log.levels) do
      if value ~= vim.log.levels.OFF then
        table.insert(extra_groups, 'Notify' .. name .. 'Body')
        table.insert(extra_groups, 'Notify' .. name .. 'Border')
      end
    end

    require("transparent").setup({
      -- table: default groups
      groups = {
        'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
        'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
        'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
        'SignColumn', 'CursorLine', 'CursorLineNr', 'StatusLine', 'StatusLineNC',
        'EndOfBuffer', 'FloatShadow'
      },
      -- table: additional groups that should be cleared
      extra_groups = extra_groups,

      -- table: groups you don't want to clear
      exclude_groups = {},

      -- function: code to be executed after highlight groups are cleared
      -- Also the user event "TransparentClear" will be triggered
      on_clear = function() end,
    })
  end,
}
