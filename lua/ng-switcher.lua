-- TODO: use a telescope picker and previewer instead of dressing UI
local function get_prefix(s)
  local index = string.find(s, '.', 1, true)
  return index and string.sub(s, 1, index - 1) or ''
end

local function has_prefix(s, prefix)
  return string.find(s, prefix .. '.', 1, true) == 1
end

vim.keymap.set('n', '<leader>cd', function()
  print 'file switcher activated'

  local current_file = vim.api.nvim_buf_get_name(0)
  local dir = vim.fs.dirname(current_file)
  local basename = vim.fs.basename(current_file)
  local prefix = get_prefix(basename)

  local items = {}
  for name, type in vim.fs.dir(dir) do
    if has_prefix(name, prefix) and name ~= basename and type == 'file' then
      table.insert(items, name)
    end
  end

  -- TODO: ordering

  return vim.ui.select(items, {
    prompt = 'Select file: (' .. prefix .. ')',
    format_item = function(item)
      if not has_prefix(item, prefix) then
        return item
      end

      return string.sub(item, #prefix + 2)
    end,
    kind = 'ngswitch',
  }, function(item, index)
    if item == nil then
      return
    end

    vim.cmd('e ' .. dir .. '/' .. item)
  end)
end, {
  desc = 'File Switcher',
})
