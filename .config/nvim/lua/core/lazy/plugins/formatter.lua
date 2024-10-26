return { -- Autoformat
  'stevearc/conform.nvim',
  lazy = false,
  config = function()
    local conform = require 'conform'
    conform.setup {
      notify_on_error = true,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = false, cpp = false }
        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'isort', 'black' },
        sql = { 'sql_formatter' },
        -- rust = { 'rustfmt' },
      },
    }

    conform.formatters.sql_formatter = {
      prepend_args = {
        '-c',
        '{ "language": "mysql", "tabWidth": 4, "keywordCase": "upper", "linesBetweenQueries": 2}',
      },
    }
  end,
}
