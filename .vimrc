" ======================================
" Plugins
" ======================================

"Auto install Vim-Plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
	silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

Plug 'williamboman/mason.nvim'
Plug 'neovim/nvim-lspconfig'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'folke/tokyonight.nvim'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }

Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'

" Snippet runtime
Plug 'SirVer/ultisnips'
" Snippet repo
Plug 'honza/vim-snippets'

Plug 'wellle/context.vim'

Plug 'windwp/nvim-autopairs'

Plug 'lervag/vimtex'

Plug 'tpope/vim-fugitive'

call plug#end()

" ======================================
" Plugin Specific Configs
" ======================================

" ======================================
" -- LaTex --
" ======================================

" Spellcheck fixes
autocmd FileType tex setlocal spell
autocmd FileType tex set spelllang=en_us
" Jump to previous spelling mistake [s, pick the first suggestion
" 1z=, jumps back ']a. <c-g>u allows undo
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

"Vimtex setup
" Map `Y` to `y$` (copy from current cursor position to the end of the line),
" which makes Y work analogously to `D` and `C`.
" (Not vi compatible, and enabled by default on Neovim)
autocmd FileType tex nnoremap <buffer> Y y$
" Map `j` to `gj` and `k` to `gk`, which makes it easier to navigate wrapped lines.
autocmd FileType tex nnoremap <buffer> j gj
autocmd FileType tex nnoremap <buffer> k gk

let g:tex_flavor='latex'
if has('unix')
	if has('mac')       " osx
		let g:vimtex_view_method='skim'
		let g:vimtex_view_skim_sync = 1 " allows forward search after every compilation
		let g:vimtex_view_skim_activate = 1 " allows change focus to skim after `:VimtexView`

	else                " linux, bsd, etc
		let g:vimtex_view_method='zathura'
	endif
endif
let g:vimtex_log_verbose=1
let g:vimtex_quickfix_mode=1
let g:vimtex_quickfix_open_on_warning=0
set conceallevel=2
let g:tex_conceal='abdmg'
" Filter out some compilation warning messages from QuickFix display
let g:vimtex_quickfix_ignore_filters = [
			\ 'Underfull \\hbox',
			\ 'Overfull \\hbox',
			\ 'LaTeX Warning: .\+ float specifier changed to',
			\ 'LaTeX hooks Warning',
			\ 'Package siunitx Warning: Detected the "physics" package:',
			\ 'Package hyperref Warning: Token not allowed in a PDF string',
			\]
