return {
  -- Copilot
  "github/copilot.vim",

  -- Other AI Plugins
  {
    "jackMort/ChatGPT.nvim",
    config = function()
      require("chatgpt").setup()
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },
  {
    "dpayne/CodeGPT.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("codegpt.config")
    end,
  },
  -- {
  --   "robitx/gp.nvim",
  --   config = function()
  --     require("gp").setup({
  --       hooks = {
  --         -- example of adding command which writes unit tests for the selected code
  --         UnitTests = function(gp, params)
  --           local template = "I have the following code from {{filename}}:\n\n"
  --             .. "```{{filetype}}\n{{selection}}\n```\n\n"
  --             .. "Please respond by writing table driven unit tests for the code above."
  --           local agent = gp.get_command_agent()
  --           gp.Prompt(params, gp.Target.enew, nil, agent.model, template, agent.system_prompt)
  --         end,
  --       },
  --     })
  --   end,
  -- },
  {
    "robitx/gp.nvim",
    tag = "v3.5.1",
    config = function()
      local conf = {
        openai_api_key = os.getenv("OPENAI_API_KEY"),
        providers = {
          openai = {
            disable = false,
            endpoint = "https://api.openai.com/v1/chat/completions",
            secret = os.getenv("OPENAI_API_KEY"),
          },
        },
      }
      require("gp").setup(conf)
    end,
  },
}
