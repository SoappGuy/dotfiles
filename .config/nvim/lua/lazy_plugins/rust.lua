return {
  {
    'mrcjkb/rustaceanvim',
    version = '^5',
    lazy = false,
  },
  {
    'saecki/crates.nvim',
    tag = 'stable',
    event = { 'BufRead Cargo.toml' },
    config = function()
      require('crates').setup {
        lsp = {
          enabled = true,
          actions = true,
          completion = true,
          hover = true,
        },
      }
    end,
  },
}
