-- Diagnostic keymaps
vim.keymap.set(
  'n',
  '<leader>e',
  function()
    vim.diagnostic.config({ virtual_lines = { current_line = true }, virtual_text = false })

    vim.api.nvim_create_autocmd('CursorMoved', {
      group = vim.api.nvim_create_augroup('line-diagnostics', { clear = true }),
      callback = function()
        vim.diagnostic.config({ virtual_lines = false, virtual_text = true })
        return true
      end,
    })
  end,
  { desc = 'Show diagnostic [E]rror messages' }
)
vim.keymap.set('n', '<Leader>q', function()
  vim.diagnostic.setloclist { open = false }
  local winid = vim.fn.getloclist(0, { winid = 0 }).winid
  if winid == 0 then
    vim.cmd.lopen()
  else
    vim.cmd.lclose()
  end
end, { desc = 'Toggle diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Move between windows
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Duplicate a line and comment out the first line
vim.keymap.set('n', 'yc', function()
  vim.api.nvim_feedkeys('yygccp', 'm', false)
end)

-- Operations on current word
vim.keymap.set('n', '<C-c>', 'ciw')
vim.keymap.set('n', '<C-y>', 'yiw')

local toggles = {
  {
    keymap = '<leader>tv',
    callback = function()
      vim.diagnostic.config { virtual_lines = not vim.diagnostic.config().virtual_lines }
    end,
    opts = { desc = 'Toggle virtual diagnostic lines' },
  },

  {
    keymap = '<leader>tl',
    callback = function()
      if next(vim.opt.colorcolumn:get()) == nil then
        vim.opt.colorcolumn = { '81', '121' }
      else
        vim.opt.colorcolumn = ''
      end
    end,
    opts = { desc = 'Toggle limit lines' },
  },

  {
    keymap = '<leader>ts',
    callback = function()
      vim.opt.spell = not vim.opt.spell:get()
    end,
    opts = { desc = 'Toggle spell checking' },
  },

  {
    keymap = '<leader>th',
    callback = function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end,
    opts = { desc = 'Toggle inlay hints' },
  },

  {
    keymap = '<leader>tw',
    callback = function()
      vim.opt.wrap = not vim.opt.wrap:get()
    end,
    opts = { desc = 'Toggle text wrap' },
  },
}

for _, toggle in ipairs(toggles) do
  vim.keymap.set('n', toggle.keymap, toggle.callback, toggle.opts)
end
