" display settings
syntax enable      " allays show highlight for file
set nowrap         " dont wrap lines
set number         " show line number
set ruler          " show cursor position in status bar
set title          " show file in titlebar
set wildmenu       " enhanced command-line completion
set laststatus=2   " Always display status line

set autoread
set visualbell     " shut vim up
set noerrorbells

"encoding
set encoding=utf8
set termencoding=utf-8
set fileencodings=          " Don't do any encoding conversion

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
set incsearch  " show search matches as you type
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

set pastetoggle=<F12> 

set t_Co=256

if has('gui_running')
  set background=light
  set mouse=a
  set guioptions-=m  "remove menu bar
  set guioptions-=T  "remove toolbar
  set guioptions-=r  "remove right-hand scroll bar
  set guioptions-=L  "remove left-hand scroll bar
else
  set background=dark
  set mouse=
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
  " Go AppEngine support via 'goapp'
  if executable('goapp')
    au BufRead,BufNewFile *.go setlocal makeprg=goapp\ test\ -c
    au BufRead,BufNewFile *.go let g:syntastic_go_checkers=['goapp', 'govet']
  else
    au BufRead,BufNewFile *.go setlocal makeprg=go\ test\ -c
    au BufRead,BufNewFile *.go let g:syntastic_go_checkers=['go', 'govet', 'golint']
  end

  " Auto close preview/scratch window after select option with omnicomplete
  autocmd CursorMovedI * if pumvisible() == 0 | pclose | endif
  autocmd InsertLeave * if pumvisible() == 0 | pclose | endif

  " Posiciona a janela QuickFix sempre na parte inferior da tela
  au FileType qf wincmd J
augroup END

command! FormatJSON call FormatJSON()
command! FormatXML call FormatXML()
command! -nargs=* GoappTest call GoappTest()
command! ToggleErrors call ToggleErrors()
command! ToggleHidden call ToggleHidden()
command! ToggleCursor call ToggleCursor()

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#cmd#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

function! ToggleErrors()
  if empty(filter(tabpagebuflist(), 'getbufvar(v:val, "&buftype") is# "quickfix"'))
    " No location/quickfix list shown, open syntastic error location panel
    Errors
  else
    lclose
  endif
endfunction

" Google App Engine Go
function! GoappTest()
  let test_line = search("func Test", "bs")
  ''
  if test_line > 0
    let line = getline(test_line)
    let test_name_raw = split(line, " ")[1]
    let test_name = split(test_name_raw, "(")[0]
    let go_cmd = '!goapp test -v -test.run=' . test_name
    exec go_cmd
  else
    echo "No test found"
  endif
endfunction

function! FormatJSON()
  %!python -m json.tool
endfunction

function! FormatXML()
  %!xmllint -format -
endfunction

function! ToggleHidden()
  set listchars=eol:¬,extends:>,precedes:<,nbsp:·,tab:»\ \,trail:~
  "Toggle the flag (or set it if it doesn't yet exist)...
  let g:list_on = exists('g:list_on') ? !g:list_on : 1
  if g:list_on
    set list
  else
    set nolist
  endif
  " another nice listchars configuration
  " set listchars=tab:\|\ ,eol:¬
  " set listchars=eol:¬,tab:>-,trail:.,extends:»,precedes:«
  " set listchars=tab:\|\ ,eol:¬,trail:-,extends:>,precedes:<,nbsp:+
  " set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
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

function! Refresh()
  "Use Ctrl L to redraw the screen. You can also use :redraw
    " code
    set noconfirm
    bufdo e!
    set confirm
endfunction

nmap <F5> :call Refresh()<CR>

" All-modes shortcut helper function
function! KeyMap(key, action, insert_mode)
  execute "noremap  <silent> " . a:key . " " . a:action . "<CR>"
  execute "vnoremap <silent> " . a:key . " <C-C>" . a:action . "<CR>"
  if a:insert_mode
    execute "inoremap <silent> " . a:key . " <C-O>" . a:action . "<CR>"
  endif
endfunction

if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif
if filereadable(expand("~/.gvimrc.local"))
  source ~/.gvimrc.local
endif

" key (re)mapppings

" shortcut to escape
map <C-c> <ESC>

" Making it so ; works like : for commands. 
nnoremap ; :

" Wrapped lines goes down/up to next row, rather than next line in file.
nnoremap j gj
nnoremap k gk

" visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

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
inoremap <C-j> <Esc>:m .+1<CR>==gi
inoremap <C-k> <Esc>:m .-2<CR>==gi
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

" Enable folding with the spacebar
nnoremap <space> za

" Shortcuts to test
map bn :bnext<CR>
map bp :bprevious<CR>
map bd :bdelete<CR>

" http://vim.wikia.com/wiki/Mapping_keys_in_Vim_-_Tutorial_(Part_2)
" Map to clear last search
call KeyMap("<C-l>", ":noh", 1)
call KeyMap("<C-S-F>", ":normal gg=G", 1)
call KeyMap("<Leader>t", ":GoappTest", 0)
call KeyMap("<Leader>fj", ":FormatJSON", 0)
call KeyMap("<Leader>fx", ":FormatXML", 0)
call KeyMap("<Leader>h", ":ToggleHidden", 1)
call KeyMap("<Leader>c", ":ToggleCursor", 1)

" map macros
let @n='iO'
"map nl @k
"map nl iO
map nl i<CR><ESC>O

" Links 
" https://www.ibm.com/developerworks/library/l-vim-script-1/
" http://vim.wikia.com/wiki/Mapping_keys_in_Vim_-_Tutorial_(Part_1)
