return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    'leoluz/nvim-dap-go',
    'mfussenegger/nvim-dap-python',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      automatic_installation = true,

      handlers = {},

      ensure_installed = {
        'debugpy',
        'delve',
      },
    }

    vim.keymap.set('n', '<leader>dc', dap.continue, { desc = 'Debug: Start/Continue' })
    vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })

    vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })

    vim.keymap.set('n', '<leader>di', dap.step_into, { desc = 'Debug: Step Into (F1)' })
    vim.keymap.set('n', '<leader>do', dap.step_over, { desc = 'Debug: Step Over (F2)' })
    vim.keymap.set('n', '<leader>dt', dap.step_out, { desc = 'Debug: Step Out (F3)' })

    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
    }

    vim.keymap.set('n', '<leader>du', dapui.toggle, { desc = 'Debug: Toggle UI' })

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    require('dap-go').setup()

    require('dap-python').setup '~/.local/share/nvim/mason/packages/debugpy/venv/bin/python'
  end,
}
