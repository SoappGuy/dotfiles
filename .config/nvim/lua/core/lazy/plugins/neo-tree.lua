-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  lazy = true,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree reveal<CR>', { desc = 'NeoTree reveal' } },
  },
  opts = {
    filesystem = {
      window = {
        -- position = 'current',
        width = 35,
        mappings = {
          ['\\'] = 'close_window',
          ['P'] = {
            function(state)
              local node = state.tree:get_node()
              require('neo-tree.ui.renderer').focus_node(state, node:get_parent_id())
            end,
            desc = 'go to parent node',
          },
          ['O'] = {
            function(state)
              local node = state.tree:get_node()

              vim.notify 'Opening file'

              vim.fn.jobstart("xdg-open '" .. node.path .. "'", {
                cwd = vim.fn.getcwd(),
                on_exit = function(jobid, data, event)
                  vim.notify 'Task finished'
                end,
              })
            end,
            desc = 'open using system default app',
          },
        },
      },
      close_if_last_window = true,
      popup_border_style = 'rounded',
      enable_git_status = true,
      enable_diagnostics = true,
      toggle = true,
    },
  },
}
