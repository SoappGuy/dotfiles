local M = {
  { 'echasnovski/mini.ai',         opts = { n_lines = 500 }, event = 'BufEnter' },
  { 'echasnovski/mini.surround',   opts = {},                event = 'BufEnter' },
  { 'echasnovski/mini.comment',    opts = {},                event = 'BufEnter' },
  { 'echasnovski/mini.move',       opts = {},                event = 'BufEnter' },
  { 'echasnovski/mini.diff',       opts = {},                event = 'BufEnter' },
  { 'echasnovski/mini.splitjoin',  opts = {},                event = 'BufEnter' },
  { 'echasnovski/mini.cursorword', opts = {},                event = 'BufEnter' },
  { 'echasnovski/mini.icons',      opts = {},                event = 'VimEnter' },
  {
    'echasnovski/mini.snippets',
    lazy = true,
    dependencies = 'rafamadriz/friendly-snippets',
    config = function()
      local minisnippets = require 'mini.snippets'
      minisnippets.setup {
        snippets = {
          minisnippets.gen_loader.from_file '~/.config/nvim/snippets/global.json',
          minisnippets.gen_loader.from_lang(),
        },
      }
    end,
  },
  {
    'echasnovski/mini.hipatterns',
    event = 'VimEnter',
    config = function()
      local hipatterns = require 'mini.hipatterns'
      hipatterns.setup {
        highlighters = {
          -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
          fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
          hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
          todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
          note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      }
    end,
  },
  {
    'echasnovski/mini.clue',
    event = 'VimEnter',
    enebled = true,
    config = function()
      local miniclue = require 'mini.clue'
      miniclue.setup {
        triggers = {
          -- Leader triggers
          { mode = 'n', keys = '<leader>' },
          { mode = 'x', keys = '<leader>' },

          -- Built-in completion
          { mode = 'i', keys = '<C-x>' },

          -- `g` key
          { mode = 'n', keys = 'g' },
          { mode = 'x', keys = 'g' },

          -- Marks
          { mode = 'n', keys = "'" },
          { mode = 'n', keys = '`' },
          { mode = 'x', keys = "'" },
          { mode = 'x', keys = '`' },

          -- Registers
          { mode = 'n', keys = '"' },
          { mode = 'x', keys = '"' },
          { mode = 'i', keys = '<C-r>' },
          { mode = 'c', keys = '<C-r>' },

          -- Window commands
          { mode = 'n', keys = '<C-w>' },

          -- `z` key
          { mode = 'n', keys = 'z' },
          { mode = 'x', keys = 'z' },
        },

        clues = {
          miniclue.gen_clues.builtin_completion(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.marks(),
          miniclue.gen_clues.registers(),
          miniclue.gen_clues.windows(),
          miniclue.gen_clues.z(),
          { mode = 'n', keys = '<leader>g', desc = 'Go' },
          { mode = 'n', keys = '<leader>t', desc = 'Term' },
          { mode = 'n', keys = '<leader>c', desc = 'Code' },
          { mode = 'n', keys = '<leader>d', desc = 'Debug' },
          { mode = 'n', keys = '<leader>s', desc = 'Search' },
          { mode = 'n', keys = '<leader>t', desc = 'Toggle' },
          { mode = 'n', keys = '<leader>m', desc = 'Multicursor', icon = '󰗧' },
        },

        window = {
          delay = 0,
          config = {
            width = 'auto',
            border = 'single',
          },

          scroll_down = '<C-d>',
          scroll_up = '<C-u>',
        },
      }
    end,
  },
  {
    'echasnovski/mini.pick',
    lazy = true,
    dependencies = {
      { 'echasnovski/mini.extra', opts = {} },
    },
    keys = {
      '<leader>ca', 'gd', 'gr', 'gI', '<leader>gt',
      { '<leader>sh',       ':Pick help<CR>',                      desc = 'Search Help' },
      { '<leader>sf',       ":Pick files tool='rg'<CR>",           desc = 'Search Files' },
      { '<leader>sg',       ':Pick grep_live<CR>',                 desc = 'Search by Grep' },
      { '<leader>sr',       ':Pick resume<CR>',                    desc = 'Resume previous picker' },
      { '<leader><leader>', ':Pick buffers<CR>',                   desc = 'Find existing buffers' },
      { '<leader>/',        ":Pick buf_lines scope='current'<CR>", desc = 'Fuzzily search in current buffer' },
    },
    config = function()
      local minipick = require 'mini.pick'

      vim.ui.select = minipick.ui_select

      minipick.setup {
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
      }
    end,
  }
}

return M
