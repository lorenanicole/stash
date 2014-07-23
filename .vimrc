set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" File viewer
Plugin 'scrooloose/nerdtree'

" Used for comments
Plugin 'scrooloose/nerdcommenter'

" Creates the status bar at the bottom
Plugin 'bling/vim-airline'

" Check for syntax problems
Plugin 'scrooloose/syntastic'
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required


set expandtab
set ruler
set nocompatible
set autoindent
set history=50
set showcmd
set incsearch
syntax on
set hlsearch
set mouse=a
set visualbell
set number
colo delek
set tabstop=4
set shiftwidth=4
set laststatus=2 " Show airline all the time

set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace
set backspace=indent,eol,start " Make sure backspace goes over lines

" UI CHANGES
set cursorline
highlight clear SignColumn      " SignColumn should match background
highlight clear LineNr 
" Set configuration options for the statusline plugin vim-airline.
if !exists('g:airline_theme')
    let g:airline_theme = 'hybrid'
endif
if !exists('g:airline_powerline_fonts')
    " Use the default set of separators with a few customizations
    let g:airline_left_sep='›'  " Slightly fancier than '>'
    let g:airline_right_sep='‹' " Slightly fancier than '<'
endif


