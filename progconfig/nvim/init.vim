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

"let $BASH_ENV = "$SALTRICED/userconfig/_aliasrc"
set shell=zsh\ -i
"set shell=/bin/bash\ --rcfile\ ~/.profile

" tabs = "    "
set tabstop=4
" tabs = "    "
set shiftwidth=4
set expandtab
set autoindent
" these next two lines disable the "ding" noise in vim
set visualbell
set t_vb=

" set :sp and :vsp to open the new file below/to the right of
" the current file(s) you're editing
set splitbelow splitright

let mapleader=","

" open where we left off
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif


" copy selected text to system clipboard with CTRL+c
vnoremap <C-c> "+y
map <C-p> "+P

" set cursor to position of next instnace of <++>
inoremap <leader><leader> <Esc>/<++><Enter>"_c4l
vnoremap <leader><leader> <Esc>/<++><Enter>"_c4l
map <leader><leader> <Esc>/<++><Enter>"_c4l

" Shortcuts for split navigation
" SHORTCUT: <CTRL-h>    move to split left
" SHORTCUT: <CTRL-j>    move to split below
" SHORTCUT: <CTRL-k>    move to split above
" SHORTCUT: <CTRL-l>    move to split right

map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l


" change autocomplete to CTRL-Space
" SHORTCUT: <CTRL-Space>    autocomplete
inoremap <C-Space> <C-n>

" remove trailing whitespace
autocmd BufWritePre * %s/\s\+$//e

" refresh xrdb after editing Xresources or Xdefaults
autocmd BufWritePost *Xresources,*Xdefaults !xrdb %

" make sure that .tex files are seen as tex filetype
autocmd BufRead,BufNewFile *.tex set filetype=tex

" clean up extra tex files when closing a tex file
autocmd VimLeave *.tex !texclear %

" refresh ctags when closing specified files
autocmd VimLeave *.c,*.cpp,*.py,*.h,*.hpp !ctags -R .
autocmd VimLeave *.c,*.cpp,*.h,*.hpp make clean >/dev/null 2>&1

" SHORTCUT: <ALT-r>    Replace text under cursor (only on current line)
map <M-r> :s/\<<C-r><C-w>\>//g<Left><Left>
inoremap <M-r> :s/\<<C-r><C-w>\>//g<Left><Left>

" SHORTCUT: <ALT-SHIFT-r>    Replace text under cursor (entire file)
map <M-R> :%s/\<<C-r><C-w>\>//g<Left><Left>
inoremap <M-R> :%s/\<<C-r><C-w>\>//g<Left><Left>

" SHORTCUT: <F12>   compiles/runs current file depending on filetype
autocmd FileType sh map <F12> :!sh %<Enter>
autocmd FileType python map <F12> :!python3 %<Enter>
autocmd FileType tex map <F12> :!pdflatex %<Enter>
autocmd FileType tex map <F5> :!pdflatex -synctex=1 -interaction=nonstopmode --shell-escape %<Enter>

autocmd FileType c,cpp,h,hpp map <F5> :!mc && m<Enter>
autocmd FileType c,cpp,h,hpp map <F6> :!mc && mt<Enter>
autocmd FileType c,cpp,h,hpp map <F10> :!mc && ct<Enter>
autocmd FileType c,cpp,h,hpp map <F11> :!mc && mt && ./test-*<Enter>
autocmd FileType c,cpp,h,hpp map <F12> :!mc && m run ARGS=""<left>

" TEMPLATES
" LaTeX
autocmd BufNewFile *.tex 0r $SNIPPETD/tex.tmpl

" INSERT MODE REMAPS
" General
map ,. <++>
inoremap ,. <++>

inoremap ,eps ε
inoremap ,del δ

" LaTeX
autocmd FileType tex inoremap ,pp \paragraph{}<Enter><++><Esc>kf}i
autocmd FileType tex inoremap ,se \section{}<Enter><++><Esc>kf}i
autocmd FileType tex inoremap ,sse \subsection{}<Enter><++><Esc>kf}i
autocmd FileType tex inoremap ,sss \subsubsection{}<Enter><++><Esc>kf}i
autocmd FileType tex inoremap ,eq \begin{equation*}<Enter><++><Enter>\end{equation*}<Esc>2kf}i
autocmd FileType tex inoremap ,neq \begin{equation}<Enter><++><Enter>\end{equation}<Esc>2kf}i
autocmd FileType tex inoremap ,al \begin{align*}<Enter><++><Enter>\end{align*}<Esc>2kf}i
autocmd FileType tex inoremap ,nal \begin{align}<Enter><++><Enter>\end{align}<Esc>2kf}i
autocmd FileType tex inoremap ,ma \left[\begin{matrix}<Enter><++><Enter>\end{matrix}\right]<Esc>2kf}i

