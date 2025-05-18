" === Core Settings ===
set nocompatible
filetype plugin indent on
syntax enable
set hidden
set shortmess+=c
set updatetime=300
set timeoutlen=500

" === UI/UX ===
set number relativenumber
set cursorline
set signcolumn=yes
set termguicolors
set list
set listchars=tab:>-,trail:·,nbsp:·

" === Disable Mouse ===
set mouse=

" === Key Mappings ===
nnoremap <silent> <leader>h :nohlsearch<CR>
nnoremap <space> za

" === Plugin Manager (vim-plug) ===
call plug#begin('~/.vim/plugged')

" Essentials
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'morhetz/gruvbox'

" File Explorer
Plug 'preservim/nerdtree'

" Git Integration
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Python
Plug 'dense-analysis/ale'
Plug 'jmcantrell/vim-virtualenv'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'pappasam/coc-jedi', {'do': 'npm install -g jedi-language-server'}

" Data Analytics
Plug 'puremourning/vimspector'
Plug 'jupyter-vim/jupyter-vim'
Plug 'chrisbra/csv.vim'
Plug 'lifepillar/pgsql.vim'
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'

" Web Development
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'posva/vim-vue'
Plug 'mattn/emmet-vim'
Plug 'ap/vim-css-color'

" LaTeX
Plug 'lervag/vimtex'

" Markdown
Plug 'plasticboy/vim-markdown', {'for': 'markdown'}
Plug 'iamcco/markdown-preview.nvim', {'do': 'cd app && yarn install'}

" UI Enhancements
Plug 'vim-airline/vim-airline'
Plug 'ryanoasis/vim-devicons'
Plug 'Yggdroot/indentLine'

call plug#end()

" === Colorscheme ===
colorscheme gruvbox
set background=dark

" === Airline Configuration ===
let g:airline_theme = 'gruvbox'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:gruvbox_italic = 1

" === NERDTree ===
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeFind<CR>
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" === Git ===
nnoremap <leader>gs :Git<CR>
nmap ]c <Plug>(GitGutterNextHunk)
nmap [c <Plug>(GitGutterPrevHunk)
nmap <leader>hs <Plug>(GitGutterStageHunk)
nmap <leader>hu <Plug>(GitGutterUndoHunk)
nmap <leader>hp <Plug>(GitGutterPreviewHunk)

" === Python ===
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

" === Web Development ===
let g:ale_fixers = {
\   'javascript': ['prettier', 'eslint'],
\   'typescript': ['prettier', 'eslint'],
\   'css': ['prettier'],
\   'html': ['prettier']
\}
let g:ale_linters = {
\   'javascript': ['eslint'],
\   'typescript': ['eslint', 'tsserver'],
\   'css': ['stylelint']
\}

let g:user_emmet_mode = 'a'
let g:user_emmet_leader_key = ','
let g:user_emmet_settings = {
\  'javascript.jsx': {'extends': 'jsx'},
\  'typescript.tsx': {'extends': 'jsx'}
\}
let g:jsx_ext_required = 0

" === LaTeX ===
let g:vimtex_view_method = 'zathura'
let g:vimtex_compiler_method = 'latexmk'
let g:vimtex_syntax_conceal_enabled = 0
nnoremap <leader>lc :VimtexCompile<CR>
nnoremap <leader>lv :VimtexView<CR>

" === Markdown ===
let g:mkdp_auto_start = 0
nnoremap <leader>mp :MarkdownPreview<CR>

" === Coc.nvim ===
let g:coc_global_extensions = [
\   'coc-pyright',
\   'coc-texlab',
\   'coc-markdownlint',
\   'coc-json',
\   'coc-html',
\   'coc-css',
\   'coc-tsserver',
\   'coc-eslint'
\]
nnoremap <silent> K :call CocAction('doHover')<CR>
nnoremap <silent> gd :call CocAction('jumpDefinition')<CR>
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

" Format on save for web files
autocmd BufWritePre *.html,*.css,*.js,*.jsx,*.ts,*.tsx :call CocAction('format')

" === Debugging ===
nnoremap <leader>dd :call vimspector#Launch()<CR>
nnoremap <leader>dc :call vimspector#Continue()<CR>
nnoremap <leader>db :call vimspector#ToggleBreakpoint()<CR>
nnoremap <leader>dx :call vimspector#Reset()<CR>

" === Jupyter ===
vmap <leader>js <Plug>JupyterSendRange
nmap <leader>js <Plug>JupyterSendRange

" === Database ===
nnoremap <leader>dbu :DBUIToggle<CR>
let g:sql_type_default = 'pgsql'

" === Auto-Install Plugins ===
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" === Final Settings ===
filetype plugin indent on
syntax enable
autocmd FileType tex setlocal conceallevel=0
