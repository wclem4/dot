" plugins
call plug#begin('~/.config/nvim/plugged')
Plug 'morhetz/gruvbox'
Plug 'fatih/vim-go'
Plug 'neoclide/coc.nvim', {'tag': '*', 'branch': 'release'}
Plug 'pangloss/vim-javascript'    " JavaScript support
Plug 'leafgarland/typescript-vim' " TypeScript syntax
Plug 'maxmellon/vim-jsx-pretty'   " JS and JSX syntax
Plug 'szw/vim-maximizer'
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
call plug#end()

" syntax highlighting
syntax enable

" colorscheme & set transparent bg
au vimenter * ++nested colorscheme gruvbox
au vimenter * hi Normal guibg=NONE ctermbg=NONE

" remember cursor location
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" remove white space at end of lines
au BufWritePre * :%s/\s\+$//e

" fix tabbing
set tabstop=4
set expandtab
set shiftwidth=2

set number " show numbers
set signcolumn=yes " always show the signcolumn left of numbers
set ignorecase " ignore case when searching
set scrolloff=1 " number of lines kept above/below cursor
set termguicolors

" auto fold json files
au FileType json set foldmethod=indent

" h4ckers dont need arrow keys
map <left> <nop>
map <right> <nop>
map <up> <nop>
map <down> <nop>

" copy/paste between vim windows
let mapleader=","
vmap <leader>y :w! /tmp/vitmp<CR>
nmap <leader>p :r! cat /tmp/vitmp<CR>

" maximize tmux style
nnoremap <silent><C-w>z :MaximizerToggle<CR>
vnoremap <silent><C-w>z :MaximizerToggle<CR>gv
inoremap <silent><C-w>z <C-o>:MaximizerToggle<CR>

" netrw
let g:netrw_banner=0 " remove banner
let g:netrw_altv=1 " open split to right
let g:netrw_liststyle=3 " tree view

set cmdheight=2 " give more space for displaying messages.

set updatetime=100 " update faster

""""""""""""""""""""""""""
"          CoC           "
""""""""""""""""""""""""""
set shortmess+=c " don't pass messages to |ins-completion-menu|.

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
inoremap <silent><expr> <C-x><C-z> coc#pum#visible() ? coc#pum#stop() : "\<C-x>\<C-z>"
" remap for complete to use tab and <cr>
inoremap <silent><expr> <TAB>
    \ coc#pum#visible() ? coc#pum#next(1):
    \ <SID>check_back_space() ? "\<Tab>" :
    \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <c-space> coc#refresh()

" use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" goto code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" show CoC status in statusline
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
