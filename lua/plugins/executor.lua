return {
  "google/executor.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  lazy = true,
  config = function()
    require("executor").setup({
      use_split = false,
    })
  end,
}
