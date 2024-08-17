function substringAfter(str, searchTerm)
  -- Find the starting position of the search term within the string
  local startPos = string.find(str, searchTerm)

  -- If the search term is not found, return an empty string
  if not startPos then
    return ""
  end

  -- Calculate the ending position by adding the length of the search term
  local endPos = startPos + string.len(searchTerm)

  -- Extract and return the substring after the search term using string.sub
  return string.sub(str, endPos)
end

return {
  -- Set lualine as statusline
  'nvim-lualine/lualine.nvim',
  -- See `:help lualine.txt`
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    options = {
      icons_enabled = true,
      theme = 'tokyonight',
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      globalstatus = true,
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch' },
      lualine_c = {
        {
          'filename',
          fmt = function(str)
            local path = vim.api.nvim_buf_get_name(0)
            local basename = vim.fs.basename(path)

            if basename:sub(1, 1) ~= '+' then
              return str
            end

            local dirname = vim.fs.dirname(path)
            local route = substringAfter(dirname, 'routes')

            return basename .. " for " .. (route == "" and "/" or route)
          end
        }

      },
      lualine_x = { 'filetype' },
      lualine_y = { 'diagnostics' },
      lualine_z = {
        {
          'location',
          fmt = function(str)
            -- Remove the column
            return 'Line ' .. string.gsub(str, '%:.+$', '')
          end,
        },
        {
          'location',
          fmt = function(str)
            -- Remove the line
            return 'Column ' .. string.gsub(str, '^.+%:', '')
          end,
        },
      },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { 'filename' },
      lualine_x = { 'location' },
      lualine_y = {},
      lualine_z = {},
    },
  },
}
