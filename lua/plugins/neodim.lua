return {
  { -- Dim Unused Objects
    "zbirenbaum/neodim",
    event = "LspAttach",
    config = function()
      require("neodim").setup({
        alpha = 0.75,
        blend_color = "#000000",
        disable = {}, -- table of filetypes to disable neodim
        hide = { underline = true, virtual_text = true, signs = true },
        refresh_delay = 50, -- time in ms to wait after typing before refresh diagnostics
      })
    end,
  },
}
