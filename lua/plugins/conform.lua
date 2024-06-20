return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local conform = require("conform")

      conform.setup({
        formatters_by_ft = {
          -- ["*"] = { "codespell" },
          ["*.sh"] = { "shfmt", "shellcheck", "shellharden" },
          css = { "stylelint", "prettier" },
          cm = {},
          elixir = { "mix" },
          go = { "goimports", "gofumpt" },
          html = { "htmlbeautifier" },
          javascript = { "prettierd", "prettier" },
          javascriptreact = { "prettierd", "prettier" },
          json = { "fixjson", "jq" },
          lua = { "stylua" },
          -- markdown = { "mdformat" },
          python = function(bufnr)
            if require("conform").get_formatter_info("ruff_format", bufnr).available then
              return { "ruff_organize_imports", "ruff_format", "black" }
            else
              return { "isort", "black" }
            end
          end,
          ruby = { "rubocop" },
          sql = { "sqlfmt", "pg_format" },
          terraform = { "terraform_fmt" },
          typescript = { "prettierd", "prettier" },
          typescriptreact = { "prettierd", "prettier" },
          -- yaml = { "yamlfmt" },
          -- Use the "_" filetype to run formatters on filetypes that don't
          -- have other formatters configured.
          -- ["_"] = { "codespell" },
        },
        format_on_save = {
          lsp_format = "fallback",
          timeout_ms = 1000,
          -- quiet = true,
        },
      })

      vim.keymap.set({ "n", "v" }, "<leader>mp", function()
        conform.format({
          lsp_format = "fallback",
          timeout_ms = 1000,
        })
      end, { desc = "Format file or range (in visual mode)" })
    end,
  },
  -- {
  --   "cappyzawa/trim.nvim",
  --   event = { "BufReadPre", "BufWritePre" },
  --   config = function()
  --     require("trim").setup({
  --       python = false,
  --       patterns = {
  --         [[%s/\(\n\n\)\n\+/\1/]], -- replace multiple blank lines with a single line
  --       },
  --     })
  --   end,
  -- },
}
