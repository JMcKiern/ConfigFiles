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

" Compile/Run commands
autocmd FileType cpp call SetCPPFileOptions()
autocmd FileType python call SetPythonFileOptions()
autocmd FileType text call SetTextFileOptions()
autocmd FileType tex call SetLatexOptions()

function SetCPPFileOptions()
	call SetGeneralProgrammingOptions()
endfunction

function SetPythonFileOptions()
	noremap <buffer> <F5> :w !python<CR>
	set nosmartindent
	" Use spaces instead of tabs in python
	set expandtab 
	call SetGeneralProgrammingOptions()
endfunction

function SetGeneralProgrammingOptions()
	set list
	set listchars=tab:\|\ ,space:·,trail:~,precedes:«,extends:»
	set colorcolumn=80
	highlight ColorColumn ctermbg=0 guibg=#444444
endfunction

function SetLatexOptions()
	map <F5> :silent w !cd "%:h" && xelatex "%:p" <CR>
	map <F6> :silent !start sumatrapdf "%:p:r.pdf" <CR>
	set colorcolumn=80
	highlight ColorColumn ctermbg=0 guibg=#444444
endfunction

function SetTextFileOptions()
	set textwidth=80
	set wrap
	set linebreak
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
Plug 'tpope/vim-surround'
"Plug 'tpope/vim-unimpaired'
Plug 'editorconfig/editorconfig-vim'
"Plug 'majutsushi/tagbar'
Plug 'valloric/youcompleteme', {'do': './install.py'}

call plug#end()

let g:lightline = {
			\ 'colorscheme': 'jellybeans',
			\ }
colorscheme jellybeans
highlight clear SpecialKey
highlight SpecialKey term=bold ctermfg=9 guifg=#444444
let NERDTreeShowHidden=1 " Show hidden files

" Arch
"colorscheme base16-default
"set background=dark
"highlight Normal ctermbg=none
"highlight NonText ctermbg=none
