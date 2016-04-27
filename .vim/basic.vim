"----------------------------
" encoding
"----------------------------

set encoding=utf-8
scriptencoding utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp932,sjis,euc-jp,iso-2022-jp

" 改行コード
set fileformat=unix
set fileformats=unix,dos,mac



"----------------------------
" Common
"----------------------------

" reset autocmd
augroup vimrc
  autocmd!
augroup END

set ambiwidth=double              " Use twice the width of ASCII characters.
set autochdir                     " Switch chdir automatically.
set autoread                      " Switch back to using the global value.
set backspace=indent,eol,start    " Delete all by backspace .
set cmdheight=2                   " Show 2lines fo cmd line.
set foldlevel=99
set helplang=ja,en"               " Help languages
set helpheight=999
set hidden
set matchpairs& matchpairs+=<:>
set nobackup"                     "Don't create backupfiles
set noerrorbells"                 "Don't sound errorbells
set noswapfile"                   "Don't create swapfiles
set notimeout"                    "Don't timeout
set notitle"                      "Don't show title
set nowritebackup
set nrformats=
set number"                       "Set line numbers
set ruler"                        "Set column numbers"
set scrolloff=3
set sidescrolloff=6
set showcmd"                      "Show command
set smarttab
set textwidth=0
set ttimeout
set timeoutlen=100
set visualbell t_vb=
set virtualedit=all
set wrap



"----------------------------
" Visual
"----------------------------

set background=dark
colorscheme hybrid                " Set colorscheme
syntax on"                        " Set syntax
highlight Normal ctermbg=None

set t_Co=256
set colorcolumn=80

set statusline=2
set laststatus=2

set cursorcolumn
set cursorline
highlight clear CursorLine
highlight CursorLine ctermbg=0

augroup cch
  autocmd!
  autocmd WinLeave * set nocursorline
  autocmd WinEnter,BufRead * set cursorline
augroup END

highlight SpellBad cterm=underline ctermbg=0



"----------------------------
" Indent
"----------------------------

filetype plugin indent on
set autoindent
set smartindent
set cindent



"---------------------------
" Status line
"--------------------------

set statusline=%<
set statusline+=[%n]
set statusline+=%m
set statusline+=%r
set statusline+=%h
set statusline+=%w
set statusline+=%{'['.(&fenc!='?&fenc:&enc).':'.&ff.']'}}}
set statusline+=%y
set statusline+=\
set statusline+=%{fugitive#statusline(}}}

if winwidth(0) >= 130
  set statusline+=%F
else
  set statusline+=%t
endif

"----------------------------
" Search
"----------------------------

set incsearch
set hlsearch
set ignorecase
set smartcase
set wrapscan



"----------------------------
" Complete
"----------------------------

set wildmenu
set wildmode=list:full
set history=1000
set complete+=k



"----------------------------
" Input assist
"----------------------------

set list
set listchars=tab:>.,trail:_,eol:↲,extends:>,precedes:<,nbsp:%
set whichwrap=b,s,h,l,<,>,[,]
set showmatch
set matchtime=3
set expandtab
set tabstop=2
set softtabstop=0
set shiftwidth=2
set display=lastline

" 括弧の補完
inoremap () ()<Left>
inoremap "" ""<Left>
inoremap [] []<Left>
inoremap {} {}<Left>
inoremap '' ''<Left>
inoremap <> <><Left>
inoremap ** **<Left>

function! ZenkakuSpace()
  highlight ZenkakuSpace cterm=reverse ctermfg=Black gui=reverse
endfunction

if has('syntax')
  augroup ZenkakuSpace
    autocmd!
    autocmd ColorScheme       * call ZenkakuSpace()
    autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
  augroup END
  call ZenkakuSpace()
endif



"----------------------------
" Clipboard
"----------------------------

set clipboard=unnamed,autoselect
set clipboard+=autoselect



"----------------------------
" Key mapping
"----------------------------
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'

vmap <C-c> :w !xsel -ib<CR><CR>



"----------------------------
" vimrc
"----------------------------

" easy open vimrc
if has("win64")
  let vimrcbody = '$HOME/_vimrc'
else
  let vimrcbody = '$HOME/.vimrc'
endif

function! OpenFile(file)
  let empty_buffer=
    \ line('$')==1 && strlen(getline('1'))==0
  if empty_buffer && !&modified
    execute 'e ' . a:file
  else
    execute 'tabnew ' . a:file
  endif
endfunction

command! OpenMyVimrc call OpenFile(vimrcbody)
nnoremap <Space><Space> :<C-u>OpenMyVimrc<CR>

" easy reload vimrc
function! SourceIfExists(file)
  if filereadable(expand(a:file))
    execute 'source ' . a:file
  endif
  echo 'Reload vimrc.'
endfunction

nnoremap <F5> <Esc>:<C-u>source $MYVIMRC<CR>
      \ :source $MYVIMRC<CR>
      \ :call SourceIfExists('~/vimfiles/ftplugin/' . &filetype . '.vim')<CR>



"----------------------------
" Plugins
"----------------------------

"# NERDTree
let g:NERDTreeShowBookmarks=1
if !argc()
  autocmd vimenter * NERDTree|normal gg3j
endif


"# lightline
let g:lightline = {
       \ 'colorscheme': 'wombat',
       \ 'active': {
       \   'right': [ [ 'syntastic', 'lineinfo' ],
       \              [ 'percent' ],
       \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
       \ },
       \ 'component': {
       \   'readonly': '%{&readonly?"⚷":""}',
       \ },
       \ 'component_expand': {
       \   'syntastic': 'SyntasticStatuslineFlag',
       \ },
       \ 'component_type': {
       \   'syntastic': 'error',
       \ },
       \ }
let g:syntastic_mode_map = { 'mode': 'passive' }

augroup reload_vimrc
  autocmd!
  autocmd bufwritepost $MYVIMRC nested source $MYVIMRC
augroup END

augroup AutoSyntastic
  autocmd!
  autocmd BufWritePost *.c,*.cpp call s:syntastic()
augroup END

function! s:syntastic()
  SyntasticCheck
  call lightline#update()
endfunction


"---------------------------
" vim-gitgutter
"---------------------------

let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '→'
let g:gitgutter_sign_removed = '✗'



"---------------------------
" evervim
"---------------------------

:helptags ~/.vim/bundle/evervim/doc/
let g:evervim_devtoken="S=s676:U=7b2a0fe:E=15baa64a54e:C=15452b377f0:P=1cd:A=en-devtoken:V=2:H=951bac9f11775981cb2788d6868cebd2"
