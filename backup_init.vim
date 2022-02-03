"Infecting nvim with pathogen
execute pathogen#infect()
"What are those values?
  set nocompatible

  " Specify a directory for plugins
  " - For Neovim: stdpath('data') . '/plugged'
  " - Avoid using standard Vim directory names like 'plugin'
  call plug#begin('~/.vim/plugged')

  "General stuff
  Plug 'morhetz/gruvbox'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-repeat'
  Plug 'itchyny/lightline.vim'
  Plug 'jiangmiao/auto-pairs'
  Plug 'RRethy/vim-hexokinase', { 'do': 'make hexokinase' }
  Plug 'sbdchd/neoformat'

  " language server & autocompletion
  Plug 'neovim/nvim-lspconfig'
  Plug 'glepnir/lspsaga.nvim'
  Plug 'ray-x/guihua.lua', {'do': 'cd lua/fzy && make' }
  Plug 'ray-x/navigator.lua'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}

  "  Snippets
  Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
  Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}
  
  " file explorer and more
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-telescope/telescope-fzy-native.nvim'
  Plug 'preservim/nerdtree'
  Plug 'ryanoasis/vim-devicons'

  "HTML,CSS...
  Plug 'mattn/emmet-vim'

  "EJS JST syntax 
  Plug 'briancollins/vim-jst'


  call plug#end()

  " setting up lspconfig and navigator 
  lua <<EOF
  require'navigator'.setup()
  EOF


  " lspconfig for lsp
  lua <<EOF
  require'lspconfig'.clangd.setup{}
  require'lspconfig'.bashls.setup{}
  require'lspconfig'.angularls.setup{}
  require'lspconfig'.cssls.setup{}
  require'lspconfig'.cssmodules_ls.setup{}
  require'lspconfig'.dockerls.setup{}
  require'lspconfig'.gopls.setup{}
  require'lspconfig'.jsonls.setup{}
  require'lspconfig'.omnisharp.setup{}
  require'lspconfig'.pyright.setup{}
  require'lspconfig'.sqls.setup{}
  require'lspconfig'.tailwindcss.setup{}
  EOF

  " lspconfig for keybindings
  lua << EOF
  local nvim_lsp = require('lspconfig')

  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'pyright', 'clangd', 'bashls', 'angularls', 'cssls'}
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
EOF


 " setting up treesitter

 lua <<EOF
require'nvim-treesitter.configs'.setup {
  -- One of "all", "maintained" (parsers with maintainers), or a list of languages
  ensure_installed = "maintained",

  -- Install languages synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- List of parsers to ignore installing
  ignore_install = {  },

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- list of language that will be disabled
    disable = { },

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
EOF


 "Emmet settings
  let g:user_emmet_mode='inv'
  let g:user_emmet_leader_key='!'
  let g:user_emmet_settings = webapi#json#decode(join(readfile(expand('~/.vim/after/snippets.json')), "\n"))


   " True colors
  set background=dark
  if (has("nvim"))
	  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
	  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  " Italics for my favorite color scheme

  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  set termguicolors
  " Set hybrid relative and absolute line numbers
  set number
  set relativenumber

  " General settings
  set ignorecase    " ignore case when searching
  set smartcase     " ignore case if search pattern is all lowercase,
  set hlsearch      " highlight search terms
  set incsearch     " show search matches as you type
  set noswapfile    " Turn off swap file
  " soft wrap settings
  set wrap linebreak nolist

  " No delay when pressing esc on visual select
  set timeoutlen=1000 ttimeoutlen=0

  " Ctrl F7 to toggle Nerdtree
  nnoremap <silent>;t <cmd>:NERDTreeToggle<CR>
  " Start NERDTree and put the cursor back in the other window.
  autocmd VimEnter * NERDTree | wincmd p
  
  "built in compiler bitch
  map <F8> :w <CR> :!gcc % -o %< && ./%< <CR>
  " Toggle paste mode on F2
  set pastetoggle=<F2>

  " vim hexokinase
  let g:Hexokinase_highlighters = ['virtual']
  let g:Hexokinase_optInPatterns = [
\     'full_hex',
\     'triple_hex',
\     'rgb',
\     'rgba',
\     'hsl',
\     'hsla'
\ ]

  " Telescope config
  " Find files using Telescope command-line sugar.
  nnoremap <silent>;f <cmd>Telescope find_files<cr>
  nnoremap <silent>;g <cmd>Telescope live_grep<cr>
  nnoremap <silent>;b <cmd>Telescope buffers<cr>
  nnoremap <silent>;h <cmd>Telescope help_tags<cr>
  " source ./telescope.nvim

  " syntax highlighting for ejs files
  au BufNewFile,BufRead *.ejs set filetype=html

  " Better display for messages
  set cmdheight=2
  " Smaller updatetime for CursorHold & CursorHoldI
  set updatetime=300
  " don't give |ins-completion-menu| messages.
  set shortmess+=c
  " always show signcolumns
  set signcolumn=yes
  
  " omnisharp config
  let g:OmniSharp_translate_cygwin_wsl = 1


  " vim-javascript
  let g:javascript_plugin_jsdoc = 1
  let g:javascript_plugin_flow = 1

  " Use markdown syntax for .md
  autocmd BufNewFile,BufReadPost *.md set filetype=markdown
  
   " vim-go
  let g:go_fmt_command = "goimports"
  let g:go_list_type = "quickfix"
  let g:go_fmt_fail_silently = 1 " Let neomake show errors instead
  let g:go_highlight_types = 1
  let g:go_highlight_fields = 1
  let g:go_highlight_functions = 1
  let g:go_highlight_methods = 1
  let g:go_highlight_operators = 1
  let g:go_highlight_extra_types = 1
  let g:go_highlight_build_constraints = 1


  " lightline
  set laststatus=2
  let g:lightline = {'colorscheme': 'gruvbox'}


  "Gruvbox theme
  let g:gruvbox_italic=1
  colorscheme gruvbox

  " Workaround for creating transparent bg
  autocmd SourcePost * highlight Normal     ctermbg=NONE guibg=NONE
			  \ |    highlight LineNr     ctermbg=NONE guibg=NONE
			  \ |    highlight SignColumn ctermbg=NONE guibg=NONE


  " Vim-ruby
  autocmd FileType ruby,eruby compiler ruby
  autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
  autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
  autocmd FileType ruby,eruby let g:rubycomplete_rails = 1

 " ERB tags
  autocmd FileType eruby let g:surround_45 = "<% \r %>"
  autocmd FileType eruby let g:surround_61 = "<%= \r %>"
  autocmd FileType eruby let g:surround_33 = "```\r```"

  " Python providers
  let g:python_host_prog = '/usr/local/bin/python2'
  let g:python3_host_prog = '/usr/bin/python3'
  
  " Autoindent
  filetype indent on
  filetype plugin indent on
 
  " Indent line color
   let g:indentLine_color_term = 239
   let g:indentLine_char_list = ['|', '¦', '┆', '┊']
   

  " Emoji shotcuts
  ab :white_check_mark: ✅
  ab :bulb: 💡
  ab :pushpin: 📌
  ab :bomb: 💣
  ab :pill: 💊
  ab :construction: 🚧
  ab :pencil: 📝
  ab :point_right: 👉
  ab :book: 📖
  ab :link: 🔗
  ab :wrench: 🔧
  ab :info: 🛈
  ab :telephone: 📞
  ab :email: 📧
  ab :computer: 💻
