" Comments in Vimscript start with a `"`

" If you open this file in Vim, it'll be syntax highlighted for you.

" Vim is based on Vi. Setting `nocompatible` switches from the default
" Vi-compatibility mode and enables useful Vim functionality. This
" configuration option turns out not to be necessary for the file named
" '~/.vimrc', because Vim automatically enters nocompatible mode if that file
" is present. But we're including it here just in case this config file is
" loaded some other way (e.g. saved as `foo`, and then Vim started with
" `vim -u foo`).
set nocompatible

" Escape key timeout is too slow, enable timeout on keycodes, and reduce
" length of timeout, :h 'ttimeout' for more info
set ttimeout ttimeoutlen=50
" Timeout for normal key bindings
set timeout timeoutlen=1000

"Auto install Vim-Plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
	silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

Plug 'w0rp/ale'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'acarapetis/vim-sh-heredoc-highlighting'

Plug 'lervag/vimtex'

Plug 'ycm-core/YouCompleteMe'

" Snippet runtime
Plug 'SirVer/ultisnips'
" Snippet repo
Plug 'honza/vim-snippets'

Plug 'morhetz/gruvbox'

Plug 'tpope/vim-fugitive'

call plug#end()

"Remap FZF commands for easier access
nnoremap <silent> <C-f> :Files<CR>
nnoremap <silent> <Leader>f :Rg<CR>
nnoremap <silent> <C-G> :GFiles<CR>
nnoremap <silent> <C-s> :Snippets<CR>

" Spellcheck fixes
autocmd FileType tex setlocal spell
autocmd FileType tex set spelllang=en_us
" Jump to previous spelling mistake [s, pick the first suggestion
" 1z=, jumps back ']a. <c-g>u allows undo
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

" Ultisnip trigger configuration
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsListSnippets="<C-space>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
" Save time loading, don't scan all folders
let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/UltiSnips']
" Use <leader>u in normal mode to refresh UltiSnips snippets
nnoremap <leader>u <Cmd>call UltiSnips#RefreshSnippets()<CR>

" YCM Remap to not conflict with ultisnip
let g:ycm_key_list_select_completion= ['<C-p>', '<Down>']
let g:ycm_key_list_previous_completion=['<C-n>', '<Up>']

" Default ycm config for c files
let g:ycm_global_ycm_extra_conf = '~/Documents/.ycm_extra_conf.py'

" Let clangd fully control code completion
let g:ycm_clangd_uses_ycmd_caching = 0
" Use installed clangd, not YCM-bundled clangd which doesn't get updates.
let g:ycm_clangd_binary_path = exepath("clangd")

" Nice commands to find definitions and symbols quickly
nnoremap <leader>fw <Plug>(YCMFindSymbolInWorkspace)
nnoremap <leader>fd <Plug>(YCMFindSymbolInDocument)
nnoremap <leader>gd :YcmCompleter GoToDefinition<cr>
nnoremap <leader>gi :YcmCompleter GoToImplementation<cr>
nnoremap <leader>fr :YcmCompleter GoToReferences<cr>
nnoremap <leader>r  <cmd>execute 'YcmCompleter RefactorRename' input( 'Rename to: ')<CR>

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
" This will only work if `vim --version` includes `+clientserver`!
"if empty(v:servername) && exists('*remote_startserver')
"  call remote_startserver('VIM')
"  endif

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


"Set up linters and fixers
let g:ale_fix_on_save = 1

let g:ale_linters={
			\'python': ['pylint'],
			\'c': ['clangd'],
			\'cuda': ['clangd']
			\}

let g:ale_fixers={
			\    '*': ['remove_trailing_lines', 'trim_whitespace'],
			\    'python':['black'], 'c':['clangd'], 'cuda':['clang-format']
			\}

"Shorten Black line length to match 79 for PEP8
let g:ale_python_black_options='--line-length=79'

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX
"check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more
"information.)
if (empty($TMUX) && getenv('TERM_PROGRAM') != 'Apple_Terminal')
	if (has("nvim"))
		"For Neovim 0.1.3 and 0.1.4 <
		"https://github.com/neovim/neovim/pull/2198 >
		let $NVIM_TUI_ENABLE_TRUE_COLOR=1
	endif
	"For Neovim > 0.1.5 and Vim > patch 7.4.1799 <
	"https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162
	">
	"Based on Vim patch 7.4.1770 (`guicolors`
	"option) <
	"https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd
	">
	" <
	" https://github.com/neovim/neovim/wiki/Following-HEAD#20160511
	" >
	if (has("termguicolors"))
		set termguicolors
	endif
endif

" Color scheme
set t_Co=256
autocmd vimenter * ++nested colorscheme gruvbox
set background=dark " dark mode

" Persistent Undo
if has('persistent_undo')         "check if your vim version supports
	set undodir=$HOME/.vim/undo     "directory where the undo files will be stored
	set undofile                    "turn on the feature
endif

" Turn on syntax highlighting.
syntax on

" Disable the default Vim startup message.
set shortmess+=I

" Show line numbers.
set number

" This enables relative line numbering mode. With both number and
" relativenumber enabled, the current line shows the true line number, while
" all other lines (above and below) are numbered relative to the current line.
" This is useful because you can tell, at a glance, what count is needed to
" jump up or down to a particular line, by {count}k to go up or {count}j to go
" down.
set relativenumber

" Always show the status line at the bottom, even if you only have one window open.
set laststatus=2
set statusline=%<%f\ %h%m%r%{FugitiveStatusline()}%=%-14.(%l,%c%V%)\ %P
"set statusline += %{FugitiveStatusline()}

" The backspace key has slightly unintuitive behavior by default. For example,
" by default, you can't backspace before the insertion point set with 'i'.
" This configuration makes backspace behave more reasonably, in that you can
" backspace over anything.
set backspace=indent,eol,start

" By default, Vim doesn't let you hide a buffer (i.e. have a buffer that isn't
" shown in any window) that has unsaved changes. This is to prevent you from "
" forgetting about unsaved changes and then quitting e.g. via `:qa!`. We find
" hidden buffers helpful enough to disable this protection. See `:help hidden`
" for more information on this.
set hidden

" This setting makes search case-insensitive when all characters in the string
" being searched are lowercase. However, the search becomes case-sensitive if
" it contains any capital letters. This makes searching more convenient.
set ignorecase
set smartcase

" Enable searching as you type, rather than waiting till you press enter.
set incsearch

" Unbind some useless/annoying default key bindings.
nnoremap Q <Nop> " 'Q' in normal mode enters Ex mode. You almost never want this.

" Disable audible bell because it's annoying.
set noerrorbells visualbell t_vb=

" Enable mouse support. You should avoid relying on this too much, but it can
" sometimes be convenient.
set mouse+=a

" Try to prevent bad habits like using the arrow keys for movement. This is
" not the only possible bad habit. For example, holding down the h/j/k/l keys
" for movement, rather than using more efficient movement commands, is also a
" bad habit. The former is enforceable through a .vimrc, while we don't know
" how to prevent the latter.
" Do this in normal mode...
nnoremap <Left>  :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up>    :echoe "Use k"<CR>
nnoremap <Down>  :echoe "Use j"<CR>
" ...and in insert mode
inoremap <Left>  <ESC>:echoe "Use h"<CR>
inoremap <Right> <ESC>:echoe "Use l"<CR>
inoremap <Up>    <ESC>:echoe "Use k"<CR>
inoremap <Down>  <ESC>:echoe "Use j"<CR>
