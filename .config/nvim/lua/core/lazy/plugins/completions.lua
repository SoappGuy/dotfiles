return { -- Autocompletion
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    {
      'L3MON4D3/LuaSnip',
      build = (function()
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        return 'make install_jsregexp'
      end)(),
      dependencies = {
        {
          'rafamadriz/friendly-snippets',
          config = function()
            require('luasnip.loaders.from_vscode').lazy_load()
          end,
        },
      },
    },
    'saadparwaiz1/cmp_luasnip',
    'onsails/lspkind.nvim',

    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    'hrsh7th/cmp-path',
    'f3fora/cmp-spell',

    {
      'MattiasMTS/cmp-dbee',
      dependencies = {
        { 'kndndrj/nvim-dbee' },
      },
      ft = 'sql', -- optional but good to have
      opts = {}, -- needed
    },

    {
      'Jezda1337/nvim-html-css',
      dependencies = {
        'nvim-treesitter/nvim-treesitter',
        'nvim-lua/plenary.nvim',
      },
      opt = {},
      option = {
        enable_on = {
          'html',
          'css',
          'gotmpl',
        },
        file_extensions = { 'css', 'sass', 'less', 'html', 'gotmpl' }, -- set the local filetypes from which you want to derive classes
        style_sheets = {
          -- example of remote styles, only css no js for now
          'https://cdn.jsdelivr.net/npm/beercss@3.7.10/dist/cdn/beer.min.css',
        },
      },
    },
  },
  config = function()
    -- See `:help cmp`
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    local lspkind = require 'lspkind'

    luasnip.config.setup {}

    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      completion = { completeopt = 'menu,menuone,noinsert' },

      mapping = cmp.mapping.preset.insert {
        -- ['<C-n>'] = cmp.mapping.select_next_item(),
        -- ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-j>'] = cmp.mapping.select_next_item(),
        ['<C-k>'] = cmp.mapping.select_prev_item(),

        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),

        -- ['<C-y>'] = cmp.mapping.confirm { select = true },
        ['<C-Space>'] = cmp.mapping.confirm { select = true },
        ['<C-S-Space>'] = cmp.mapping.complete {},
        ['<C-l>'] = cmp.mapping(function()
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          end
        end, { 'i', 's' }),
        ['<C-h>'] = cmp.mapping(function()
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          end
        end, { 'i', 's' }),
      },
      sources = {

        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'buffer' },
        { name = 'luasnip' },
        { name = 'html-css' },
        { name = 'cmp-dbee' },
        { name = 'path' },
        -- {
        --   name = 'spell',
        --   option = {
        --     keep_all_entries = false,
        --     enable_in_context = function()
        --       return true
        --     end,
        --     preselect_correct_word = true,
        --   },
        -- },
      },

      window = {
        completion = cmp.config.window.bordered {
          border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
          col_offset = -3,
          side_padding = 0,
        },
        documentation = cmp.config.window.bordered {
          border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
        },
      },
      formatting = {
        fields = { 'kind', 'abbr' },
        format = function(entry, vim_item)
          local kind = lspkind.cmp_format { mode = 'symbol', maxwidth = 50 }(entry, vim_item)

          if entry.source.name == 'html-css' then
            kind.menu = entry.completion_item.menu
          else
            kind.menu = ''
          end

          kind.kind = ' ' .. kind.kind .. ' '

          return kind
        end,
      },
    }
  end,
}
