return {
  'mfussenegger/nvim-dap',
  lazy = true,
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    'leoluz/nvim-dap-go',
    'mfussenegger/nvim-dap-python',
  },
  cmd = 'DapLazySetBreakpoint',
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    -- Install all deps
    require('mason-nvim-dap').setup {
      automatic_installation = true,

      handlers = {},

      ensure_installed = {
        'debugpy',
        'delve',
        'codelldb',
      },
    }

    -- Register keymaps
    vim.keymap.set('n', '<leader>dc', dap.continue, { desc = 'Debug: Start/Continue' })
    vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })

    vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })

    vim.keymap.set('n', '<leader>di', dap.step_into, { desc = 'Debug: Step Into (F1)' })
    vim.keymap.set('n', '<leader>do', dap.step_over, { desc = 'Debug: Step Over (F2)' })
    vim.keymap.set('n', '<leader>dt', dap.step_out, { desc = 'Debug: Step Out (F3)' })

    vim.keymap.set('n', '<leader>du', dapui.toggle, { desc = 'Debug: Toggle UI' })

    -- Create UI, change colors and signs
    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
    }

    vim.api.nvim_set_hl(0, 'red', { fg = '#DE3C3C' })
    vim.api.nvim_set_hl(0, 'green', { fg = '#9ece6a' })
    vim.api.nvim_set_hl(0, 'yellow', { fg = '#FFFF00' })
    vim.api.nvim_set_hl(0, 'orange', { fg = '#f09000' })

    vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'red', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapBreakpointCondition', { text = '', texthl = 'red', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'orange', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapStopped', { text = '', texthl = 'green', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'yellow', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })

    -- Setup all debuggers

    -- Go
    require('dap-go').setup()

    -- Python
    require('dap-python').setup '~/.local/share/nvim/mason/packages/debugpy/venv/bin/python'

    -- LLDB (now only C)
    dap.adapters.codelldb = function(cb)
      -- Compile current file
      local current_file = vim.fn.expand '%:p'
      local file_name = vim.fn.expand '%:t:r'
      local bin_dir = './bin'
      local output_file = bin_dir .. '/' .. file_name

      -- Create bin directory if it doesn't exist
      vim.fn.mkdir(bin_dir, 'p')

      -- Compile the C file
      local compile_cmd = string.format('clang %s -o %s --debug', current_file, output_file)
      local result = vim.fn.system(compile_cmd)

      if vim.v.shell_error ~= 0 then
        print 'Compilation failed:'
        print(result)
      else
        print('Compilation successful. Binary saved to: ' .. output_file)
      end

      local adapter = {
        type = 'server',
        port = '${port}',
        executable = {
          command = vim.fn.stdpath 'data' .. '/mason/bin/codelldb',
          args = { '--port', '${port}' },
        },
      }

      cb(adapter)
    end

    dap.configurations.c = {
      {
        name = 'Compile and Debug',
        type = 'codelldb',
        request = 'launch',
        program = './bin/${fileBasenameNoExtension}',
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
      },
    }

    -- Function to delete C binary after exit
    local exit_and_delete_bin = function()
      dapui.close()
      local file_name = vim.fn.expand '%:t:r'
      local bin_dir = './bin'
      local binary_file = bin_dir .. '/' .. file_name

      if vim.fn.filereadable(binary_file) == 1 then
        vim.fn.delete(binary_file)
        print('Binary file deleted: ' .. binary_file)

        -- Check if bin directory is empty
        local is_empty = vim.fn.empty(vim.fn.glob(bin_dir .. '/*'))
        if is_empty == 1 then
          vim.fn.delete(bin_dir, 'd')
          print('Deleted empty bin directory: ' .. bin_dir)
        end
      else
        print 'No binary file found for the current C file.'
      end
    end

    -- Auto toggle UI
    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = exit_and_delete_bin
    dap.listeners.before.event_exited['dapui_config'] = exit_and_delete_bin
  end,
}
