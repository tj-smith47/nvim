return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    {
      "antosha417/nvim-lsp-file-operations",
      config = true,
    },
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "mfussenegger/nvim-dap",
    {
      "folke/lazydev.nvim",
      ft = "lua", -- only load on lua files
      opts = {
        library = {
          "luvit-meta/library", -- see below
          plugins = {
            { "nvim-dap-ui" },
            types = true,
          },
        },
      },
    },
    {
      "Bilal2453/luvit-meta",
      lazy = true,
    }, -- optional `vim.uv` typings
  },
  config = function()
    local keymap = vim.keymap -- for conciseness

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf, silent = true }

        -- set keybinds
        opts.desc = "Go to reference"
        keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

        opts.desc = "Go to definition"
        keymap.set("n", "gd", vim.lsp.buf.definition, opts) -- go to definition

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

        opts.desc = "Show LSP definitions"
        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

        opts.desc = "Show general type definition"
        keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts) -- show general type definition

        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

        opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary

        opts.desc = "Rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- rename

        opts.desc = "Show signature help"
        keymap.set({ "n", "i" }, "<C-k>", vim.lsp.buf.signature_help, opts) -- show signature help

        opts.desc = "Show document symbols"
        keymap.set("n", "<leader>ds", "<cmd>Telescope lsp_document_symbols<CR>", opts) -- show document symbols

        opts.desc = "Show workspace symbols"
        keymap.set("n", "<leader>ws", "<cmd>Telescope lsp_workspace_symbols<CR>", opts) -- show workspace symbols

        opts.desc = "Hover Documentation"
        keymap.set("n", "K", vim.lsp.buf.hover, opts) -- hover documentation

        opts.desc = "Workspace add folder"
        keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts) -- workspace add folder

        opts.desc = "Workspace remove folder"
        keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts) -- workspace remove folder

        opts.desc = "Workspace list folders"
        keymap.set("n", "<leader>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts) -- workspace list folders

        -- Create a command `:Format` local to the LSP buffer
        -- vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
        --   vim.lsp.buf.format()
        -- end, { desc = "Format current buffer with LSP" })
      end,
    })

    -- Setup Handlers
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded", silent = true })
    vim.lsp.handlers["textDocument/signatureHelp"] =
      vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded", source = true })
    -- LSP integration
    -- Make sure to also have the snippet with the common helper functions in your config!

    -- local client_notifs = {}
    --
    -- local function get_notif_data(client_id, token)
    --   if not client_notifs[client_id] then
    --     client_notifs[client_id] = {}
    --   end
    --
    --   if not client_notifs[client_id][token] then
    --     client_notifs[client_id][token] = {}
    --   end
    --
    --   return client_notifs[client_id][token]
    -- end
    --
    -- local function format_title(title, client_name)
    --   return client_name .. (#title > 0 and ": " .. title or "")
    -- end
    --
    -- local function format_message(message, percentage)
    --   return (percentage and percentage .. "%\t" or "") .. (message or "")
    -- end
    --
    -- local spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }
    --
    -- local function update_spinner(c_id, token)
    --   local notif_data = get_notif_data(c_id, token)
    --
    --   if notif_data.spinner then
    --     local new_spinner = (notif_data.spinner + 1) % #spinner_frames
    --     notif_data.spinner = new_spinner
    --
    --     ---@diagnostic disable-next-line: lua_ls
    --     notif_data.notification = vim.notify(nil, nil, {
    --       hide_from_history = true,
    --       icon = spinner_frames[new_spinner],
    --       replace = notif_data.notification,
    --     })
    --
    --     vim.defer_fn(function()
    --       update_spinner(c_id, token)
    --     end, 100)
    --   end
    -- end
    --
    -- vim.lsp.handlers["$/progress"] = function(_, result, ctx)
    --   local client_id = ctx.client_id
    --
    --   local val = result.value
    --
    --   if not val.kind then
    --     return
    --   end
    --
    --   -- Utility functions shared between progress reports for LSP and DAP
    --
    --   local notif_data = get_notif_data(client_id, result.token)
    --
    --   if val.kind == "begin" then
    --     local message = format_message(val.message, val.percentage)
    --
    --     notif_data.notification = vim.notify(message, "info", {
    --       -- title = format_title(val.title, vim.lsp.get_client_by_id(client_id).name),
    --       icon = spinner_frames[1],
    --       timeout = false,
    --       hide_from_history = false,
    --     })
    --
    --     notif_data.spinner = 1
    --     update_spinner(client_id, result.token)
    --   elseif val.kind == "report" and notif_data then
    --     notif_data.notification = vim.notify(format_message(val.message, val.percentage), "info", {
    --       -- title = val.title,
    --       replace = notif_data.notification,
    --       hide_from_history = false,
    --       timeout = 2000,
    --     })
    --   elseif val.kind == "end" and notif_data then
    --     notif_data.notification =
    --       vim.notify(val.message and format_message(val.message) or "LSP setup complete!", "info", {
    --         icon = "",
    --         replace = notif_data.notification,
    --         timeout = 3000,
    --       })
    --
    --     notif_data.spinner = nil
    --   end
    -- end
    --
    -- Setup Diagnostics
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
      source = true,
      underline = false,
      update_in_insert = false,
      virtual_text = false,
    })
    vim.lsp.handlers["workspace/diagnostic/refresh"] = function(_, _, ctx)
      local ns = vim.lsp.diagnostic.get_namespace(ctx.client_id)
      local bufnr = vim.api.nvim_get_current_buf()
      vim.diagnostic.reset(ns, bufnr)
      return true
    end

    -- DAP integration
    -- Make sure to also have the snippet with the common helper functions in your config!
    -- local dap = require("dap")
    --
    -- dap.listeners.before["event_progressStart"]["progress-notifications"] = function(session, body)
    --   local notif_data = get_notif_data("dap", body.progressId)
    --
    --   local message = format_message(body.message, body.percentage)
    --   notif_data.notification = vim.notify(message, "info", {
    --     title = format_title(body.title, session.config.type),
    --     icon = spinner_frames[1],
    --     timeout = false,
    --     hide_from_history = false,
    --   })
    --
    --   notif_data.notification.spinner = 1, update_spinner("dap", body.progressId)
    -- end
    --
    -- dap.listeners.before["event_progressUpdate"]["progress-notifications"] = function(session, body)
    --   local notif_data = get_notif_data("dap", body.progressId)
    --   notif_data.notification = vim.notify(format_message(body.message, body.percentage), "info", {
    --     replace = notif_data.notification,
    --     hide_from_history = false,
    --   })
    -- end
    --
    -- dap.listeners.before["event_progressEnd"]["progress-notifications"] = function(session, body)
    --   local notif_data = client_notifs["dap"][body.progressId]
    --   notif_data.notification = vim.notify(body.message and format_message(body.message) or "Complete", "info", {
    --     icon = "",
    --     replace = notif_data.notification,
    --     timeout = 3000,
    --   })
    --   notif_data.spinner = nil
    -- end

    -- Change the Diagnostic symbols in the sign column (gutter)
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    -- Set User Config
    vim.diagnostic.config({
      float = {
        border = "rounded",
        source = true,
        -- style = "minimal",
      },
      severity_sort = true,
      underline = true,
      update_in_insert = false,
      virtual_text = false,
    })
  end,
}
