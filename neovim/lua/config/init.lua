-- Run all my independent configurations
require('config.cmp')
require('config.csharp')
require('config.keymaps')
-- Don't load LSP if performing a merge or diff
if vim.opt.diff:get() then
	print("Not loading LSP, detected diff mode.")
else
	require('config.lsp')
end
require('config.ocaml')
require('config.telescope')
require('config.terminal')
require('config.treesitter')
require('config.ultisnip')
require('config.vimtex')
require("nvim-autopairs").setup {}
