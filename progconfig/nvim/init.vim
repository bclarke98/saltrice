call plug#begin('~/.config/nvim/plugged')
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdtree'
Plug 'junegunn/goyo.vim'
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'jreybert/vimagit'
Plug 'vimwiki/vimwiki'
Plug 'bling/vim-airline'
Plug 'tpope/vim-commentary'
Plug 'vifm/vifm.vim'
call plug#end()

set bg=light
set go=a
set mouse=a
set nohlsearch
set clipboard=unnamedplus

syntax on
filetype plugin on
set number relativenumber
set wildmode=longest,list,full

set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set visualbell
set t_vb=

let mapleader=","

if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

" copy selected text to system clipboard with CTRL+c
vnoremap <C-c> "+y

" set cursor to position of next instnace of <++>
inoremap <leader><leader> <Esc>/<++><Enter>"_c4l
vnoremap <leader><leader> <Esc>/<++><Enter>"_c4l
map <leader><leader> <Esc>/<++><Enter>"_c4l

" remove trailing whitespace
autocmd BufWritePre * %s/\s\+$//e

autocmd BufWritePost *Xresources,*Xdefaults !xrdb %

autocmd FileType sh map <F12> :!sh %<Enter>
autocmd FileType python map <F12> :!py %<Enter>

autocmd FileType c,cpp,h,hpp map <F5> :!ctags -R . && make clean && make<Enter>
autocmd FileType c,cpp,h,hpp map <F12> :!ctags -R . && make clean && make run ARGS=""<left>
