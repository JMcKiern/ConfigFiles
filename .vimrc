" use :so % or :so $MYVIRMC to reload vimrc

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

" Detect os
" https://vi.stackexchange.com/a/2577
if !exists("g:os")
	if has("win64") || has("win32") || has("win16")
		let g:os = "Windows"
	else
		let g:os = substitute(system('uname'), '\n', '', '')
	endif
endif

" Change guifont to avoid italics being cut off
if has("gui_running")
	set guifont=Consolas:h11
endif

" Latex command
if g:os == "Windows"
	" TODO: Add check if *.tex file
	map <F5> :w <bar> !cd %:h && "C:\Program Files\MiKTeX 2.9\miktex\bin\x64\xelatex.exe" "%:p" 
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
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
"Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
"Plug 'tpope/vim-unimpaired'

call plug#end()

let g:lightline = {
			\ 'colorscheme': 'jellybeans',
			\ }
colorscheme jellybeans
let NERDTreeShowHidden=1 " Show hidden files
