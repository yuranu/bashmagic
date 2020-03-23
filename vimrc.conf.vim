set nocompatible              " be iMproved, required
filetype off                  " required

set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" Start plugins
call plug#begin('~/.vim/plugged')

source <sfile>:p:h/vimrc.plugins.vim

" End plugins
call plug#end()

set termguicolors
set term=xterm-256color

source <sfile>:p:h/vimrc.coc.vim

"if !exists("g:ycm_server_python_interpreter")
"	let g:ycm_server_python_interpreter = '/usr/bin/python3'
"endif
"if !exists("g:ycm_global_ycm_extra_conf")
"	let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/.ycm_extra_conf.py'
"endif
"
"let g:ycm_show_diagnostics_ui = 0 " ycm diagnostics REALLY sucks - other features are OK though

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
let g:airline_theme='badwolf'

:hi CursorLine   cterm=NONE ctermbg=17 guibg=#00002f
:nnoremap <Leader>c :set cursorline!<CR>

:autocmd InsertEnter * :hi CursorLine   cterm=NONE ctermbg=darkred  guibg=#2f0000
:autocmd InsertLeave * :hi CursorLine   cterm=NONE ctermbg=darkblue guibg=#00002f

set mouse=a
set clipboard=unnamedplus
set cursorline

