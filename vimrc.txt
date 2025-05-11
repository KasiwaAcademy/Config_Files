" === Core Settings ===
set nocompatible
filetype plugin indent on
syntax enable
set hidden
set shortmess+=c
set updatetime=300 " GitGutter updates based on this, 300ms is a reasonable value
set timeoutlen=500

" === UI/UX ===
set number relativenumber
set cursorline
set signcolumn=yes " Required by GitGutter
set termguicolors
" colorscheme gruvbox " Set later after plugins are loaded
set list
set listchars=tab:>-,trail:·,nbsp:· " Use >- for tab, restore trail/nbsp

" === Key Mappings ===
nnoremap <silent> <leader>h :nohlsearch<CR>
nnoremap <space> za " Toggle folds

" === Plugin Manager (vim-plug) ===
call plug#begin('~/.vim/plugged')

" Essentials
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'morhetz/gruvbox'

" === NERDTree (File Explorer) ===
Plug 'preservim/nerdtree'

" === Git Integration ===
Plug 'tpope/vim-fugitive' " Core Git commands wrapper
Plug 'airblade/vim-gitgutter' " Shows Git diff markers in the sign column

" === Python ===
Plug 'dense-analysis/ale'
Plug 'jmcantrell/vim-virtualenv'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'pappasam/coc-jedi', {'do': 'npm install -g jedi-language-server'}

" --- Data Analysis Additions Start ---
" Debugging (Requires external setup like debugpy for Python)
Plug 'puremourning/vimspector'

" Jupyter Notebook Interaction
Plug 'jupyter-vim/jupyter-vim' " Send code to Jupyter kernels

" CSV File Editing
Plug 'chrisbra/csv.vim' " Feature-rich CSV file handling

" PostgreSQL & Database Interaction
Plug 'lifepillar/pgsql.vim' " PostgreSQL specific syntax & completion
Plug 'tpope/vim-dadbod' " General database client
Plug 'kristijanhusak/vim-dadbod-ui' " UI for vim-dadbod
" --- Data Analysis Additions End ---

" === LaTeX ===
Plug 'lervag/vimtex'

" === Markdown ===
Plug 'plasticboy/vim-markdown', {'for': 'markdown'}
Plug 'iamcco/markdown-preview.nvim', {'do': 'cd app && yarn install'}

" === UI Enhancements ===
Plug 'vim-airline/vim-airline'
Plug 'ryanoasis/vim-devicons' " Provides icons for NERDTree and Airline
Plug 'Yggdroot/indentLine'   " For displaying indent lines

call plug#end()

" === indentLine Configuration ===
" Enable indentLine by default
let g:indentLine_enabled = 1
" Use a nice vertical bar character (ensure your terminal/font supports it)
let g:indentLine_char = '│'
" You can also use '¦', '┆', or '|' if '│' doesn't display well
" let g:indentLine_char = '|' " Alternative character
" *** ADD THIS LINE UNCOMMENTED ***
" Prevent indentLine from overriding conceal settings
let g:indentLine_setConceal = 0

" === Color Scheme ===
colorscheme gruvbox
set background=dark " or 'light' for light mode

" === NERDTree Configuration ===
" Toggle NERDTree window
nnoremap <leader>n :NERDTreeToggle<CR>
" Open NERDTree to find the current file
nnoremap <leader>f :NERDTreeFind<CR>
" Automatically close Vim if NERDTree is the last window
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" === Fugitive Configuration ===
" Open Git status summary window
nnoremap <leader>gs :Git<CR>

" === GitGutter Configuration ===
" Mappings to jump between hunks (blocks of changes)
nmap ]c <Plug>(GitGutterNextHunk)
nmap [c <Plug>(GitGutterPrevHunk)
" Mappings to stage/undo/preview hunks
nmap <leader>hs <Plug>(GitGutterStageHunk)
nmap <leader>hu <Plug>(GitGutterUndoHunk)
nmap <leader>hp <Plug>(GitGutterPreviewHunk)
" Enable GitGutter integration with Airline
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#hunks#enabled = 1

" === Python Configuration ===
let g:ale_fixers = {'python': ['black', 'isort']}
let g:ale_linters = {'python': ['flake8', 'mypy']}
let g:ale_fix_on_save = 1

function! DetectVirtualEnv()
    let l:venv = findfile('pyproject.toml', '.;')
    if empty(l:venv)
        let l:venv = findfile('requirements.txt', '.;')
    endif

     if !empty(l:venv)
        let l:venv_dir = fnamemodify(l:venv, ':h')
        if filereadable(l:venv_dir . '/.venv/bin/activate')
            let g:virtualenv_directory = l:venv_dir
        endif
    endif
endfunction
autocmd BufEnter *.py call DetectVirtualEnv()

" === LaTeX Configuration ===
let g:vimtex_view_method = 'zathura'
let g:vimtex_compiler_method = 'latexmk'
" Disable vimtex's own conceal feature
let g:vimtex_syntax_conceal_enabled = 0
" Key mappings for compilation and viewing
nnoremap <leader>lc :VimtexCompile<CR>
nnoremap <leader>lv :VimtexView<CR>


" === Markdown Preview ===
let g:mkdp_auto_start = 0
nnoremap <leader>mp :MarkdownPreview<CR>

" === Coc.nvim (LSP) ===
let g:coc_global_extensions = [
    \ 'coc-pyright',
    \ 'coc-texlab',
    \ 'coc-markdownlint',
    \ 'coc-json'
    \ ]
nnoremap <silent> K :call CocAction('doHover')<CR>
nnoremap <silent> gd :call CocAction('jumpDefinition')<CR>

" Completion Navigation
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

" --- Data Analysis Plugin Configuration Start ---

" === Vimspector (Debugger) ===
" NOTE: Vimspector requires setup per language.
" For Python, you'll need 'debugpy' installed (pip install debugpy)
" and a .vimspector.json config file in your project.
" See :help vimspector for full configuration details.
" Example basic key mappings:
nnoremap <leader>dd :call vimspector#Launch()<CR>
nnoremap <leader>dc :call vimspector#Continue()<CR>
nnoremap <leader>db :call vimspector#ToggleBreakpoint()<CR>
nnoremap <leader>dx :call vimspector#Reset()<CR>

" === Jupyter-Vim ===
" Connect to a running Jupyter kernel (e.g., start with 'jupyter qtconsole')
" See :help jupyter-vim for commands like :JupyterConnect, :JupyterRunFile
" Example mapping to send current line/selection:
" (Requires Jupyter kernel running and :JupyterConnect executed first)
vmap <leader>js <Plug>JupyterSendRange
nmap <leader>js <Plug>JupyterSendRange

" === CSV.vim ===
" Provides commands like :ArrangeColumn, :SearchInColumn, :Header, etc.
" See :help csv.vim for extensive features.
" Often works well out-of-the-box for .csv files.

" === vim-dadbod & vim-dadbod-ui ===
" General database interaction. Requires database URL setup.
" Example: :DB mysql://user:pass@host/db
" See :help dadbod and :help dadbod-ui
" Toggle the UI:
nnoremap <leader>dbu :DBUIToggle<CR>
" NOTE: You might need to install database drivers/clients separately
" (e.g., `psql` for PostgreSQL).

" === pgsql.vim ===
" Enhances SQL syntax highlighting specifically for PostgreSQL.
" To ensure it's used for .sql files by default (overrides Vim's default SQL):
let g:sql_type_default = 'pgsql'

" --- Data Analysis Plugin Configuration End ---


" === Auto-Install Plugins ===
" Checks if plug.vim exists and installs plugins if not found.
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif " Ensure this endif has no trailing characters

" === Final Settings ===
" Ensure filetype detection is on (mostly redundant here, but safe)
filetype plugin indent on
syntax enable

" === Force Disable Conceal for LaTeX (LAST ATTEMPT) ===
" Try setting conceallevel=0 specifically for 'tex' filetype AFTER everything else.
autocmd FileType tex setlocal conceallevel=0
