local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
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
      'michaelrommel/nvim-silicon',
      lazy = true,
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
      'chrisgrieser/nvim-spider',
      lazy = true,
      keys = {
        { '<S-e>', "<cmd>lua require('spider').motion('e')<CR>", mode = { 'n', 'o', 'x' } },
        { '<S-w>', "<cmd>lua require('spider').motion('w')<CR>", mode = { 'n', 'o', 'x' } },
        { '<S-b>', "<cmd>lua require('spider').motion('b')<CR>", mode = { 'n', 'o', 'x' } },
      },
    },

    { 'sphamba/smear-cursor.nvim',    opts = {} },
    { 'github/copilot.vim' },
    { 'rhysd/clever-f.vim' },
    { 'windwp/nvim-autopairs',        event = 'InsertEnter', opts = {} },
    { 'nishigori/increment-activator' }, -- More actions on <C-a>/<C-x> (like true -> false -> true ...)
    { 'tpope/vim-sleuth' },              -- Filetype based tab width
    {                                    -- Smart substitute
      'tpope/vim-abolish',
      init = function()
        vim.cmd 'cabbrev s Subvert'
      end,
    },

    { import = 'core.lazy.plugins' },
  },
  {
    rtp = {
      disabled_plugins = {
        "netrwPlugin",
        -- "gzip",
        -- "matchit",
        -- "matchparen",
        -- "tarPlugin",
        -- "tohtml",
        -- "tutor",
        -- "zipPlugin",
      },
    },
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
  }
)
