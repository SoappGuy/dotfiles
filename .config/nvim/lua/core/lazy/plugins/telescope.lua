return { -- Fuzzy Finder (files, lsp, etc)
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
      'nvim-telescope/telescope-fzf-native.nvim',

      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    {
      'tomasky/bookmarks.nvim',
      config = function()
        require('bookmarks').setup {
          -- sign_priority = 8,  --set bookmark sign priority to cover other sign
          save_file = vim.fn.expand '$HOME/.bookmarks', -- bookmarks save file path
          keywords = {
            ['@t'] = '', -- mark annotation startswith @t ,signs this icon as `Todo`
            ['@w'] = '', -- mark annotation startswith @w ,signs this icon as `Warn`
            ['@n'] = '󰠮', -- mark annotation startswith @n ,signs this icon as `Note`
          },
          on_attach = function()
            local bm = require 'bookmarks'
            local map = vim.keymap.set
            map('n', '<leader>bt', bm.bookmark_toggle, { desc = '[T]oggle bookmark' }) -- add or remove bookmark at current line
            map('n', '<leader>be', bm.bookmark_ann, { desc = '[E]dit bookmark' }) -- add or edit mark annotation at current line
          end,
        }
      end,
    },
  },
  config = function()
    require('telescope').setup {
      defaults = {
        layout_config = {
          width = 0.95,
          height = 0.95,
        },

        mappings = {
          i = {
            ['<C-p>'] = require('telescope.actions.layout').toggle_preview,
          },
        },

        preview = {
          -- hide_on_startup = true, -- hide previewer when picker starts
        },
      },

      -- pickers = {}

      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    }

    -- Enable Telescope extensions if they are installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')
    pcall(require('telescope').load_extension, 'bookmarks')

    local builtin = require 'telescope.builtin'
    local bookmarks = require('telescope').extensions.bookmarks

    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

    vim.keymap.set('n', '<leader>bl', bookmarks.list, { desc = '[L]ist bookmarks' })

    vim.keymap.set('n', '<leader>/', function()
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })

    vim.keymap.set('n', '<leader>s/', function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end, { desc = '[S]earch [/] in Open Files' })

    -- Shortcut for searching your Neovim configuration files
    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim files' })
  end,
}
