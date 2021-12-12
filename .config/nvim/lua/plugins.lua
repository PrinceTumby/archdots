vim.cmd "packadd packer.nvim"

return require("packer").startup(function()
  use "wbthomason/packer.nvim"
  use "kyazdani42/nvim-web-devicons"
  -- use "akinsho/nvim-bufferline.lua"
  use "famiu/bufdelete.nvim"
  use "sheerun/vim-polyglot"
  use "rakr/vim-one"
  use "agreco/vim-citylights"
  use "tpope/vim-commentary"
  use "tpope/vim-surround"
  use "tpope/vim-unimpaired"
  use "tpope/vim-abolish"
  use "tpope/vim-repeat"
  use "guns/vim-sexp"
  use "godlygeek/tabular"
  use {
    "junegunn/goyo.vim",
    cmd = "Goyo",
  }
  use "mhinz/vim-startify"
  use {
    "Shougo/deoplete.nvim",
    run = ":UpdateRemotePlugins",
  }
  use "Shougo/deoplete-lsp"
  use "neovim/nvim-lspconfig"
  use "nvim-lua/popup.nvim"
  use "nvim-lua/plenary.nvim"
  use "nvim-lua/telescope.nvim"
  use "vim-syntastic/syntastic"
  use "liuchengxu/vista.vim"
  use "cohama/lexima.vim"
  use "wellle/visual-split.vim"
  use "luochen1990/rainbow"
  use "vim-scripts/utl.vim"
  use "vim-scripts/SyntaxRange"
  use "wellle/targets.vim"
  use "jpalardy/vim-slime"
  use "vimwiki/vimwiki"
  use "liuchengxu/vim-which-key"
  use "pechorin/any-jump.vim"
  use "AndrewRadev/sideways.vim"
  use "AndrewRadev/splitjoin.vim"
  -- Individual language support
  use "bakpakin/fennel.vim"
  use "jceb/vim-orgmode"
  use "rhysd/vim-wasm"
end)
