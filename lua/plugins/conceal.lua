return {
  enabled = false,
  "Jxstxs/conceal.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  events = "VeryLazy",
  config = function()
    local conceal = require('conceal')
    conceal.setup {
      enabled = true,
      ['typescript'] = {
        enabled = true,
        keywords = {
          ["readonly"] = {
            enabled = true,
            conceal = "r",
          },
          ["const"] = {
            enabled = true,
            conceal = 'c'
          },

          ["function"] = {
            enabled = true,
            conceal = "λ"
          }

        }
      }
    }
    --[[ ["language"] = {
        enabled = bool,
        keywords = {
          ["keyword"] = {
              enabled     = bool,
              conceal     = string,
              highlight   = string
          }
        }
    } ]]
  end
}
