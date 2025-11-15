return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			flavour = "mocha",
			integrations = {
				treesitter = true,
				telescope = true,
				mason = true,
				neotree = true,
			},
		})
		vim.cmd.colorscheme("catppuccin")

		-- yank highlight
		vim.api.nvim_set_hl(0, "YankHighlight", {
			bg = "#cba6f7",
			fg = "#1e1e2e",
			blend = 10,
		})

		vim.api.nvim_create_autocmd("TextYankPost", {
			callback = function()
				vim.highlight.on_yank({
					higroup = "YankHighlight",
					timeout = 200,
				})
			end,
		})
	end,
}
