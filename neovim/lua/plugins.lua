--------------------
-- Plugins
--------------------

-- Builtin Plugins
-- Allow filtering of the quickfix list when it is long.
vim.cmd('packadd cfilter')


-- External Plugins

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
Plug('nvimtools/none-ls.nvim')

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
