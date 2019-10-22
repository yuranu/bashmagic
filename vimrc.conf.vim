set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

"Truecolor
set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" let Vundle manage Vundle, required
source <sfile>:p:h/vimrc.plugins.vim

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

set termguicolors
set term=xterm-256color


if !exists("g:ycm_server_python_interpreter")
	let g:ycm_server_python_interpreter = '/usr/bin/python3'
endif
if !exists("g:ycm_global_ycm_extra_conf")
	let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/.ycm_extra_conf.py'
endif

let g:ycm_show_diagnostics_ui = 0 " ycm diagnostics REALLY sucks - other features are OK though

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'default'

nmap <S-Insert> "+gP
imap <S-Insert> <ESC><S-Insert>a
vmap <C-Insert> "+y


set tabstop=4
set shiftwidth=4
set listchars=tab:→\ ,trail:•
set list

" CtrlP
let g:ctrlp_map = '<C-P>'
let g:ctrlp_cmd = 'CtrlP'
map <C-O> :CtrlPCmdPalette<CR>
map <S-F> :BLine<CR>

" Colorschemes
syntax on
colorscheme onedark
let g:airline_theme='badcat'

:hi CursorLine   cterm=NONE ctermbg=17 guibg=#00002f
:nnoremap <Leader>c :set cursorline!<CR>

:autocmd InsertEnter * :hi CursorLine   cterm=NONE ctermbg=darkred  guibg=#2f0000
:autocmd InsertLeave * :hi CursorLine   cterm=NONE ctermbg=darkblue guibg=#00002f

set mouse=a
set clipboard=unnamedplus
set cursorline

