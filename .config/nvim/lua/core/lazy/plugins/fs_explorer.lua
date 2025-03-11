local permission_hlgroups = {
  ['-'] = 'NonText',
  ['r'] = 'DiagnosticWarn',
  ['w'] = 'DiagnosticError',
  ['x'] = 'DiagnosticOk',
}

local M = {
  'stevearc/oil.nvim',
  cmd = 'Oil',
  lazy = false,
  keys = {
    {
      '\\',
      function()
        local oil = require 'oil'

        if vim.w.is_oil_win then
          oil.close()
        else
          oil.open_float(nil, { preview = {} })
        end
      end,

      { desc = 'Oil toggle' },
    },
  },

  --- @module 'oil'
  --- @type oil.Config
  opts = {
    default_file_explorer = true,
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
    lsp_file_methods = {
      autosave_changes = 'unmodified',
    },

    constrain_cursor = 'name',
    watch_for_changes = true,
    columns = {
      {
        'permissions',
        highlight = function(permission_str)
          local hls = {}
          for i = 1, #permission_str do
            local char = permission_str:sub(i, i)
            table.insert(hls, { permission_hlgroups[char], i - 1, i })
          end
          return hls
        end,
      },
      { 'size', highlight = 'Special' },
      { 'mtime', highlight = 'Number' },
      { 'icon' },
    },
    float = {
      padding = 4,
      max_width = 0.75,
      winblend = 10,
    },
    keymaps = {
      ['g?'] = { 'actions.show_help', mode = 'n' },
      ['<CR>'] = 'actions.select',
      ['<C-s>'] = { 'actions.select', opts = { vertical = true } },
      ['<C-h>'] = { 'actions.select', opts = { horizontal = true } },
      ['<C-t>'] = { 'actions.select', opts = { tab = true } },
      ['<C-p>'] = 'actions.preview',
      ['<C-c>'] = { 'actions.close', mode = 'n' },
      ['q'] = { 'actions.close', mode = 'n' },
      ['<C-l>'] = 'actions.refresh',
      ['-'] = { 'actions.parent', mode = 'n' },
      ['_'] = { 'actions.open_cwd', mode = 'n' },
      ['`'] = { 'actions.cd', mode = 'n' },
      ['~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
      ['gs'] = { 'actions.change_sort', mode = 'n' },
      ['gx'] = 'actions.open_external',
      ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
      ['g\\'] = { 'actions.toggle_trash', mode = 'n' },
      ['gq'] = { 'actions.send_to_qflist', opts = {}, mode = 'n' },
    },
  },
}

return M
