vim.cmd('source ~/.vimrc')

local hostname = vim.loop.os_gethostname()
local workPC = "WL-G7M2MN3"
local macbook = "Brians-Laptop"
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

-- Navigation scrolling stay centered
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Next, with centering', noremap = true })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Previous, with centering', noremap = true })
vim.keymap.set('n', 'n', 'nzz', { desc = 'Next, with centering', noremap = true })
vim.keymap.set('n', 'N', 'Nzz', { desc = 'Previous, with centering', noremap = true })
vim.keymap.set('n', '*', '*zz', { desc = 'Search forward, with centering', noremap = true })
vim.keymap.set('n', '#', '#zz', { desc = 'Search backward, with centering', noremap = true })

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

--------------------
-- Settings
--------------------
---
if hostname == macbook then
	vim.g.python3_host_prog = "/Users/briancurless/neovim_venv/bin/python3"
elseif hostname == workPC then
	vim.g.python3_host_prog = "C:\\Users\\BCurless\\AppData\\Local\\Programs\\Python\\Python312\\python.exe"
end


vim.g.have_nerd_font = false

vim.api.nvim_create_autocmd("VimEnter", {
    pattern = "*",
    callback = function()
        local sln_file = vim.fn.glob("*.sln") -- Check for .sln file in the current directory
        if sln_file ~= "" then
            vim.opt.makeprg = "dotnet build " .. sln_file .. " /p:Configuration=Debug"
            print("Makeprg set to build solution: " .. sln_file)
        end
    end,
})

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

-- Specify how the border looks like
local border = {
	{ '┌', 'FloatBorder' },
	{ '─', 'FloatBorder' },
	{ '┐', 'FloatBorder' },
	{ '│', 'FloatBorder' },
	{ '┘', 'FloatBorder' },
	{ '─', 'FloatBorder' },
	{ '└', 'FloatBorder' },
	{ '│', 'FloatBorder' },
}

-- Add border to the diagnostic popup window
vim.diagnostic.config({
	virtual_text = {
		prefix = '■ ', -- Could be '●', '▎', 'x', '■', , 
	},
	float = { border = border },
})

-------------------
--- Plugin setup
-------------------

-------------------
--- Autopairs Setup
-------------------
require("nvim-autopairs").setup {}

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

-----------------------
--- Treesitter
----------------------
---
require 'nvim-treesitter.configs'.setup {
	-- A list of parser names, or "all" (the listed parsers MUST always be installed)
	ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "cuda", "cpp", "python", "c_sharp" },

	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- Automatically install missing parsers when entering buffer
	-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
	auto_install = true,

	-- List of parsers to ignore installing (or "all")
	ignore_install = { "javascript" },

	---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
	-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

	highlight = {
		enable = true,

		-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
		-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
		-- the name of the parser)
		-- list of language that will be disabled
		-- disable = { "c", "rust" },
		-- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
		disable = function(lang, buf)
			local max_filesize = 100 * 1024 -- 100 KB
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			if ok and stats and stats.size > max_filesize then
				return true
			end
		end,

		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
	},
}

----------------------------------------
-- Ultisnip
----------------------------------------

-- Ultisnip trigger configuration
vim.g.UltiSnipsExpandTrigger = "<tab>"
vim.g.UltiSnipsListSnippets = "<C-space>"
vim.g.UltiSnipsJumpForwardTrigger = "<tab>"
vim.g.UltiSnipsJumpBackwardTrigger = "<s-tab>"
-- Save time loading, don't scan all folders
-- Snippets that I make go to default location
vim.g.UltiSnipsSnippetDirectories = { "plugged/vim-snippets/UltiSnips", "UltiSnips" }

vim.keymap.set('n', '<leader>u', '<Cmd>call UltiSnips#RefreshSnippets()<CR>',
	{ desc = 'Refresh snippets', noremap = true })

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
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
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
		--{ name = 'nvim_lsp_signature_help' },
	}, { { name = 'buffer' },
	})
})


-- Use this to set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

--------------------
-- LSP Configurations
--------------------
---
require("lazydev").setup({
	ft = "lua", -- only load on lua files
	opts = {
		library = {
			-- It can also be a table with trigger words / mods
			-- Only load luvit types when the `vim.uv` word is found
			{ path = "${3rd}/luv/library",        words = { "vim%.uv" } },
			-- always load the LazyVim library
			"LazyVim",
			-- Only load the lazyvim library when the `LazyVim` global is found
			{ path = "LazyVim",                   words = { "LazyVim" } },
			-- Load the xmake types when opening file named `xmake.lua`
			-- Needs `LelouchHe/xmake-luals-addon` to be installed
			{ path = "xmake-luals-addon/library", files = { "xmake.lua" } },
		},
		-- always enable unless `vim.g.lazydev_enabled = false`
		-- This is the default
		enabled = function(root_dir)
			return vim.g.lazydev_enabled == nil and true or vim.g.lazydev_enabled
		end,
	},
})

vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"


-- Add the border on hover and on signature help popup window
local handlers = {
	['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
	['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
}

require("mason").setup()

require 'lspconfig'.bashls.setup {
	handlers = handlers }
require 'lspconfig'.clangd.setup {
	handlers = handlers }
require 'lspconfig'.lua_ls.setup {
	handlers = handlers,
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

require 'lspconfig'.powershell_es.setup {
	handlers = handlers,
	cmd = { 'powershell.exe', '-NoLogo', '-NoProfile', '-Command', "~/AppData/Local/nvim-data/mason/packages/powershell-editor-services/PowerShellEditorServices/Start-EditorServices.ps1" },
	shell = 'powershell.exe',
	settings = { powershell = { codeFormatting = { Preset = 'OTBS' } } },
	init_options = {
		enableProfileLoading = false,
	},
}
require 'lspconfig'.pyright.setup {
	handlers = handlers,
}

require 'lspconfig'.omnisharp.setup {
	handlers = handlers,
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

require 'lspconfig'.vimls.setup {
	handlers = handlers,
}

-- Normal lsp Keymaps
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		local is_cs_file = vim.bo.filetype == "cs" or vim.bo.filetype == "csharp"
		if is_cs_file then
			print("Csharp file detected!")
			-- Special omnisharp lsp keymaps
			vim.keymap.set("n", "<leader>gd", "<Cmd>lua require('omnisharp_extended').lsp_definition()<CR>",
				{ noremap = true, silent = true })
			vim.keymap.set("n", "<leader>D",
				"<Cmd>lua require('omnisharp_extended').lsp_type_definition()<CR>",
				{ noremap = true, silent = true })
			vim.keymap.set("n", "<leader>fr", "<Cmd>lua require('omnisharp_extended').lsp_references()<CR>",
				{ noremap = true, silent = true })
			vim.keymap.set("n", "<leader>gi",
				"<Cmd>lua require('omnisharp_extended').lsp_implementation()<CR>",
				{ noremap = true, silent = true })
		else
			print("Other file detected!")
			if client.supports_method('textDocument/definition') then
				vim.api.nvim_set_keymap('n', '<leader>gd', '<Cmd>lua vim.lsp.buf.definition()<CR>',
					{ noremap = true, silent = true })
			end
			if client.supports_method('textDocument/references') then
				vim.api.nvim_set_keymap('n', '<leader>fr', '<Cmd>lua vim.lsp.buf.references()<CR>',
					{ noremap = true, silent = true })
			end
			if client.supports_method('textDocument/implementation') then
				vim.api.nvim_set_keymap('n', '<leader>gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>',
					{ noremap = true, silent = true })
			end
		end

		if client.supports_method('textDocument/rename') then
			vim.api.nvim_set_keymap('n', '<leader>r', '<Cmd>lua vim.lsp.buf.rename()<CR>',
				{ noremap = true, silent = true })
		end
		if client.supports_method('textDocument/code_action') then
			vim.api.nvim_set_keymap('n', '<leader>ca', '<Cmd>lua vim.lsp.buf.code_action()<CR>',
				{ noremap = true, silent = true })
		end
		if client.supports_method('textDocument/hover') then
			vim.api.nvim_set_keymap('n', '<C-k>', '<Cmd>lua vim.lsp.buf.hover()<CR>',
				{ noremap = true, silent = true })
		end
		if client.supports_method('textDocument/signature_help') then
			vim.api.nvim_set_keymap('i', '<C-s>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>',
				{ noremap = true, silent = true })
		end
		if client.supports_method('textDocument/format') then
			vim.api.nvim_set_keymap('n', '<leader>=', '<Cmd>lua vim.lsp.buf.format()<CR>',
				{ noremap = true, silent = true })
		end
	end
})
