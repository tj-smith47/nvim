local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  group = augroup("black"),
  command = "silent !ruff --fix %",
  pattern = "*.py",
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.tf", "*.tfvars", "*.ts", "*.tsx", "*.lua" },
  callback = function()
    vim.lsp.buf.format()
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("go"),
  callback = function()
    require('go.format').goimports()
  end,
  pattern = "*.go",
})

vim.api.nvim_create_autocmd({ "BufRead" }, {
  group = augroup("cm_yaml"),
  callback = function()
    vim.bo.filetype = "yaml"
  end,
  pattern = "*.cm",
})

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank()
  end,
  pattern = '*',
})

vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function(data)
    if vim.fn.isdirectory(data.file) == 1 then
      vim.cmd.enew()
      vim.cmd.bw(data.buf)
      vim.cmd.cd(data.file)
      require("nvim-tree.api").tree.open()
    end
  end,
})
