return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  main = 'nvim-treesitter.configs', -- Sets main module to use for opts
  opts = {
    ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
    -- Autoinstall languages that are not installed
    auto_install = true,
    sync_install = false,
    highlight = { enable = true },
    indent = { enable = true },
  }
}
