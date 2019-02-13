" General editor settings
set encoding=UTF-8
set textwidth=100               " Set line break on 100 chars
set showmatch                   " Show matching brackets
set hlsearch                    " Highlight all search results
set ignorecase                  " Ignore case on search
set autoindent                  " Autoindent on new line
set expandtab                   " Use spaces, not tabs
set shiftwidth=2                " Set tab to 4 spaces
set softtabstop=4
set backspace=indent,eol,start  " Fix backsapce issues
set ruler                       " Show char pos
set undolevels=1000             " Better undo history
set mouse=a                     " Enable mouse in all modes
syntax on                       " Enable syntax highlighting
set ttyfast                     " Fast scrolling
set autoread


" Visuals
set laststatus=2
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:.
set number                      " Show linw numbers

" Status bar if airline not enabled
let g:bufferline_echo = 0
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ [BUFFER=%n]\%{strftime('%c')}
hi statusline guibg=DarkGrey ctermfg=10 guifg=Grey ctermbg=20


" Fix text wrap when pasting
nnoremap <F2> :set invpaste paste?<CR>
imap <F2> <C-O>:set invpaste paste?<CR>
set pastetoggle=<F2>



" keymaps
let mapleader = ","
map <leader>, :NERDTreeToggle<CR>
nnoremap <leader>u :UndotreeToggle<CR>
map <Space> :noh<CR>





" Plug plugins
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
Plug 'terryma/vim-multiple-cursors'
Plug 'mattn/emmet-vim'
Plug 'w0rp/ale'                             " Linter
Plug 'airblade/vim-gitgutter'               " Git info before line numbers
Plug 'morhetz/gruvbox'                      " Standard color scheme
" Plug 'gilgigilgil/anderson.vim'           " Alternate color scheme
Plug 'valloric/youcompleteme'               " Autocompletion
Plug 'pangloss/vim-javascript'              " JS and JSX support
Plug 'mxw/vim-jsx'
Plug 'prettier/vim-prettier'                " File formatting
Plug 'ambv/black'                           " Python formatter
Plug 'tpope/vim-fugitive'                   " More git info
Plug 'mbbill/undotree'                      " Undo tree

call plug#end()


" Gruvbox color scheme settings
colorscheme gruvbox
set background=dark
let g:gruvbox_improved_warnings = '1'
let g:gruvbox_contrast_light = '1'


"Nerdtree settings
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif


" Ale settings
let g:ale_fixers = {
            \'*': ['remove_trailing_lines', 'trim_whitespace'],
            \'javascript': ['prettier', 'eslint'],
            \'python': ['black', 'isort']
\}

let g:ale_linters = {
      \'python': ['flake8']
\}

let g:ale_fix_on_save = '1'               " Enble auto fixing on save
let g:ale_lint_on_insert_leave = '1'
let g:ale_echo_msg_format = '[%linter%]: %s'
let g:ale_cursor_detail = '0'
hi ALEErrorSign ctermbg=235 ctermfg=160
hi ALEWarningSign ctermbg=235 ctermfg=214
let g:ale_sign_warning = ''
let g:ale_sign_error = ''


" Airline
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
  endif
let g:airline_symbols.branch = ''
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
let g:airline_section_z = '%3p%% %3l/%L:%3v'


" Git gutter
set updatetime=100
set signcolumn=yes
let g:gitgutter_override_sign_column_highlight = 0
hi VertSplit ctermbg=235 ctermfg=235
hi SignColumn ctermbg=235 ctermfg=235
hi GitGutterAdd ctermbg=235 ctermfg=34
hi GitGutterChange ctermbg=235 ctermfg=220
hi GitGutterDelete ctermbg=235 ctermfg=160
let g:gitgutter_sign_added = '⏽'
let g:gitgutter_sign_modified = '⏽'
let g:gitgutter_sign_removed = ''
