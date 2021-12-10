""""""""""""""""""""
" GENERAL SETTINGS "
""""""""""""""""""""

"Indentation
set noexpandtab
set tabstop=3
set softtabstop=3
set shiftwidth=3
set autoindent
set smartindent
set cindent
let fortran_free_source=1
let fortran_do_enddo=1

set hidden 

filetype plugin on
filetype indent on

set showcmd
set showmatch
set incsearch "Search immediately
set hlsearch  "Highlight partial search results
set smartcase
set wildmenu
set wildmode=longest:full,full
set nowrap

set number
set termguicolors
set title
set list
set listchars=tab:▸\ \ ,trail:·,nbsp:·
set mouse=a
set scrolloff=8
set sidescrolloff=8
set nojoinspaces
set splitright
set updatetime=300
set redrawtime=10000

set undofile
"set spell
set backup
set backupdir=~/.share/vim_backup

"""""""""""
" KEYMAPS "
"""""""""""
let mapleader = "\<space>"

" Keep cursor position when yanking visual http://ddrscott.github.io/blog/2016/yank-without-jank/
vnoremap y myy`y
vnoremap Y myY`y

set pastetoggle=<F2> 
:imap jk <Esc>
:nmap <F3> :cprevious<CR>
:nmap <F4> :cnext<CR>
:nmap <F5> :Make<CR>
:nnoremap <F9>  :ConqueGdbCommand step<CR>
:nnoremap <F10> :ConqueGdbCommand next<CR>
:nnoremap <F11> :ConqueGdbCommand finish<CR>

"set makeprg=./build_*.sh\ %                    " Set the make command to run build_*.sh scripts
":command -nargs=* Make silent make! <args> | cwindow 32 | redraw!  " Run the makeprg command with arguments and if errors show up open an error window

