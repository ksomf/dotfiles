----------------------
-- GENERAL SETTINGS --
----------------------

--Indentation
vim.opt.expandtab   = false
vim.opt.tabstop     = 3
vim.opt.softtabstop = 3
vim.opt.shiftwidth  = 3
vim.opt.autoindent  = true
vim.opt.smartindent = true
vim.opt.cindent     = true
vim.cmd([[
  let fortran_free_source=1
  let fortran_do_enddo=1
]])

vim.opt.hidden = true
vim.opt.wrap   = true

vim.cmd([[
filetype plugin on
filetype indent on
autocmd FileType python setlocal noexpandtab
syntax on
]])

vim.opt.showcmd   = true
vim.opt.showmatch = true
vim.opt.incsearch = true -- Search immediately
vim.opt.hlsearch  = true -- Highlight partial search results
vim.opt.smartcase = true
vim.opt.wildmenu  = true
vim.opt.wildmode  = 'longest:full,full'
vim.opt.wrap      = false

vim.opt.number        = true
vim.opt.termguicolors = true
vim.opt.title         = true
vim.opt.list          = true
vim.opt.scrolloff     = 8
vim.opt.sidescrolloff = 8
vim.opt.joinspaces    = false
vim.opt.splitright    = true
vim.opt.updatetime    = 300
vim.opt.redrawtime    = 10000
vim.opt.autoread      = true
vim.cmd([[
set showbreak=↪\
set listchars=tab:→\ ,trail:•,nbsp:•",eol:↲
]])
--vim.opt.clipboard   =unnamedplus "Warning security risk
--vim.opt.mouse       ='a'

vim.opt.directory = os.getenv("HOME") .. '/.local/vim_swap//'
vim.opt.undofile  = true
vim.opt.undodir   = os.getenv("HOME") .. '/.local/vim_undo//'
vim.opt.backup    = true
vim.opt.backupdir = os.getenv("HOME") .. '/.local/vim_backup//'


vim.opt.spell = false

-------------
-- KEYMAPS --
-------------

-- Keep cursor position when yanking visual http://ddrscott.github.io/blog/2016/yank-without-jank/
vim.cmd([[
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
]])

vim.cmd([[
"set makeprg=./build_*.sh\ %                    " Set the make command to run build_*.sh scripts
":command -nargs=* Make silent make! <args> | cwindow 32 | redraw!  " Run the makeprg command with arguments and if errors show up open an error window
"
hi CocFloating guibg=none guifg=none
]])

local config_dir = vim.fn.stdpath('config')
local data_dir   = vim.fn.stdpath('data')

local ensure_packer = function()
  local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  
  use { 'voldikss/vim-floaterm'
      , config=function() 
			vim.g.floaterm_keymap_toggle = '<F1>' 
         vim.g.floaterm_keymap_next   = '<F2>'
         vim.g.floaterm_keymap_prev   = '<F3>'
         vim.g.floaterm_keymap_new    = '<F4>'
         vim.g.floaterm_gitcommit     ='floaterm'
         vim.g.floaterm_autoinsert    =1
         vim.g.floaterm_width         =0.8
         vim.g.floaterm_height        =0.8
         vim.g.floaterm_wintitle      =0
         vim.g.floaterm_autoclose     =1

         vim.cmd([[
         augroup FloatermCustomisations
             autocmd!
             autocmd ColorScheme * highlight FloatermBorder guibg=none
         augroup END
         ]])
		end }

  use 'tpope/vim-commentary'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  use 'tpope/vim-dispatch'
  use 'tpope/vim-unimpaired'
  use 'tpope/vim-eunuch'
  use 'tpope/vim-surround'
  use 'tpope/vim-repeat'

  use { 'junegunn/fzf', run=vim.fn['fzf#install'] }
  use 'junegunn/fzf.vim'

  use { 'jpalardy/vim-slime'
      , config=function()
          vim.g.slime_target = "kitty"
          vim.g.slime_config = { window_id=2, listen_on=os.getenv('KITTY_LISTEN_ON') }
        end }

  use { 'snakemake/snakemake', rtp='misc/vim' }

  use { 'williamboman/mason.nvim', config=function() require("mason").setup() end }
  use { 'williamboman/mason-lspconfig.nvim'
      , requires={'williamboman/mason.nvim'}
		, config=function()
          require("mason-lspconfig").setup({
          -- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
          	ensure_installed = { "asm_lsp", "clangd", "fortls", "hls", "ltex", "marksman", "ruff_lsp", "jedi_language_server", "r_language_server", "rust_analyzer", "vimls", "yamlls" },
          	automatic_installation = true,
          })
		  end }

  use 'neovim/nvim-lspconfig'
  use { 'nvim-treesitter/nvim-treesitter'
      , requires={'williamboman/mason.nvim', 'williamboman/mason-lspconfig.nvim', 'neovim/nvim-lspconfig'}
		, config=function()
          require('nvim-treesitter.configs').setup({
          	ensure_installed = { "bibtex", "c", "cpp", "cuda", "llvm", "lua", "make", "markdown", "python", "r", "rust", "vim", "yaml" },
          	auto_install = true,
          	highlight = {
          		enable = true,
          		additional_vim_regex_highlighting = false,
          	}
          })
        end }

  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'
  use 'onsails/lspkind.nvim'

  use { 'hrsh7th/nvim-cmp'
      , requires = { 'williamboman/mason.nvim', 'williamboman/mason-lspconfig.nvim', 'neovim/nvim-lspconfig', 'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-vsnip', 'hrsh7th/vim-vsnip', 'onsails/lspkind.nvim' }
		, config =  function()
          local lspkind = require('lspkind')
          local cmp = require('cmp')
          
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
          
          -- See: https://github.com/neovim/nvim-lspconfig/tree/54eb2a070a4f389b1be0f98070f81d23e2b1a715#suggested-configuration
          local on_attach = function(client, bufnr)
            -- Enable completion triggered by <c-x><c-o>
				-- Also allows default behaviour if no LSP attached
            vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
            local bufopts = { noremap=true, silent=true, buffer=bufnr }
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
            vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
            vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
            vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
            vim.keymap.set('n', '<space>wl', function()
              print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, bufopts)
            vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
            vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
            vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
            vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
          end
          
          -- Setup lspconfig. (:h mason-lspconfig-automatic-server-setup)
          local capabilities = require('cmp_nvim_lsp').default_capabilities()
          require('mason-lspconfig').setup_handlers {
            function (server_name)
              require('lspconfig')[server_name].setup { capabilities = capabilities, on_attach = on_attach }
            end,
            ['ruff_lsp'] = function ()
              require('lspconfig')['ruff_lsp'].setup {
                capabilities = capabilities,
                init_options = { settings = { args = { '--ignore', 'E501', '--ignore', 'E101' } } },
                on_attach    = on_attach
              }
              end
          }
		
		  end }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost init.lua source <afile> | PackerCompile
  augroup end
]])

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
