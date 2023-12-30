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

          -- Open
          ['<CR>'] = { api.node.open.edit, 'Open' },
          ['<2-LeftMouse>'] = { api.node.open.edit, 'Open' },
          ['<C-\\>'] = { api.node.open.vertical, 'Open: Vertical Split' },
          ['O'] = { api.node.open.no_window_picker, 'Open: No Window Picker' },
          ['<Tab>'] = { api.node.open.preview, 'Open: Preview' },

          -- Filters
          ['B'] = { api.tree.toggle_no_buffer_filter, 'Toggle Filter: No Buffer' },
          ['H'] = { api.tree.toggle_hidden_filter, 'Toggle Filter: Dotfiles' },
          ['I'] = { api.tree.toggle_gitignore_filter, 'Toggle Filter: Git Ignore' },
          ['U'] = { api.tree.toggle_custom_filter, 'Toggle Custom Filter' },

          -- Live Filter
          ['F'] = { api.live_filter.clear, 'Live Filter: Clear' },
          ['f'] = { api.live_filter.start, 'Live Filter: Start' },

          -- FS operations
          ['a'] = { api.fs.create, 'Fs: Create File Or Directory' },
          ['d'] = { api.fs.remove, 'Fs: Delete' },
          ['p'] = { api.fs.paste, 'Fs: Paste' },
          ['x'] = { api.fs.cut, 'Fs: Cut' },
          ['c'] = { api.fs.copy.node, 'Fs: Copy' },
          ['gy'] = { api.fs.copy.absolute_path, 'Fs: Copy Absolute Path' },
          ['y'] = { api.fs.copy.filename, 'Fs: Copy Name' },
          ['Y'] = { api.fs.copy.relative_path, 'Fs: Copy Relative Path' },

          -- Renaming
          ['r'] = { api.fs.rename, 'Rename' },
          ['u'] = { api.fs.rename_full, 'Rename: Full Path' },
          ['e'] = { api.fs.rename_basename, 'Rename: Basename' },
          ['<C-r>'] = { api.fs.rename_sub, 'Rename: Omit Filename' },

          -- Navigation
          [']d'] = { api.node.navigate.diagnostics.next, 'Nav: Next Diagnostic' },
          ['[d'] = { api.node.navigate.diagnostics.prev, 'Nav: Prev Diagnostic' },
          ['<C-D>'] = { api.node.navigate.sibling.last, 'Nav: Last Sibling' },
          ['<C-U>'] = { api.node.navigate.sibling.first, 'Nav: First Sibling' },
          ['P'] = { api.node.navigate.parent, 'Nav: Parent Directory' },
          ['<BS>'] = { api.node.navigate.parent_close, 'Nav: Close Directory' },
          ['E'] = { api.tree.expand_all, 'Nav: Expand All' },
          ['W'] = { api.tree.collapse_all, 'Nav: Collapse' },

          -- MISC
          ['.'] = { api.node.run.cmd, 'Misc: Run Command' },
          ['S'] = { api.tree.search_node, 'Misc: Search' },
          ['K'] = { api.node.show_info_popup, 'Misc: Info' },
          ['R'] = { api.tree.reload, 'Misc: Refresh' },
          ['q'] = { api.tree.close, 'Misc: Close' },
          ['?'] = { api.tree.toggle_help, 'Misc: Help' },

          -- ['<2-RightMouse>'] = { api.tree.change_root_to_node, 'CD' },
          -- ['M'] = { api.tree.toggle_no_bookmark_filter, 'Toggle Filter: No Bookmark' },
          -- ['m'] = { api.marks.toggle, 'Toggle Bookmark' },
          -- ['s'] = { api.node.run.system, 'Run System' },
          -- ['<C-]>'] = { api.tree.change_root_to_node, 'CD' },
          -- ['<C-e>'] = { api.node.open.replace_tree_buffer, 'Open: In Place' },
          -- ['<C-t>'] = { api.node.open.tab, 'Open: New Tab' },
          -- ['<C-->'] = { api.node.open.horizontal, 'Open: Horizontal Split' },
          -- ['>'] = { api.node.navigate.sibling.next, 'Next Sibling' },
          -- ['<'] = { api.node.navigate.sibling.prev, 'Previous Sibling' },
          -- ['-'] = { api.tree.change_root_to_parent, 'Up' },
          -- ['bd'] = { api.marks.bulk.delete, 'Delete Bookmarked' },
          -- ['bt'] = { api.marks.bulk.trash, 'Trash Bookmarked' },
          -- ['bmv'] = { api.marks.bulk.move, 'Move Bookmarked' },
          -- ['C'] = { api.tree.toggle_git_clean_filter, 'Toggle Filter: Git Clean' },
          -- ['[c'] = { api.node.navigate.git.prev, 'Prev Git' },
          -- [']c'] = { api.node.navigate.git.next, 'Next Git' },
          -- ['D'] = { api.fs.trash, 'Trash' },
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
      help = {
        sort_by = 'desc',
      },
    }
  end,
}
