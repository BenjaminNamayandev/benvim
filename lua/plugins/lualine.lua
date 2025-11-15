return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons", -- optional, but gives you nice icons
	},
	config = function()
		-- Hide the built-in "-- INSERT --" etc, since lualine will show mode
		vim.o.showmode = false

		-- Always show a single global statusline
		vim.o.laststatus = 3

		require("lualine").setup({
			options = {
				theme = "catppuccin", -- matches your colorscheme
				icons_enabled = true,
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
			},
			sections = {
				-- `mode` on the far left: NORMAL / INSERT / VISUAL etc.
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { "filename" },
				lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
		})
	end,
}
