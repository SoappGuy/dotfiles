local M = {
  'saghen/blink.cmp',
  version = '*',

  event = 'BufReadPre',

  dependencies = {
    'echasnovski/mini.snippets',
    'mini.snippets',
  },

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = 'default',

      ['<C-p>'] = { 'select_prev', 'fallback' },
      ['<C-n>'] = { 'select_next', 'fallback' },

      ['<S-A-k>'] = { 'scroll_documentation_up', 'fallback' },
      ['<S-A-j>'] = { 'scroll_documentation_down', 'fallback' },

      ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<C-e>'] = { 'hide', 'fallback' },
    },

    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = 'mono',
    },

    snippets = { preset = 'mini_snippets' },

    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },

      providers = {
        lsp = { score_offset = 100 },
        snippets = {
          name = 'snippets',
          enabled = true,
          max_items = 15,
          min_keyword_length = 3,
          module = 'blink.cmp.sources.snippets',
          score_offset = 85,
        },
        path = {
          name = 'Path',
          module = 'blink.cmp.sources.path',
          score_offset = 25,
          fallbacks = { 'snippets', 'buffer' },
          opts = {
            trailing_slash = false,
            label_trailing_slash = true,
            get_cwd = function(context)
              return vim.fn.expand(('#%d:p:h'):format(context.bufnr))
            end,
            show_hidden_files_by_default = true,
          },
        },
        buffer = {
          name = 'Buffer',
          enabled = true,
          max_items = 3,
          module = 'blink.cmp.sources.buffer',
          min_keyword_length = 4,
          score_offset = 15,
        },
      },
    },

    completion = {
      menu = { border = 'single' },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 0,
        window = { border = 'single' },
      },
    },
    signature = {
      enabled = true,
      window = { border = 'single' },
    },

    fuzzy = { implementation = 'prefer_rust_with_warning' },
  },
  opts_extend = { 'sources.default' },
}

return M
