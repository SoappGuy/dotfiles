local hl_name_list = {
  'GruberDarkerRed',
  'GruberDarkerYellow',
  'GruberDarkerGreen',
  'GruberDarkerNiagara',
}

return {
  {
    'https://gitlab.com/HiPhish/rainbow-delimiters.nvim',
    config = function()
      local rainbow_delimiters = require 'rainbow-delimiters'

      vim.g.rainbow_delimiters = {
        strategy = {
          [''] = rainbow_delimiters.strategy['global'],
          vim = rainbow_delimiters.strategy['local'],
        },
        query = {
          [''] = 'rainbow-delimiters',
        },
        highlight = hl_name_list,
      }
    end,
  },
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    config = function()
      require('ibl').setup {
        scope = {
          enabled = true,
          show_start = true,
          show_end = true,
          highlight = hl_name_list,
        },
      }
      local hooks = require 'ibl.hooks'
      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end,
  },
}
