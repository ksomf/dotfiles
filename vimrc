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
set wrap

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

set pastetoggle=<F5> 
:imap jk <Esc>
:nmap <F6> :cprevious<CR>
:nmap <F7> :cnext<CR>
:nmap <F8> :Make<CR>
:nnoremap <F9>  :ConqueGdbCommand step<CR>
:nnoremap <F10> :ConqueGdbCommand next<CR>
:nnoremap <F11> :ConqueGdbCommand finish<CR>

"set makeprg=./build_*.sh\ %                    " Set the make command to run build_*.sh scripts
":command -nargs=* Make silent make! <args> | cwindow 32 | redraw!  " Run the makeprg command with arguments and if errors show up open an error window
"
hi CocFloating guibg=none guifg=none

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

Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter'

Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/nvim-cmp'
Plug 'onsails/lspkind.nvim'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

call plug#end()
" doautocmd User PlugLoaded

lua <<EOF
require("mason").setup()
require("mason-lspconfig").setup({
-- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
	ensure_installed = { "asm_lsp", "clangd", "fortls", "hls", "ltex", "marksman", "ruff_lsp", "r_language_server", "rust_analyzer", "vimls", "yamlls" },
	automatic_installation = true,
})
require('nvim-treesitter.configs').setup({
	ensure_installed = { "bibtex", "c", "cpp", "cuda", "llvm", "lua", "make", "markdown", "python", "r", "rust", "vim" },
	auto_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	}
})

local lspkind = require('lspkind')
local cmp = require'cmp'

-- https://github.com/hrsh7th/nvim-cmp, with lspkind modification
cmp.setup({
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol', -- show only symbol annotations
      maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
    })
  },
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
  }, {
    { name = 'buffer' },
  }),
  enabled = function()
    -- disable completion in comments
    local context = require 'cmp.config.context'
    -- keep command mode completion enabled when cursor is in a comment
    if vim.api.nvim_get_mode().mode == 'c' then
      return true
    else
      return not context.in_treesitter_capture("comment") 
        and not context.in_syntax_group("Comment")
    end
  end
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Setup lspconfig. (:h mason-lspconfig-automatic-server-setup)
local capabilities = require('cmp_nvim_lsp').default_capabilities()
require('mason-lspconfig').setup_handlers {
  function (server_name)
    require('lspconfig')[server_name].setup { capabilities = capabilities }
  end,
  ['ruff_lsp'] = function ()
    require('lspconfig')['ruff_lsp'].setup {
      capabilities = capabilities,
      init_options = { settings = { args = { '--ignore', 'E501' } } }
    }
    end
}

-- FIX Awefull Floating Window Colour Scheme https://old.reddit.com/r/neovim/comments/tibfjr/changing_popup_window_background_color/i1d7q1b/
vim.api.nvim_set_hl(0, "NormalFloat", { ctermbg = "darkgrey", ctermfg = "darkred" })
vim.api.nvim_set_hl(0, "Pmenu"      , { ctermbg = "darkgrey", ctermfg = "darkred" })

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    signs = {
      severity_limit = "Warning",
    },
    virtual_text = {
      severity_limit = "Warning",
    },
    underline = {
      severity_limit = "Warning",
    },
  }
)
EOF
