return {
  { -- View Markdown Live in the Browser
    'iamcco/markdown-preview.nvim',
    build = function() vim.fn["mkdp#util#install"]() end,
  },
}
