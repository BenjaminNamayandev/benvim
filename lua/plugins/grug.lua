return {
	"MagicDuck/grug-far.nvim",
	config = function()
		local grug = require("grug-far")

		grug.setup({})

		vim.keymap.set("n", "<leader>gr", function()
			grug.open()
		end, { desc = "[S]earch [R]eplace (Grug)" })

		vim.keymap.set("n", "<leader>gR", function()
			grug.open({
				search = vim.fn.expand("<cword>"),
			})
		end, { desc = "[S]earch [R]eplace word (Grug)" })

		vim.keymap.set("v", "<leader>gr", function()
			local save_reg = vim.fn.getreg('"')
			vim.cmd('normal! "vy')
			local text = vim.fn.getreg('"')
			vim.fn.setreg('"', save_reg)

			grug.open({
				search = text,
			})
		end, { desc = "[S]earch [R]eplace selection (Grug)" })
	end,
}
