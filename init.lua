-- =========================
--  Neovim Configuration
-- =========================

-- Bootstrap Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- =========================
--  Core Settings
-- =========================
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true
vim.opt.hidden = true
vim.opt.updatetime = 300
vim.opt.timeoutlen = 500
vim.opt.list = true
vim.opt.listchars = { tab = ">-", trail = "·", nbsp = "·" }

-- Leader key
vim.g.mapleader = " "

-- =========================
--  Plugins
-- =========================
require("lazy").setup({

  -- Colorscheme
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      vim.cmd("colorscheme gruvbox")
      vim.opt.background = "dark"
    end,
  },

    -- Airline (statusline)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup {
        options = {
          theme = "gruvbox",
          icons_enabled = true,
          section_separators = { left = "", right = "" },
          component_separators = "|",
        },
      }
    end,
  },
  -- Bufferline (buffers on top)
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup {
        options = {
          mode = "buffers",
          diagnostics = "coc",
          show_buffer_close_icons = true,
          show_close_icon = false,
          separator_style = "slant",
        }
      }
    end,
  },

  -- File Explorer
  { "preservim/nerdtree" },

  -- Git
  { "tpope/vim-fugitive" },
  { "airblade/vim-gitgutter" },

  -- Python & Linting
  { "dense-analysis/ale" },
  { "jmcantrell/vim-virtualenv" },

  -- Coc.nvim for LSP + completion
  { "neoclide/coc.nvim", branch = "release" },

  -- Database
  { "tpope/vim-dadbod" },
  { "kristijanhusak/vim-dadbod-ui" },
  { "lifepillar/pgsql.vim" },

  -- Web development
  { "pangloss/vim-javascript" },
  { "leafgarland/typescript-vim" },
  { "maxmellon/vim-jsx-pretty" },
  { "posva/vim-vue" },
  { "mattn/emmet-vim" },
  { "ap/vim-css-color" },

  -- LaTeX
  { "lervag/vimtex" },

  -- Markdown
  { "plasticboy/vim-markdown" },
  { "iamcco/markdown-preview.nvim", build = "cd app && yarn install" },

  -- UI Enhancements
  { "ryanoasis/vim-devicons" },
  { "Yggdroot/indentLine" },

  -- Vimwiki
  { "vimwiki/vimwiki" },

})

-- =========================
--  Key Mappings
-- =========================
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>", { silent = true })
vim.keymap.set("n", "<space>", "za", { silent = true })

-- Bufferline
vim.keymap.set("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>", { silent = true })
vim.keymap.set("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", { silent = true })

-- NERDTree
vim.keymap.set("n", "<leader>n", ":NERDTreeToggle<CR>", { silent = true })
vim.keymap.set("n", "<leader>f", ":NERDTreeFind<CR>", { silent = true })

-- Git
vim.keymap.set("n", "<leader>gs", ":Git<CR>", { silent = true })

-- Coc.nvim mappings
vim.keymap.set("n", "K", ":call CocAction('doHover')<CR>", { silent = true })
vim.keymap.set("n", "gd", ":call CocAction('jumpDefinition')<CR>", { silent = true })

-- Fix <CR> completion issue
vim.api.nvim_set_keymap("i", "<CR>", [[pumvisible() ? coc#_select_confirm() : "\<CR>"]],
  { noremap = true, silent = true, expr = true })

vim.api.nvim_set_keymap("i", "<Tab>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]],
  { noremap = true, silent = true, expr = true })

vim.api.nvim_set_keymap("i", "<S-Tab>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]],
  { noremap = true, silent = true, expr = true })

-- =========================
--  Plugin Configurations
-- =========================

-- Vimwiki
vim.g.vimwiki_list = {{
  path = "~/.vimwiki/",
  syntax = "markdown",
  ext = ".md",
}}
vim.g.vimwiki_global_ext = 0

-- Vimtex
vim.g.vimtex_view_method = "zathura"
vim.g.vimtex_compiler_method = "latexmk"
vim.g.vimtex_syntax_conceal_enabled = 0

-- ALE
vim.g.ale_fixers = { python = { "black", "isort" } }
vim.g.ale_linters = { python = { "flake8", "mypy" } }
vim.g.ale_fix_on_save = 1
