return {
  'folke/todo-comments.nvim',
  event = 'VimEnter',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {
    highlight = {
      comments_only = true,
    },
  },
  keys = {
    { '<leader>tb', '<cmd>TodoTelescope<cr>', desc = 'Todo' },
  },
}
