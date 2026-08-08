vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true

vim.o.number = true
vim.o.relativenumber = true

vim.o.mouse = "a"

vim.o.clipboard = "unnamedplus"

vim.o.undofile = true
vim.o.autoread = true

vim.o.cmdheight = 0
vim.o.laststatus = 3

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.updatetime = 50

vim.o.timeoutlen = 300

-- Preview substitutions live, as you type!
vim.o.inccommand = "split"

vim.o.scrolloff = 10

vim.o.hlsearch = false
vim.o.incsearch = true

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

vim.o.smartindent = true
vim.o.wrap = false

vim.diagnostic.config({
	virtual_text = {
		prefix = "●", -- or '■', '●', '▎', '◆', ''
		spacing = 2,
	},
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

vim.diagnostics = {
	os = {
		update_in_insert = true,
	},
}
