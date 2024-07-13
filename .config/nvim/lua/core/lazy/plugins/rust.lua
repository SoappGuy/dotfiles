return {
  {
    'mrcjkb/rustaceanvim',
    version = '^4',
    lazy = false,
  },
  {
    'saecki/crates.nvim',
    event = { 'BufRead Cargo.toml' },
    config = function()
      require('crates').setup()
    end,
  },
}
