-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
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
        width = 50,
        mappings = {
          ['\\'] = 'close_window',
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
