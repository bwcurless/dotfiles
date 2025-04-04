local builtin = require('telescope.builtin')

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
