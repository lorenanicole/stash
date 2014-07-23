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

" git integration
Plugin 'tpope/vim-fugitive'

" all of the colors
Plugin 'flazz/vim-colorschemes'

" Better json
Plugin 'elzr/vim-json'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
filetype plugin on

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
"colo delek
set tabstop=4
set shiftwidth=4
set laststatus=2 " Show airline all the time
let mapleader = "," "Change leader key to ,
set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace
set backspace=indent,eol,start " Make sure backspace goes over lines

" UI CHANGES
let g:molokai_original = 1
set cursorline
set t_Co=256
"hi CursorLine   cterm=NONE ctermbg=grey ctermfg=white guibg=grey guifg=white
hi CursorLine   cterm=NONE ctermbg=235
" hi CursorColumn cterm=NONE ctermbg=grey ctermfg=white guibg=grey guifg=white
highlight clear SignColumn      " SignColumn should match background
highlight clear LineNr 
" Set configuration options for the statusline plugin vim-airline.
" airline {
    let g:airline_theme='molokai'
    if !exists('g:airline_powerline_fonts')
        " Use the default set of separators with a few customizations
        let g:airline_left_sep='›'  " Slightly fancier than '>'
        let g:airline_right_sep='‹' " Slightly fancier than '<'
    endif
"}

" NerdTree {
    if isdirectory(expand("~/.vim/bundle/nerdtree"))
        map <C-e> <plug>NERDTreeTabsToggle<CR>
        map <leader>e :NERDTreeFind<CR>
        nmap <leader>nt :NERDTreeFind<CR>

        let NERDTreeShowBookmarks=1
        let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
        let NERDTreeChDirMode=0
        let NERDTreeQuitOnOpen=1
        let NERDTreeMouseMode=2
        let NERDTreeShowHidden=1
        let NERDTreeKeepTreeInNewTab=1
        let g:nerdtree_tabs_open_on_gui_startup=0
    endif
    " }

" Fugitive {
    if isdirectory(expand("~/.vim/bundle/vim-fugitive/"))
        nnoremap <silent> <leader>gs :Gstatus<CR>
        nnoremap <silent> <leader>gd :Gdiff<CR>
        nnoremap <silent> <leader>gc :Gcommit<CR>
        nnoremap <silent> <leader>gb :Gblame<CR>
        nnoremap <silent> <leader>gl :Glog<CR>
        nnoremap <silent> <leader>gp :Git push<CR>
        nnoremap <silent> <leader>gr :Gread<CR>
        nnoremap <silent> <leader>gw :Gwrite<CR>
        nnoremap <silent> <leader>ge :Gedit<CR>
        " Mnemonic _i_nteractive
        nnoremap <silent> <leader>gi :Git add -p %<CR>
        nnoremap <silent> <leader>gg :SignifyToggle<CR>
    endif
"}

" vim-JSON {
    let g:vim_json_syntax_conceal = 0
" }
