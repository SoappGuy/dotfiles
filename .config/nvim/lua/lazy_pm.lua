local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup(
  {
    -- {
    --   "OXY2DEV/markview.nvim",
    --   lazy = false,
    --   dependencies = { "saghen/blink.cmp" },
    --   opts = { typst = { enable = false } }
    -- },
    -- {
    --   'm4xshen/hardtime.nvim',
    --   lazy = false,
    --   dependencies = { 'MunifTanjim/nui.nvim' },
    --   opts = {}
    -- },
    {
      'scottmckendry/cyberdream.nvim',
      lazy = false,
      priority = 1000,
      opts = {},
      init = function()
        vim.cmd 'colorscheme cyberdream'
      end,
    },
    {
      'folke/lazydev.nvim',
      ft = 'lua',
      opts = {
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          { path = "LazyVim",            words = { "LazyVim" } },
        }
      }
    },
    {
      'michaelrommel/nvim-silicon',
      cmd = 'Silicon',
      opts = {
        font = 'IosevkaTerm Nerd Font=34',
        theme = 'Dracula',
        background = '#999999',
        to_clipboard = true,
        window_title = function()
          return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), ':t')
        end,
      },
    },
    {
      "Aietes/esp32.nvim",
      opts = {
        build_dir = "build",
      },
    },
    -- {
    --   'chrisgrier/nvim-spider',
    --   keys = {
    --     { '<S-e>', "<cmd>lua require('spider').motion('e')<CR>", mode = { 'n', 'o', 'x' } },
    --     { '<S-w>', "<cmd>lua require('spider').motion('w')<CR>", mode = { 'n', 'o', 'x' } },
    --     { '<S-b>', "<cmd>lua require('spider').motion('b')<CR>", mode = { 'n', 'o', 'x' } },
    --   },
    -- },
    {
      'https://github.com/aklt/plantuml-syntax',
      ft = { 'pu', 'plantuml', 'iuml', 'puml', 'wsd' },
      cmd = 'PlantUML',
      dependencies = {
        {
          'https://gitlab.com/itaranto/plantuml.nvim',
          opts = { renderer = { type = 'image', options = { prog = 'loupe', dark_mode = false, format = 'png' } } }
        },
      }
    },

    {
      'saecki/crates.nvim',
      tag = 'stable',
      event = { 'BufRead Cargo.toml' },
      opts = { lsp = { enabled = true, actions = true, completion = true, hover = true } }
    },

    { 'sphamba/smear-cursor.nvim',     event = "VimEnter" },
    { 'rhysd/clever-f.vim',            keys = { 'f', 'F', 't', 'T' } },
    { 'windwp/nvim-autopairs',         event = "InsertEnter",                                              opts = {} }, -- Autopairs
    { 'nishigori/increment-activator', keys = { { '<C-a>', noremap = true }, { '<C-x>', noremap = true } } },           -- More actions like true -> false -> true ...
    { 'tpope/vim-sleuth',              event = 'BufReadPre' },                                                          -- Filetype based tab width
    {
      'tpope/vim-abolish',
      event = 'VeryLazy',
      config = function()
        vim.cmd 'cabbrev S Subvert'
        vim.api.nvim_set_keymap('n', '/', ':Abolish -search ', {})
      end,
    }, -- Smart substitute
    { import = 'lazy_plugins' },
  },

  {
    rtp = { disabled_plugins = { "netrwPlugin" } },
    ui = { border = 'single', },
  }
)
