-- TODO: fix the display of the folded line
-- e.g. '#imports' instead of 'import { ... }'
vim.api.nvim_create_autocmd('BufEnter', {
  desc = [[
    Create a fold from the start of the first import to the end of the last import
  ]],
  callback = function()
    local parser = vim.treesitter.get_parser(0)
    local tree = parser:parse()[1]

    local imports_start
    local imports_end

    for node in tree:root():iter_children() do
      if node:type() == 'import_statement' then
        if not imports_start then
          imports_start = node:start()
        end

        imports_end = node:end_()
      end
    end

    if imports_start and imports_end then
      vim.cmd(imports_start .. ',' .. imports_end .. 'fold')
    end
  end,
  -- TODO: group
  pattern = { '*.ts' },
})
