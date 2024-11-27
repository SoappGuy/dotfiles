-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
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
    config = function()
      local gitsigns = require 'gitsigns'

      gitsigns.setup {
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        },
      }

      vim.keymap.set({ 'v' }, '<leader>gh', function()
        gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { desc = 'Gitsigns: Stage selected hunk(s)' })
    end,
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
    'NvChad/nvim-colorizer.lua',
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
      -- Available modes: foreground, background, virtual
      mode = 'virtualtext',
    },
    config = function()
      require('colorizer').setup {}
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
  {
    'johmsalas/text-case.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function()
      require('textcase').setup {}
      require('telescope').load_extension 'textcase'
    end,
    keys = {
      'ga', -- Default invocation prefix
      { 'ga.', '<cmd>TextCaseOpenTelescope<CR>', mode = { 'n', 'x' }, desc = 'Telescope' },
      { '<leader>cs', '<cmd>TextCaseStartReplacingCommand<CR>', mode = 'n', desc = '[s]mart replace' },
    },
    cmd = {
      'Ss',
      'TextCaseOpenTelescope',
      'TextCaseOpenTelescopeQuickChange',
      'TextCaseOpenTelescopeLSPChange',
      'TextCaseStartReplacingCommand',
    },
    opt = {
      substitude_command_name = 'Ss', -- Default: 'Subs'
    },
    -- If you want to use the interactive feature of the `Subs` command right away, text-case.nvim
    -- has to be loaded on startup. Otherwise, the interactive feature of the `Subs` will only be
    -- available after the first executing of it or after a keymap of text-case.nvim has been used.
    lazy = false,
  },
  -- Smooth cursor movement.
  {
    'sphamba/smear-cursor.nvim',
    opts = {},
  },

  {
    'chrisgrieser/nvim-spider',
    keys = {
      {
        '<S-e>',
        "<cmd>lua require('spider').motion('e')<CR>",
        mode = { 'n', 'o', 'x' },
      },
      {
        '<S-w>',
        "<cmd>lua require('spider').motion('w')<CR>",
        mode = { 'n', 'o', 'x' },
      },
      {
        '<S-b>',
        "<cmd>lua require('spider').motion('b')<CR>",
        mode = { 'n', 'o', 'x' },
      },
    },
    lazy = true,
  },

  { 'rhysd/clever-f.vim' },
  { 'github/copilot.vim' },
  { 'tpope/vim-abolish' },
  { 'tpope/vim-sleuth' },
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
