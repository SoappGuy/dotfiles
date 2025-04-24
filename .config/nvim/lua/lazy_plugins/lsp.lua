local M = {
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "LazyVim",            words = { "LazyVim" } },
      }
    }
  },
  {
    'neovim/nvim-lspconfig',
    lazy = true,
    event = 'BufReadPre',
    dependencies = {
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },
      { 'saghen/blink.cmp' },

      { 'nvim-java/nvim-java' },

      { 'j-hui/fidget.nvim',                opts = {} },
    },
    config = function()
      require('java').setup()

      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(event)
          local maps = {
            { '<leader>cr', vim.lsp.buf.rename,                                     'Rename' },
            { 'K',          function() vim.lsp.buf.hover { border = 'single' } end, 'Hover documentation' },
          }

          for _, map in ipairs(maps) do
            vim.keymap.set('n', map[1], map[2], { buffer = event.buf, desc = map[3] })
          end

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            vim.lsp.inlay_hint.enable(true)
          end
        end,
      })

      local servers = {
        taplo = {},
        intelephense = {
          root_dir = function(_, bufnr)
            return vim.fs.root(bufnr, { '.git' }) or vim.fn.expand '%:p:h'
          end,
        },
        jsonls = {},
        jdtls = {},
        gopls = {},
        clangd = {},
        tinymist = {
          settings = {
            formatterMode = 'typstyle',
            exportPdf = 'onType',
            outputPath = '$root/$dir/$name',
          },
          single_file_support = true,
          root_dir = function(_, bufnr)
            return vim.fs.root(bufnr, { '.git' }) or vim.fn.expand '%:p:h'
          end,
        },
        pyright = {},
        bashls = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
        cssls = {
          settings = {
            css = {
              validate = true,
              lint = {
                unknownAtRules = 'ignore',
              }
            },
            scss = {
              validate = true,
              lint = {
                unknownAtRules = 'ignore',
              }
            },
            less = {
              validate = true,
              lint = {
                unknownAtRules = 'ignore',
              }
            },
          },
        },
        emmet_language_server = {},
        hyprls = {},
        rust_analyzer = {},
      }

      require('mason').setup({
        registries = {
          'github:nvim-java/mason-registry',
          "github:mason-org/mason-registry",
        }
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities())

      require('mason-lspconfig').setup {
        ensure_installed = vim.tbl_keys(servers),
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,

          rust_analyzer = function() end,
          -- jdtls = function() end,
        },
      }
    end,
  } }

return M
