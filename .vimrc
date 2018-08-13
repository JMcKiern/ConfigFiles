set hidden " Allow hidden unwriten buffers
set nowrap
set t_Co=256
set laststatus=2
set noshowmode
set number

" Set indentation to tabs 4 spaces wide
set tabstop=4
set shiftwidth=4
set noexpandtab

" Detect os
" https://vi.stackexchange.com/a/2577
if !exists("g:os")
	if has("win64") || has("win32") || has("win16")
		let g:os = "Windows"
	else
		let g:os = substitute(system('uname'), '\n', '', '')
	endif
endif

" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
	\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'itchyny/lightline.vim'
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

let NERDTreeShowHidden=1 " Show hidden files
let g:lightline = {
			\ 'colorscheme': 'jellybeans',
			\ }
colorscheme jellybeans
