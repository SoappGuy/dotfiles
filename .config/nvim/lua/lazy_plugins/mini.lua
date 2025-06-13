local M = {
  { 'echasnovski/mini.ai',       opts = { n_lines = 500 }, event = 'BufEnter' },
  { 'echasnovski/mini.surround', opts = {},                event = 'BufEnter' },
  { 'echasnovski/mini.comment',  opts = {},                event = 'BufEnter' },
  { 'echasnovski/mini.move',     opts = {},                event = 'BufEnter' },
  {
    'echasnovski/mini.diff',
    opts = {},
    init = function()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniDiffUpdated',
        callback = function(data)
          local summary = vim.b[data.buf].minidiff_summary or {}
          local str = ""
          if summary.add ~= nil and summary.add > 0 then
            str = str .. '%#MiniDiffSignAdd# ' .. summary.add .. "%#MiniStatuslineDevinfo#"
          end
          if summary.change ~= nil and summary.change > 0 then
            str = str .. ' %#MiniDiffSignChange# ' .. summary.change .. "%#MiniStatuslineDevinfo#"
          end
          if summary.delete ~= nil and summary.delete > 0 then
            str = str .. ' %#MiniDiffSignDelete# ' .. summary.delete .. "%#MiniStatuslineDevinfo#"
          end
          vim.b[data.buf].minidiff_summary_string = str
        end
      })
    end,
    event = 'BufEnter'
  },
  { 'echasnovski/mini.splitjoin',  opts = {}, event = 'BufEnter' },
  { 'echasnovski/mini.cursorword', opts = {}, event = 'BufEnter' },
  { 'echasnovski/mini.icons',      opts = {}, event = 'VimEnter' },
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
    dependencies = { { 'echasnovski/mini.extra', opts = {} }, },
    keys = {
      { 'gD',               vim.lsp.buf.declaration,                  'Goto declaration' },
      { '<leader>ca',       vim.lsp.buf.code_action,                  'Code action' },
      { 'gd',               ":Pick lsp scope='definition'<CR>",       desc = 'Goto definition' },
      { 'gr',               ":Pick lsp scope='references'<CR>",       desc = 'Goto references' },
      { 'gI',               ":Pick lsp scope='implementation'<CR>",   desc = 'Goto implementation' },
      { '<leader>gt',       ":Pick lsp scope='type_definition' <CR>", desc = 'Goto type definition' },
      { '<leader>sh',       ":Pick help<CR>",                         desc = 'Search Help' },
      { '<leader>sf',       ":Pick files tool='rg'<CR>",              desc = 'Search Files' },
      { '<leader>sg',       ":Pick grep_live<CR>",                    desc = 'Search by Grep' },
      { '<leader>sr',       ":Pick resume<CR>",                       desc = 'Resume previous picker' },
      { '<leader><leader>', ":Pick buffers<CR>",                      desc = 'Find existing buffers' },
      { '<leader>/',        ":Pick buf_lines scope='current'<CR>",    desc = 'Fuzzily search in current buffer' },
      { 'z=',               ":Pick spellsuggest<CR>",                 desc = 'Spell suggestions' },
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
  },
  {
    'echasnovski/mini.statusline',
    config = function()
      require('mini.statusline').setup {
        content = {
          active =
              function()
                local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 300 })
                local git           = MiniStatusline.section_git({ trunc_width = 40 })
                local diff          = MiniStatusline.section_diff({ trunc_width = 75, icon = " :" })

                local lsp           = 'No Active LSP'
                local clients       = vim.lsp.get_clients()
                if next(clients) ~= nil then
                  for _, client in ipairs(clients) do
                    local filetypes = client.config.filetypes ---@diagnostic disable-line: undefined-field
                    if filetypes and vim.fn.index(filetypes, vim.api.nvim_get_option_value('filetype', { buf = 0 })) ~= -1 then
                      lsp = ' LSP: ' .. client.name
                    end
                  end
                end

                local diagnostics = MiniStatusline.section_diagnostics({
                  trunc_width = 75,
                  icon = "",
                  signs = {
                    ERROR = '%#DiagnosticError#' .. ' ',
                    WARN = '%#DiagnosticWarn#' .. ' ',
                    INFO = '%#DiagnosticInfo#' .. '',
                    HINT = '%#DiagnosticHint#' .. ' ',
                  }
                })

                local filename    = MiniStatusline.section_filename({ trunc_width = 300 })
                local fileinfo    = MiniStatusline.section_fileinfo({ trunc_width = 120 })
                local location    = MiniStatusline.section_location({ trunc_width = 300 })
                local search      = MiniStatusline.section_searchcount({ trunc_width = 75 })

                return MiniStatusline.combine_groups({
                  { hl = mode_hl,                  strings = { mode } },
                  { hl = 'MiniStatuslineFilename', strings = { filename } },
                  { hl = 'MiniStatuslineDevinfo',  strings = { git, lsp, diagnostics } },
                  '%=',
                  { hl = 'MiniStatuslineDevinfo',  strings = { diff } },
                  { hl = 'MiniStatuslineFilename', strings = { fileinfo } },
                  { hl = mode_hl,                  strings = { search, location } },
                })
              end
          ,
        }
      }
    end,
  }
}

return M
