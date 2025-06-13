local M = {
  {
    'neovim/nvim-lspconfig',
    lazy = true,
    event = 'BufReadPre',
    dependencies = { { 'j-hui/fidget.nvim', opts = {} } },
    config = function()
      vim.lsp.enable({
        'taplo',
        'phpactor',
        'jsonls',
        'jdtls',
        'gopls',
        'clangd',
        'tinymist',
        'pyright',
        'bashls',
        'lua_ls',
        'emmet_language_server',
        'hyprls',
        'rust_analyzer'
      })
    end,
  }
}

return M
