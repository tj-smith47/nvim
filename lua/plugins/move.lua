return {
  { -- Move Selected Text / Lines (Opt + j/k/h/l)
    "echasnovski/mini.move",
    config = function()
      require("mini.move").setup()
    end,
  },
}
