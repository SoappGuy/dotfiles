return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    input = { enabled = true },
    indent = {
      animate = {
        enabled = vim.fn.has 'nvim-0.10' == 1,
        style = 'out',
        easing = 'linear',
        duration = {
          step = 20,
          total = 200,
        },
      },
      scope = {
        enabled = true,
        priority = 200,
        char = '│',
        underline = true,
        only_current = false,
        hl = {
          'SnacksIndent1',
          'SnacksIndent2',
          'SnacksIndent3',
          'SnacksIndent4',
          'SnacksIndent5',
          'SnacksIndent6',
          'SnacksIndent7',
          'SnacksIndent8',
        },
      },
      filter = function(buf)
        return vim.g.snacks_indent ~= false and vim.b[buf].snacks_indent ~= false and vim.bo[buf].buftype == ''
      end,
    },
    statuscolumn = {
      enabled = true,
      left = { 'mark', 'sign' },
      right = { 'fold' },
      folds = {
        open = true,
        git_hl = true,
      },
      refresh = 50,
    },
  },
}
