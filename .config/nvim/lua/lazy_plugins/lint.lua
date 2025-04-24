return {
  'mfussenegger/nvim-lint',
  event = 'BufEnter',
  config = function()
    local lint = require 'lint'
    lint.linters_by_ft = {
      json = { 'jsonlint' },
      -- text = { 'vale' },
      -- c = { 'cpplint' },
      -- python = { 'ruff' },
    }

    local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      group = lint_augroup,
      callback = function()
        require('lint').try_lint()
      end,
    })
  end,
}
