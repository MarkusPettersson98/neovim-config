-- 0. no-bloat neovim config for everyday dev work.
vim.pack.add {
	-- Configure LSPs
	{ src = 'https://github.com/neovim/nvim-lspconfig' },
	-- Install LSPs, linters, formatters
	{ src = 'https://github.com/mason-org/mason.nvim' },
	{ src = 'https://github.com/mason-org/mason-lspconfig.nvim' },
	{ src = 'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim' },
	-- Nice status update
	{ src = 'https://github.com/j-hui/fidget.nvim' },
	-- Nice colortheme
	{ src = 'https://github.com/rose-pine/neovim' },
	-- Find, Filter, Preview, Pick.
	{ src = 'https://github.com/nvim-telescope/telescope.nvim' },
		-- Telescope dependencies
		{ src = 'https://github.com/nvim-lua/plenary.nvim' },
	-- Rust LSP
	{ src = 'https://github.com/mrcjkb/rustaceanvim' },
}


-- 1. Remap keys
-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- 2. Set vim options
-- Show numbers
vim.o.number = true
vim.o.relativenumber = true


-- 3. Set colorscheme
-- Configure options before setting colorscheme.
vim.cmd.colorscheme "rose-pine" -- default
-- vim.cmd.colorscheme "rose-pine-moon" -- darker
-- vim.cmd.colorscheme "rose-pine-dawn" -- light theme

-- 4. Load plugins
require('mason').setup()
require('mason-lspconfig').setup()
require('mason-tool-installer').setup({
	ensure_installed = {
		"lua_ls",
		"stylua",
	}
})

vim.lsp.config('lua_ls', {
	settings = {
		Lua = {
			runtime = {
				version = 'LuaJIT',
			},
			diagnostics = {
				globals = {
					'vim',
					'require'
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

require('fidget').setup()

-- Load telescope
require('telescope').setup { }

-- 5. Keybinds
---- Keybinds to make split navigation easier.
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<leader>wv', '<C-w>v', { desc = 'Split window vertically' }) -- split window vertically
vim.keymap.set('n', '<leader>ws', '<C-w>s', { desc = 'Split window horizontally' }) -- split window horizontally
vim.keymap.set('n', '<leader>we', '<C-w>=', { desc = 'Make splits equal size' }) -- make split windows equal width & height
vim.keymap.set('n', '<leader>wc', '<cmd>close<CR>', { desc = 'Close current split' }) -- close current split window

vim.keymap.set('n', '<leader>wh', '<C-w>h', { desc = 'Split window vertically' }) -- move to window left of current window
vim.keymap.set('n', '<leader>wl', '<C-w>l', { desc = 'Split window horizontally' }) -- move to window right of current window
vim.keymap.set('n', '<leader>wj', '<C-w>j', { desc = 'Make splits equal size' }) -- move to window below the current window
vim.keymap.set('n', '<leader>wk', '<C-w>k', { desc = 'Close current split' }) -- move to window above the current window

-- Open file explorer in Normal mode
vim.keymap.set('n', '<leader>.', vim.cmd.Ex)

-- delete single character without copying into register
vim.keymap.set('n', 'x', '"_x')

-- Override join-by-'J' to force cursor to remain in place
vim.keymap.set('n', 'J', 'mzJ`z')

-- Center window on current line
-- Note: It should be possible to replicate Emacs' `recenter-top-bottom` function
-- by cycling through `zz`->`zt`->`zb`->`zz`->.. on repeated keypresses.
vim.keymap.set('n', '<C-l>', 'zz')

-- When highlighting search, clear by pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Keybindings for Telescope
local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = 'Find recently opened files' })
vim.keymap.set('n', '<leader>,', require('telescope.builtin').buffers, { desc = 'Find existing buffers' })
vim.keymap.set('n', '<leader>ps', function()
  builtin.live_grep {}
end)
vim.keymap.set('n', '<leader>s', function()
  local opts = { winblend = 10, previewer = true }
  builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown(opts))
end, { desc = 'Fuzzily search in current buffer' })
