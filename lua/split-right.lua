vim.api.nvim_create_autocmd('Filetype', {
  pattern = "help",
  desc = [[ Open new splits to the right. ]],
  command = 'wincmd L'
})
