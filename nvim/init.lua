require("options")
require("remaps")
require("lazy_setup")
require("colours")

vim.lsp.config('qmlls', {cmd = {'qmlls'}})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.workspace = capabilities.workspace or {}
capabilities.workspace.didChangeWatchedFiles = { dynamicRegistration = false }

vim.lsp.config("roslyn", { capabilities = capabilities })

vim.lsp.enable({ "ols", "lua_ls", "roslyn_ls", "qmlls", "clangd" })
