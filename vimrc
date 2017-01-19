" enable plugin manager Vundle
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'scrooloose/nerdtree'
Plugin 'majutsushi/tagbar'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'wincent/Command-T'
Plugin 'editorconfig/editorconfig-vim'
"Plugin 'maksimr/vim-jsbeautify'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'buffet.vim'
Plugin 'kien/tabman.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'tpope/vim-surround' " provides mappings to easily delete, change and add such surroundings in pairs

Plugin 'yegappan/grep'

Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-git'

Plugin 'vim-syntastic/syntastic'

Plugin 'Blackrush/vim-gocode'
Plugin 'fatih/vim-go'
Plugin 'dgryski/vim-godef'

Plugin 'kchmck/vim-coffee-script'

"snipmate
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'
Plugin 'honza/vim-snippets' " Optional:

" plugin from http://vim-scripts.org/vim/scripts.html

" Allow to add custom plugins
if filereadable(expand("~/.vimrc.plugins.local"))
  source ~/.vimrc.plugins.local
endif

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" basic confs
syntax enable      " allays show highlight for file
set number         " show line number
set ruler          " Turn line information always on
set visualbell     " shut vim up
set noerrorbells
set autoread
set nowrap         " Turn off line wrapping
set laststatus=2   " Always display status line
set wildmenu       " enhanced command-line completion
let mapleader=","

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

set pastetoggle=<F12> 

set t_Co=256
if has('gui_running')
  set background=light
  set mouse=a
else
  set background=dark
  set mouse=
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

" nerdtree
let NERDTreeIgnore=['\.pyc$', '\.pyo$', '\.rbc$', '\.rbo$', '\.class$', '\.o$', '\~$']

" syntastic
let g:syntastic_enable_signs=1
let g:syntastic_quiet_messages = {'level': 'warnings'}
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_jump = 0
let g:syntastic_full_redraws=1

" syntastic Go
let g:syntastic_auto_loc_list = 1
" let g:syntastic_go_checkers = ['go', 'golint', 'errcheck']

" vim-go
let g:gofmt_command="goimports"
let g:go_list_type = "quickfix"

" godef
let g:godef_split=1 "0 new buffer, 1 split window, 2 new tab, 3 vsplit window

" tagbar
let g:tagbar_type_go = {
      \ 'ctagstype' : 'go',
      \ 'kinds'     : [
      \ 'p:package',
      \ 'i:imports:1',
      \ 'c:constants',
      \ 'v:variables',
      \ 't:types',
      \ 'n:interfaces',
      \ 'w:fields',
      \ 'e:embedded',
      \ 'm:methods',
      \ 'r:constructor',
      \ 'f:functions'
      \ ],
      \ 'sro' : '.',
      \ 'kind2scope' : {
      \ 't' : 'ctype',
      \ 'n' : 'ntype'
      \ },
      \ 'scope2kind' : {
      \ 'ctype' : 't',
      \ 'ntype' : 'n'
      \ },
      \ 'ctagsbin'  : 'gotags',
      \ 'ctagsargs' : '-sort -silent'
      \ }

let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\v[\/]\.(git|hg|svn)$',
      \ 'file': '\v\.(exe|so|dll)$',
      \ }

command! FormatJSON call FormatJSON()
command! FormatXML call FormatXML()
command! -nargs=* GoappTest call GoappTest()
command! ToggleErrors call ToggleErrors()
command! ToggleHidden call ToggleHidden()
command! ToggleCursor call ToggleCursor()

command! GoDefNewTab call ChangeGoDef(2)
command! GoDefCurrent call ChangeGoDef(0)
command! GoDefHorizontal call ChangeGoDef(1)
command! GoDefVertical call ChangeGoDef(3)

function! ChangeGoDef(v)
  echo "changing godef split to" a:v
  let g:godef_split=a:v
endfunction

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

" Map to clear last search
" http://vim.wikia.com/wiki/Mapping_keys_in_Vim_-_Tutorial_(Part_2)
call KeyMap("<SPACE>", ":noh", 0)
call KeyMap("<F2>", ":Bufferlist", 1)
call KeyMap("<F6>", "ToggleErrors", 1)
call KeyMap("<F7>", ":NERDTreeToggle", 1)
call KeyMap("<S-F7>", ":NERDTreeFind", 1)
call KeyMap("<F8>", ":TagbarToggle", 1)
call KeyMap("<Leader>t", ":GoappTest", 0)
call KeyMap("<Leader>fj", ":FormatJSON", 0)
call KeyMap("<Leader>fx", ":FormatXML", 0)
call KeyMap("<Leader>h", ":ToggleHidden", 1)
call KeyMap("<Leader>c", ":ToggleCursor", 1)
call KeyMap("<Leader>f", ":Rgrep", 1)
call KeyMap("<Leader>fb", ":Bgrep", 1)
"call KeyMap("<C>C", '"+y', 1) "copy
"call KeyMap("<C>X", '"+x', 1) "cut
call KeyMap("<C>V", '"+gP', 1) "paste
nnoremap <silent> <Leader>+ :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> <Leader>- :exe "resize " . (winheight(0) * 2/3)<CR>
" Move line/block up: \k
nnoremap <leader>k :m-2<cr>
vnoremap <leader>k :m'<-2<cr>gv=gv
" Move line/block down: \j
nnoremap <leader>j :m+1<cr>
vnoremap <leader>j :m'>+1<cr>gv=gv
" Duplicate line/block down: \y
nnoremap <leader>y :t.<cr>
vnoremap <leader>y :t'>.<cr>gv=gv
" Mappings to move lines http://vim.wikia.com/wiki/Moving_lines_up_or_down
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Links 
" https://www.ibm.com/developerworks/library/l-vim-script-1/
