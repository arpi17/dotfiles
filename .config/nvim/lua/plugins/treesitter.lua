-- Treesitter extensions that will be installed next to the default ones
return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    vim.list_extend(opts.ensure_installed, {
      "kdl",
      "swift",
    })
  end,
}
