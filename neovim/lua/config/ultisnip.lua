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
