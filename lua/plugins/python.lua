return {
  { -- Python Imports Handler
    'tjdevries/apyrori.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    -- config = {
    --   require('apyrori.config').new(
    --     'name_of_configuration',
    --     {
    --       command = 'grep',

    --       args    = function(text)
    --         return { 'the', 'commands', 'to', 'send', 'to', 'command' }
    --       end,

    --       -- results: the results of running the commands. Split on new lines
    --       -- counts: the counts of the various different import styles. Most common will be used.
    --       parser  = function(results, counts)
    --         for _, result in ipairs(results) do
    --           local split_result = require('apyrori.util').string_split(result, ":", 4)
    --           local value = split_result[4]

    --           if counts[value] == nil then
    --             counts[value] = 0
    --           end

    --           counts[value] = counts[value] + 1
    --         end
    --       end
    --     },
    --     true
    --   )
    -- },
  },
}
