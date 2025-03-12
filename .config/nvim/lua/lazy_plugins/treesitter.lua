return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    {
      'kevinhwang91/nvim-ufo',
      otps = {},
      dependencies = { 'kevinhwang91/promise-async' },
    },
    { 'nvim-treesitter/nvim-treesitter-textobjects' },
  },
  build = ':TSUpdate',
  lazy = true,
  event = 'BufRead',
  opts = {
    ensure_installed = { 'bash', 'c', 'rust', 'python', 'diff', 'html', 'css', 'lua', 'luadoc', 'markdown', 'vim', 'vimdoc' },
    auto_install = true,
    highlight = {
      enable = true,
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
    require('nvim-treesitter.install').prefer_git = true
    require('nvim-treesitter.configs').setup(opts)

    local ufo = require 'ufo'

    ufo.setup {
      provider_selector = function()
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

    vim.keymap.set('n', 'zR', ufo.openAllFolds, { desc = 'Open all folds' })
    vim.keymap.set('n', 'zM', ufo.closeAllFolds, { desc = 'Close all folds' })
    vim.keymap.set('n', 'zk', function()
      local winid = ufo.peekFoldedLinesUnderCursor()
      if not winid then
        vim.lsp.buf.hover()
      end
    end)
  end,
}
