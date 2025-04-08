--------------------
--- My Neovim Configuration!
--------------------

-- Remap leader to space key for quicker access, important to set this first, so leader based keymaps from plugins work
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.keymap.set('n', '<SPACE>', '<Nop>', { desc = 'Don\'t move cursor with space', silent = true })

require('globals')
require('plugins')
require('config')

--------------------
-- Keymaps
--------------------
-- My generic keymaps are here, but some specific keymaps are located in their own configs.
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
local host = Which_host()

-- Python 3 config. Each PC has to point neovim toward python3 so that ultisnips can run.
if host == "macbook" then
	print("Macbook launched nvim")
	vim.g.python3_host_prog = "/Users/briancurless/neovim_venv/bin/python3"
elseif host == "work" then
	print("Work pc launched nvim")
	vim.g.python3_host_prog = "C:\\Users\\BCurless\\AppData\\Local\\Programs\\Python\\Python312\\python.exe"
end


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
