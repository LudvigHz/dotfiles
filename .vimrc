" General editor settings
set encoding=UTF-8
set textwidth=100               " Set line break on 100 chars
set showmatch                   " Show matching brackets
set hlsearch                    " Highlight all search results
set ignorecase                  " Ignore case on search
set autoindent                  " Autoindent on new line
set expandtab                   " Use spaces, not tabs
set shiftwidth=4                " Set tab to 4 spaces
set softtabstop=4
set backspace=indent,eol,start  " Fix backsapce issues
set ruler                       " Show char pos
set undolevels=1000             " Better undo history
set mouse=a                     " Enable mouse in all modes
syntax on                       " Enable syntax highlighting
set ttyfast                     " Fast scrolling


" Visuals
set laststatus=2
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:.
set number                      " Show linw numbers

" Status bar
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ [BUFFER=%n]\%{strftime('%c')}
hi statusline guibg=DarkGrey ctermfg=10 guifg=Grey ctermbg=20


" Fix text wrap when pasting
nnoremap <F2> :set invpaste paste?<CR>
imap <F2> <C-O>:set invpaste paste?<CR>
set pastetoggle=<F2>



" keymaps
let mapleader = ","
map <leader>, :NERDTreeToggle<CR>





" Plug plugins
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
        endif

call plug#begin('~/.vim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'scrooloose/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug '~/fsf'
Plug 'terryma/vim-multiple-cursors'
Plug 'mattn/emmet-vim'
Plug 'w0rp/ale'
Plug 'airblade/vim-gitgutter'
Plug 'morhetz/gruvbox'
" Plug 'gilgigilgil/anderson.vim'           " Alternate color scheme
Plug 'valloric/youcompleteme'

call plug#end()


"Nerdtree settings
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif


" Ale settings
let b:ale_fixers = ['eslint']
let b:ale_fix_on_save = '1'               " Enble auto fixing on save

" Gruvbox color scheme settings
colorscheme gruvbox
set background=dark
let g:gruvbox_improved_warnings = '1'
let g:gruvbox_contrast_light = '1'
