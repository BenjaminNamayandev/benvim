return {
	"stevearc/oil.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons", -- optional but nice for icons
	},
	config = function()
		require("oil").setup({
			default_file_explorer = true, -- replace netrw
			view_options = {
				show_hidden = true, -- show dotfiles
			},
		})

		-- Open Oil in the current window
		vim.keymap.set("n", "<leader>ol", "<cmd>Oil<CR>", {
			desc = "Open Oil file explorer",
			silent = true,
		})
	end,
}
