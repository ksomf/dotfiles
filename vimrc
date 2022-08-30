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
autocmd FileType python setlocal noexpandtab
syntax on

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
set showbreak=↪\
set listchars=tab:→\ ,trail:•,nbsp:•",eol:↲
"set mouse=a
set scrolloff=8
set sidescrolloff=8
set nojoinspaces
set splitright
set updatetime=300
set redrawtime=10000
"set clipboard=unnamedplus "Warning security risk
set autoread

set directory=~/.local/vim_swap//
set undofile
set undodir=~/.local/vim_undo//
set backup
set backupdir=~/.local/vim_backup//
"set spell

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

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(data_dir . '/plugins')

Plug 'voldikss/vim-floaterm'
let g:floaterm_keymap_toggle = '<F1>'
let g:floaterm_keymap_next   = '<F2>'
let g:floaterm_keymap_prev   = '<F3>'
let g:floaterm_keymap_new    = '<F4>'
let g:floaterm_gitcommit='floaterm'
let g:floaterm_autoinsert=1
let g:floaterm_width=0.8
let g:floaterm_height=0.8
let g:floaterm_wintitle=0
let g:floaterm_autoclose=1
augroup FloatermCustomisations
    autocmd!
    autocmd ColorScheme * highlight FloatermBorder guibg=none
augroup END

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'jpalardy/vim-slime'
let g:slime_target = "kitty"
let b:slime_config = { "window_id":2, "listen_on": $KITTY_LISTEN_ON }

Plug 'snakemake/snakemake', {'rtp': 'misc/vim'}

Plug 'neovim/nvim-lspconfig'

call plug#end()
" doautocmd User PlugLoaded
