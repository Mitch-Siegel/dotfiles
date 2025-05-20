set nocompatible
set showmatch
set ignorecase
set hlsearch
set incsearch
set tabstop=4
set expandtab
set shiftwidth=4
set autoindent
set relativenumber " relative line numbering
set wildmode=longest,list
"set cc=80
filetype plugin indent on
syntax on
set mouse=a
set clipboard=unnamedplus
filetype plugin on
set cursorline

call plug#begin()
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'EdenEast/nightfox.nvim'
    Plug 'neovim/nvim-lspconfig'
    "Plug-jpq/coq.artifacts', {'branch': 'artifacts'}
    "Plug 'tomasiser/vim-code-dark'
    Plug 'nvim-tree/nvim-tree.lua'
    Plug 'github/copilot.vim'
call plug#end()

source ~/.config/nvim/nvim/lua/init.lua

colorscheme carbonfox

" HOW did i make that? --------> 

" Terminal Function
let g:term_buf = 0
let g:term_win = 0
function! TermToggle(height)
    if win_gotoid(g:term_win)
        hide
    else
        botright new
        exec "resize " . a:height
        try
            exec "buffer " . g:term_buf
        catch
            call termopen($SHELL, {"detach": 0})
            let g:term_buf = bufnr("")
            set nonumber
            set norelativenumber
            set signcolumn=no
        endtry
        startinsert!
        let g:term_win = win_getid()
    endif
endfunction

" Toggle terminal on/off (neovim)
nnoremap <A-t> :call TermToggle(12)<CR>
inoremap <A-t> <Esc>:call TermToggle(12)<CR>
tnoremap <A-t> <C-\><C-n>:call TermToggle(12)<CR>

noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" Terminal go back to normal mode
tnoremap <Esc> <C-\><C-n>
tnoremap :q! <C-\><C-n>:q!<CR>

noremap <f1> :NvimTreeToggle<return>
inoremap <f1> <Esc>:NvimTreeToggle<return>
noremap <A-f> :NvimTreeToggle<return>
inoremap <A-f> <Esc>:NvimTreeToggle<return>

nmap <silent> gd <Plug>(coc-definition)
