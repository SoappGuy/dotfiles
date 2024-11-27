vim.keymap.set('n', '<leader>cc', function()
  local filename = vim.api.nvim_buf_get_name(0)
  vim.print('Compiling ' .. filename)
  vim.fn.system("tectonic '" .. filename .. "'")
  vim.print 'Compilation finished'
end, { desc = 'Compile latex' })
