local M = {
  'echasnovski/mini.pick',
  lazy = true,
  dependencies = {
    { 'echasnovski/mini.extra', opts = {} },
  },
  keys = {
    { '<leader>sh',       ':Pick help<CR>',                      desc = 'Search Help' },
    { '<leader>sf',       ":Pick files tool='rg'<CR>",           desc = 'Search Files' },
    { '<leader>sg',       ':Pick grep_live<CR>',                 desc = 'Search by Grep' },
    { '<leader>sr',       ':Pick resume<CR>',                    desc = 'Resume previous picker' },
    { '<leader><leader>', ':Pick buffers<CR>',                   desc = 'Find existing buffers' },
    { '<leader>/',        ":Pick buf_lines scope='current'<CR>", desc = 'Fuzzily search in current buffer' },
  },
  opts = {
    options = { use_cache = true },
    window = {
      config = function()
        local height = math.floor(0.6 * vim.o.lines)
        local width = math.floor(0.6 * vim.o.columns)
        return {
          anchor = 'NW',
          height = height,
          width = width,
          row = math.floor(0.5 * (vim.o.lines - height)),
          col = math.floor(0.5 * (vim.o.columns - width)),
        }
      end
    },
  },
}

return M
