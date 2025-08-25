function Colour(color)
	color = color or "rose-pine"
	vim.cmd.colorscheme(color)
end

Colour("candle-grey")
