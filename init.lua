vim.cmd('source ~/.vimrc')

require 'lspconfig'.pylsp.setup {}
require 'lspconfig'.clangd.setup {}
require 'lspconfig'.lua_ls.setup {
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

vim.g.python3_host_prog = "/Users/briancurless/neovim_venv/bin/python3"

vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
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
