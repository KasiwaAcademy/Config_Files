-- =========================================
-- INIT.LUA for Neovim (Lazy.nvim version)
-- =========================================

-- CORE SETTINGS
vim.opt.compatible = false
vim.opt.hidden = true
vim.opt.shortmess:append("c")
vim.opt.updatetime = 300
vim.opt.timeoutlen = 500

-- UI / UX
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true
vim.opt.list = true
vim.opt.listchars = { tab = ">-", trail = "·", nbsp = "·" }

-- KEY MAPPINGS
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>", { silent = true })
vim.keymap.set("n", "<space>", "za")

-- BOOTSTRAP LAZY.NVIM (Plugin Manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- PLUGIN SETUP
require("lazy").setup({
    -- Essentials
    { "tpope/vim-sensible" },
    { "tpope/vim-commentary" },
    { "tpope/vim-surround" },
    { 
        "morhetz/gruvbox",
        config = function()
            vim.cmd("colorscheme gruvbox")
            vim.cmd("set background=dark")
            vim.g.gruvbox_italic = 1
        end
    },

    -- File Explorer
    { "preservim/nerdtree" },

    -- Git Integration
    { "tpope/vim-fugitive" },
    { "airblade/vim-gitgutter" },

    -- Python
    { "dense-analysis/ale" },
    { "jmcantrell/vim-virtualenv" },
    { "neoclide/coc.nvim", branch = "release" },
    { "pappasam/coc-jedi", run = "npm install -g jedi-language-server" },

    -- Data Analytics
    { "puremourning/vimspector" },
    { "jupyter-vim/jupyter-vim" },
    { "chrisbra/csv.vim" },
    { "lifepillar/pgsql.vim" },
    { "tpope/vim-dadbod" },
    { "kristijanhusak/vim-dadbod-ui" },

    -- Web Development
    { "pangloss/vim-javascript" },
    { "leafgarland/typescript-vim" },
    { "maxmellon/vim-jsx-pretty" },
    { "posva/vim-vue" },
    { "mattn/emmet-vim" },
    { "ap/vim-css-color" },

    -- LaTeX
    { "lervag/vimtex" },

    -- Markdown
    { "plasticboy/vim-markdown", ft = "markdown" },
    { "iamcco/markdown-preview.nvim", build = "cd app && yarn install" },

    -- UI Enhancements
    { "vim-airline/vim-airline" },
    { "ryanoasis/vim-devicons" },
    { "Yggdroot/indentLine" },

    -- Vimwiki
    { "vimwiki/vimwiki" },
})

-- =========================================
-- AIRLINE CONFIG
-- =========================================
vim.g.airline_theme = "gruvbox"
vim.g.airline_powerline_fonts = 1

-- =========================================
-- NERDTree
-- =========================================
vim.keymap.set("n", "<leader>n", ":NERDTreeToggle<CR>")
vim.keymap.set("n", "<leader>f", ":NERDTreeFind<CR>")

-- Close Vim if NERDTree is only window
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = function()
        if vim.fn.tabpagenr("$") == 1 and vim.fn.winnr("$") == 1 and vim.b.NERDTree and vim.b.NERDTree.isTabTree() then
            vim.cmd("quit")
        end
    end
})

-- =========================================
-- Python ALE CONFIG
-- =========================================
vim.g.ale_fixers = { python = { "black", "isort" } }
vim.g.ale_linters = { python = { "flake8", "mypy" } }
vim.g.ale_fix_on_save = 1
vim.g.ale_hover_to_preview = 1
vim.g.ale_floating_preview = 0

-- Virtualenv detection
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.py",
    callback = function()
        local venv = vim.fn.findfile("pyproject.toml", ".;")
        if venv == "" then
            venv = vim.fn.findfile("requirements.txt", ".;")
        end
        if venv ~= "" then
            local venv_dir = vim.fn.fnamemodify(venv, ":h")
            if vim.fn.filereadable(venv_dir .. "/.venv/bin/activate") == 1 then
                vim.g.virtualenv_directory = venv_dir
            end
        end
    end
})

-- =========================================
-- Coc.nvim Keybindings
-- =========================================
vim.keymap.set("n", "K", "<cmd>call CocAction('doHover')<CR>", { silent = true })
vim.keymap.set("n", "gd", "<cmd>call CocAction('jumpDefinition')<CR>", { silent = true })
vim.keymap.set("i", "<Tab>", "pumvisible() ? '<C-n>' : '<Tab>'", { expr = true })
vim.keymap.set("i", "<S-Tab>", "pumvisible() ? '<C-p>' : '<S-Tab>'", { expr = true })
vim.keymap.set("i", "<CR>", "pumvisible() ? '<C-y>' : '<CR>'", { expr = true })

-- =========================================
-- Vimwiki
-- =========================================
vim.g.vimwiki_list = { { path = "~/.vimwiki/", syntax = "markdown", ext = ".md" } }
vim.g.vimwiki_global_ext = 0

-- =========================================
-- LaTeX
-- =========================================
vim.g.vimtex_view_method = "zathura"
vim.g.vimtex_compiler_method = "latexmk"
vim.g.vimtex_syntax_conceal_enabled = 0
vim.keymap.set("n", "<leader>lc", ":VimtexCompile<CR>")
vim.keymap.set("n", "<leader>lv", ":VimtexView<CR>")

-- =========================================
-- Markdown Preview
-- =========================================
vim.g.mkdp_auto_start = 0
vim.keymap.set("n", "<leader>mp", ":MarkdownPreview<CR>")

-- =========================================
-- Database (Dadbod)
-- =========================================
vim.keymap.set("n", "<leader>dbu", ":DBUIToggle<CR>")
vim.g.sql_type_default = "pgsql"

-- =========================================
-- Debugging (Vimspector)
-- =========================================
vim.keymap.set("n", "<leader>dd", ":call vimspector#Launch()<CR>")
vim.keymap.set("n", "<leader>dc", ":call vimspector#Continue()<CR>")
vim.keymap.set("n", "<leader>db", ":call vimspector#ToggleBreakpoint()<CR>")
vim.keymap.set("n", "<leader>dx", ":call vimspector#Reset()<CR>")

-- =========================================
-- Jupyter
-- =========================================
vim.keymap.set("v", "<leader>js", "<Plug>JupyterSendRange")
vim.keymap.set("n", "<leader>js", "<Plug>JupyterSendRange")

-- =========================================
-- Autoformat on save for web files
-- =========================================
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.html", "*.css", "*.js", "*.jsx", "*.ts", "*.tsx" },
    command = "call CocAction('format')",
})

-- =========================================
-- Final settings
-- =========================================
vim.api.nvim_create_autocmd("FileType", {
    pattern = "tex",
    command = "setlocal conceallevel=0",
})
