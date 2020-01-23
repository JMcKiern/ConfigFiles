" use :so % or :so $MYVIRMC to reload vimrc
set encoding=utf-8
set hidden " Allow hidden unwriten buffers
set nowrap
set t_Co=256
set laststatus=2
set noshowmode
set number
set backspace=eol,indent,start
set showcmd
syntax on

" Set indentation to tabs 4 spaces wide
set tabstop=4
set shiftwidth=4
set noexpandtab
set autoindent
set smartindent
set smarttab

set foldmethod=syntax
set foldnestmax=10
set nofoldenable " no fold on opening
set foldlevel=100

" Don't place swap files in working directory
set dir-=.

" Detect os
" https://vi.stackexchange.com/a/2577
if !exists("g:os")
	if has("win64") || has("win32") || has("win16")
		let g:os = "Windows"
	else
		let g:os = substitute(system('uname'), '\n', '', '')
	endif
endif

if has("gui_running")
	" Change guifont to avoid italics being cut off
	set guifont=Ubuntu_Mono_derivative_Powerlin:h10,Consolas:h10
	" Don't automatically resize GUI window
	"set guioptions+=k
	" Remove scrollbars
	"set guioptions-=l
	"set guioptions-=L
	"set guioptions-=r
	"set guioptions-=R
	set guioptions=
endif

command! ViewPanes call ViewPanesToggle()
function! ViewPanesToggle()
	:TagbarToggle
	:NERDTreeToggle
endfunction

" Compile/Run commands
autocmd FileType c call SetCFileOptions()
autocmd FileType cpp call SetCFileOptions()
autocmd FileType java call SetGeneralProgrammingOptions()
autocmd FileType python call SetPythonFileOptions()
autocmd FileType text call SetTextFileOptions()
autocmd FileType tex call SetLatexOptions()
autocmd FileType markdown call SetMarkdownOptions()

function! SetCFileOptions()
	let g:ycm_global_ycm_extra_conf = "~/.vim/plugged/youcompleteme/third_party/ycmd/.ycm_extra_conf.py"
	call SetGeneralProgrammingOptions()
endfunction

function! SetPythonFileOptions()
	" For current buffer, set F5 = write file and run in current folder
	if g:os == "Windows"
		" Must do this to remove two ENTER presses to continue
		noremap <buffer> <F5> :w <bar> silent !python "%:p" & pause<CR>
	endif
	if g:os == "Linux"
		noremap <buffer> <F5> :w <bar> !python "%:p"<CR>
	endif
	set nosmartindent
	" Use spaces instead of tabs in python
	set expandtab
	call SetGeneralProgrammingOptions()
endfunction

function! ShowWhiteSpace()
	set list
	set listchars=tab:\|\ ,space:·,trail:~,precedes:«,extends:»
endfunction

function! ShowColorColumn()
	set colorcolumn=80
	highlight ColorColumn ctermbg=0 guibg=#444444
endfunction

function! SetGeneralProgrammingOptions()
	call ShowWhiteSpace()
	call ShowColorColumn()
endfunction

function! SetLatexOptions()
	map <F4> :w <bar> !cd "%:h" && latexmk -pdf -xelatex "%:h/main.tex" <CR>
	map <F5> :w <bar> !cd "%:h" && latexmk -pdf -xelatex "%:p" <CR>
	map <F6> :silent !start sumatrapdf "%:p:r.pdf" <CR>
	call SetGeneralProgrammingOptions()
endfunction

function! SetTextFileOptions()
	set textwidth=80
	set wrap
	set linebreak
endfunction

function! SetMarkdownOptions()
	map <F5> :silent !chrome.exe "%:p" <CR>
	call ShowWhiteSpace()
	set shiftwidth=4
	set expandtab
endfunction

if g:os == "Windows"
	" TODO: Add check if *.tex file
endif

" Install vim-plug if not found
if g:os == "Linux"
	if empty(glob('~/.vim/autoload/plug.vim'))
		silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
		autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
	endif
endif

call plug#begin('~/.vim/plugged')

Plug 'itchyny/lightline.vim'
"Plug 'junegunn/fzf.vim'
Plug 'nanotech/jellybeans.vim'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
"vim-multiple-cursors: <C-n> to use
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
"Plug 'tpope/vim-repeat'
"Plug 'tpope/vim-sleuth'
"Plug 'tpope/vim-surround'
"Plug 'tpope/vim-unimpaired'
Plug 'editorconfig/editorconfig-vim'
Plug 'majutsushi/tagbar'
"Plug 'valloric/youcompleteme', {'do': './install.py --clang-completer'}
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
"Plug 'dense-analysis/ale'
"Plug 'maralla/validator.vim'
Plug 'PProvost/vim-ps1'

call plug#end()

function! GitStatusLine()
	let l:branch = fugitive#head()
	if (l:branch != "")
		return " " . fugitive#head()
	else
		return l:branch
endfunction

if &guifont ==# "Ubuntu_Mono_derivative_Powerlin:h10"
	let g:lightline = {
				\ 'colorscheme': 'jellybeans',
				\ 'active' : {
				\   'left': [ [ 'mode', 'paste' ],
				\             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
				\   'right': [ [ 'syntastic', 'lineinfo' ],
				\              [ 'percent' ],
				\              [ 'fileformat', 'fileencoding', 'filetype' ] ]
				\ },
				\ 'inactive' : {
				\   'left' : [ [ 'gitbranch', 'filename', 'modified' ] ],
				\ },
				\ 'component_function': {
				\   'gitbranch': 'GitStatusLine'
				\ },
				\ 'component_expand': {
				\   'syntastic': 'SyntasticStatuslineFlag',
				\ },
				\ 'component_type': {
				\   'syntastic': 'error',
				\ },
				\ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
				\ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" },
				\ 'enable': { 'tabline': 0 },
				\ }
else
	let g:lightline = {
				\ 'colorscheme': 'jellybeans',
				\ 'active' : {
				\   'left': [ [ 'mode', 'paste' ],
				\             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
				\   'right': [ [ 'syntastic', 'lineinfo' ],
				\              [ 'percent' ],
				\              [ 'fileformat', 'fileencoding', 'filetype' ] ]
				\ },
				\ 'inactive' : {
				\   'left' : [ [ 'filename', 'modified' ] ],
				\ },
				\ 'component_expand': {
				\   'syntastic': 'SyntasticStatuslineFlag',
				\ },
				\ 'component_type': {
				\   'syntastic': 'error',
				\ },
				\ 'enable': { 'tabline': 0 },
				\ }
endif
colorscheme jellybeans
highlight clear SpecialKey
highlight SpecialKey term=bold ctermfg=9 guifg=#444444
let NERDTreeShowHidden=1 " Show hidden files
let NERDTreeIgnore = ['\.swp$']

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

set belloff=all

" Arch
"colorscheme base16-default
"set background=dark
"highlight Normal ctermbg=none
"highlight NonText ctermbg=none
