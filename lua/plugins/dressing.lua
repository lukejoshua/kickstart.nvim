return {
  'stevearc/dressing.nvim',
  lazy = true,
  init = function()
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.ui.select = function(...)
      require('lazy').load { plugins = { 'dressing.nvim' } }
      return vim.ui.select(...)
    end
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.ui.input = function(...)
      require('lazy').load { plugins = { 'dressing.nvim' } }
      return vim.ui.input(...)
    end
  end,
  config = function()
    require('dressing').setup {
      select = {
        backend = { 'builtin' },
        get_config = function(opts)
          if opts.kind == 'codeaction' then
            return {
              builtin = {
                relative = 'cursor',
              },
            }
          end

          if opts.kind == 'ngswitch' then
            return {
              builtin = {
                relative = 'win',
              },
            }
          end
        end,
      },
    }
  end,
}
