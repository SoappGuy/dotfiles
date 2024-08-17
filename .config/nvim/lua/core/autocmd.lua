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

local view_group = vim.api.nvim_create_augroup('auto_view', { clear = true })

vim.api.nvim_create_autocmd({ 'BufWinLeave', 'BufWritePost', 'WinLeave' }, {
  desc = 'Save view with mkview for real files',
  group = view_group,
  callback = function(args)
    if vim.b[args.buf].view_activated then
      vim.cmd.mkview { mods = { emsg_silent = true } }
    end
  end,
})

vim.api.nvim_create_autocmd('BufWinEnter', {
  desc = 'Try to load file view if available and enable view saving for real files',
  group = view_group,
  callback = function(args)
    if not vim.b[args.buf].view_activated then
      local filetype = vim.api.nvim_get_option_value('filetype', { buf = args.buf })
      local buftype = vim.api.nvim_get_option_value('buftype', { buf = args.buf })
      local ignore_filetypes = { 'gitcommit', 'gitrebase', 'svg', 'hgcommit' }
      if buftype == '' and filetype and filetype ~= '' and not vim.tbl_contains(ignore_filetypes, filetype) then
        vim.b[args.buf].view_activated = true
        vim.cmd.loadview { mods = { emsg_silent = true } }
      end
    end
  end,
})
