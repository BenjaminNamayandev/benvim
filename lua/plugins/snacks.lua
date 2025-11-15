return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,

	---@type snacks.Config
	opts = {
		-- enable the pieces that replace what you removed
		explorer = { enabled = true }, -- replaces neo-tree
		picker = { enabled = true }, -- replaces telescope
		notifier = {
			enabled = true, -- replaces noice (for notifications)
			timeout = 3000,
		},

		-- optional nice QoL bits
		quickfile = { enabled = true },
		indent = { enabled = true },
		scroll = { enabled = true },
		words = { enabled = true },
		statuscolumn = { enabled = true },
	},

	keys = {
		---------------------------------------------------------------------------
		-- Pickers (Telescope replacements)
		---------------------------------------------------------------------------
		-- was: <leader><leader> -> telescope find_files
		{
			"<leader><leader>",
			function()
				Snacks.picker.files()
			end,
			desc = "Find Files (Snacks)",
		},

		-- was: <leader>fg -> telescope live_grep
		{
			"<leader>sg",
			function()
				Snacks.picker.grep()
			end,
			desc = "Live Grep (Snacks)",
		},

		-- was: <leader>fb -> telescope buffers
		{
			"<leader>fb",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Buffers (Snacks)",
		},

		-- was: <leader>fh -> telescope help_tags
		{
			"<leader>fh",
			function()
				Snacks.picker.help()
			end,
			desc = "Help Tags (Snacks)",
		},

		---------------------------------------------------------------------------
		-- Explorer (Neo-tree replacement)
		---------------------------------------------------------------------------
		-- was: <leader>e -> Neotree toggle
		{
			"<leader>e",
			function()
				Snacks.explorer()
			end,
			desc = "File Explorer (Snacks)",
		},

		---------------------------------------------------------------------------
		-- Notifications (Noice-ish replacement)
		---------------------------------------------------------------------------
		{
			"<leader>n",
			function()
				Snacks.notifier.show_history()
			end,
			desc = "Notification History (Snacks)",
		},
		{
			"<leader>un",
			function()
				Snacks.notifier.hide()
			end,
			desc = "Dismiss All Notifications",
		},
	},
}
