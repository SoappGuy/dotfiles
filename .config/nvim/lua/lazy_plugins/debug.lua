local M = {
  'mfussenegger/nvim-dap',
  dependencies = {
    'igorlfs/nvim-dap-view',
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    'leoluz/nvim-dap-go',
    { 'mfussenegger/nvim-dap-python', lazy = true },
  },
  commands = {
    'DapContinue',
    'DapToggleBreakpoint',
    'DapStepInto',
    'DapStepOver',
    'DapStepOut',
    'DapViewToggle',
  },
  keys = {
    { '<leader>dc', ":DapContinue<CR>",         desc = 'Debug: Start/Continue' },
    { '<leader>db', ":DapToggleBreakpoint<CR>", desc = 'Debug: Toggle Breakpoint' },
    { '<F1>',       ":DapStepInto<CR>",         desc = 'Debug: Step Into' },
    { '<leader>di', ":DapStepInto<CR>",         desc = 'Debug: Step Into (F1)' },
    { '<F2>',       ":DapStepOver<CR>",         desc = 'Debug: Step Over' },
    { '<leader>do', ":DapStepOver<CR>",         desc = 'Debug: Step Over (F2)' },
    { '<F3>',       ":DapStepOut<CR>",          desc = 'Debug: Step Out' },
    { '<leader>dt', ":DapStepOut<CR>",          desc = 'Debug: Step Out (F3)' },
    { '<leader>du', ':DapViewToggle<CR>',       desc = 'Debug: Toggle UI' },
  },
  config = function()
    local signs = {
      { 'DapBreakpoint', '', 'DiagnosticSignError' },
      { 'DapBreakpointCondition', '', 'DiagnosticSignError' },
      { 'DapBreakpointRejected', '', 'DiagnosticSignWarning' },
      { 'DapStopped', '', 'DiagnosticSignOk'
      },

      { 'DapLogPoint', '', 'DiagnosticSignInfo' },
    }

    for _, sign in ipairs(signs) do
      vim.fn.sign_define(sign[1], { text = sign[2], texthl = sign[3], linehl = 'DapBreakpoint', numhl = 'DapBrealpoint' })
    end

    require('mason-nvim-dap').setup {
      automatic_installation = true,

      handlers = {},

      ensure_installed = {
        'delve',
        'codelldb',
      },
    }

    require('dap-go').setup()
    require('dap-python').setup '~/.local/share/nvim/mason/packages/debugpy/venv/bin/python'
  end,
}

return M
