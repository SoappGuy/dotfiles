local M = {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'echasnovski/mini.icons' },

  config = function()
    local lualine = require 'lualine'
    local colors = {
      bg = '#282828',
      fg = '#e4e4e4',
      yellow = '#ffdd33',
      niagara = '#96a6c8',
      red = '#f43841',
      green = '#73d936',
      darkniagara = '#081633',
      wisteria = '#9e95c7',
      brown = '#cc8c3c',
      quartz = '#95a99f',
    }

    local mode_map = {
      ['n'] = 'NORMAL',
      ['no'] = 'O-PENDING',
      ['nov'] = 'O-PENDING',
      ['noV'] = 'O-PENDING',
      ['no�'] = 'O-PENDING',
      ['niI'] = 'NORMAL',
      ['niR'] = 'NORMAL',
      ['niV'] = 'NORMAL',
      ['nt'] = 'NORMAL',
      ['v'] = 'VISUAL',
      ['vs'] = 'VISUAL',
      ['V'] = 'V-LINE',
      ['Vs'] = 'V-LINE',
      ['�'] = 'V-BLOCK',
      ['�s'] = 'V-BLOCK',
      ['s'] = 'SELECT',
      ['S'] = 'S-LINE',
      ['�'] = 'S-BLOCK',
      ['i'] = 'INSERT',
      ['ic'] = 'INSERT',
      ['ix'] = 'INSERT',
      ['R'] = 'REPLACE',
      ['Rc'] = 'REPLACE',
      ['Rx'] = 'REPLACE',
      ['Rv'] = 'V-REPLACE',
      ['Rvc'] = 'V-REPLACE',
      ['Rvx'] = 'V-REPLACE',
      ['c'] = 'COMMAND',
      ['cv'] = 'EX',
      ['ce'] = 'EX',
      ['r'] = 'REPLACE',
      ['rm'] = 'MORE',
      ['r?'] = 'CONFIRM',
      ['!'] = 'SHELL',
      ['t'] = 'TERMINAL',
    }

    local conditions = {
      buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand '%:t') ~= 1
      end,
      hide_in_width = function()
        return vim.fn.winwidth(0) > 80
      end,
      check_git_workspace = function()
        local filepath = vim.fn.expand '%:p:h'
        local gitdir = vim.fn.finddir('.git', filepath .. ';')
        return gitdir and #gitdir > 0 and #gitdir < #filepath
      end,
    }

    -- Config
    local config = {
      options = {
        component_separators = '',
        section_separators = '',
        theme = {
          normal = { c = { fg = colors.fg, bg = colors.bg } },
          inactive = { c = { fg = colors.fg, bg = colors.bg } },
        },
      },
      sections = {
        -- these are to remove the defaults
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        -- These will be filled later
        lualine_c = {},
        lualine_x = {},
      },
      inactive_sections = {
        -- these are to remove the defaults
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        lualine_c = {},
        lualine_x = {},
      },
    }

    -- Inserts a component in lualine_c at left section
    local function ins_left(component)
      table.insert(config.sections.lualine_c, component)
    end

    -- Inserts a component in lualine_x at right section
    local function ins_right(component)
      table.insert(config.sections.lualine_x, component)
    end

    ins_left {
      function()
        return '▊'
      end,
      color = { fg = colors.yellow },    -- Sets highlighting of component
      padding = { left = 0, right = 1 }, -- We don't need space before this
    }

    ins_left {
      -- mode component
      function()
        return mode_map[vim.fn.mode()]
      end,
      color = function()
        -- auto change color according to neovims mode
        local mode_color = {
          n = colors.red,
          i = colors.green,
          v = colors.niagara,
          [''] = colors.niagara,
          V = colors.niagara,
          c = colors.wisteria,
          no = colors.red,
          s = colors.brown,
          S = colors.brown,
          [''] = colors.brown,
          ic = colors.yellow,
          R = colors.wisteria,
          Rv = colors.wisteria,
          cv = colors.red,
          ce = colors.red,
          r = colors.niagara,
          rm = colors.niagara,
          ['r?'] = colors.niagara,
          ['!'] = colors.red,
          t = colors.red,
        }
        return { fg = mode_color[vim.fn.mode()] }
      end,
      padding = { right = 1 },
    }

    ins_left {
      -- Lsp server name .
      function()
        local msg = 'No Active Lsp'
        local buf_ft = vim.api.nvim_get_option_value('filetype', { buf = 0 })
        local clients = vim.lsp.get_clients()
        if next(clients) == nil then
          return msg
        end
        for _, client in ipairs(clients) do
          local filetypes = client.config.filetypes
          if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
            return client.name
          end
        end
        return msg
      end,
      icon = ' LSP:',
      color = { fg = '#ffffff', gui = 'bold' },
    }

    ins_left {
      'diagnostics',
      sources = { 'nvim_diagnostic' },
      symbols = { error = ' ', warn = ' ', info = '' },
      diagnostics_color = {
        error = { fg = colors.red },
        warn = { fg = colors.yellow },
        info = { fg = colors.niagara },
      },
    }

    -- Insert mid section. You can make any number of sections in neovim :)
    -- for lualine it's any number greater then 2
    ins_left {
      function()
        return '%='
      end,
    }

    ins_left {
      'filename',
      cond = conditions.buffer_not_empty,
      color = { fg = colors.wisteria, gui = 'bold' },
    }

    -- Add components to right sections
    ins_right {
      'o:encoding',       -- option component same as &encoding in viml
      fmt = string.upper, -- I'm not sure why it's upper case either ;)
      cond = conditions.hide_in_width,
      color = { fg = colors.green, gui = 'bold' },
    }

    ins_right {
      'fileformat',
      fmt = string.upper,
      icons_enabled = true, -- I think icons are cool but Eviline doesn't have them. sigh
      color = { fg = colors.green, gui = 'bold' },
    }

    ins_right {
      'branch',
      icon = '',
      color = { fg = colors.wisteria, gui = 'bold' },
    }

    ins_right {
      'diff',
      -- Is it me or the symbol for modified us really weird
      symbols = { added = ' ', modified = ' ', removed = ' ' },
      diff_color = {
        added = { fg = colors.green },
        modified = { fg = colors.brown },
        removed = { fg = colors.red },
      },
      cond = conditions.hide_in_width,
    }

    ins_right {
      function()
        return '▊'
      end,
      color = { fg = colors.yellow },
      padding = { left = 1 },
    }

    lualine.setup(config)
  end,
}

local M = {
  'echasnovski/mini.statusline',
  config = function()
    local MiniStatusline = require 'mini.statusline'

    local mode, mode_hl  = MiniStatusline.section_mode({ trunc_width = 120 })
    local git            = MiniStatusline.section_git({ trunc_width = 40 })
    local diff           = MiniStatusline.section_diff({ trunc_width = 75 })
    local diagnostics    = MiniStatusline.section_diagnostics({ trunc_width = 75 })
    local lsp            = MiniStatusline.section_lsp({ trunc_width = 75 })
    local filename       = MiniStatusline.section_filename({ trunc_width = 140 })
    local fileinfo       = MiniStatusline.section_fileinfo({ trunc_width = 120 })
    local location       = MiniStatusline.section_location({ trunc_width = 75 })
    local search         = MiniStatusline.section_searchcount({ trunc_width = 75 })

    return MiniStatusline.combine_groups({
      { hl = mode_hl,                 strings = { mode } },
      { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, lsp } },
      '%<', -- Mark general truncate point
      { hl = 'MiniStatuslineFilename', strings = { filename } },
      '%=', -- End left alignment
      { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
      { hl = mode_hl,                  strings = { search, location } },
    })
  end,
}

return M
