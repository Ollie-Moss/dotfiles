require("options")
require("remaps")
require("lazy_setup")
require("colours")

vim.lsp.config('qmlls', {cmd = {'qmlls6'}})

vim.lsp.enable({ "ols", "lua_ls", "roslyn_ls", "qmlls" })
