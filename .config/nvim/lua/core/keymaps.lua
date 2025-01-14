-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<Leader>q', function()
  vim.diagnostic.setloclist { open = false }
  local winid = vim.fn.getloclist(0, { winid = 0 }).winid
  if winid == 0 then
    vim.cmd.lopen()
  else
    vim.cmd.lclose()
  end
end, { desc = 'Toggle diagnostic [Q]uickfix list' })

-- Save buffer
vim.keymap.set('n', '<C-s>', function()
  vim.api.nvim_command 'write'
end, { desc = 'Save buffer' })

-- Exit terminal mode in the builtin terminal
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

--  TODO: See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.api.nvim_create_user_command('DapSetBreakpoint', function()
  if not package.loaded['dap'] then
    require('lazy').load { plugins = { 'nvim-dap' } }
  end
  require('dap').toggle_breakpoint()
end, {})
vim.keymap.set('n', '<leader>db', ':DapSetBreakpoint<CR>', { silent = true })

-- Duplicate a line and comment out the first line
vim.keymap.set('n', 'yc', function()
  vim.api.nvim_feedkeys('yygccp', 'm', false)
end)

-- Operations on current word
vim.keymap.set('n', '<C-c>', 'ciw')
vim.keymap.set('n', '<C-y>', 'yiw')

-- Toggles
-- Toggle line numbers
vim.keymap.set('n', '<leader>tl', function()
  if next(vim.opt.colorcolumn:get()) == nil then
    vim.opt.colorcolumn = { '81', '121' }
  else
    vim.opt.colorcolumn = ''
  end
end, { desc = 'Toggle limit lines' })

-- Toggle text wrap
vim.keymap.set('n', '<leader>tw', function()
  vim.opt.wrap = not vim.opt.wrap:get()
end, { desc = 'Toggle text wrap' })
