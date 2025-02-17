return { -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    {
      'kevinhwang91/nvim-ufo',
      otps = {},
      dependencies = { 'kevinhwang91/promise-async' },
    },
    { 'nvim-treesitter/nvim-treesitter-textobjects' },
    {
      'luukvbaal/statuscol.nvim',
      opts = function()
        local builtin = require 'statuscol.builtin'
        return {
          setopt = true,
          -- override the default list of segments with:
          -- number-less fold indicator, then signs, then line number & separator
          segments = {
            { text = { builtin.foldfunc }, click = 'v:lua.ScFa' },
            { text = { '%s' }, click = 'v:lua.ScSa' },
            {
              text = { builtin.lnumfunc, ' ' },
              condition = { true, builtin.not_empty },
              click = 'v:lua.ScLa',
            },
          },
        }
      end,
    },
  },
  build = ':TSUpdate',
  lazy = true,
  event = 'BufRead',
  opts = {
    ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'vim', 'vimdoc' },
    auto_install = true,
    highlight = {
      enable = true,
      -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
      --  If you are experiencing weird indenting issues, add the language to
      --  the list of additional_vim_regex_highlighting and disabled languages for indent.
      additional_vim_regex_highlighting = { 'ruby' },
    },
    indent = { enable = true, disable = { 'ruby' } },
    incremental_selection = {
      enable = true,
      keymaps = {
        node_incremental = 'v',
        node_decremental = 'V',
      },
    },

    textobjects = {
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = { query = '@function.outer', desc = 'function start' },
          ['gj'] = { query = '@function.outer', desc = 'function start' },
          [']]'] = { query = '@class.outer', desc = 'class start' },
          [']b'] = { query = '@block.outer', desc = 'block start' },
          [']a'] = { query = '@parameter.inner', desc = 'parameter start' },
        },
        goto_next_end = {
          [']M'] = { query = '@function.outer', desc = 'function end' },
          ['gJ'] = { query = '@function.outer', desc = 'function end' },
          [']['] = { query = '@class.outer', desc = 'class end' },
          [']B'] = { query = '@block.outer', desc = 'block end' },
          [']A'] = { query = '@parameter.inner', desc = 'parameter end' },
        },
        goto_previous_start = {
          ['[m'] = { query = '@function.outer', desc = 'previous function start' },
          ['gk'] = { query = '@function.outer', desc = 'previous function start' },
          ['[['] = { query = '@class.outer', desc = 'previous class start' },
          ['[b'] = { query = '@block.outer', desc = 'previous block start' },
          ['[a'] = { query = '@parameter.inner', desc = 'previous parameter start' },
        },
        goto_previous_end = {
          ['[M'] = { query = '@function.outer', desc = 'previous function end' },
          ['gK'] = { query = '@function.outer', desc = 'previous function end' },
          ['[]'] = { query = '@class.outer', desc = 'previous class end' },
          ['[B'] = { query = '@block.outer', desc = 'previous block end' },
          ['[A'] = { query = '@parameter.inner', desc = 'previous parameter end' },
        },
      },
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ['af'] = { query = '@function.outer', desc = 'outer function' },
          ['if'] = { query = '@function.inner', desc = 'inner function' },
          ['ac'] = { query = '@class.outer', desc = 'outer class' },
          ['ic'] = { query = '@class.inner', desc = 'inner class' },
          ['ab'] = { query = '@block.outer', desc = 'outer block' },
          ['ib'] = { query = '@block.inner', desc = 'inner block' },
          ['al'] = { query = '@loop.outer', desc = 'outer loop' },
          ['il'] = { query = '@loop.inner', desc = 'inner loop' },
          ['a/'] = { query = '@comment.outer', desc = 'outer comment' },
          ['i/'] = { query = '@comment.outer', desc = 'outer comment' }, -- no inner for comment
          ['aa'] = { query = '@parameter.outer', desc = 'outer parameter' },
          ['ia'] = { query = '@parameter.inner', desc = 'inner parameter' },
        },
      },
    },
  },
  config = function(_, opts)
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

    -- Prefer git instead of curl in order to improve connectivity in some environments
    require('nvim-treesitter.install').prefer_git = true
    ---@diagnostic disable-next-line: missing-fields
    require('nvim-treesitter.configs').setup(opts)

    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects

    local ufo = require 'ufo'

    vim.keymap.set('n', 'zR', ufo.openAllFolds, { desc = 'Open all folds' })
    vim.keymap.set('n', 'zM', ufo.closeAllFolds, { desc = 'Close all folds' })

    ufo.setup {
      provider_selector = function(bufnr, filetype, buftype)
        return { 'treesitter', 'indent' }
      end,
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (' 󰁂 %d '):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, 'MoreMsg' })
        return newVirtText
      end,
    }

    vim.keymap.set('n', 'zk', function()
      local winid = ufo.peekFoldedLinesUnderCursor()
      if not winid then
        vim.lsp.buf.hover()
      end
    end)
  end,
}
