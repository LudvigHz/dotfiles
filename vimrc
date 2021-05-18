"    __              _         _
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
nmap <C-w> :bp <BAR> bd #<CR>

" Use F2 to toggle paste on/off
nnoremap <F2> :set invpaste paste?<CR>
imap <F2> <C-O>:set invpaste paste?<CR>
set pastetoggle=<F2>


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

inoremap <c-b> <c-g>u<Esc>[s1z=`]a<c-g>u


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


"#--------------------------------------
"# Create pdf from md using eisvogel template
"#--------------------------------------
function! EisvogelRun()
  let generated_file = substitute(fnameescape(expand('%:p')), '.md', '.pdf', '')
  execute system('pandoc --pdf-engine=tectonic '
        \ . fnameescape(expand('%:p'))
        \ . ' -o '
        \ . generated_file
        \ . ' --from markdown --template eisvogel -V lang=en --listings &')
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

" Command to toggle compile on save
command Eisvogel let b:eisvogel_auto = !get(b:, 'eisvogel_auto', 0)
" Command to recompile current buffer
command EisvogelCompile call EisvogelRun()



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

Plug 'junegunn/rainbow_parentheses.vim'     " Rainbow parentheses

Plug 'junegunn/vim-peekaboo'                " Show register contents

Plug 'dense-analysis/ale'                   " Linter
Plug 'airblade/vim-gitgutter'               " Git info before line numbers

" Color schemes
Plug 'gruvbox-community/gruvbox'            " Standard color scheme
Plug 'gilgigilgil/anderson.vim'             " Alternate color schemes
Plug 'srcery-colors/srcery-vim'
Plug 'sainnhe/gruvbox-material'

" Completion (nvim-lsp)
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
"Plug 'nvim-treesitter/nvim-treesitter'

Plug 'sheerun/vim-polyglot'                 " Support for most languages
Plug 'Procrat/oz.vim'
Plug 'tpope/vim-fugitive'                   " More git info
Plug 'tpope/vim-surround'                   " Tag and delimit manipulation
Plug 'tpope/vim-repeat'                     " Repeat plugin commands
Plug 'tpope/vim-vinegar'                    " netrw tweaks
Plug 'tpope/vim-sleuth'                     " Auto set tab width based on buffer

Plug 'mbbill/undotree'                      " Undo tree
Plug 'scrooloose/nerdcommenter'             " Command to comment out code
Plug 'raimondi/delimitmate'                 " Auto close tags and parentheses
"Plug 'flowtype/vim-flow'                    " Flow support
Plug 'RRethy/vim-hexokinase', {'do': 'make hexokinase'} " Color highlighting CSS
Plug 'mhinz/vim-startify'                   " Fancy start screen
Plug 'svermeulen/vim-yoink'                 " Yank utils
Plug 'tmux-plugins/vim-tmux'                " tmux.conf editing features

" LaTeX and snippets
Plug 'lervag/vimtex'
Plug 'vim-pandoc/vim-pandoc-syntax'
"Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

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
"# Goyo
"#--------------------------------------
let g:goyo_width = 110

autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!



"#--------------------------------------
"# Ale
"#--------------------------------------
let g:ale_fixers = {
            \'*': ['remove_trailing_lines', 'trim_whitespace'],
            \'javascript': ['prettier', 'eslint'],
            \'json': ['prettier'],
            \'typescript': ['prettier', 'eslint'],
            \'typescriptreact': ['prettier', 'eslint'],
            \'python': ['black', 'isort'],
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
            \'cpp': ['clang-format']
\}

let g:ale_linters = {
      \'python': ['flake8', 'isort', 'jedi'],
      \'typescript': ['tsserver', 'eslint'],
      \'typescriptreact': ['tsserver', 'eslint'],
      \'javascript': ['eslint', 'ternjs', 'flow'],
      \'jsx': ['stylelint'],
      \'sh': ['shell', 'shellcheck', 'language_server'],
      \'bash': ['shell', 'shellcheck'],
      \'zsh': ['shell'],
      \'scala': ['metals'],
\}

let g:nvim_typescript#diagnostics_enable = 0

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


"--------------------------------------
"# LSP
"#--------------------------------------

set completeopt=menuone,noselect
set shortmess+=c
" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

let g:compe = {}
let g:compe.enabled = v:true
let g:compe.autocomplete = v:true
let g:compe.debug = v:false
let g:compe.min_length = 1
let g:compe.preselect = 'enable'
let g:compe.throttle_time = 80
let g:compe.source_timeout = 200
let g:compe.incomplete_delay = 400
let g:compe.max_abbr_width = 100
let g:compe.max_kind_width = 100
let g:compe.max_menu_width = 100
let g:compe.documentation = v:true

let g:compe.source = {}
let g:compe.source.path = v:true
let g:compe.source.buffer = v:true
"let g:compe.source.calc = v:true
let g:compe.source.nvim_lsp = v:true
let g:compe.source.nvim_lua = v:true
let g:compe.source.vsnip = v:true
let g:compe.source.ultisnips = v:true

highlight link CompeDocumentation NormalFloat

lua << EOF
local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', '<leader>d', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', '<leader>g', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<leader>i', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '<leader>r', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
end

nvim_lsp.vimls.setup{on_attach=on_attach}

nvim_lsp.ccls.setup{on_attach=on_attach}

nvim_lsp.tsserver.setup{on_attach=on_attach}

nvim_lsp.jedi_language_server.setup{on_attach=on_attach}

nvim_lsp.gopls.setup{on_attach=on_attach}

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
augroup rainbow_parentheses
    autocmd!
    autocmd FileType javascript,typescript,latex,java,python RainbowParentheses
augroup END
let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]


"#--------------------------------------
"# Airline
"#--------------------------------------
let g:airline_powerline_fonts = 1
let g:airline_theme = 'gruvbox_material'
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
"if has('nvim')
  let g:Hexokinase_ftEnabled = ['css', 'xml', 'javascript.jsx']
"endif


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
