return {
	"folke/noice.nvim",
	event = "VeryLazy",

	dependencies = {
		"MunifTanjim/nui.nvim",
	},

	opts = {
		cmdline = {
			enabled = true,
			view = "cmdline_popup",
		},

		messages = {
			enabled = true,
			view = "mini", -- small inline popup for short messages
			view_error = "mini",
			view_warn = "mini",
			view_info = "mini",
			view_search = "virtualtext",
		},

		popupmenu = {
			enabled = true,
			backend = "nui",
		},

		notify = {
			enabled = false,
		},

		lsp = {
			progress = {
				enabled = true,
			},
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true,
			},
			hover = { enabled = true },
			signature = { enabled = true },
		},

		presets = {
			bottom_search = false, -- keep search in popup, not cmdline
			command_palette = true,
			long_message_to_split = true, -- long msgs -> split so they don’t spam UI
			inc_rename = false,
			lsp_doc_border = true,
		},
	},
}
