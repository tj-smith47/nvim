return {
  { -- Dim Unused Objects
    "zbirenbaum/neodim",
    event = "LspAttach",
    config = function()
      require("neodim").setup({
        refresh_delay = 50, -- time in ms to wait after typing before refresh diagnostics
        alpha = 0.75,
        blend_color = "#000000",
        hide = { underline = true, virtual_text = true, signs = true },
        disable = {}, -- table of filetypes to disable neodim
      })
    end,
  },
}
