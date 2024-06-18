local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- [[ Format on save: Go ]]
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("go"),
  callback = function()
    require("go.format").goimports()
  end,
  pattern = "*.go",
})

-- [[ Format on save: Python ]]
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  group = augroup("black"),
  command = "silent !ruff --fix %",
  pattern = "*.py",
})

-- [[ Format on save: Terraform, TypeScript, Lua ]]
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.tf", "*.tfvars", "*.ts", "*.tsx", "*.lua" },
  callback = function()
    vim.lsp.buf.format()
  end,
})

-- [[ Disable format-on-save for *.cm files ]]
vim.api.nvim_create_autocmd({ "BufReadPre", "BufWritePre" }, {
  group = augroup("disable_format_on_save"),
  command = "setlocal formatprg=",
  pattern = { "*.cm", ".cm/*.cm" },
})

-- [[ Highlight on yank ]]
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank()
  end,
  pattern = "*",
})

-- [[ Open nvim-tree when opening a directory ]]
vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function(data)
    if vim.fn.isdirectory(data.file) == 1 then
      vim.cmd("enew")
      vim.cmd.bw(data.buf)
      vim.cmd.cd(data.file)
      require("nvim-tree.api").tree.toggle()
      -- Move focus back to the file
      vim.cmd.wincmd("p")
    end
  end,
})
