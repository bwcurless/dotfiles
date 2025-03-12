" ======================================
" ------ Generic Vim Settings --------
" ======================================

set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case

syntax enable

" Escape key timeout is too slow, enable timeout on keycodes, and reduce
" length of timeout, :h 'ttimeout' for more info
set ttimeout ttimeoutlen=50
set timeout timeoutlen=1000 " Timeout for normal key bindings

set shortmess+=I " Disable the default Vim startup message.

set number " Show line numbers.
set relativenumber " Show relative line numbers for easy jumping around

set laststatus=2 " Always show the status line at the bottom, even if you only have one window open.
set statusline=%<%f\ %h%m%r%{FugitiveStatusline()}%=%-14.(%l,%c%V%)\ %P

set backspace=indent,eol,start " backspace over anything.

set hidden " Allow hidden buffers. Just be careful to save and not force quit (q!)

set ignorecase
set smartcase
set incsearch " Enable searching as you type, rather than waiting till you press enter.

nnoremap Q <Nop> " 'Q' in normal mode enters Ex mode. You almost never want this.
set noerrorbells visualbell t_vb= " Disable audible bell because it's annoying.
set mouse+=a " Enable mouse support.


if !has('nvim')
    set completepopup=highlight:Pmenu
endif
set completeopt=menu,popup

" Persistent Undo
if has('persistent_undo')         "check if your vim version supports
	set undodir=$HOME/.vim/undo     "directory where the undo files will be stored
	set undofile                    "turn on the feature
endif

"Automatically update files when changed outside vim
set autoread

if ! exists("g:CheckUpdateStarted")
	let g:CheckUpdateStarted=1
	call timer_start(1,'CheckUpdate')
endif
function! CheckUpdate(timer)
	silent! checktime
	call timer_start(1000,'CheckUpdate')
endfunction

" ======================================
" -- Colors --
" ======================================

" Delay setting scheme until all plugins are loaded
autocmd vimenter * ++nested colorscheme gruvbox
set background=dark " dark mode

"Use 24-bit (true-color) mode in Vim.
if (has("termguicolors"))
	set termguicolors
endif


" ======================================
" ----- Generic Remaps ------
" ======================================

"Remap leader to space key for quicker access
nnoremap <SPACE> <Nop>
let mapleader=" "

" Pastes except don't overwrite yank register
xnoremap <leader>p	"_dP

" Navigation scrolling stay centered
"nnoremap <C-u> <C-u>zz
"nnoremap <C-d> <C-d>zz
nnoremap n	nzz
nnoremap N	Nzz
nnoremap * *zz
nnoremap # #zz

" Enable completion where available.
" This setting must be set before ALE is loaded.
if !has('nvim')
   let g:ale_completion_enabled = 1
endif

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

if !has('nvim')
   Plug 'w0rp/ale'
else
   Plug 'neovim/nvim-lspconfig'
endif

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'wellle/context.vim'

Plug 'markonm/traces.vim'

Plug 'lervag/vimtex'

" Snippet runtime
Plug 'SirVer/ultisnips'
" Snippet repo
Plug 'honza/vim-snippets'

Plug 'morhetz/gruvbox'

Plug 'tpope/vim-fugitive'

call plug#end()

" ======================================
" Plugin Specific Configs
" ======================================

" ======================================
" FZF
" ======================================

"Remap FZF commands for easier access
nnoremap <silent> <C-f> :Files<CR>
nnoremap <silent> <Leader>f :Rg<CR>
nnoremap <silent> <C-G> :GFiles<CR>
nnoremap <silent> <C-s> :Snippets<CR>
nnoremap <silent> <Leader>b :Buffers<CR>

" ======================================
" Ultisnip
" ======================================

" Ultisnip trigger configuration
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsListSnippets="<C-space>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
" Save time loading, don't scan all folders
" Snippets that I make go to default location
let g:UltiSnipsSnippetDirectories=["plugged/vim-snippets/UltiSnips", "UltiSnips"]
" Use <leader>u in normal mode to refresh UltiSnips snippets
nnoremap <leader>u <Cmd>call UltiSnips#RefreshSnippets()<CR>



" ======================================
" -- ALE --
" ======================================
if !has('nvim')
   set omnifunc=ale#completion#OmniFunc
   let g:ale_floating_preview = 1
   let g:ale_hover_to_floating_preview = 1
   let g:ale_floating_window_border = ['│', '─', '╭', '╮', '╯', '╰', '│', '─']
   
   " Nice commands to find definitions and symbols quickly
   nnoremap <leader>gd :ALEGoToDefinition<cr>
   nnoremap <leader>fr :ALEFindReferences -quickfix<cr>
   nnoremap <leader>ca :ALECodeAction<cr>
   xnoremap <leader>ca :ALECodeAction<cr>
   nnoremap <leader>r  :ALERename<cr>
   "nmap <silent> <C-\> <Plug>(ale_hover)
   imap <C-\> <Plug>(ale_hover)
   
   "Set up linters and fixers
   let g:ale_fix_on_save = 1
   let g:ale_echo_msg_format = '%linter% says %code%: %s'
   
   let g:ale_linters={
   			\'python': ['pylint', 'pylsp'],
   			\'c': ['clangd'],
   			\'cpp': ['clangd'],
   			\'cuda': ['clangd']
   			\}
   
   let g:ale_fixers={
   			\    '*': ['remove_trailing_lines', 'trim_whitespace'],
   			\    'python':['black'], 'c':['clangd'], 'cuda':['clang-format'],
   			\    'cpp':['clang-format']
   			\}
   
   let g:ale_cpp_cc_options = '-std=c++17 -Wall'
   let g:ale_cpp_clangd_options = '-std=c++17'
   
   "Shorten Black line length to match 79 for PEP8
   let g:ale_python_black_options='--line-length=79'
endif

" syntax highlight doxygen comments in C, C++, C#, IDL and PHP files
let g:load_doxygen_syntax=1
" cuda files aren't automatically syntax highlighted
au Syntax cuda
        \ if (exists('b:load_doxygen_syntax') && b:load_doxygen_syntax)
        \       || (exists('g:load_doxygen_syntax') && g:load_doxygen_syntax)
        \   | runtime! syntax/doxygen.vim
        \ | endif


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
