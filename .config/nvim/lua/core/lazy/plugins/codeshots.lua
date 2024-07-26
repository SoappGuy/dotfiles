return {
  'michaelrommel/nvim-silicon',
  lazy = true,
  cmd = 'Silicon',
  config = function()
    require('nvim-silicon').setup {
      font = 'JetBrainsMono Nerd Font=34',
      theme = 'Dracula',
      background = '#999999',
      -- background = '#94e295',
      to_clipboard = true,
      window_title = function()
        return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), ':t')
      end,
    }
  end,
}
