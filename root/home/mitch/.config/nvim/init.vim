set nocompatible
set showmatch
set ignorecase
set hlsearch
set incsearch
set tabstop=4
set expandtab
set shiftwidth=4
set autoindent
set nu
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
function! TermToggle(dimension, vertical)
    if win_gotoid(g:term_win)
        hide
    else
        if a:vertical
            botright vnew
            exec "vertical resize " . a:dimension
        else
            botright new:
            exec "resize " . a:dimension
        endif

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

" Toggle terminal on/off (neovim, horizontal)
noremap <A-t> :call TermToggle(20, 0)<CR>
noremap <A-t> <Esc>:call TermToggle(20, 0)<CR>
noremap <A-t> <C-\><C-n>:call TermToggle(20, 0)<CR>
" Toggle terminal on/off (neovim, vertical)
noremap <A-T> :call TermToggle(80, 1)<CR>
noremap <A-T> <Esc>:call TermToggle(80, 1)<CR>
noremap <A-T> <C-\><C-n>:call TermToggle(80, 1)<CR>

" iterate all windows, if we find a terminal go to it and return true
" else, do nothing and return false
function! GoToTerminal()
    for win in getwininfo()
        if getbufvar(win.bufnr, '&buftype') ==# 'terminal'
            call win_gotoid(win.winid)
            return v:true
        endif
    endfor
    return v:false
endfunction

function! RerunLastTerminalCommand()
  let l:cur_win = win_getid()
  
  if GoToTerminal()
      " Use feedkeys with a slight defer so terminal mode activates properly
      call timer_start(10, { -> feedkeys("i\<Up>\<CR>", 't') })
      " Return to the original window (after a short delay)
      call timer_start(50, { -> win_gotoid(l:cur_win) })
  endif
endfunction
noremap <F3> :call RerunLastTerminalCommand()<CR>

let g:terminal_toggle_prev_winid = -1
function! ToggleTerminalInsert()
    " first press, record where we are and jump to the terminal
    if g:terminal_toggle_prev_winid == -1
        let g:terminal_toggle_prev_winid = win_getid()
        if !GoToTerminal()
            echo "No open terminal buffer found."
            let g:terminal_toggle_prev_winid = -1
        else
            echo "Switched to terminal."
            call feedkeys("i")
        endif
    else
        call timer_start(10, { -> feedkeys("\<Esc>\<C-\\>\<C-n>", 't')})
        call timer_start(50, { -> win_gotoid(g:terminal_toggle_prev_winid)})
        let g:terminal_toggle_prev_winid = -1
        echo "Switched back from terminal"
    endif
endfunction
noremap <F2> :call ToggleTerminalInsert()<CR>
tnoremap <F2> <C-\><C-n>:call ToggleTerminalInsert()<CR>

" unbind arrow keys
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" Terminal go back to normal mode
tnoremap <Esc> <C-\><C-n>
tnoremap :q! <C-\><C-n>:q!<CR>

" nvim-tree binds
noremap <f1> :NvimTreeToggle<return>
inoremap <f1> <Esc>:NvimTreeToggle<return>
noremap <A-f> :NvimTreeToggle<return>
inoremap <A-f> <Esc>:NvimTreeToggle<return>

" CoC binds
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nmap <silent> rn <Plug>(coc-rename)

nmap <silent> f <Plug>(coc-format)


