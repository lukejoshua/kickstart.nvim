-- TODO: use a telescope picker and previewer instead of dressing UI
local function get_prefix(s)
  local index = string.find(s, '.', 1, true)
  return index and string.sub(s, 1, index - 1) or ''
end

local function has_prefix(s, prefix)
  return string.find(s, prefix .. '.', 1, true) == 1
end

local function angularFileSwitcher(current_file)
  local dir = vim.fs.dirname(current_file)
  local basename = vim.fs.basename(current_file)
  local prefix = get_prefix(basename)

  local items = {}
  for name, type in vim.fs.dir(dir) do
    if has_prefix(name, prefix) and name ~= basename and type == 'file' then
      table.insert(items, name)
    end
  end

  local defaults = {
    "component.ts",
    "component.html",
    "analytics.ts",
    "component.scss",
  }

  local function index(xs, x)
    for index, value in ipairs(xs) do
      if value == x then return index end
    end

    return nil
  end

  -- TODO: ordering
  table.sort(items, function(a, b)
    local aHasPrefix = has_prefix(a, prefix)
    local bHasPrefix = has_prefix(b, prefix)

    if aHasPrefix and bHasPrefix then
      local indexA = index(defaults, string.sub(a, #prefix + 2))
      local indexB = index(defaults, string.sub(b, #prefix + 2))

      if indexA == nil and indexB == nil then
        return a < b
      end

      if indexA ~= nil and indexB ~= nil then
        return indexA < indexB
      end

      if indexA == nil then
        return false
      end

      if indexB == nil then
        return true
      end

      return a < b
    elseif aHasPrefix then
      return true
    elseif bHasPrefix then
      return false
    else
      return a < b
    end
  end)

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
end


local function svelteFileSwitcher(current_file)
  local dir = vim.fs.dirname(current_file)
  local basename = vim.fs.basename(current_file)

  local endPos = string.find(dir, "routes") + string.len("routes")
  local route = string.sub(dir, endPos)

  local items = {}
  for name, type in vim.fs.dir(dir) do
    if name ~= basename and type == 'file' then
      table.insert(items, name)
    end
  end

  local defaults = {
    "+page.svelte",
    "+page.ts",
    "+page.server.ts",
    "+layout.svelte",
    "+layout.ts",
    "+layout.server.ts",
    "+server.ts",
    "+error.svelte",
  }

  local function index(xs, x)
    for index, value in ipairs(xs) do
      if value == x then return index end
    end

    return nil
  end

  -- TODO: ordering
  table.sort(items, function(a, b)
    local indexA = index(defaults, a)
    local indexB = index(defaults, b)

    if indexA == nil and indexB == nil then
      return a < b
    end

    if indexA ~= nil and indexB ~= nil then
      return indexA < indexB
    end

    if indexA == nil then
      return false
    end

    if indexB == nil then
      return true
    end

    return a < b
  end)

  return vim.ui.select(items, {
    prompt = 'Select file: ' .. (route == "" and "/" or route),
    kind = 'ngswitch',
  }, function(item, index)
    if item == nil then
      return
    end

    vim.cmd('e ' .. dir .. '/' .. item)
  end)
end


vim.keymap.set('n', '<leader>cd', function()
  local current_file = vim.api.nvim_buf_get_name(0)
  local basename = vim.fs.basename(current_file)
  if basename:sub(1, 1) == '+' then
    print 'svelte file switcher activated'
    svelteFileSwitcher(current_file)
  else
    print 'ng file switcher activated'
    angularFileSwitcher(current_file)
  end
end, {
  desc = 'File Switcher',
})
