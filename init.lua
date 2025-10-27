-- 0. no-bloat neovim config for everyday dev work.
vim.pack.add({
	-- Configure LSPs
	{ src = "https://github.com/neovim/nvim-lspconfig", version = "v2.5.0" },
	-- Install LSPs, linters, formatters
	{ src = "https://github.com/mason-org/mason.nvim", version = "v2.1.0" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim", version = "v2.1.0" },
	{
		src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
		version = "517ef5994ef9d6b738322664d5fdd948f0fdeb46",
	},
	-- Nice status update
	{ src = "https://github.com/j-hui/fidget.nvim", version = "v1.6.1" },
	-- Nice colortheme
	{ src = "https://github.com/rose-pine/neovim", version = "v3.0.2" },
	-- lua stdlib2
	{ src = "https://github.com/nvim-lua/plenary.nvim", version = "v0.1.4" },
	-- Find, Filter, Preview, Pick.
	{ src = "https://github.com/nvim-telescope/telescope.nvim", version = "0.1.8" }, -- depends on plenary.nvim
	-- Rust LSP
	{ src = "https://github.com/mrcjkb/rustaceanvim", version = "v6.9.2" },
	-- Typescript LSP
	{ src = "https://github.com/pmizio/typescript-tools.nvim", version = "bf11d98ad5736e1cbc1082ca9a03196d45c701f1" },
	-- Highlight TODO-esque comments
	{ src = "https://github.com/folke/todo-comments.nvim", version = "v1.4.0" }, -- depends on plenary.nvim
	-- Formatting
	{ src = "https://github.com/stevearc/conform.nvim", version = "v9.1.0" },
	-- Completion
	{ src = "https://github.com/Saghen/blink.cmp", version = "v1.7.0" }, -- git tag v1.7.0
	-- Git integration
	{ src = "https://github.com/nvim-mini/mini-git", version = "v0.16.0" },
	{ src = "https://github.com/nvim-mini/mini.diff", version = "v0.16.0" },
	-- which key
	{ src = "https://github.com/folke/which-key.nvim", version = "v3.17.0" },
	-- Auto-pairing delimiters
	{ src = "https://github.com/m4xshen/autoclose.nvim", version = "3f86702b54a861a17d7994b2e32a7c648cb12fb1" },
})

-- 1. Remap keys
-- Set <space> as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 2. Set vim options
-- Show numbers
vim.o.number = true
vim.o.relativenumber = true

-- Sync clipboard between OS and Neovim.
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

-- 3. Set colorscheme
-- Configure options before setting colorscheme.
vim.cmd.colorscheme("rose-pine") -- default
-- vim.cmd.colorscheme "rose-pine-moon" -- darker
-- vim.cmd.colorscheme "rose-pine-dawn" -- light theme

-- 4. Load plugins
require("which-key").setup({})
require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
	ensure_installed = {
		"lua_ls",
		"stylua",
		"typescript-language-server",
	},
})

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = {
					"vim",
					"require",
				},
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
			telemetry = {
				enable = false,
			},
		},
	},
})

vim.lsp.config("typescript-tools", {
	filetypes = { "typescript" },
})

require("blink.cmp").setup({})
require("autoclose").setup({
	keys = {
		-- add custom symbols to auto-match
		-- ["$"] = { escape = true, close = true, pair = "$$", disabled_filetypes = {} },
	},
})

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
	},
	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})

require("fidget").setup({})
require("todo-comments").setup({
	opts = {
		keywords = {
			SAFETY = {
				icon = "☢",
				color = "warning",
				alt = { "SOUNDNESS", "UNSAFE", "UNSOUND" },
			},
			INVARIANT = {
				icon = "🦑",
				color = "hint",
			},
		},
	},
})

-- Load mini plugins
require("mini.git").setup()
require("mini.diff").setup({
	view = {
		style = "sign",
		signs = { add = "+", change = "~", delete = "-" },
	},
})

-- Load telescope
require("telescope").setup({})

-- 5. Keybinds
---- Keybinds to make split navigation easier.
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("n", "<leader>wv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
vim.keymap.set("n", "<leader>ws", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
vim.keymap.set("n", "<leader>we", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
vim.keymap.set("n", "<leader>wc", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

vim.keymap.set("n", "<leader>wh", "<C-w>h", { desc = "Split window vertically" }) -- move to window left of current window
vim.keymap.set("n", "<leader>wl", "<C-w>l", { desc = "Split window horizontally" }) -- move to window right of current window
vim.keymap.set("n", "<leader>wj", "<C-w>j", { desc = "Make splits equal size" }) -- move to window below the current window
vim.keymap.set("n", "<leader>wk", "<C-w>k", { desc = "Close current split" }) -- move to window above the current window

-- Git
vim.keymap.set("n", "<leader>gS", ":Git status<enter>", { desc = "status" })
vim.keymap.set("n", "<leader>gC", ":Git commit<enter>", { desc = "commit" })
vim.keymap.set("n", "<leader>gl", ":Git log<enter>", { desc = "log" })
vim.keymap.set({ "n", "x" }, "<leader>gs", MiniGit.show_at_cursor, { desc = "Show at cursor" })

-- Open file explorer in Normal mode
vim.keymap.set("n", "<leader>.", vim.cmd.Ex)

-- delete single character without copying into register
vim.keymap.set("n", "x", '"_x')

-- Override join-by-'J' to force cursor to remain in place
vim.keymap.set("n", "J", "mzJ`z")

-- Center window on current line
-- Note: It should be possible to replicate Emacs' `recenter-top-bottom` function
-- by cycling through `zz`->`zt`->`zb`->`zz`->.. on repeated keypresses.
vim.keymap.set("n", "<C-l>", "zz")

-- When highlighting search, clear by pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Keybindings for Telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
vim.keymap.set("n", "<C-p>", builtin.git_files, {})
vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "Find recently opened files" })
vim.keymap.set("n", "<leader>,", require("telescope.builtin").buffers, { desc = "Find existing buffers" })
vim.keymap.set("n", "<leader>ps", function()
	builtin.live_grep({})
end)
vim.keymap.set("n", "<leader>s", function()
	local opts = { winblend = 10, previewer = true }
	builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown(opts))
end, { desc = "Fuzzily search in current buffer" })

-- Coding keybidns / LSP keybinds
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
	callback = function(event)
		local bufnr = event.buf
		-- Enable inlay hints by default.
		vim.lsp.inlay_hint.enable(true)
		-- Jump to the definition of the word under your cursor.
		--  This is where a variable was first declared, or where a function is defined, etc.
		--  To jump back, press <C-t>.
		vim.keymap.set(
			"n",
			"<leader>cd",
			require("telescope.builtin").lsp_definitions,
			{ buffer = bufnr, desc = "[C]ode [D]efinition" }
		)

		-- Find references for the word under your cursor.
		vim.keymap.set(
			"n",
			"<leader>cD",
			require("telescope.builtin").lsp_references,
			{ buffer = bufnr, desc = "[C]ode References" }
		)

		-- Fuzzy find all the symbols in your current document.
		--  Symbols are things like variables, functions, types, etc.
		vim.keymap.set(
			"n",
			"<leader>cs",
			require("telescope.builtin").lsp_document_symbols,
			{ buffer = bufnr, desc = "Document [C]ode [S]ymbols" }
		)

		-- Fuzzy find all the symbols in your current workspace
		--  Similar to document symbols, except searches over your whole project.
		vim.keymap.set(
			"n",
			"<leader>cS",
			require("telescope.builtin").lsp_dynamic_workspace_symbols,
			{ buffer = bufnr, desc = "Document Workspace [C]ode [S]ymbols" }
		)

		-- Rename the variable under your cursor
		--  Most Language Servers support renaming across files, etc.
		vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { buffer = bufnr, desc = "[C]ode [R]ename" })

		-- Execute a code action, usually your cursor needs to be on top of an error
		-- or a suggestion from your LSP for this to activate.
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "[C]ode [A]ction" })

		-- Show errors in the current project
		vim.keymap.set(
			"n",
			"<leader>ce",
			require("telescope.builtin").diagnostics,
			{ buffer = bufnr, desc = "[C]ode [E]rrors" }
		)
	end,
})

-- TODO: Scope this ..
local set_rust_target = function(target)
	local fidget = require("fidget")
	fidget.notify("Switching rust-analyzer target => " .. target)
	-- https://github.com/mrcjkb/rustaceanvim/blob/fee0aa094b0c9f93fffe5a385b3d5d2386c2b072/lua/rustaceanvim/lsp/init.lua#L305-L308
	vim.cmd.RustAnalyzer({ "target", target })
end

-- a custom telescope picker for changing rust-analyzer target
local pick_rust_target = function(opts)
	opts = opts or {}
	require("telescope.pickers")
		.new(opts, {
			prompt_title = "rustup target list --installed",
			finder = require("telescope.finders").new_oneshot_job({ "rustup", "target", "list", "--installed" }, opts),
			sorter = require("telescope.config").values.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr, _)
				local actions = require("telescope.actions")
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = require("telescope.actions.state").get_selected_entry()
					set_rust_target(selection[1])
				end)
				return true
			end,
		})
		:find()
end

-- Pick a rust target triple
vim.keymap.set("n", "<leader>ctp", pick_rust_target, { desc = "Pick rust-analyzer target" })
-- Add a keybinding for quickly switching rust-analyser to use
-- the specified target triple.
local function add_rustc_target_map(keybinding, target)
	vim.keymap.set("n", ("<leader>" .. keybinding), function()
		set_rust_target(target)
	end, { desc = target })
end
add_rustc_target_map("cta", "aarch64-linux-android")
add_rustc_target_map("ctl", "x86_64-unknown-linux-gnu")
add_rustc_target_map("ctw", "x86_64-pc-windows-gnu")
