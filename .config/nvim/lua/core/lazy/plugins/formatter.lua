return {
  'stevearc/conform.nvim',
  lazy = false,
  config = function()
    local conform = require 'conform'
    conform.setup {
      notify_on_error = true,
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end

        local disable_filetypes = { c = false, cpp = false, sql = true }

        return { timeout_ms = 500, lsp_format = not disable_filetypes[vim.bo[bufnr].filetype] }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'isort', 'black' },
        rust = { 'rustfmt' },
        -- sql = { 'sql_formatter' },
      },
    }

    conform.formatters.sql_formatter = {
      prepend_args = {
        '-c',
        '{ "language": "mysql", "tabWidth": 4, "keywordCase": "upper", "linesBetweenQueries": 2}',
      },
    }

    vim.keymap.set('', '<leader>f', function()
      require('conform').format({ async = true }, function(err)
        if not err then
          local mode = vim.api.nvim_get_mode().mode
          if vim.startswith(string.lower(mode), 'v') then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
          end
        end
      end)
    end, { desc = 'Format selection' })
  end,
}
