return {
  -- LSP Configuration & Plugins
  'neovim/nvim-lspconfig',
  lazy = false, -- TODO: temp
  dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    { 'williamboman/mason.nvim', config = true },
    'williamboman/mason-lspconfig.nvim',

    -- Useful status updates for LSP
    -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
    { 'j-hui/fidget.nvim',       opts = {} },

    -- Additional lua configuration, makes nvim stuff amazing!
    'folke/neodev.nvim',
    'davidosomething/format-ts-errors.nvim',
  },
  init = function()
    -- on-lspconfig requires that these setup functions are called in this order
    -- before setting up the servers.
    require('mason').setup()
    require('mason-lspconfig').setup()

    -- Setup neovim lua configuration
    require('neodev').setup()

    -- Enable the following language servers
    --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
    --
    --  Add any additional override configuration in the following tables. They will be passed to
    --  the `settings` field of the server config. You must look up that documentation yourself.
    --
    --  If you want to override the default filetypes that your language server will attach to you can
    --  define the property 'filetypes' to the map in question.
    local servers = {
      -- clangd = {},
      -- gopls = {},
      -- pyright = {},
      -- rust_analyzer = {},
      -- html = { filetypes = { 'html', 'twig', 'hbs'} },

      -- tsserver = {},
      angularls = {
        filetypes = { 'html', 'typescript' }
      },
      jsonls = {},
      -- eslint = {},
      volar = {
        filetypes = { 'vue' }

      },

      lua_ls = {
        Lua = {
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
          -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
          -- diagnostics = { disable = { 'missing-fields' } },
        },
      },

    }

    -- nvim-cmp supports additional completion capabilities, so broadcast that to servers

    -- Ensure the servers above are installed
    local mason_lspconfig = require 'mason-lspconfig'

    mason_lspconfig.setup {
      ensure_installed = vim.tbl_keys(servers),
    }

    require('lspconfig').gleam.setup({})

    mason_lspconfig.setup_handlers {
      function(server_name)
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true
        }
        require('lspconfig')[server_name].setup {
          capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities),

          --  This function gets run when an LSP connects to a particular buffer.
          on_attach = function(_, bufnr)
            local nmap = function(keys, func, desc)
              if desc then
                desc = 'LSP: ' .. desc
              end

              vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
            end

            nmap('<leader>cr', function()
              -- Prevent double prompts from angularls and tsserver
              local is_angularls_attached = #(vim.lsp.get_active_clients { name = 'angularls', bufnr = 0 }) > 0
              local is_tsserver_attached = #(vim.lsp.get_active_clients { name = 'tsserver', bufnr = 0 }) > 0

              if is_angularls_attached and is_tsserver_attached then
                vim.lsp.buf.rename(nil, { name = 'angularls' })
                return
              else
                vim.lsp.buf.rename()
              end
            end, '[R]e[n]ame')
            nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

            -- Typescript imports
            if server_name == 'ts_ls' then
              nmap('<leader>co', function()
                print 'organizeImports'
                vim.lsp.buf.code_action {
                  apply = true,
                  context = {
                    only = { 'source.organizeImports', 'source' },
                    diagnostics = {},
                  },
                }
              end, 'Organize Imports')
              nmap('<leader>cR', function()
                vim.lsp.buf.code_action {
                  apply = true,
                  context = {
                    only = { 'source.fixAll' },
                    diagnostics = {},
                  },
                }
              end, 'Fix All')
            end

            nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
            nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
            nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
            nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
            nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
            nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

            -- See `:help K` for why this keymap
            nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
            nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

            -- Lesser used LSP functionality
            nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
            nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
            nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
            nmap('<leader>wl', function()
              print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, '[W]orkspace [L]ist Folders')

            -- Create a command `:Format` local to the LSP buffer
            vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
              vim.lsp.buf.format()
            end, { desc = 'Format current buffer with LSP' })
          end,

          settings = servers[server_name],
          filetypes = (servers[server_name] or {}).filetypes,
          -- setup typescript prettier errors
          handlers = server_name == 'tsserver'
              and {
                ['textDocument/publishDiagnostics'] = function(_, result, ctx, config)
                  if result.diagnostics == nil then
                    return
                  end

                  -- ignore some tsserver diagnostics
                  local idx = 1
                  while idx <= #result.diagnostics do
                    local entry = result.diagnostics[idx]

                    local formatter = require('format-ts-errors')[entry.code]
                    entry.message = formatter and formatter(entry.message) or entry.message

                    -- codes: https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
                    if entry.code == 80001 then
                      -- { message = "File is a CommonJS module; it may be converted to an ES module.", }
                      table.remove(result.diagnostics, idx)
                    else
                      idx = idx + 1
                    end
                  end

                  vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
                end,
              }
              or nil,
        }
      end,
    }
  end,
  -- autoformating
  -- TODO: remove this?
  config = function()
    -- Use :AutoFormatToggle to toggle autoformatting on or off
    local format_is_enabled = true
    vim.api.nvim_create_user_command('AutoFormatToggle', function()
      format_is_enabled = not format_is_enabled
      print('Setting autoformatting to: ' .. tostring(format_is_enabled))
    end, {})

    -- Create an augroup that is used for managing our formatting autocmds.
    --      We need one augroup per client to make sure that multiple clients
    --      can attach to the same buffer without interfering with each other.
    local _augroups = {}
    local get_augroup = function(client)
      if not _augroups[client.id] then
        local group_name = 'lsp-autoformat-' .. client.name
        local id = vim.api.nvim_create_augroup(group_name, { clear = true })
        _augroups[client.id] = id
      end

      return _augroups[client.id]
    end

    -- Whenever an LSP attaches to a buffer, we will run this function.
    --
    -- See `:help LspAttach` for more information about this autocmd event.
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('lsp-attach-autoformat', { clear = true }),
      -- This is where we attach the autoformatting for reasonable clients
      callback = function(args)
        local client_id = args.data.client_id
        local client = vim.lsp.get_client_by_id(client_id)
        local bufnr = args.buf

        -- Only attach to clients that support document formatting
        if not client.server_capabilities.documentFormattingProvider then
          return
        end

        -- Tsserver usually works poorly. Sorry you work with bad languages
        -- You can remove this line if you know what you're doing :)
        if client.name == 'tsserver' then
          return
        end

        -- Create an autocmd that will run *before* we save the buffer.
        --  Run the formatting command for the LSP that has just attached.
        vim.api.nvim_create_autocmd('BufWritePre', {
          group = get_augroup(client),
          buffer = bufnr,
          callback = function()
            if not format_is_enabled then
              return
            end

            vim.lsp.buf.format {
              async = false,
              filter = function(c)
                return c.id == client.id
              end,
            }
          end,
        })
      end,
    })
  end,
}
