return {
  'folke/todo-comments.nvim',
  event = 'VimEnter',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {},
  keys = {
    { '<leader>bl', '<cmd>TodoTelescope<cr>', desc = 'Todo' },
  },
}
