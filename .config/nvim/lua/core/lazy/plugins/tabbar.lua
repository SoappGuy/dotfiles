return {
  'romgrk/barbar.nvim',
  lazy = true,
  event = 'VeryLazy',
  version = '^1.0.0', -- optional: only update when a new 1.x version is released
  dependencies = {
    'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
    'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
  },
  init = function()
    vim.g.barbar_auto_setup = false
  end,
  opts = {
    -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
    sidebar_filetypes = {
      ['neo-tree'] = { event = 'BufWipeout' },
      -- Outline = { event = 'BufWinLeave', text = 'symbols-outline', align = 'right' },
    },
    icons = {
      separator = { left = '󰇙', right = '󰇙' },
      separator_at_end = true,

      diagnostics = {
        [vim.diagnostic.severity.ERROR] = { enabled = true, icon = ' ' },
        [vim.diagnostic.severity.WARN] = { enabled = true, icon = ' ' },
        [vim.diagnostic.severity.INFO] = { enabled = false },
        [vim.diagnostic.severity.HINT] = { enabled = true },
      },
    },

    maximum_padding = 1,
    minimum_padding = 1,
  },
}
