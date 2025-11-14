-- =========================
-- Basic settings
-- =========================
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.splitright = true
vim.opt.splitbelow = true

-- =========================
-- Bootstrap lazy.nvim (plugin manager)
-- =========================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- =========================
-- Plugins
-- =========================
require("lazy").setup({

	-- Neo-tree
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		lazy = false,
		config = function()
			require("neo-tree").setup({
				window = {
					mappings = {
						-- stop Neo-tree from using `e` so we can use it as a global toggle
						["e"] = "none",
						["<leader>e"] = "none",
					},
				},
			})

			-- global toggle key (works in normal buffers AND in Neo-tree)
			vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", {
				desc = "Toggle Neo-tree",
				silent = true,
				noremap = true,
			})
		end,
	},
	-- LSP + Mason (language servers) + format on save
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"ts_ls", -- JS / TS (new name, was tsserver)
					"pyright", -- Python
					"lua_ls", -- Lua
					"clangd", -- C / C++
					"jdtls", -- Java
					"rust_analyzer", -- Rust
					"omnisharp", -- C#
				},
				automatic_installation = true,
			})

			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local on_attach = function(_, bufnr)
				local map = function(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
				end

				map("n", "gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
				map("n", "K", vim.lsp.buf.hover, "Hover")
				map("n", "gr", vim.lsp.buf.references, "[G]oto [R]eferences")
				map("n", "<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
				map("n", "<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

				-- Manual format: <leader>f
				map("n", "<leader>f", function()
					vim.lsp.buf.format({ async = false })
				end, "[F]ormat file")
			end

			-- Apply these defaults to *all* LSP servers
			vim.lsp.config("*", {
				capabilities = capabilities,
				on_attach = on_attach,
			})

			-- Enable the servers you care about
			local servers = {
				"ts_ls",
				"pyright",
				"lua_ls",
				"clangd",
				"jdtls",
				"rust_analyzer",
				"omnisharp",
			}

			for _, server in ipairs(servers) do
				vim.lsp.enable(server)
			end

			-- Format on save using LSP
			local augroup = vim.api.nvim_create_augroup("LspFormatOnSave", { clear = true })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				callback = function(event)
					local clients = vim.lsp.get_clients({ bufnr = event.buf })
					if #clients > 0 then
						vim.lsp.buf.format({ bufnr = event.buf })
					end
				end,
			})
		end,
	},

	-- Noice
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			-- add any options here
		},
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
		},
	},
	-- Grug-far (search/replace UI)
	{
		"MagicDuck/grug-far.nvim",
		config = function()
			require("grug-far").setup({})
		end,
	},

	-- Completion (IntelliSense UI)
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
					{ name = "path" },
				}),
			})
		end,
	},

	-- toggleterm
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup({
				direction = "float", -- or "horizontal" / "vertical"
			})

			-- Use count + <C-/> to pick terminal number.
			-- <C-/> is <C-_> in keymap notation.
			local function toggle_term_with_count()
				local count = vim.v.count
				if count == 0 then
					vim.cmd("ToggleTerm") -- default terminal (1)
				else
					vim.cmd(count .. "ToggleTerm") -- e.g. 2ToggleTerm, 3ToggleTerm
				end
			end

			vim.keymap.set({ "n", "t" }, "<C-_>", toggle_term_with_count, {
				desc = "Toggle terminal (with count)",
			})
		end,
	},
	-- Autopairs
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},

	-- Catppuccin Color Scheme
	{
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

			-- 👇 Purple, smooth yank highlight
			vim.api.nvim_set_hl(0, "YankHighlight", {
				bg = "#cba6f7", -- Catppuccin purple
				fg = "#1e1e2e", -- Dark text so it’s readable
				blend = 10, -- Slight blend for smoothness
			})

			vim.api.nvim_create_autocmd("TextYankPost", {
				callback = function()
					vim.highlight.on_yank({
						higroup = "YankHighlight",
						timeout = 200, -- ms; tweak: 150–250 for feel
					})
				end,
			})
		end,
	},

	-- Treesitter (better syntax highlighting & indent)
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"lua",
					"python",
					"javascript",
					"typescript",
					"html",
					"css",
				},
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},

	-- Telescope = fuzzy finder
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.6",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local telescope = require("telescope")
			local builtin = require("telescope.builtin")

			telescope.setup({
				defaults = {
					layout_config = {
						prompt_position = "top",
					},
					sorting_strategy = "ascending",
					mappings = {
						i = {
							["<C-k>"] = "move_selection_previous",
							["<C-j>"] = "move_selection_next",
						},
					},
				},
			})

			-- Keymaps for Telescope
			vim.keymap.set("n", "<leader><leader>", builtin.find_files, { desc = "[F]ind [F]iles" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind by [G]rep" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "[F]ind [B]uffers" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp" })
		end,
	},
})
