-- Highlight when yanking text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd('TermOpen', {
  desc = 'Turn off spelchek in terminal',
  group = vim.api.nvim_create_augroup('spellchesk-term', { clear = true }),
  callback = function()
    vim.opt.spell = false
  end,
})

vim.api.nvim_create_autocmd('TermClose', {
  desc = 'Turn off spelchek in terminal',
  group = vim.api.nvim_create_augroup('spellchesk-term', { clear = true }),
  callback = function()
    vim.opt.spell = true
  end,
})
