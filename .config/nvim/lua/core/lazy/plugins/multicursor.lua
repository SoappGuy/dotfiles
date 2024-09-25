return {
  'jake-stewart/multicursor.nvim',
  branch = '1.0',
  config = function()
    local mc = require 'multicursor-nvim'

    mc.setup()

    -- Add cursors above/below the main cursor.
    vim.keymap.set({ 'n', 'v' }, '<leader>mk', function()
      mc.addCursor 'k'
    end, { desc = 'Add [m]ulticursor line above [k]' })
    vim.keymap.set({ 'n', 'v' }, '<leader>mj', function()
      mc.addCursor 'j'
    end, { desc = 'Add [m]ulticursor line below [j]' })

    -- Add a cursor and jump to the next word under cursor.
    vim.keymap.set({ 'n', 'v' }, '<leader>mn', function()
      mc.addCursor '*'
    end, { desc = 'Add [m]ulticursor on [n]ext word occurance' })

    -- Jump to the next word under cursor but do not add a cursor.
    vim.keymap.set({ 'n', 'v' }, '<leader>ms', function()
      mc.skipCursor '*'
    end, { desc = 'Search for next word occurance' })

    -- Rotate the main cursor.
    vim.keymap.set({ 'n', 'v' }, '<c-n>', mc.nextCursor)
    vim.keymap.set({ 'n', 'v' }, '<c-p>', mc.prevCursor)

    -- Delete the main cursor.
    vim.keymap.set({ 'n', 'v' }, '<leader>mx', mc.deleteCursor, { desc = 'Delete current cursor' })

    -- Add and remove cursors with control + left click.
    vim.keymap.set('n', '<c-leftmouse>', mc.handleMouse)

    vim.keymap.set({ 'n', 'v' }, '<leader>mq', function()
      if mc.cursorsEnabled() then
        -- Stop other cursors from moving.
        -- This allows you to reposition the main cursor.
        mc.disableCursors()
      else
        mc.addCursor()
      end
    end, { desc = 'Stop all, but current, cursors from moving' })

    vim.keymap.set('n', '<esc>', function()
      if not mc.cursorsEnabled() then
        mc.enableCursors()
      elseif mc.hasCursors() then
        mc.clearCursors()
      else
        -- Default <esc> handler.
        vim.cmd 'nohlsearch'
      end
    end)

    -- Align cursor columns.
    vim.keymap.set('n', '<leader>ma', mc.alignCursors, { desc = 'Align all cursor' })

    -- Split visual selections by regex.
    vim.keymap.set('v', 'S', mc.splitCursors)

    -- Append/insert for each line of visual selections.
    vim.keymap.set('v', 'I', mc.insertVisual)
    vim.keymap.set('v', 'A', mc.appendVisual)

    -- match new cursors within visual selections by regex.
    vim.keymap.set('v', 'M', mc.matchCursors)

    -- Customize how cursors look.
    vim.api.nvim_set_hl(0, 'MultiCursorCursor', { link = 'Cursor' })
    vim.api.nvim_set_hl(0, 'MultiCursorVisual', { link = 'Visual' })
    vim.api.nvim_set_hl(0, 'MultiCursorDisabledCursor', { link = 'Visual' })
    vim.api.nvim_set_hl(0, 'MultiCursorDisabledVisual', { link = 'Visual' })
  end,
}
