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
set hidden
set updatetime=100              " Update more often (Gitgutter and Ale)
filetype plugin on              " Enable file type specific settings
syntax on                       " Enable syntax highlighting
" Doesnt work properly with airline
"if exists('+termguicolors')
"  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
"  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
"  set termguicolors
"endif
set visualbell                  " Use visual bell instead of audio
set t_vb=                       " Set visual bell to do nothing (Disable)
set noshowmode
set ttimeoutlen=10

" Visuals
set laststatus=2
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:.
set number                      " Show line numbers
" Wildmenu
set wildcharm=<Tab>             " Use Tab for wildmenu selection
set wildmenu
set wildmode=full


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
  if exists("t:expl_buf_num")
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
      let t:expl_buf_num = bufnr("%")
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
let mapleader = ","             " Use ',' as leader
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


"#--------------------------------------
"# Spellcheck
"#--------------------------------------
augroup text_langs
  autocmd!
  autocmd Filetype tex, text, markdown setlocal spell
  autocmd Filetype tex, text, markdown setlocal spelllang=nb,en_gb
augroup end

inoremap <C-b> <c-g>u<Esc>[s1z=`]a<c-g>u


"#--------------------------------------
"# Autoclose hidden buffers if the file is defined in .gitignore
"#--------------------------------------
function! Close_gitignore()
  let git_dir = substitute(system('git rev-parse --show-toplevel'), '\n\+$', '', '')
  if filereadable(git_dir . '/.gitignore')
    for buffer in copy(getbufinfo())
      let file_ignored = 0
      for oline in readfile(git_dir . '/.gitignore')
        let line = substitute(oline, '\s|\n|\r', '', "g")
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
augroup buffer_autoclose
  autocmd!
  autocmd BufEnter * call Close_gitignore()
augroup end





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
Plug 'scrooloose/nerdtree'                  " File tree browser
Plug 'ryanoasis/vim-devicons'               " devicons for all icon support (requires nerdfont)
Plug '~/.fzf'
Plug 'junegunn/fzf.vim'                     " Fzf must have fuzzy search
Plug 'junegunn/rainbow_parentheses.vim'     " Rainbow parentheses
Plug 'mattn/emmet-vim'
Plug 'w0rp/ale'                             " Linter
Plug 'airblade/vim-gitgutter'               " Git info before line numbers
Plug 'gruvbox-community/gruvbox'            " Standard color scheme
Plug 'gilgigilgil/anderson.vim'             " Alternate color scheme
Plug 'srcery-colors/srcery-vim'
"Plug 'valloric/youcompleteme'               " Autocompletion
" deoplete
Plug 'shougo/deoplete.nvim'                 " deoplete autocompletion
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'wokalski/autocomplete-flow'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'mhartington/nvim-typescript', {'do': './install.sh'} " Ts completion
Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
Plug 'deoplete-plugins/deoplete-jedi'

Plug 'sheerun/vim-polyglot'                 " Support for most languages
Plug 'pangloss/vim-javascript'              " JS support
Plug 'prettier/vim-prettier'                " File formatting
Plug 'tpope/vim-fugitive'                   " More git info
Plug 'tpope/vim-surround'                   " Tag and delimit manipulation
Plug 'tpope/vim-vinegar'                    " netrw tweaks
Plug 'mbbill/undotree'                      " Undo tree
Plug 'scrooloose/nerdcommenter'             " Command to comment out code
Plug 'raimondi/delimitmate'                 " Auto close tags and parentheses
Plug 'flowtype/vim-flow'                    " Flow support
Plug 'RRethy/vim-hexokinase'                " Color highlighting CSS
Plug 'mhinz/vim-startify'                   " Fancy start screen

" LaTeX plugins
Plug 'lervag/vimtex'
Plug 'SirVer/ultisnips'
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


"#--------------------------------------
"# Nerdtree
"#--------------------------------------
map <leader>, :NERDTreeToggle<CR>
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
let NERDTreeMinimalUI=1


"#--------------------------------------
"# Undotree
"#--------------------------------------
nnoremap <leader>u :UndotreeToggle<CR>


"#--------------------------------------
"# Fzf
"#--------------------------------------
function! Custom_files()
  if isdirectory(".git")
    :GFiles
  else
    :Files
  endif
endfunction

nnoremap <C-p> :call Custom_files()<CR>
nnoremap <C-O> :Buffers<CR>


"#--------------------------------------
"# Ale
"#--------------------------------------
let g:ale_fixers = {
            \'*': ['remove_trailing_lines', 'trim_whitespace'],
            \'javascript': ['prettier', 'eslint'],
            \'json': ['prettier'],
            \'typescript': ['prettier', 'eslint'],
            \'python': ['black', 'isort'],
            \'java': ['google_java_format']
\}

let g:ale_linters = {
      \'python': ['flake8'],
      \'typescript': ['tsserver', 'eslint'],
      \'javascript': ['eslint', 'ternjs', 'flow']
\}

let g:nvim_typescript#diagnostics_enable = 0



let g:ale_fix_on_save = '1'               " Enble auto fixing on save
let g:ale_lint_on_insert_leave = '1'
let g:ale_echo_msg_format = '[%linter%]: %s'
let g:ale_cursor_detail = '0'
hi ALEErrorSign ctermbg=235 ctermfg=160
hi ALEWarningSign ctermbg=235 ctermfg=214
let g:ale_sign_warning = ''
let g:ale_sign_error = ''


"#--------------------------------------
"# YouCompleteMe
"#--------------------------------------

" Hacky fix to use venv while in django project dir
if filereadable("manage.py")
  let g:ycm_python_interpreter_path = 'venv/bin/python'
  let g:ycm_python_sys_path = []
  let g:ycm_extra_conf_vim_data = [
    \  'g:ycm_python_interpreter_path',
    \  'g:ycm_python_sys_path'
    \]
  let g:ycm_global_ycm_extra_conf = '~/global_extra_conf.py'
endif

let g:ycm_show_diagnostics_ui = 0
let g:ycm_autoclose_preview_window_after_completion = 1


"#--------------------------------------
"# Deoplete
"#--------------------------------------
let g:deoplete#enable_at_startup = 1

" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
set completeopt-=preview
call deoplete#custom#option('max_list', 45)         " Set max options in completion dropdown
call deoplete#custom#option('max_abbr_width', 60)   " Set max width of completion dropdown

try
  "call deoplete#custom#source('ultisnips', 'rank', 1000)
  call deoplete#custom#var('omni', 'input_patterns', {
    \ 'tex': g:vimtex#re#deoplete,
    \})
catch
endtry

" tern.js completion
let g:deoplete#sources#ternjs#filetypes = [
  \'jsx',
  \'javascript.jsx',
  \]
let g:deoplete#sources#ternjs#types = 1           " Show type in completion pane


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


"#--------------------------------------
"# Git gutter
"#--------------------------------------
set signcolumn=yes
let g:gitgutter_override_sign_column_highlight = 1
hi VertSplit ctermbg=235 ctermfg=235
hi SignColumn ctermbg=235 ctermfg=235
hi GitGutterAdd ctermbg=235 ctermfg=34
hi GitGutterChange ctermbg=235 ctermfg=220
hi GitGutterDelete ctermbg=235 ctermfg=160
hi GitGutterChangeDelete ctermbg=235 ctermfg=220
let g:gitgutter_sign_added = '⏽'
let g:gitgutter_sign_modified = '⏽'
let g:gitgutter_sign_removed = ''
let g:gitgutter_sign_modified_removed = ''


"#--------------------------------------
"$ Delimitmate
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
let g:Hexokinase_highlighters = ['virtual', 'backgroundfill']
let g:Hexokinase_virtualText = '■'
let g:Hexokinase_refreshEvents = ['TextChanged', 'TextChangedI']
let g:Hexokinase_ftAutoload = ['css', 'xml', 'jsx']


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
let g:UltiSnipsSnippetsDirectories = ["~/dotfiles/UltiSnips", "UltiSnips"]
let g:UltiSnipsExpandTrigger= "<c-u>"
