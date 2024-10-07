-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  'tpope/vim-sleuth',
  {
    'hedyhli/outline.nvim',
    lazy = true,
    cmd = { 'Outline' },
    keys = { -- Example mapping to toggle outline
      { '<leader>to', '<cmd>Outline<CR>', desc = 'Toggle outline' },
    },
    opts = {
      -- Your setup opts here
    },
  },

  { 'rhysd/clever-f.vim' },
  {
    'SoappGuy/gruber-darker.nvim',

    priority = 1000,
    config = function()
      require('gruber-darker').setup {
        bold = true,
        invert = {
          signs = true,
          tabline = true,
          visual = false,
        },
        italic = {
          strings = false,
          comments = false,
          operators = false,
          folds = false,
        },
        undercurl = true,
        underline = true,
      }
      vim.cmd.colorscheme 'gruber-darker'
      vim.cmd.hi 'Comment gui=none'
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    lazy = true,
    event = 'VeryLazy',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  {
    'folke/which-key.nvim',
    lazy = true,
    event = 'User VeryLazy', -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
      require('which-key').setup()

      -- Document existing key chains
      require('which-key').add {
        { '<leader>g', group = '[G]o' },
        { '<leader>g_', hidden = true },
        { '<leader>t', group = '[T]erm' },
        { '<leader>t_', hidden = true },
        { '<leader>c', group = '[C]ode' },
        { '<leader>c_', hidden = true },
        { '<leader>d', group = '[D]ebug' },
        { '<leader>d_', hidden = true },
        { '<leader>h', group = '[H]arpoon' },
        { '<leader>h_', hidden = true },
        { '<leader>r', group = '[R]ename' },
        { '<leader>r_', hidden = true },
        { '<leader>s', group = '[S]earch' },
        { '<leader>s_', hidden = true },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>t_', hidden = true },
        { '<leader>m', group = '[M]ulticursor' },
        { '<leader>m_', hidden = true },
      }
    end,
  },

  {
    'norcalli/nvim-colorizer.lua',
    lazy = true,
    event = 'VeryLazy',
    opts = {
      RGB = true, -- #RGB hex codes
      RRGGBB = true, -- #RRGGBB hex codes
      names = true, -- "Name" codes like Blue
      RRGGBBAA = true, -- #RRGGBBAA hex codes
      rgb_fn = true, -- CSS rgb() and rgba() functions
      hsl_fn = true, -- CSS hsl() and hsla() functions
      css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
      css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
      -- Available modes: foreground, background
      mode = 'background',
    }, -- Set the display mode.},
    config = function()
      require('colorizer').setup()
    end,
  },

  {
    'iamcco/markdown-preview.nvim',
    lazy = true,
    cmd = { 'MarkdownPreviewToggle' },
    ft = { 'markdown' },
    build = function()
      vim.fn['mkdp#util#install']()
    end,
  },

  {
    'fedepujol/move.nvim',
    lazy = true,
    event = 'BufEnter',
    config = function()
      local move = require 'move'
      move.setup {
        line = {
          enable = true, -- Enables line movement
          indent = true, -- Toggles indentation
        },
        block = {
          enable = true, -- Enables block movement
          indent = true, -- Toggles indentation
        },
        word = {
          enable = true, -- Enables word movement
        },
        char = {
          enable = true, -- Enables char movement
        },
      }

      local opts = { noremap = true, silent = true }
      -- Normal-mode commands
      vim.keymap.set('n', '<A-k>', ':MoveLine(-1)<CR>', opts)
      vim.keymap.set('n', '<A-j>', ':MoveLine(1)<CR>', opts)
      vim.keymap.set('n', '<A-h>', ':MoveHChar(-1)<CR>', opts)
      vim.keymap.set('n', '<A-l>', ':MoveHChar(1)<CR>', opts)
      vim.keymap.set('n', '<leader>wf', ':MoveWord(1)<CR>', opts)
      vim.keymap.set('n', '<leader>wb', ':MoveWord(-1)<CR>', opts)

      -- Visual-mode commands
      vim.keymap.set('v', '<A-j>', ':MoveBlock(1)<CR>', opts)
      vim.keymap.set('v', '<A-k>', ':MoveBlock(-1)<CR>', opts)
      vim.keymap.set('v', '<A-h>', ':MoveHBlock(-1)<CR>', opts)
      vim.keymap.set('v', '<A-l>', ':MoveHBlock(1)<CR>', opts)
    end,
  },

  { 'nishigori/increment-activator' },
  { 'dstein64/vim-startuptime', lazy = false },

  { import = 'core.lazy.plugins' },
}, {
  ui = {
    border = 'rounded',
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
