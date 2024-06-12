return {
  { -- Go plugins
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    event = "CmdlineEnter",
    ft = { "go", "gomod" },
    opts = {
      goimports = "goimports",
      gofmt = "gofumpt",
      diagnostics = {
        update_in_insert = false,
        enable = true,
        linters = { "golangci-lint" },
        lint_debounce = "500ms",
        golint = true,
        goimport = true,
        govet = false,
        staticcheck = false,
      },
    },
    config = function(_, opts)
      -- checkhealth doesn't like this
      require("go").setup(opts)
    end,
  },
}
