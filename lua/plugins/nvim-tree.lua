local HEIGHT_RATIO = 0.8
local WIDTH_RATIO = 0.8
local ENABLE_FLOATING_WINDOW = true

return {
  'nvim-tree/nvim-tree.lua',
  version = '*',
  lazy = false,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('nvim-tree').setup {
      on_attach = function(buffer_number)
        local api = require 'nvim-tree.api'

        local mappings = {
          ['<C-]>'] = { api.tree.change_root_to_node, 'CD' },
          ['<C-e>'] = { api.node.open.replace_tree_buffer, 'Open: In Place' },
          ['<C-k>'] = { api.node.show_info_popup, 'Info' },
          ['<C-r>'] = { api.fs.rename_sub, 'Rename: Omit Filename' },
          ['<C-t>'] = { api.node.open.tab, 'Open: New Tab' },
          ['<C-v>'] = { api.node.open.vertical, 'Open: Vertical Split' },
          ['<C-x>'] = { api.node.open.horizontal, 'Open: Horizontal Split' },
          ['<BS>'] = { api.node.navigate.parent_close, 'Close Directory' },
          ['<CR>'] = { api.node.open.edit, 'Open' },
          ['<Tab>'] = { api.node.open.preview, 'Open Preview' },
          ['>'] = { api.node.navigate.sibling.next, 'Next Sibling' },
          ['<'] = { api.node.navigate.sibling.prev, 'Previous Sibling' },
          ['.'] = { api.node.run.cmd, 'Run Command' },
          ['-'] = { api.tree.change_root_to_parent, 'Up' },
          ['a'] = { api.fs.create, 'Create File Or Directory' },
          ['bd'] = { api.marks.bulk.delete, 'Delete Bookmarked' },
          ['bt'] = { api.marks.bulk.trash, 'Trash Bookmarked' },
          ['bmv'] = { api.marks.bulk.move, 'Move Bookmarked' },
          ['B'] = { api.tree.toggle_no_buffer_filter, 'Toggle Filter: No Buffer' },
          ['c'] = { api.fs.copy.node, 'Copy' },
          ['C'] = { api.tree.toggle_git_clean_filter, 'Toggle Filter: Git Clean' },
          ['[c'] = { api.node.navigate.git.prev, 'Prev Git' },
          [']c'] = { api.node.navigate.git.next, 'Next Git' },
          ['d'] = { api.fs.remove, 'Delete' },
          ['D'] = { api.fs.trash, 'Trash' },
          ['E'] = { api.tree.expand_all, 'Expand All' },
          ['e'] = { api.fs.rename_basename, 'Rename: Basename' },
          [']e'] = { api.node.navigate.diagnostics.next, 'Next Diagnostic' },
          ['[e'] = { api.node.navigate.diagnostics.prev, 'Prev Diagnostic' },
          ['F'] = { api.live_filter.clear, 'Live Filter: Clear' },
          ['f'] = { api.live_filter.start, 'Live Filter: Start' },
          ['gy'] = { api.fs.copy.absolute_path, 'Copy Absolute Path' },
          ['H'] = { api.tree.toggle_hidden_filter, 'Toggle Filter: Dotfiles' },
          ['I'] = { api.tree.toggle_gitignore_filter, 'Toggle Filter: Git Ignore' },
          ['J'] = { api.node.navigate.sibling.last, 'Last Sibling' },
          ['K'] = { api.node.navigate.sibling.first, 'First Sibling' },
          ['M'] = { api.tree.toggle_no_bookmark_filter, 'Toggle Filter: No Bookmark' },
          ['m'] = { api.marks.toggle, 'Toggle Bookmark' },
          ['o'] = { api.node.open.edit, 'Open' },
          ['O'] = { api.node.open.no_window_picker, 'Open: No Window Picker' },
          ['p'] = { api.fs.paste, 'Paste' },
          ['P'] = { api.node.navigate.parent, 'Parent Directory' },
          ['q'] = { api.tree.close, 'Close' },
          ['r'] = { api.fs.rename, 'Rename' },
          ['R'] = { api.tree.reload, 'Refresh' },
          ['s'] = { api.node.run.system, 'Run System' },
          ['S'] = { api.tree.search_node, 'Search' },
          ['u'] = { api.fs.rename_full, 'Rename: Full Path' },
          ['U'] = { api.tree.toggle_custom_filter, 'Toggle Filter: Hidden' },
          ['W'] = { api.tree.collapse_all, 'Collapse' },
          ['x'] = { api.fs.cut, 'Cut' },
          ['y'] = { api.fs.copy.filename, 'Copy Name' },
          ['Y'] = { api.fs.copy.relative_path, 'Copy Relative Path' },
          ['<2-LeftMouse>'] = { api.node.open.edit, 'Open' },
          ['<2-RightMouse>'] = { api.tree.change_root_to_node, 'CD' },
          ['?'] = { api.tree.toggle_help, 'Help' },
        }

        for lhs, value in pairs(mappings) do
          local rhs, description = value[1], value[2]
          vim.keymap.set('n', lhs, rhs, {
            desc = 'nvim-tree: ' .. description,
            buffer = buffer_number,
            noremap = true,
            silent = true,
            nowait = true,
          })
        end
      end,
      view = {
        side = 'right',
        centralize_selection = true,
        width = ENABLE_FLOATING_WINDOW and function()
          return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
        end or {
          min = 30,
          padding = 5,
        },
        float = {
          enable = ENABLE_FLOATING_WINDOW,
          open_win_config = function()
            local screen_w = vim.opt.columns:get()
            local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
            local window_w = screen_w * WIDTH_RATIO
            local window_h = screen_h * HEIGHT_RATIO
            local window_w_int = math.floor(window_w)
            local window_h_int = math.floor(window_h)
            local center_x = (screen_w - window_w) / 2
            local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
            return {
              border = 'rounded',
              relative = 'editor',
              row = center_y,
              col = center_x,
              width = window_w_int,
              height = window_h_int,
            }
          end,
        },
      },
      renderer = {
        root_folder_label = false,
        highlight_diagnostics = true,
      },
      filters = {
        dotfiles = true,
        custom = {},
      },
    }
  end,
}
