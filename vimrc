""""""""""""""""""""""""""""""""""""
" Filipe Peixoto Vimrc configuration
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

function! Build()
  " build has a funtion to map custom files to build
  if (&ft=='go') " to build work correctly is necessary the plugin fatih/vim-go
    if(match(expand('%:t'), '_test\.go') > 0)
      :GoTestCompile <CR>
    else
      :GoBuild <CR>
    endif
  endif
endfunction
command! Build call Build()
map <Leader>B :call Build() <CR>
command! W w | Build " map W to save and build file

command! TabToSpace call TabToSpace()
command! RangeTabToSpace call RangeTabToSpace()
function! TabToSpace()
  :s/\t/  /g
endfunction
function! RangeTabToSpace() range
  :'<,'>s/\t/  /g
endfunction

function! Space4ToTab()
  :s/    /\t/g
endfunction
command! Space4ToTab call Space4ToTab()

" NEL non empty line
command! GoToNEL call search('^.\+')
command! GoToPNEL call search('^.\+', 'b')

command! SaveSession :mks! ~/.vim/session.vim
command! LoadSession :source ~/.vim/session.vim

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#cmd#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

function! ToggleCursor()
  let g:cursor_on = exists('g:cursor_on') ? !g:cursor_on : 1
  if g:cursor_on
    set cursorcolumn
    set cursorline
  else
    set nocursorcolumn
    set nocursorline
  endif
endfunction
map <Leader>tc :call ToggleCursor() <CR>

function! ToggleErrors()
  if empty(filter(tabpagebuflist(), 'getbufvar(v:val, "&buftype") is# "quickfix"'))
    " No location/quickfix list shown, open syntastic error location panel
    Errors
  else
    lclose
  endif
endfunction
map <Leader>te :call ToggleErrors() <CR>

function! ToggleHidden()
  set listchars=eol:↵,extends:>,precedes:<,nbsp:·,tab:»\ \,trail:~
  "Toggle the flag (or set it if it doesn't yet exist)...
  let g:list_on = exists('g:list_on') ? !g:list_on : 1
  if g:list_on
    set list
  else
    set nolist
  endif
endfunction
map <Leader>th :call ToggleHidden() <CR>

function! FormatJSON()
  %!python -m json.tool
endfunction
command! FormatJSON call FormatJSON()

function! FormatXML()
  %!xmllint -encode utf8 -format -
endfunction
command! FormatXML call FormatXML()

function! FormatSH()
  %!shfmt
endfunction
command! FormatSH call FormatSH()

function! URLDecode()
  %!python -c "import sys, urllib as ul; print ul.unquote_plus(sys.stdin.read())"
endfunction
command! URLDecode call URLDecode()

function! URLEncode()
  %!python -c "import sys, urllib as ul; print ul.quote_plus(sys.stdin.read())"
endfunction
command! URLEncode call URLEncode()

function! CloseHelpWindows()
  :pclose
  :cclose " close the quickfix window
  :lclose
endfunction
map <F6> :call CloseHelpWindows()<CR>

function! TrimWhiteSpace()
  ":%s/\s\+$//e
	%s/\s*$//
	''
endfunction
command! TrimWhiteSpace call TrimWhiteSpace()

function! RunNode()
  :%y"
  call TempWindow("Node", 1, 's')
  :put
  execute 'silent %!node'
endfunction

function! Table(...)
  let a:delimiter = get(a:, 1, 0)
  if a:delimiter == "0"
    let a:delimiter=','
  endif

  :%y"
  call TempWindow("Table", 1, 's')
  :put
  execute 'silent %!column -t -s"' . a:delimiter . '"'
endfunction
command! Table call Table()

function! Execute(c)
  :%y"
  call TempWindow("Execute", 1, 'v')
  :put
  execute 'silent %!' . a:c
endfunction
command! Execute -nargs=1 Execute call Execute(<f-args>)

" Disposable temporary window
" TODO bug janela não atulizar se rodar mais de uma vez
function! TempWindow(name, clear, mode) abort
  let name = substitute(a:name, "[^a-zA-Z0-9]", "_", "g")
  let bn = bufnr(name)
  if bn == -1
    exe "new " . name
    let bn = bufnr(name)
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    setlocal buflisted
  else
    let wn = bufwinnr(bn)
    if wn != -1
      exe wn . "wincmd w"
    else
      exe "split +buffer" . bn
    endif
  endif

  if a:clear
    normal gg
    normal dG
  endif
  if a:mode == 'v'
    wincmd L
  else
    wincmd J
  endif
endfunction

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
