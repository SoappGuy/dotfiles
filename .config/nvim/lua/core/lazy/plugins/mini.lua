local M = {
  { 'echasnovski/mini.ai',         opts = { n_lines = 500 }, event = 'BufReadPre' },
  { 'echasnovski/mini.surround',   opts = {},                event = 'BufReadPre' },
  { 'echasnovski/mini.comment',    opts = {},                event = 'BufReadPre' },
  { 'echasnovski/mini.move',       opts = {},                event = 'BufReadPre' },
  { 'echasnovski/mini.diff',       opts = {},                event = 'BufReadPre' },
  { 'echasnovski/mini.splitjoin',  opts = {},                event = 'BufReadPre' },
  { 'echasnovski/mini.icons',      opts = {},                event = 'VimEnter' },
  { 'echasnovski/mini.cursorword', opts = {},                event = 'BufReadPre' },
  {
    'echasnovski/mini.snippets',
    event = 'VimEnter',
    dependencies = 'rafamadriz/friendly-snippets',
    opts = {
      snippets = {
        require('mini.snippets').gen_loader.from_file '~/.config/nvim/snippets/global.json',
        require('mini.snippets').gen_loader.from_lang(),
      },
    },
  },
  {
    'echasnovski/mini.hipatterns',
    event = 'BufReadPre',
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
}

return M
