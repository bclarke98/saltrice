call plug#begin('~/.config/nvim/plugged')
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdtree'
Plug 'junegunn/goyo.vim'
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'jreybert/vimagit'
Plug 'vimwiki/vimwiki'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-commentary'
Plug 'arcticicestudio/nord-vim'
"Plug 'dr-kino/cscope-maps'
call plug#end()

set go=a
set mouse=a
set nohlsearch
set clipboard=unnamedplus
colorscheme nord
syntax on
filetype plugin on
set number relativenumber
set wildmode=longest,list,full

let g:airline_section_z = airline#section#create(['windowswap', '%3p%% ', 'linenr', ':%3v'])
let g:airline_powerline_fonts = 1


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

nmap <C-s> :w<CR>
imap <C-s> <Esc>:w<CR>a
vmap <C-s> <Esc>:w<CR>

" SHORTCUT: <CTRL-a>    Toggle NerdTree
nmap <C-a> :NERDTreeToggle<CR>
imap <C-a> <ESC>:NERDTreeToggle<CR>
vmap <C-a> <ESC>:NERDTreeToggle<CR>

" change autocomplete to CTRL-Space
" SHORTCUT: <CTRL-Space>    autocomplete
inoremap <C-Space> <C-n>

" remove trailing whitespace
autocmd BufWritePre * %s/\s\+$//e

" refresh xrdb after editing Xresources or Xdefaults
autocmd BufWritePost *Xresources,*Xdefaults !xrdb %

" reloads aliases when editing 'bookmark' files
autocmd BufWritePost */userconfig/* !sh $SALTRICED/userconfig/_loadbm

" make sure that .tex files are seen as tex filetype
autocmd BufRead,BufNewFile *.tex set filetype=tex

" make sure that .md files are seen as markdown filetype
autocmd BufRead,BufNewFile *.md set filetype=markdown

" clean up extra tex files when closing a tex file
autocmd VimLeave *.tex !texclear %

" refresh ctags when modifying specified files
autocmd VimLeave *.c,*.cpp,*.py,*.h,*.hpp !wtag -R .
" autocmd VimLeave *.c,*.cpp,*.h,*.hpp make clean >/dev/null 2>&1

" SHORTCUT: <ALT-r>    Replace text under cursor (only on current line)
map <M-r> :s/\<<C-r><C-w>\>//g<Left><Left>
inoremap <M-r> :s/\<<C-r><C-w>\>//g<Left><Left>

" SHORTCUT: <ALT-SHIFT-r>    Replace text under cursor (entire file)
map <M-R> :%s/\<<C-r><C-w>\>//g<Left><Left>
inoremap <M-R> :%s/\<<C-r><C-w>\>//g<Left><Left>

" SHORTCUT: <F12>   compiles/runs current file depending on filetype
autocmd FileType sh map <F12> :!% <Enter>
autocmd FileType python map <F12> :!python3 %<Enter>
autocmd FileType markdown map <F12> :w<Enter>:!compile %<Enter>
autocmd FileType tex map <F12> :w<Enter>:!compile %<Enter>
autocmd FileType tex map <F5> :!pdflatex -synctex=1 -interaction=nonstopmode --shell-escape % && biber %<Enter>

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
inoremap ,cir ∘
inoremap ,cup ∪
inoremap ,mem ∈
inoremap ,nil ∅
inoremap ,sig Σ

" LaTeX
autocmd FileType tex inoremap ,up \usepackage{<++>}<++><Esc>F{ci{
autocmd FileType tex inoremap ,pp \paragraph{}<Enter><++><Esc>kf}i
autocmd FileType tex inoremap ,se \section{}<Enter><++><Esc>kf}i
autocmd FileType tex inoremap ,sse \subsection{}<Enter><++><Esc>kf}i
autocmd FileType tex inoremap ,sss \subsubsection{}<Enter><++><Esc>kf}i
autocmd FileType tex inoremap ,fr \frac{}{<++>}<++><Esc>F}F}i
autocmd FileType tex inoremap ,t \text{<++>}<++><Esc>F{ci{
autocmd FileType tex inoremap ,b \textbf{<++>}<++><Esc>F{ci{
autocmd FileType tex inoremap ,i \emph{<++>}<++><Esc>F{ci{
autocmd FileType tex inoremap ,eq \begin{equation*}<Enter><++><Enter>\end{equation*}<Esc>2kf}i
autocmd FileType tex inoremap ,neq \begin{equation}<Enter><++><Enter>\end{equation}<Esc>2kf}i
autocmd FileType tex inoremap ,al \begin{align*}<Enter><++><Enter>\end{align*}<Enter><Esc>3kf}i
autocmd FileType tex inoremap ,ce \begin{center}<Enter><++><Enter>\end{center}<Enter><Esc>3kf}i
autocmd FileType tex inoremap ,nal \begin{align}<Enter><++><Enter>\end{align}<Enter><Esc>3kf}i
autocmd FileType tex inoremap ,ma \left[\begin{matrix}<Enter><++><Enter>\end{matrix}\right]<Esc>2kf}i


