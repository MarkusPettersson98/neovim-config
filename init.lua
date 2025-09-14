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
