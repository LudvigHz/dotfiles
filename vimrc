"na    __              _         _
"   / /   _   _   __| |__   __(_)  __ _   /\  /\ ____
"  / /   | | | | / _` |\ \ / /| | / _` | / /_/ /|_  /
" / /___ | |_| || (_| | \ V / | || (_| |/ __  /  / /
" \____/  \__,_| \__,_|  \_/  |_| \__, |\/ /_/  /___|
"                                 |___/
"
" ---------------------------------------------------------
"
" | |  / /   (_)   ____ ___    _____  _____
" | | / /   / /   / __ `__ \  / ___/ / ___/
" | |/ /   / /   / / / / / / / /    / /__
" |___/   /_/   /_/ /_/ /_/ /_/     \___/
"
"



"###########################################################
"###########################################################
"#                                                         #
"#              General Editor settings                    #
"#                                                         #
"###########################################################
"###########################################################

set encoding=UTF-8
set textwidth=100               " Set line break on 100 chars
set showmatch                   " Show matching bracket/
set noswapfile                  " Disable swap files
set hlsearch                    " Highlight all search results
set ignorecase                  " Ignore case on search
set autoindent                  " Autoindent on new line
set expandtab                   " Use spaces, not tabs
set shiftwidth=2                " Set tab to 2 spaces
set softtabstop=2
set ruler                       " Show char pos
set undolevels=1000             " Better undo history
set mouse=a                     " Enable mouse in all modes
set ttyfast                     " Fast scrolling
set scrolloff=10                " Scoll offset. 10 lines above/below cursor
set autoread                    " Autoupdate files
set incsearch                   " Enable incremental search
set clipboard=unnamed           " Use standard clipboard
set hidden                      " Hide buffer when it is not in a window
set updatetime=100              " Update more often (Gitgutter and Ale)
filetype plugin on              " Enable file type specific settings
syntax on                       " Enable syntax highlighting
if exists('+termguicolors')
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif
set visualbell                  " Use visual bell instead of audio
set t_vb=                       " Set visual bell to do nothing (Disable)
set noshowmode
set ttimeoutlen=10
set cmdheight=1

" Visuals
set laststatus=2
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:.
set number                      " Show line numbers
" Wildmenu
set wildcharm=<Tab>             " Use Tab for wildmenu selection
set wildmenu
set wildmode=full
set guicursor=n-v-c:block-Cursor

" Retain cursor position when reading a new buffer
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif


"#--------------------------------------
"# Netrw settings
"#--------------------------------------
let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_browse_split = 1
let g:netrw_winsize = 25
let g:netrw_altv = 1

" Toggle Vexplore with Ctrl-E
function! ToggleVExplorer()
  if exists('t:expl_buf_num')
      let expl_win_num = bufwinnr(t:expl_buf_num)
      if expl_win_num != -1
          let cur_win_nr = winnr()
          exec expl_win_num . 'wincmd w'
          close
          exec cur_win_nr . 'wincmd w'
          unlet t:expl_buf_num
      else
          unlet t:expl_buf_num
      endif
  else
      exec '1wincmd w'
      Vexplore
      let t:expl_buf_num = bufnr('%')
  endif
endfunction
map <silent> <leader>e :call ToggleVExplorer()<CR>


"#-------------------------------------
"# Status bar (If airline is disabled)
"#-------------------------------------
let g:bufferline_echo = 0
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ [BUFFER=%n]\%{strftime('%c')}
hi statusline guibg=DarkGrey ctermfg=10 guifg=Grey ctermbg=20


"#--------------------------------------
"# Keymaps (non-plugin)
"#--------------------------------------
let mapleader = ','             " Use ',' as leader
map <Space> :noh<CR>

" Keep selection when indenting in visual mode
vnoremap > >gv
vnoremap < <gv

" Fast buffer switching
nnoremap <leader><Tab> :buffer<Space><Tab>

" Navigate between buffers
nmap <C-l> :bnext<CR>
nmap <C-h> :bprevious<CR>
nnoremap <C-w> :bp <BAR> bd #<CR>

" Use F2 to toggle paste on/off
nnoremap <F2> :set invpaste paste?<CR>
imap <F2> <C-O>:set invpaste paste?<CR>
set pastetoggle=<F2>

" Splits (See also vim-tmux-navigator)
nmap <silent> <C-t>k :wincmd k<CR>
nmap <silent> <C-t>l :wincmd l<CR>
nmap <silent> <C-t>j :wincmd j<CR>
nmap <silent> <C-t>h :wincmd h<CR>

"#--------------------------------------
"# Undos
"#--------------------------------------
set undofile
set undodir=$HOME/.vim/undo
set undolevels=1000
set undoreload=10000

if !isdirectory(&undodir)
  call system("bash -c \"mkdir -p " . &undodir . "\"")
endif


"#--------------------------------------
"# Spellcheck
"#--------------------------------------
augroup text_langs
  autocmd!
  autocmd FileType tex,text,markdown setlocal spell
  autocmd FileType tex,text,markdown setlocal spelllang=nb,en_us
augroup end

inoremap <c-h> <c-g>u<Esc>[s1z=`]a<c-g>u

"Spellchecking and text wrapping in commits
autocmd Filetype gitcommit setlocal spell textwidth=72


"#--------------------------------------
"# Autoclose hidden buffers if the file is defined in .gitignore
"#--------------------------------------
function! Close_gitignore()
  let git_dir = substitute(system('git rev-parse --show-toplevel'), '\n\+$', '', '')
  if filereadable(git_dir . '/.gitignore')
    for buffer in copy(getbufinfo())
      let file_ignored = 0
      for oline in readfile(git_dir . '/.gitignore')
        let line = substitute(oline, '\s|\n|\r', '', 'g')
        if buffer.name =~ line
          let file_ignored = 1
          break
        endif
      endfor
      if buffer.hidden && file_ignored
        execute 'bdelete ' . buffer.bufnr
      endif
    endfor
  endif
endfun
" For some reason getbufinfo() is not updated if called on BufHidden
" so BufEnter has to be used instead
"augroup buffer_autoclose
  "autocmd!
  "autocmd BufEnter * call Close_gitignore()
"augroup end


"#--------------------------------------
"# Open current file with xdg-open
"#--------------------------------------
function! Open_xdg()
  let file_uri = fnameescape(expand('%:p'))
  execute system('xdg-open ' . file_uri)
endfun

command ShowFile call Open_xdg()

function! s:eis_on_err(j, d, e)
  if len(a:d[0]) > 0
    redraw
    echoe a:d[0]
  endif
endfun

function! s:eis_on_out(j, d, e)
  redraw
  echoh MoreMsg | echom "Eisvogel compiled successfully" | echoh None
endfun

"#--------------------------------------
"# Create pdf from md using eisvogel template
"#--------------------------------------
function! EisvogelRun()
  redraw
  echom "Compiling pandoc..."
  let generated_file = substitute(fnameescape(expand('%:p')), '.md', '.pdf', '')
  call jobstart('pandoc --pdf-engine=tectonic --filter pandoc-latex-environment '
        \ . fnameescape(expand('%:p'))
        \ . ' -o '
        \ . generated_file
        \ . ' --from markdown --template eisvogel -V lang=en --listings',
        \ {
          \ 'stdout_buffered': 1,
          \ 'stderr_buffered': 1,
          \ 'on_stderr': function("s:eis_on_err"),
          \ 'on_stdout': function("s:eis_on_out")
        \ })
  " If run for the first time, open the generated pdf in zathura, or another program
  if !get(b:, 'eisvogel_auto_run', 0) && filereadable(generated_file)
    try
      execute system(get(g:, 'pdf_viewer', 'xdg-open') . generated_file . ' &')
    catch
      try
        if has('macunix')
          execute system('open ' . generated_file)
        elseif has('unix')
          execute system('xdg-open ' . generated_file)
        else
          throw 1
        endif
      catch
        echom 'No pdf viewer available to open file'
      endtry
    endtry
    let b:eisvogel_auto_run = 1
  endif
endfunction

augroup eisvogel_on_save
  autocmd!
  autocmd FileType markdown let b:eisvogel_auto_run = 0
  autocmd BufWritePost * if get(b:, 'eisvogel_auto', 0) | call EisvogelRun() | endif
augroup end

function! Eis_toggleMsg()
  echom 'Eisvogel auto compile ' . (get(b:, 'eisvogel_auto') ? 'ON' : 'OFF')
endfun

" Command to toggle compile on save for the current buffer
command EisvogelToggle let b:eisvogel_auto = !get(b:, 'eisvogel_auto', 0) | call Eis_toggleMsg()
" Command to recompile current buffer
command EisvogelCompile call EisvogelRun()



let g:python3_host_prog = '/usr/bin/python3'
if has('mac')
  let g:python3_host_prog = '/usr/bin/python3'
endif


"###########################################################
"###########################################################
"#                                                         #
"#                        Plugins                          #
"#                                                         #
"###########################################################
"###########################################################


" -------------------------------------
" Load plugins with vim-plug
" -------------------------------------
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
        endif


call plug#begin('~/.vim/plugged')

Plug 'vim-airline/vim-airline'              " Status bar
Plug 'ryanoasis/vim-devicons'               " devicons for all icon support (requires nerdfont)
Plug 'junegunn/fzf.vim'                     " Fzf must have fuzzy search
"if filereadable('~/.fzf')
  "" For git installations
  "Plug '~/.fzf'
  "let g:fzf_installed = 1
"elseif filereadable('/usr/share/doc/fzf/examples/fzf.vim')
  "" For debian installations with fzf installed through apt
  "source /usr/share/doc/fzf/examples/fzf.vim
  "let g:fzf_installed = 1
"else
  "" If fzf is not installed, can fall back to Vexplore
  "let g:fzf_installed = 0
"endif
Plug 'junegunn/fzf', {'do': { -> fzf#install() }}
let g:fzf_installed = 1

if has('nvim')
  Plug 'p00f/nvim-ts-rainbow'
else
  Plug 'junegunn/rainbow_parentheses.vim'   " Rainbow parentheses
endif

Plug 'junegunn/vim-peekaboo'                " Show register contents
Plug 'christoomey/vim-tmux-navigator'

Plug 'dense-analysis/ale'                   " Linter
Plug 'airblade/vim-gitgutter'               " Git info before line numbers

" Color schemes
Plug 'gruvbox-community/gruvbox'            " Standard color scheme
"Plug 'gilgigilgil/anderson.vim'             " Alternate color schemes
"Plug 'srcery-colors/srcery-vim'
"Plug 'sainnhe/gruvbox-material'

" Completion (nvim-lsp)
if has('nvim')
  Plug 'neovim/nvim-lspconfig'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/cmp-omni'
  "Plug 'quangnguyen30192/cmp-nvim-ultisnips'
  Plug 'onsails/lspkind-nvim'
  Plug 'ray-x/lsp_signature.nvim'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  "Plug 'mfussenegger/nvim-jdtls'
  "Plug 'mfussenegger/nvim-dap'             " Debug Adapter Protocol support
  "Plug 'simrat39/rust-tools.nvim'

  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'

  Plug 'IndianBoy42/tree-sitter-just'
endif

Plug 'sheerun/vim-polyglot'                 " Support for most languages
"Plug 'NoahTheDuke/vim-just'

Plug 'tpope/vim-fugitive'                   " More git info
Plug 'tpope/vim-surround'                   " Tag and delimit manipulation
Plug 'tpope/vim-repeat'                     " Repeat plugin commands
"Plug 'tpope/vim-vinegar'                    " netrw tweaks
Plug 'tpope/vim-sleuth'                     " Auto set tab width based on buffer

Plug 'mbbill/undotree'                      " Undo tree
if !has('nvim')
  Plug 'scrooloose/nerdcommenter'           " Command to comment out code
endif
if has('nvim')
  Plug 'm4xshen/autoclose.nvim'
else
  Plug 'raimondi/delimitmate'                 " Auto close tags and parentheses
endif
"Plug 'RRethy/vim-hexokinase', {'do': 'make hexokinase'} " Color highlighting CSS
Plug 'mhinz/vim-startify'                   " Fancy start screen
Plug 'svermeulen/vim-yoink'                 " Yank utils
Plug 'tmux-plugins/vim-tmux'                " tmux.conf editing features

"Plug 'kdheepak/JuliaFormatter.vim'

" LaTeX and snippets
Plug 'lervag/vimtex'
"Plug 'peterbjorgensen/sved'
"Plug 'vim-pandoc/vim-pandoc-syntax'
"Plug 'SirVer/ultisnips'
"Plug 'honza/vim-snippets'

"Plug 'omnisharp/omnisharp-vim'

call plug#end()


"#--------------------------------------
"# Color scheme
"#--------------------------------------
colorscheme gruvbox
set background=dark
let g:gruvbox_improved_warnings = '1'
let g:gruvbox_contrast_dark = 'medium'
let g:gruvbox_sign_column = 'NONE'
let g:gruvbox_material_palette = 'original'
"colorscheme gruvbox-material

autocmd! ColorScheme
autocmd ColorScheme * hi Visual cterm=NONE ctermbg=237 guibg=#3a3a3a
hi Visual cterm=NONE ctermbg=237 gui=NONE guibg=#3a3a3a


"#--------------------------------------
"# Undotree
"#--------------------------------------
nnoremap <leader>u :UndotreeToggle<CR>


"#--------------------------------------
"# Fzf
"#--------------------------------------
function! CustomFiles()
  if !get(g:, 'fzf_installed')
    call ToggleVExplorer()
    return
  endif
  let git_dir = substitute(system('git rev-parse --show-toplevel'), '\n\+$', '', '')
  if isdirectory(git_dir)
    :GFiles -co --exclude-standard
  else
    :Files
  endif
endfunction

nnoremap <C-p> :call CustomFiles()<CR>
nnoremap <C-O> :Buffers<CR>

let $FZF_DEFAULT_OPTS="--ansi --preview-window 'right:60%' --layout reverse --margin=1,4 --preview 'batcat --color=always --style=header,grid --line-range :300 {}'"

" Terminal buffer options for fzf
autocmd! FileType fzf
autocmd  FileType fzf set noshowmode noruler nonu


"#--------------------------------------
"# vim-tmux-navigator
"#--------------------------------------
let g:tmux_navigator_no_mappings = 1

nnoremap <silent> <C-b>h :TmuxNavigateLeft<cr>
nnoremap <silent> <C-b>j :TmuxNavigateDown<cr>
nnoremap <silent> <C-b>k :TmuxNavigateUp<cr>
nnoremap <silent> <C-b>l :TmuxNavigateRight<cr>
nnoremap <silent> <C-b>/ :TmuxNavigatePrevious<cr>



"#--------------------------------------
"# Ale
"#--------------------------------------
let g:ale_fixers = {
            \'*': ['remove_trailing_lines', 'trim_whitespace'],
            \'javascript': ['prettier', 'eslint'],
            \'javascriptreact': ['prettier', 'eslint'],
            \'json': ['prettier'],
            \'typescript': ['prettier', 'eslint', 'biome'],
            \'typescriptreact': ['prettier', 'eslint', 'biome'],
            \'python': ['black', 'isort', 'ruff'],
            \'java': ['google_java_format'],
            \'css': ['prettier'],
            \'markdown': ['prettier'],
            \'pandoc': ['prettier'],
            \'sql': ['sqlfmt'],
            \'sh': ['shfmt'],
            \'bash': ['shfmt'],
            \'zsh': ['shfmt'],
            \'go': ['gofmt'],
            \'scala': ['scalafmt'],
            \'c': ['clang-format'],
            \'cpp': ['clang-format'],
            \'cuda': ['clang-format'],
            \'cs': [],
            \'rust': ['rustfmt'],
            \'zig': ['zigfmt'],
            \'julia': ['FormatJulia'],
            \'svelte': ['prettier'],
            \'ruby': ['syntax_tree', 'rubocop']
\}
            "\'lua': ['lua-format'],
            "
let g:ale_ruby_syntax_tree_executable = 'bundle'
let g:ale_ruby_rubocop_executable = 'bundle'

function! FormatJulia(buffer) abort
  :silent :JuliaFormatterFormat
endfunction


function! FormatDotnet(buffer) abort
  return {
        \'command': 'dotnet format --fix --include' . ' %t',
        \'read_temporary_file': 1,
        \}
endfunction

execute ale#fix#registry#Add('dotnet-format', 'FormatDotnet', ['cs'], 'Dotnet-format for csharp')

let g:ale_linters = {
      \'python': ['flake8', 'isort', 'mypy', 'ruff'],
      \'typescript': ['tsserver', 'eslint', 'biome'],
      \'typescriptreact': ['tsserver', 'eslint', 'biome'],
      \'javascript': ['eslint', 'ternjs', 'flow', 'biome'],
      \'jsx': ['stylelint'],
      \'sh': ['shell', 'shellcheck', 'language_server'],
      \'bash': ['shell', 'shellcheck'],
      \'zsh': ['shell'],
      \'scala': ['metals'],
      \'cs': [],
      \'rust': ['analyzer'],
\}

let g:ale_fix_on_save = '1'               " Enble auto fixing on save
let g:ale_lint_on_insert_leave = '1'
let g:ale_echo_msg_format = '[%linter%]: %s'
let g:ale_cursor_detail = '0'
hi ALEErrorSign ctermbg=235 ctermfg=160 guifg=#d70000
hi ALEWarningSign ctermbg=235 ctermfg=214 guifg=#ffaf00
let g:ale_sign_warning = ''
let g:ale_sign_error = ''
let g:ale_hover_to_preview = 1

let g:ale_writegood_options = '--no-passive'
let g:ale_c_parse_makefile = 1
let g:ale_c_clangformat_options = '--style=Mozilla'

let g:ale_disable_lsp = 1

if has('nvim')
  let g:ale_floating_preview = 1
  let g:ale_floating_window_border = ['│', '─', '╭', '╮', '╯', '╰']
endif

"--------------------------------------
"# LSP
"#--------------------------------------

set completeopt=menu,menuone,noselect
set shortmess+=c
" Use <Tab> and <S-Tab> to navigate through popup menu
"inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
"inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

if has('nvim')
lua << EOF
local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body)
    end,
    },

  mapping = {
    ['<Tab>'] = cmp.mapping(function(fallback)
      local col = vim.fn.col('.') - 1

      if cmp.visible() then
        cmp.select_next_item()
      elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        fallback()
      else
        cmp.complete()
      end
    end, {'i', 's'}),

    ['<S-Tab>'] = cmp.mapping(function(mapping)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, {'i', 's'}),

    ['<CR>'] = cmp.mapping.confirm({ select = true })
  },

  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    --{ name = 'omni' },
    --{ name = 'ultisnips' },
    { name = 'path' },
    --{ name = 'cmdline' },
  }, {
    { name = 'buffer', keyword_length = 3 },
  }),

  formatting = {
    format = function(entry, vim_item)
      -- fancy icons and a name of kind
      vim_item.kind = require("lspkind").presets.default[vim_item.kind] .. " " .. vim_item.kind

      -- set a name for each source
      vim_item.menu = ({
        omni = (vim.inspect(vim_item.menu):gsub('%"', "")),
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        luasnip = "[LuaSnip]",
        nvim_lua = "[Lua]",
        latex_symbols = "[Latex]",
      })[entry.source.name]
      return vim_item
    end,
  },

})
EOF



lua << EOF
local nvim_lsp = require('lspconfig')

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
  local map = function(keys, func, desc, mode)
    mode = mode or 'n'
    vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
  end

  map('<leader>d', require('telescope.builtin').lsp_definitions, 'Goto definitions')
  map('<leader>r', require('telescope.builtin').lsp_references, 'Goto references')

  end
  })

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<leader>i', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  --buf_set_keymap('n', '<leader>r', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'L', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
end

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

nvim_lsp.vimls.setup{on_attach=on_attach; capabilities=capabilities}

nvim_lsp.ccls.setup{on_attach=on_attach; capabilities=capabilities; filetypes = {"c", "cpp", "cuda"}}

nvim_lsp.ts_ls.setup{
  on_attach=on_attach;
  capabilities=capabilities;
  root_dir=nvim_lsp.util.root_pattern("package.json");
  --handlers={['textDocument/publishDiagnostics'] = function(...) end }
}


nvim_lsp.biome.setup{
  on_attach=on_attach;
  capabilities=capabilities;
}

nvim_lsp.jedi_language_server.setup{on_attach=on_attach; capabilities=capabilities}
nvim_lsp.ruff_lsp.setup{on_attach=on_attach; capabilities=capabilities}

nvim_lsp.gopls.setup{on_attach=on_attach; capabilities=capabilities}

nvim_lsp.metals.setup{on_attach=on_attach; capabilities=capabilities}

nvim_lsp.gopls.setup{on_attach=on_attach; capabilities=capabilities}

nvim_lsp.lua_ls.setup{
  on_attach=on_attach;
  capabilities=capabilities;
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT"
      },
      diagnostics = {
        globals = {'vim'},
      },
      workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
      },
      telemetry = {
        enable = false,
      }
    },
  }
}

-- Rust
nvim_lsp.rust_analyzer.setup{
  on_attach=on_attach;
  --capabilities=capabilities;
  settings = {
    ['rust-analyzer'] = {
      useClientWatching = true;
      checkOnSave = {
        command = "clippy"
      },
    }
  }
}

local rust_opts = {
    tools = { -- rust-tools options
        autoSetHints = true,
        hover_with_actions = true,
        inlay_hints = {
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = "",
        },
    },
}
--require('rust-tools').setup(rust_opts)
--------------

-- Zig
nvim_lsp.zls.setup{on_attach=on_attach; capabilities=capabilities}


-- Julia
nvim_lsp.julials.setup{on_attach=on_attach; capabilities=capabilities}

-- LaTeX
nvim_lsp.texlab.setup{on_attach=on_attach; capabilities=capabilities}

-- Elixir
nvim_lsp.elixirls.setup{
  on_attach=on_attach;
  capabilities=capabilities;
  cmd = { "/usr/lib/elixir-ls/language_server.sh" }
}

-- TOML
nvim_lsp.taplo.setup{
  on_attach=on_attach;
  capabilities=capabilities;
}

-- YAML
nvim_lsp.yamlls.setup{
  on_attach=on_attach;
  capabilities=capabilities;
  settings = {
    yaml = {
      schemas = {
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
        ["https://storage.googleapis.com/nais-json-schema-2c91/nais-k8s-all.json"] = "*nais*",
        }
      }
    }
}

-- JSON
nvim_lsp.jsonls.setup{
  on_attach=on_attach;
  capabilities=capabilities;
}

-- Terraform
nvim_lsp.terraformls.setup{
  on_attach=on_attach;
  capabilities=capabilities;
}

nvim_lsp.tailwindcss.setup{
  on_attach=on_attach;
  capabilities=capabilities;
}

-- Svelte
nvim_lsp.svelte.setup{
  on_attach=on_attach;
  capabilities=capabilities;
}

nvim_lsp.typst_lsp.setup{
  on_attach=on_attach;
  capabilities=capabilities;
}
-- Kotlin
nvim_lsp.kotlin_language_server.setup{
  on_attach=on_attach;
  capabilities=capabilities;
  -- root_dir=nvim_lsp.util.root_pattern("settings.gradle.kts")
}

-- Ruby
-- nvim_lsp.rubocop.setup{
--   on_attach=on_attach;
--   capabilities=capabilities;
-- }
-- nvim_lsp.ruby_ls.setup{
--   on_attach=on_attach;
--   capabilities=capabilities;
-- }
nvim_lsp.solargraph.setup{
  on_attach=on_attach;
  capabilities=capabilities;
}


local pid = vim.fn.getpid()
-- local omnisharp_bin = "/home/ludvig/.cache/omnisharp-vim/omnisharp-roslyn/omnisharp/OmniSharp.exe"
local omnisharp_bin = "/home/ludvig/.bin/run"


nvim_lsp.omnisharp.setup{
  on_attach=on_attach;
  cmd = {omnisharp_bin, "-lsp", "-s", vim.fn.getcwd(), "-e utf-8", "--hostPID", tostring(pid) };
  root_dir = nvim_lsp.util.root_pattern("*.sln");
}

-- Signature help
require'lsp_signature'.setup({
  bind = true,
  hint_prefix = " ",
--  handler_opts = {
--    border = "shadow"
--    }
})


-- ================
-- Telescope
-- ================


EOF
endif

augroup CSwrap
  autocmd!
  autocmd FileType cs set nowrap
augroup END


"#--------------------------------------
"# Treesitter
"#--------------------------------------
if has('nvim')
lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    },
  rainbow = {
    enable = false,
    extended_mode = true,
      colors = {
        "#a89984",
        "#fb4934",
        "#98971a",
        "#d79921",
        "#458588",
      },
    }
  }
EOF
endif


"#--------------------------------------
"# Treesitter
"#--------------------------------------
lua << EOF
require('tree-sitter-just').setup({})
EOF


"#--------------------------------------
"# Jump to definition (Ale & CoC)
"#--------------------------------------

" Custom function for jump to definition.
" Will try jump to definition in order:
" coc -> ale
function! JumpToDefinition()
  call CocActionAsync('jumpDefinition')
  sleep 200m
  let lastMsg = execute('1messages')
  if lastMsg =~? 'Definition provider not found'
    redraw
    echom ''
    execute 'ALEGoToDefinition'
  endif
endfunction

"nmap <leader>g :call JumpToDefinition()<CR>


"#--------------------------------------
"# Rainbow parentheses
"#--------------------------------------
if !has('nvim')
  augroup rainbow_parentheses
      autocmd!
      autocmd FileType javascript,typescript,latex,java,python,c RainbowParentheses
  augroup END
  let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]
endif


"#--------------------------------------
"# Airline
"#--------------------------------------
let g:airline_powerline_fonts = 1
let g:airline_theme = 'gruvbox'
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.branch = ''
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
" Visuals
let g:airline_section_z = '%3p%% %3l/%L:%3v'
let g:airline_right_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_left_alt_sep= ''
let g:airline_left_sep = ''
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

" Show buffers in top bar
let g:airline#extensions#tabline#enabled = 1

" Other airline extensions
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#coc#enabled = 1


"#--------------------------------------
"# Git gutter
"#--------------------------------------
set signcolumn=yes
let g:gitgutter_override_sign_column_highlight = 1
hi VertSplit ctermbg=235 ctermfg=235
hi SignColumn ctermbg=235 ctermfg=235
hi! link SignColumn LineNr
hi GitGutterAdd ctermbg=235 ctermfg=34 guifg=#00af00
hi GitGutterChange ctermbg=235 ctermfg=220 guifg=#ffd700
hi GitGutterDelete ctermbg=235 ctermfg=160 guifg=#d70000
hi GitGutterChangeDelete ctermbg=235 ctermfg=220 guifg=#ffd700
let g:gitgutter_sign_added = '⏽'
let g:gitgutter_sign_modified = '⏽'
let g:gitgutter_sign_removed = ''
let g:gitgutter_sign_modified_removed = ''


"#--------------------------------------
"# Delimitmate
"#--------------------------------------
let g:delimitMate_expand_space = 1
let g:delimitMate_expand_cr = 2
" Add markdown syntax to autoclosing quotes
augroup markdown_delimitmate
  autocmd!
  autocmd FileType markdown let b:delimitMate_quotes = "\" ' ` * _"
  autocmd FileType markdown let b:delimitMate_nesting_quotes = ['*', '_']
augroup END


"#--------------------------------------
"# Hexokinase
"#--------------------------------------
let g:Hexokinase_highlighters = ['backgroundfull']
if has('nvim')
  let g:Hexokinase_highlighters = ['virtual']
endif
let g:Hexokinase_optInPatterns = [
    \ 'full_hex',
    \ 'triple_hex',
    \ 'rgb',
    \ 'rgba',
    \ 'hsl',
    \ 'hsla',
    \ 'colour_names'
    \ ]
let g:Hexokinase_virtualText = '■'
let g:Hexokinase_refreshEvents = ['TextChanged', 'TextChangedI']
let g:Hexokinase_ftEnabled = ['css', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact']


"#--------------------------------------
"# Startify
"#--------------------------------------
let g:startify_session_dir = '~/.vim/session'
let g:startify_change_to_vcs_root = 1
let g:startify_bookmarks = [
      \ { 'x': $DOTFILES . '/vimrc' },
      \ { 'z': $DOTFILES . '/zshrc' },
      \ { 'L': '~/code/lego-editor/' },
      \ { 'w': '~/code/lego-webapp/' },
      \ { 'l': '~/code/lego/' }
      \ ]


"#--------------------------------------
"# Ultisnips
"#--------------------------------------
let g:UltiSnipsSnippetsDirectories = [$DOTFILES . '/UltiSnips', 'UltiSnips']
let g:UltiSnipsExpandTrigger= '<c-u>'



"#--------------------------------------
"# Yoink
"#--------------------------------------
nmap p <plug>(YoinkPaste_p)
nmap P <plug>(YoinkPaste_P)


"#--------------------------------------
"# VimTeX
"#--------------------------------------
let g:tex_flavor = 'latex'
let g:vimtex_compiler_method = 'tectonic'
"let g:vimtex_view_method = 'zathura'

nmap <leader>G :call SVED_Sync()<CR>
