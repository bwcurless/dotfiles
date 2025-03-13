vim.cmd('source ~/.vimrc')

--------------------
-- Plugins
--------------------

--------------------
-- Keymaps
--------------------

-- Remap leader to space key for quicker access
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.keymap.set('n', '<SPACE>', '<Nop>', { desc = 'Don\'t move cursor with space', noremap = true })

vim.keymap.set('x', '<leader>p', '"_dP', { desc = 'Paste, but delete to black hole first', noremap = true })

--[["
"nnoremap <C-u> <C-u>zz
"nnoremap <C-d> <C-d>zz
--]]
-- Navigation scrolling stay centered
vim.keymap.set('n', 'n', 'nzz', { desc = 'Next, with centering', noremap = true })
vim.keymap.set('n', 'N', 'Nzz', { desc = 'Previous, with centering', noremap = true })
vim.keymap.set('n', '*', '*zz', { desc = 'Search forward, with centering', noremap = true })
vim.keymap.set('n', '#', '#zz', { desc = 'Search backward, with centering', noremap = true })

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

--------------------
-- Settings
--------------------

vim.g.have_nerd_font = false

vim.opt.number = true         -- Show line numbers.
vim.opt.relativenumber = true -- Show relative line numbers for easy jumping around

vim.opt.mouse = 'a'

vim.opt.undofile = true

vim.opt.timeoutlen = 1000

vim.opt.hidden = true

vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.incsearch = true

vim.opt.completeopt = { 'menu', 'popup' }

vim.cmd.colorscheme 'tokyonight-night'

-- Auto update files when navigating to them
vim.go.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
	command = "if mode() != 'c' | checktime | endif",
	pattern = { "*" },
})

vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
vim.opt.grepformat = "%f:%l:%c:%m"


-------------------
--- Plugin setup
-------------------


-----------------------
--- Telescope setup
----------------------
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-f>', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<C-g>', builtin.git_files, { desc = 'Telescope find git files' })
vim.keymap.set('n', '<leader>fr', builtin.lsp_references, { desc = 'Telescope find references' })
vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep working directory' })
vim.api.nvim_create_user_command('Maps', function()
	builtin.keymaps()
end, { desc = 'Telescope keymaps' })
vim.api.nvim_create_user_command('Help', function()
	builtin.help_tags()
end, { desc = 'Telescope help tags' })

----------------------------------------
-- Ultisnip
----------------------------------------

-- Ultisnip trigger configuration
vim.g.UltiSnipsExpandTrigger="<tab>"
vim.g.UltiSnipsListSnippets="<C-space>"
vim.g.UltiSnipsJumpForwardTrigger="<tab>"
vim.g.UltiSnipsJumpBackwardTrigger="<s-tab>"
-- Save time loading, don't scan all folders
-- Snippets that I make go to default location
vim.g.UltiSnipsSnippetDirectories={"plugged/vim-snippets/UltiSnips", "MyUltiSnipsSnippets"}
-- vim.g.UltiSnipsSnippetStorageDirectoryForUltiSnipsEdit={"MyUltiSnipsSnippets"}
vim.keymap.set('n', '<leader>u', '<Cmd>call UltiSnips#RefreshSnippets()<CR>', {desc = 'Refresh snippets', noremap = true})

--------------------
-- nvim-cmp
--------------------

local cmp = require 'cmp'

cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
		end,
	},
	window = {
		-- completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'ultisnips' }, -- For ultisnips users.
	})
})


-- Use this to set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

--------------------
-- LSP Configurations
--------------------
require("mason").setup()

require 'lspconfig'.pylsp.setup {
	capabilities = capabilities
}

require 'lspconfig'.omnisharp.setup {
	cmd = { "omnisharp.cmd" },
	capabilities = capabilities,

	settings = {
		FormattingOptions = {
			-- Enables support for reading code style, naming convention and analyzer
			-- settings from .editorconfig.
			EnableEditorConfigSupport = true,
			-- Specifies whether 'using' directives should be grouped and sorted during
			-- document formatting.
			OrganizeImports = true,
		},
		MsBuild = {
			-- If true, MSBuild project system will only load projects for files that
			-- were opened in the editor. This setting is useful for big C# codebases
			-- and allows for faster initialization of code navigation features only
			-- for projects that are relevant to code that is being edited. With this
			-- setting enabled OmniSharp may load fewer projects and may thus display
			-- incomplete reference lists for symbols.
			LoadProjectsOnDemand = nil,
		},
		RoslynExtensionsOptions = {
			-- Enables support for roslyn analyzers, code fixes and rulesets.
			EnableAnalyzersSupport = true,
			-- Enables support for showing unimported types and unimported extension
			-- methods in completion lists. When committed, the appropriate using
			-- directive will be added at the top of the current file. This option can
			-- have a negative impact on initial completion responsiveness,
			-- particularly for the first few completion sessions after opening a
			-- solution.
			EnableImportCompletion = true,
			-- Only run analyzers against open files when 'enableRoslynAnalyzers' is
			-- true
			AnalyzeOpenDocumentsOnly = nil,
		},
		Sdk = {
			-- Specifies whether to include preview versions of the .NET SDK when
			-- determining which version to use for project loading.
			IncludePrereleases = nil,
		},
	},
}

require 'lspconfig'.clangd.setup {}

require 'lspconfig'.lua_ls.setup {
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = {
				version = 'LuaJIT', -- Neovim uses LuaJIT
			},
			diagnostics = {
				globals = { 'vim' }, -- Recognize 'vim' as a global
			},
			workspace = {
				library = {
					vim.api.nvim_get_runtime_file("", true), -- Make LSP aware of Neovim runtime files
				},
				checkThirdParty = false, -- Avoid warnings about third-party plugins
			},
			completion = {
				callSnippet = "Replace", -- Show function signatures in completion
			},
			telemetry = { enable = false },
		},
	},
}

vim.g.python3_host_prog = "C:\\Users\\BCurless\\AppData\\Local\\Programs\\Python\\Python312\\python.exe"

vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

vim.keymap.set("n", "<leader>gd", "<Cmd>lua require('omnisharp_extended').lsp_definition()<CR>",
	{ noremap = true, silent = true })
vim.keymap.set("n", "<leader>D", "<Cmd>lua require('omnisharp_extended').lsp_type_definition()<CR>",
	{ noremap = true, silent = true })
vim.keymap.set("n", "<leader>fr", "<Cmd>lua require('omnisharp_extended').lsp_references()<CR>",
	{ noremap = true, silent = true })
vim.keymap.set("n", "<leader>gi", "<Cmd>lua require('omnisharp_extended').lsp_implementation()<CR>",
	{ noremap = true, silent = true })

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client.supports_method('textDocument/definition') then
			vim.api.nvim_set_keymap('n', '<leader>gd', '<Cmd>lua vim.lsp.buf.definition()<CR>',
				{ noremap = true, silent = true })
		end
		if client.supports_method('textDocument/rename') then
			vim.api.nvim_set_keymap('n', '<leader>r', '<Cmd>lua vim.lsp.buf.rename()<CR>',
				{ noremap = true, silent = true })
		end
		if client.supports_method('textDocument/references') then
			vim.api.nvim_set_keymap('n', '<leader>fr', '<Cmd>lua vim.lsp.buf.references()<CR>',
				{ noremap = true, silent = true })
		end
		if client.supports_method('textDocument/code_action') then
			vim.api.nvim_set_keymap('n', '<leader>ca', '<Cmd>lua vim.lsp.buf.code_action()<CR>',
				{ noremap = true, silent = true })
		end
		if client.supports_method('textDocument/implementation') then
			vim.api.nvim_set_keymap('n', '<leader>gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>',
				{ noremap = true, silent = true })
		end
		if client.supports_method('textDocument/hover') then
			vim.api.nvim_set_keymap('n', '<C-\\>', '<Cmd>lua vim.lsp.buf.hover()<CR>',
				{ noremap = true, silent = true })
		end
		if client.supports_method('textDocument/signature_help') then
			vim.api.nvim_set_keymap('i', '<C-\\>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>',
				{ noremap = true, silent = true })
		end
		if client.supports_method('textDocument/format') then
			vim.api.nvim_set_keymap('n', '<leader>=', '<Cmd>lua vim.lsp.buf.format()<CR>',
				{ noremap = true, silent = true })
		end
	end
})
