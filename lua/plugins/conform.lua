-- TODO: no hardcoding - it should be driven by config files
return {
  'stevearc/conform.nvim',
  event = 'BufEnter',
  opts = {
    formatters_by_ft = {
      ['javascript'] = { 'prettierd' },
      ['javascriptreact'] = { 'prettierd' },
      -- ['typescript'] = { 'prettierd' },
      ['typescriptreact'] = { 'prettierd' },
      ['vue'] = { 'prettierd' },
      ['css'] = { 'prettierd' },
      ['scss'] = { 'prettierd' },
      ['less'] = { 'prettierd' },
      ['html'] = { 'prettierd' },
      ['json'] = { 'prettierd' },
      ['jsonc'] = { 'prettierd' },
      ['yaml'] = { 'prettierd' },
      ['markdown'] = { 'prettierd' },
      ['markdown.mdx'] = { 'prettierd' },
      ['graphql'] = { 'prettierd' },
      ['handlebars'] = { 'prettierd' },
    },
    format_on_save = {
      lsp_fallback = true,
      timeout_ms = 500,
    },
  },
}
