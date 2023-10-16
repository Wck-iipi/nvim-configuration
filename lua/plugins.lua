vim.g.mapleader = " "
vim.g.maplocalleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup(
{
  'nvim-treesitter/nvim-treesitter',
  'rmagatti/auto-session',
  'nvim-tree/nvim-web-devicons',
  'nvim-lualine/lualine.nvim',
  'kyazdani42/nvim-tree.lua',
  {
    'stevearc/oil.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {'akinsho/bufferline.nvim', dependencies = 'nvim-tree/nvim-web-devicons'},
  'glepnir/dashboard-nvim',
  'nvim-lua/plenary.nvim',
  { 'nvim-telescope/telescope.nvim', tag = '0.1.0', },
  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',
  'lukas-reineke/indent-blankline.nvim',
  'jose-elias-alvarez/null-ls.nvim',
  'neovim/nvim-lspconfig',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  'hrsh7th/nvim-cmp',
  'windwp/nvim-autopairs',
  'numToStr/Comment.nvim',
  "L3MON4D3/LuaSnip",
  'saadparwaiz1/cmp_luasnip',
  'lewis6991/impatient.nvim',
  "EdenEast/nightfox.nvim",
  {'akinsho/flutter-tools.nvim', dependencies = 'nvim-lua/plenary.nvim'},
  --debugging,
  'mfussenegger/nvim-dap',
  {
    'jay-babu/mason-nvim-dap.nvim',
    event = 'VeryLazy',
    dependencies = {
      'williamboman/mason.nvim',
      'mfussenegger/nvim-dap',
    },
    opts = {
        handlers = {},
      }
  },
  {
    'rcarriga/nvim-dap-ui',
    event = 'VeryLazy',
    dependencies = {
      'mfussenegger/nvim-dap',
    },
    config = function()
      local dap = require('dap')
      local dapui = require('dapui')
      dapui.setup()
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
      end
    end
  },
  'theHamsta/nvim-dap-virtual-text',
  'nvim-telescope/telescope-dap.nvim',
  { 'TimUntersberger/neogit', dependencies = 'nvim-lua/plenary.nvim' },
  { 'sindrets/diffview.nvim', dependencies = 'nvim-lua/plenary.nvim' },
  { 'ibhagwan/fzf-lua', dependencies ='nvim-tree/nvim-web-devicons' },
  { 'junegunn/fzf', build = './install --bin', },
  {'scalameta/nvim-metals', dependencies = { "nvim-lua/plenary.nvim" }},
  'windwp/nvim-ts-autotag',
  'github/copilot.vim',
  'MunifTanjim/prettier.nvim',
  { "someone-stole-my-name/yaml-companion.nvim", dependencies = { { "neovim/nvim-lspconfig" }, { "nvim-lua/plenary.nvim" }, { "nvim-telescope/telescope.nvim" }, }, config = function() require("telescope").load_extension("yaml_schema") end, },
  { "folke/trouble.nvim", dependencies = { "nvim-tree/nvim-web-devicons" }, opts = { -- your configuration comes here or leave it empty to use the default settings refer to the configuration section below 
  }},
  { 'xeluxee/competitest.nvim', dependencies = 'MunifTanjim/nui.nvim', config = function() require('competitest').setup() end, },
  { 'christoomey/vim-tmux-navigator', lazy = false,}
})
