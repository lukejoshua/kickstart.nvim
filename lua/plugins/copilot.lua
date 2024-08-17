return {
  "zbirenbaum/copilot.lua",
  enabled = false,
  dependencies = {
    "hrsh7th/nvim-cmp",
  },
  cmd = "Copilot",
  build = ":Copilot auth",
  event = "InsertEnter",
  config = function()
    require('copilot').setup({
      suggestion = {
        auto_trigger = true,
        keymap = {
          next = "<C-Space>",
          accept = "<M-CR>"

        }
      }
    })

    -- hide copilot suggestions when cmp menu is open
    -- to prevent odd behavior/garbled up suggestions
    local cmp_status_ok, cmp = pcall(require, "cmp")
    if cmp_status_ok then
      cmp.event:on("menu_opened", function()
        vim.b.copilot_suggestion_hidden = true
      end)

      cmp.event:on("menu_closed", function()
        vim.b.copilot_suggestion_hidden = false
      end)
    end
  end
  -- config = function()
  --   require("copilot").setup({
  --     panel = {
  --       enabled = true,
  --       auto_refresh = true,
  --     },
  --     suggestion = {
  --       -- enabled = true,
  --       auto_trigger = true,
  --       keymap = {
  --         accept = "<C-CR>",
  --         accept_word = false,
  --         accept_line = false,
  --         next = "<C-]>",
  --         prev = "<C-[>",
  --         dismiss = "<M-CR>",
  --       }
  --     },
  --   })
  --
  --   -- hide copilot suggestions when cmp menu is open
  --   -- to prevent odd behavior/garbled up suggestions
  --   local cmp_status_ok, cmp = pcall(require, "cmp")
  --   if cmp_status_ok then
  --     cmp.event:on("menu_opened", function()
  --       vim.b.copilot_suggestion_hidden = true
  --     end)
  --
  --     cmp.event:on("menu_closed", function()
  --       vim.b.copilot_suggestion_hidden = false
  --     end)
  --   end
  -- end,
}
