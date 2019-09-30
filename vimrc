""""""""""""""""""""""""""""""""""""
" Filipe Peixoto VIM Configuration
""""""""""""""""""""""""""""""""""""

" display settings
syntax enable      " allays show highlight for file
set nowrap         " dont wrap lines
set number         " show line number
set ruler          " show cursor position in status bar
set title          " show file in titlebar
set wildmenu       " enhanced command-line completion
set laststatus=2   " Always display status line

set autoread
"set visualbell this option on iterm results on blank screen always ESC is pressed
"set errorbells

"encoding
"set encoding=utf-8
"set termencoding=utf-8
"set fileencodings=          " Don't do any encoding conversion

" backup
set noswapfile
set nobackup
set nowb
set wildignore=*.swp,*.bak,*.pyc,*.class

"History
set history=1000    " remember more commands and search history
set undolevels=1000 " use many much levels of undo

" searching
set smarttab   " insert tabs on the start of a line according to
"              " shiftwidth, not tabstop
set hlsearch   " highlight search terms
set incsearch  " vim incremental search
set smartcase  " ignore case if search pattern is all lowercase,
"              " case-sensitive otherwise
set ignorecase " ignore case when searching

" indent
set autoindent      "Keep indentation from previous line
set smartindent     "Automatically inserts indentation in some cases
set cindent         "Like smartindent, but stricter and more customisable

" Enable folding
set foldmethod=indent
set foldlevel=99

" => Editing mappings
" Remap VIM 0 to first non-blank character
"map 0 ^

set pastetoggle=<F12>
"set clipboard=unnamedplus

" increasing <CTRL>+a <CTRL>+x
" avaliable options are alpha,bin,octal,hex
set nrformats=

if has('gui_running')
  set mouse=a
  set guioptions-=m  "remove menu bar
  set guioptions-=T  "remove toolbar
  set guioptions-=r  "remove right-hand scroll bar
  set guioptions-=L  "remove left-hand scroll bar
endif

" The default leader is '\\', changed to ','
let mapleader=","

" Load plugins
if filereadable(expand("~/.vimrc.plugins"))
  source ~/.vimrc.plugins
endif

augroup filemapping
  " Java settings
  au BufRead,BufNewFile *.java compiler javac
  au BufRead,BufNewFile *.java setlocal makeprg=javac\ %
  au BufRead,BufNewFile *.java let g:syntastic_java_javac_options = "-Xlint -encoding utf-8"
  au BufRead,BufNewFile *.bsh setlocal filetype=java
  au BufRead,BufNewFile *dotfilesrc setlocal filetype=sh

  " Golang settings
  "au BufRead,BufNewFile *.go setlocal makeprg=go\ test\ -c
  "au BufRead,BufNewFile *.go let g:syntastic_go_checkers=['go', 'govet', 'golint']

  " Auto close preview/scratch window after select option with omnicomplete
  autocmd CursorMovedI * if pumvisible() == 0 | pclose | endif
  autocmd InsertLeave * if pumvisible() == 0 | pclose | endif

  autocmd BufEnter * :syntax sync fromstart

  " Map ,gb to add current branch on commit
  au Filetype gitcommit map ,gb :0r!git rev-parse --abbrev-ref HEAD<CR>A

  " Posiciona a janela QuickFix sempre na parte inferior da tela
  au FileType qf wincmd J

  "configure bigquery files to sql syntax
  autocmd BufRead *.bq set filetype=sql
  au FileType sql setl tabstop=2 shiftwidth=2 expandtab
augroup END

" auto load vimrc files on save vimrc
augroup myvimrc
  au!
  au BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc so $MYVIMRC | if has('gui_running') | if filereadable(expand($MYGVIMRC)) | so $MYGVIMRC | endif | endif
augroup END


" NEL non empty line
command! GoToNEL call search('^.\+')
command! GoToPNEL call search('^.\+', 'b')

command! SaveSession :mks! ~/.vim/session.vim
command! LoadSession :source ~/.vim/session.vim

if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif
if filereadable(expand("~/.gvimrc.local"))
  source ~/.gvimrc.local
endif

" shortcut to escape
map <C-c> <ESC>

" map quote to go line and column
map ` '

" Wrapped lines goes down/up to next row, rather than next line in file.
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" Map gb and gB move between buffers
"map gb :bnext<CR>
"map gB :bprevious<CR>

" Shortcuts to test
"map bn :bnext<CR>
"map bp :bprevious<CR>
"map bd :bdelete<CR>

" visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" keep the yanked text on paste
xnoremap <expr> p 'pgv"'.v:register.'y'

" custom copy/paste to use in X
vnoremap <leader>y "+y
vnoremap <leader>x "+x
vnoremap <leader>p "+gP
nnoremap <leader>p "+gP

nnoremap <silent> <Leader>+ :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> <Leader>- :exe "resize " . (winheight(0) * 2/3)<CR>

" Mappings to move lines http://vim.wikia.com/wiki/Moving_lines_up_or_down
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
"inoremap <C-j> <Esc>:m .+1<CR>==gi
"inoremap <C-k> <Esc>:m .-2<CR>==gi
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

" Move line/block up: \k
nnoremap <leader>k :m-2<cr>
vnoremap <leader>k :m'<-2<cr>gv=gv
" Move line/block down: \j
nnoremap <leader>j :m+1<cr>
vnoremap <leader>j :m'>+1<cr>gv=gv
" Duplicate line/block down: \y
nnoremap <leader>d :t.<cr>
vnoremap <leader>d :t'>.<cr>gv=gv

"Toggling the display of a widget
"http://vim.wikia.com/wiki/Hide_toolbar_or_menus_to_see_more_text
nnoremap <C-F1> :if &go=~#'m'<Bar>set go-=m<Bar>else<Bar>set go+=m<Bar>endif<CR>
nnoremap <C-F2> :if &go=~#'T'<Bar>set go-=T<Bar>else<Bar>set go+=T<Bar>endif<CR>
nnoremap <C-F3> :if &go=~#'r'<Bar>set go-=r<Bar>else<Bar>set go+=r<Bar>endif<CR>

" Clear last search highlighting
noremap <F3> :noh<CR>
noremap <F5> <Esc>:syntax sync fromstart<CR>

" ,v brings up my .vimrc
" ,V reloads it -- making all changes active (have to save first)
map <silent> ,V :sp ~/.vimrc<CR><C-W>_
map <silent> ,v :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

" map macros
let @n='iO'
let @t='F<yf>f>pF<a/F>l'
"map nl @k
"map nl iO

"Break lines
map <Leader>o i<CR><ESC>O
"Break lines after >
map <Leader>nb T>i<CR><ESC>O

if filereadable(expand("~/.vimrc.projects"))
  source ~/.vimrc.projects
endif

if filereadable(expand("~/.vimrc.funcs"))
  source ~/.vimrc.funcs
endif

" Links
" https://www.ibm.com/developerworks/library/l-vim-script-1/
" http://vim.wikia.com/wiki/Mapping_keys_in_Vim_-_Tutorial_(Part_1)
" http://vim.wikia.com/wiki/Mapping_keys_in_Vim_-_Tutorial_(Part_2)
" http://vim.wikia.com/wiki/Accessing_the_system_clipboard
" http://vim.wikia.com/wiki/Remove_unwanted_spaces
" http://vim.wikia.com/wiki/Search_for_visually_selected_text
" http://vim.wikia.com/wiki/Power_of_g
" http://vim.wikia.com/wiki/Fix_syntax_highlighting
" http://vim.wikia.com/wiki/Search_only_over_a_visual_range
" http://vim.wikia.com/wiki/Category:Searching
" http://vim.wikia.com/wiki/Increasing_or_decreasing_numbers
" http://vim.wikia.com/wiki/Using_marks
" http://vim.wikia.com/wiki/Highlight_unwanted_spaces
" http://vimdoc.sourceforge.net/htmldoc/motion.html#object-select

" Comments
" to replace selected text on visual mode use \%V before text to replace:
" sample :'<,'>s/\%Vorig/replace/g
" to replace comma inside two quotes to dot
" %s/"\(\d\+\),\(\d\+\)"/\"\1\.\2\"/g
