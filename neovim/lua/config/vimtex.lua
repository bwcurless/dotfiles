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
