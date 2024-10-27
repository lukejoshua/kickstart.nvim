return {
  'akinsho/bufferline.nvim',
  version = "*",
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'otavioschwanck/arrow.nvim'
  },
  ---@type bufferline.Config
  opts = {
    options = {
      -- separator_style = 'slant',
      show_buffer_close_icons = false,
      diagnostics = 'nvim_lsp',
      name_formatter = function() end,
      numbers = function(opts)
        local arrow = require('arrow.statusline')
        return arrow.text_for_statusline_with_icons(opts.id)
      end,
      custom_filter = function(buf_number, buf_numbers)
        -- TODO: include current file and alternate file

        if buf_number == vim.api.nvim_get_current_buf() then
          return true
        end

        local arrow = require('arrow.statusline')
        return arrow.is_on_arrow_file(buf_number) ~= nil
      end,
      sort_by = function(buffer_a, buffer_b)
        local arrow = require('arrow.statusline')
        local buffer_a = buffer_a
        local key_a = arrow.text_for_statusline(buffer_a.id)
        local key_b = arrow.text_for_statusline(buffer_b.id)

        return key_a < key_b
      end
    }
  }
}
