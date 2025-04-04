--------------------
--- My Neovim Configuration!
--------------------

local hostname = vim.loop.os_gethostname()
local workPC = "WL-G7M2MN3"
local macbook = "Brians-Laptop"

--------------------
-- Globals
--------------------
function P(table)
	print(vim.inspect(table))
end

--------------------
-- Plugins
--------------------
---
local function file_exists(filepath)
	return vim.loop.fs_stat(filepath) ~= nil
end

-- Auto install Vim-Plug
local data_dir = vim.fn.stdpath('data') .. '/site'
if not file_exists(data_dir .. '/autoload/plug.vim') then
	vim.fn.execute(
		'!curl -fLo ' ..
		data_dir ..
		'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim',
		'silent')
	vim.api.nvim_create_autocmd('VimEnter', { pattern = '*', command = 'PlugInstall --sync' })
end

local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')

Plug('williamboman/mason.nvim')
Plug('neovim/nvim-lspconfig')

Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' })

Plug('folke/tokyonight.nvim')
Plug('folke/lazydev.nvim')

Plug('nvim-lua/plenary.nvim')
Plug('nvim-telescope/telescope.nvim', { ['branch'] = '0.1.x' })
Plug('nvim-telescope/telescope-fzf-native.nvim', { ['do'] = 'make' })

Plug('hrsh7th/nvim-cmp')
Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/cmp-buffer')
Plug('hrsh7th/cmp-nvim-lua')
Plug('quangnguyen30192/cmp-nvim-ultisnips')

-- Snippet runtime
Plug('SirVer/ultisnips')
-- Snippet repo
Plug('honza/vim-snippets')

Plug('Hoffs/omnisharp-extended-lsp.nvim')

Plug('windwp/nvim-autopairs')

Plug('lervag/vimtex')

Plug('tpope/vim-fugitive')


vim.call('plug#end')

--------------------
-- Keymaps
--------------------

-- Remap leader to space key for quicker access
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.keymap.set('n', '<SPACE>', '<Nop>', { desc = 'Don\'t move cursor with space', silent = true })

vim.keymap.set('x', '<leader>p', '"_dP', { desc = 'Paste, but delete to black hole first', silent = true })

-- Navigation scrolling stay centered
vim.keymap.set('n', '<C-u>', '<Cmd>normal! <C-u>zz<CR>', { desc = 'Scroll up, with centering', silent = true })
vim.keymap.set('n', '<C-d>', '<Cmd>normal! <C-d>zz<CR>', { desc = 'Scroll down, with centering', silent = true })
vim.keymap.set('n', 'n', '<Cmd>normal! nzz<CR>', { desc = 'Next, with centering', silent = true })
vim.keymap.set('n', 'N', '<Cmd>normal! Nzz<CR>', { desc = 'Previous, with centering', silent = true })
vim.keymap.set('n', '*', '<Cmd>normal! *zz<CR>', { desc = 'Search forward, with centering', silent = true })
vim.keymap.set('n', '#', '<Cmd>normal! #zz<CR>', { desc = 'Search backward, with centering', silent = true })

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')


--------------------
-- Settings
--------------------
---
if hostname == macbook then
	print("Macbook launched nvim")
	vim.g.python3_host_prog = "/Users/briancurless/neovim_venv/bin/python3"
elseif hostname == workPC then
	print("Work pc launched nvim")
	vim.g.python3_host_prog = "C:\\Users\\BCurless\\AppData\\Local\\Programs\\Python\\Python312\\python.exe"
else
	print("Unknown computer: " .. hostname .. " launched nvim. Python path is not specified")
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

-- Auto format if we have an lsp that supports it
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function()
		for _, client in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
			if client.supports_method('textDocument/format') then
				vim.lsp.buf.format()
				print("Auto formatting")
			end
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
--- Terminal setup
-------------------
vim.keymap.set({ 't' }, '<Esc><Esc>', '<C-\\><C-n>', { desc = "Easily escape terminal mode" })

--Configure terminal when it is opened
vim.api.nvim_create_autocmd({ "TermOpen" }, {
	group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
	callback = function()
		vim.opt.number = false
		vim.opt.relativenumber = false
		vim.api.nvim_cmd({ cmd = "startinsert" }, { output = false })
	end
})

-- Start terminal shortcut
vim.keymap.set('n', "<leader>st", function()
	vim.cmd.vnew()
	vim.cmd.term()
	vim.cmd.wincmd("J")
	vim.api.nvim_win_set_height(0, 10)
end)


-------------------
--- Plugin setup
-------------------

-------------------
--- Argument reorderer "( ... , ... , ... )"
--- 		          -->	<--
-------------------
local function swap_strings_on_lines(str1, row1, str2, row2)
	-- Multi line argument lists
	if row1 ~= row2 then
		local line1 = vim.api.nvim_buf_get_lines(0, row1, row1 + 1, true)[1]
		print(vim.inspect(line1))
		local temp1 = line1:gsub(vim.pesc(str1), str2, 1)
		vim.api.nvim_buf_set_lines(0, row1, row1 + 1, true, { temp1 })

		local line2 = vim.api.nvim_buf_get_lines(0, row2, row2 + 1, true)[1]
		print(vim.inspect(line2))
		local temp2 = line2:gsub(vim.pesc(str2), str1, 1)
		vim.api.nvim_buf_set_lines(0, row2, row2 + 1, true, { temp2 })
		-- Single line argument lists
	else
		local line = vim.api.nvim_buf_get_lines(0, row1, row1 + 1, true)[1]
		-- Replace first occurrence of str1 with a placeholder
		local temp = line:gsub(vim.pesc(str1), "TEMP_SWAP_PLACEHOLDER", 1)
		-- Replace first occurrence of str2 with str1
		temp = temp:gsub(vim.pesc(str2), str1, 1)
		-- Replace placeholder with str2
		temp = temp:gsub("TEMP_SWAP_PLACEHOLDER", str2, 1)

		vim.api.nvim_buf_set_lines(0, row1, row1 + 1, true, { temp })
	end
end

local function is_cursor_on_node(node)
	local cursor_row, cursor_col = unpack(vim.api.nvim_win_get_cursor(0))
	local start_row, start_col, end_row, end_col = node:range()

	cursor_row = cursor_row - 1
	-- Check if the cursor is inside this argument's range
	if cursor_row >= start_row and cursor_row <= end_row and cursor_col >= start_col and cursor_col <= end_col then
		return true
	else
		return false
	end
end


local function is_swappable_parent(node)
	if node:type() == "argument_list"
	    or node:type() == "arguments"
	    or node:type() == "parameters"
	    or node:type() == "parameter_list"
	    or node:type() == "type_argument_list" then
		return true
	else
		return false
	end
end

local function is_swappable_item(node)
	if node:type() == "argument"
	    or node:type() == "parameter"
	    or node:type() == "string"
	    or node:type() == "identifier" then
		return true
	else
		return false
	end
end

local function get_parentheses_node_around_cursor()
	local ts_utils = require("nvim-treesitter.ts_utils")
	local node = ts_utils.get_node_at_cursor()
	while node do
		if is_swappable_parent(node) then
			print("node is: " .. node:type())
			return node
		end
		node = node:parent()
	end
	return nil
end

local function swap_argument_right()
	local node = get_parentheses_node_around_cursor()
	if not node then
		print("Cursor is not inside parentheses!")
		return
	end

	local left_arg, left_row = nil, nil
	for child in node:iter_children() do
		if is_swappable_item(child) then
			local arg_text = vim.treesitter.get_node_text(child, 0)
			if is_cursor_on_node(child) then
				left_arg = arg_text
				left_row, _, _, _ = child:range()
			elseif left_arg ~= nil then
				local right_arg = arg_text
				local right_row, _, _, _ = child:range()
				-- Swap the two
				swap_strings_on_lines(left_arg, left_row, right_arg, right_row)
				-- Shift the cursor back to where it was before
				local escape_str = vim.pesc(left_arg)
				vim.fn.search(escape_str)

				return
			end
		end
	end
	print("Can't shift, already rightmost argument")
end

local function swap_argument_left()
	local node = get_parentheses_node_around_cursor()
	if not node then
		print("Cursor is not inside parentheses!")
		return
	end

	local left_arg, left_row = nil, nil
	for child in node:iter_children() do
		if is_swappable_item(child) then
			local arg_text = vim.treesitter.get_node_text(child, 0)
			if is_cursor_on_node(child) then
				if (not left_arg) then
					print("Can't shift, already leftmost argument")
					return
				end

				local right_arg = arg_text
				local right_row = child:range()
				-- Swap the two
				swap_strings_on_lines(left_arg, left_row, right_arg, right_row)
				-- Shift the cursor back to where it was before
				local escape_str = vim.pesc(right_arg)
				vim.fn.search(escape_str, 'b')

				return
			else
				-- Update left argument
				left_arg = arg_text
				left_row, _, _, _ = child:range()
			end
		end
	end
end

--[[
local function repeatable_swap_arg_left()
	swap_argument_left()
	vim.fn["repeat#set"](":lua repeatable_swap_arg_left()<CR>")
end
--]]

vim.keymap.set('n', '<leader>al', swap_argument_left,
	{ desc = "Shift argument left", silent = true })
vim.keymap.set('n', '<leader>ar', swap_argument_right,
	{ desc = "Shift argument right", silent = true })

-------------------
--- Autopairs Setup
-------------------
require("nvim-autopairs").setup {}


-----------------------
--- Vimtex Setup
----------------------
-- Spellcheck fixes
vim.api.nvim_create_autocmd({ 'FileType' }, {
	pattern = { "tex" },
	callback = function()
		print("Entering a tex file")
		vim.opt_local.spell = true
		vim.opt_local.spelllang = "en_us"
		vim.opt.conceallevel = 2
		-- Map `j` to `gj` and `k` to `gk`, which makes it easier to navigate wrapped lines.
		vim.keymap.set('n', 'j', 'gj', { buffer = true })
		vim.keymap.set('n', 'k', 'gk', { buffer = true })
		-- Jump to previous spelling mistake [s, pick the first suggestion
		-- 1z=, jumps back ']a. <c-g>u allows undo
		-- inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
	end
})
if vim.fn.has('unix') then
	if vim.fn.has('mac') then     -- osx
		vim.g.vimtex_view_method = 'skim'
		vim.g.vimtex_view_skim_sync = 1 -- allows forward search after every compilation
		vim.g.vimtex_view_skim_activate = 1 -- allows change focus to skim after `:VimtexView`
	else                          -- linux, bsd, etc
		vim.g.vimtex_view_method = 'zathura'
	end
end
vim.g.tex_flavor = 'latex'
vim.g.vimtex_log_verbose = 1
vim.g.vimtex_quickfix_mode = 1
vim.g.vimtex_quickfix_open_on_warning = 0
vim.g.tex_conceal = 'abdmg'
-- Filter out some compilation warning messages from QuickFix display
vim.g.vimtex_quickfix_ignore_filters = {
	'Underfull \\hbox',
	'Overfull \\hbox',
	'LaTeX Warning: .+ float specifier changed to',
	'LaTeX hooks Warning',
	'Package siunitx Warning: Detected the "physics" package:',
	'Package hyperref Warning: Token not allowed in a PDF string',
}

-----------------------
--- Telescope setup
----------------------
-- You dont need to set any of these options. These are the default ones. Only
-- the loading is important
require('telescope').setup {
	extensions = {
		fzf = {
			fuzzy = true, -- false will only do exact matching
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			-- the default case_mode is "smart_case"
		}
	}
}
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')

local builtin = require('telescope.builtin')

-- Keymaps
-- Note look at on LspAttach event to see more Telescope bindings
vim.keymap.set('n', '<C-f>', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<C-g>', builtin.git_files, { desc = 'Telescope find git files' })
vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep working directory' })
vim.keymap.set('n', '<leader>fc', builtin.grep_string,
	{ desc = 'Telescope grep string under cursor in working directory' })
vim.keymap.set("n", "<leader>fl", function()
	require('telescope.builtin').live_grep({
		prompt_title = "Search through plugins",
		cwd = vim.fn.stdpath("data") .. "/plugged",
		extensions = { "lua" }
	})
end, { desc = "Find Lua files" })

-- Commands (I use these less frequently)
vim.api.nvim_create_user_command('Maps', function()
	builtin.keymaps()
end, { desc = 'Telescope keymaps' })
vim.api.nvim_create_user_command('Help', function()
	builtin.help_tags()
end, { desc = 'Telescope help tags' })
vim.api.nvim_create_user_command('Qf', function()
	builtin.quickfix()
end, { desc = 'Telescope quickfix list' })
vim.api.nvim_create_user_command('Reg', function()
	builtin.registers()
end, { desc = 'Telescope registers' })
vim.api.nvim_create_user_command('Commits', function()
	builtin.git_commits()
end, { desc = 'Telescope git commits' })
vim.api.nvim_create_user_command('BCommits', function()
	builtin.git_bcommits()
end, { desc = 'Telescope git commits on this buffer' })

-----------------------
--- Treesitter
----------------------

require 'nvim-treesitter.configs'.setup {
	-- A list of parser names, or "all" (the listed parsers MUST always be installed)
	ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "cuda", "cpp", "python", "c_sharp", "xml" },

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

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, { pattern = { "*.xaml" }, command = "set filetype=xml" })

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
		{ name = 'nvim_lua' },
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
require 'lspconfig'.jsonls.setup {
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
				-- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
				disable = { 'missing-fields' },
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
			EnableEditorConfigSupport = false,
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
			LoadProjectsOnDemand = false,
		},
		RoslynExtensionsOptions = {
			-- Enables support for roslyn analyzers, code fixes and rulesets.
			EnableAnalyzersSupport = false,
			-- Enables support for showing unimported types and unimported extension
			-- methods in completion lists. When committed, the appropriate using
			-- directive will be added at the top of the current file. This option can
			-- have a negative impact on initial completion responsiveness,
			-- particularly for the first few completion sessions after opening a
			-- solution.
			EnableImportCompletion = false,
			-- Only run analyzers against open files when 'enableRoslynAnalyzers' is
			-- true
			AnalyzeOpenDocumentsOnly = true,
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
			print("On LspAttach: Csharp file detected!")
			-- Special omnisharp lsp keymaps
			vim.keymap.set("n", "<leader>gd", function()
					require('omnisharp_extended').telescope_lsp_definition()
				end,
				{ desc = 'omnisharp go to definition' })
			vim.keymap.set("n", "<leader>fr",
				function()
					require("omnisharp_extended").telescope_lsp_references(require(
						"telescope.themes").get_ivy({ excludeDefinition = true }))
				end,
				{ desc = 'omnisharp go to references' })
			vim.keymap.set("n", "<leader>gi",
				function()
					require('omnisharp_extended').telescope_lsp_implementation()
				end,
				{ desc = 'omnisharp go to implementation' })
		else
			print("On LspAttach: Other file detected!")
			if client.supports_method('textDocument/definition') then
				vim.keymap.set('n', '<leader>gd', function()
						vim.lsp.buf.definition()
					end,
					{ desc = 'Go to LSP definition' })
			end
			if client.supports_method('textDocument/references') then
				vim.keymap.set('n', '<leader>fr', builtin.lsp_references,
					{ desc = 'Telescope find references' })
			end
			if client.supports_method('textDocument/implementation') then
				vim.keymap.set('n', '<leader>gi', function()
						builtin.lsp_implementations()
					end,
					{ desc = 'Telescope go to implementations' })
			end
		end

		if client.supports_method('workspace/symbol') then
			vim.keymap.set('n', '<leader>fs', builtin.lsp_workspace_symbols,
				{ desc = 'Telescope find workspace symbols' })
		end
		if client.supports_method('textDocument/symbol') then
			vim.keymap.set('n', '<leader>ds', builtin.lsp_document_symbols,
				{ desc = 'Telescope find document symbols' })
		end
		if client.supports_method('textDocument/rename') then
			vim.api.nvim_set_keymap('n', '<leader>r', '<Cmd>lua vim.lsp.buf.rename()<CR>',
				{ desc = 'Telescope find document symbols' })
		else
			print(
				"Language server doesn't support textDocument/rename. Binding up rename shortcut anyways. This appears to be a bug")
			vim.api.nvim_set_keymap('n', '<leader>r', '<Cmd>lua vim.lsp.buf.rename()<CR>',
				{ desc = 'Lsp rename' })
		end
		if client.supports_method('textDocument/code_action') then
			vim.api.nvim_set_keymap('n', '<leader>ca', '<Cmd>lua vim.lsp.buf.code_action()<CR>',
				{ desc = 'Lsp execute code action' })
		end
		if client.supports_method('textDocument/hover') then
			vim.api.nvim_set_keymap('n', '<C-k>', '<Cmd>lua vim.lsp.buf.hover()<CR>',
				{ desc = 'Lsp hover' })
		end
		if client.supports_method('textDocument/signature_help') then
			vim.api.nvim_set_keymap('i', '<C-s>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>',
				{ desc = 'Lsp signature help' })
		end
		if client.supports_method('textDocument/format') then
			vim.api.nvim_set_keymap('n', '<leader>=', '<Cmd>lua vim.lsp.buf.format()<CR>',
				{ desc = 'Lsp format current buffer' })
		end
	end
})
