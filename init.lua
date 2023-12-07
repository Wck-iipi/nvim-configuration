-- If you want to disable it for certain files
-- vim.g.copilot_filetypes = {
--     ["*"] = false,
--     ["javascript"] = true,
--     ["typescript"] = true,
--     ["lua"] = false,
--     ["rust"] = true,
--     ["c"] = true,
--     ["c#"] = true,
--     ["c++"] = true,
--     ["go"] = true,
--     ["python"] = true,
--   }

vim.wo.number = true
--:set number
--:filetype on
vim.opt.shell = "bash"
--:set shell=powershell
vim.wo.relativenumber = true
--:set relativenumber
vim.bo.autoindent = false
--:set autoindent
vim.opt.tabstop = 2
--:set tabstop=4
vim.opt.shiftwidth = 2
--:set shiftwidth=4
vim.opt.expandtab = true
vim.opt.virtualedit = "all"
--:set virtualedit=all
vim.o.termguicolors = true
--:set termguicolors
vim.opt.completeopt = {'menuone', 'noselect', 'noinsert', 'menu'}
--:set completeopt=menu,menuone,noselect,noinsert
vim.opt.smartindent = true
require('plugins')
local ls = require "luasnip"
-----------------------------------------------------------KEYMAP SECTION------------------------------------------------------
---------VARUN IN HOSTEL, THE PROBLEM IS THAT WE HAVEN'T LOADED VIM AND YET THIS IS RUNNING, SEE THAT IT RUNS ON KEYMAP ONCE--
local opts = { noremap = true, silent = true}
local keymap = vim.api.nvim_set_keymap
local locationWithDirectory = vim.fn.expand('%')
-- local finalCommandRequired = ":sp <cr><C-w>j:terminal <cr><C-w>10-iThis should be inputted" .. locationWithDirectory 
-- print("This should be the final command :" .. locationWithDirectory  .. " this ain't bluff")
-- Leader key is spacebar

vim.keymap.set('n', '<Tab>', ':bn<cr>');
vim.keymap.set('n', '<S-Tab>', ':bp<cr>');
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "
keymap("n", "<leader>t",":NvimTreeToggle <cr>" , opts)
keymap("n", "<leader>o","o<Esc>k" , opts)
keymap("n", "<leader>O","O<Esc>j" , opts)
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)
keymap("i",";,", "<Esc>$a,<Esc>o", opts)
keymap("i", ";.", "<Esc>o", opts)
keymap("i", ";;", "<Esc>$a;<Esc>o", opts)
keymap('n', '<leader>ff', ":lua require('fzf-lua').files()<CR>", { noremap = true, silent = true })
keymap('n', '<leader>fg', ":lua require('fzf-lua').grep()<CR>", { noremap = true, silent = true })
keymap('n', '<leader>p', ':lua vim.lsp.buf.format()<CR>', { noremap = true, silent = true })
local locationOfLuaSnipConfiguration =  vim.fn.stdpath('config') .. '/after/plugin/luasnip.lua'
local directoryLuaSnip = vim.fn.stdpath('config') .. '/after/plugin/'
local locationOfSnippet = vim.fn.stdpath('config') .. '/snippets/luasnippets.lua'
local directoryOfSnippet = vim.fn.stdpath('config') .. '/snippets/'
local sourceLuaSnipCommand = "<cmd>source " .. locationOfSnippet .. '<cr>'
keymap("n", "<leader><leader>s", sourceLuaSnipCommand , opts)
keymap("n", "<C-h>", "<cmd> TmuxNavigateLeft <cr>", opts)
keymap("n", "<C-j>", "<cmd> TmuxNavigateDown <cr>", opts)
keymap("n", "<C-k>", "<cmd> TmuxNavigateUp <cr>", opts)
keymap("n", "<C-l>", "<cmd> TmuxNavigateRight <cr>", opts)

local cmp = require "cmp"
cmp.setup({
snippet = {
	-- REQUIRED - you must specify a snippet engine
	expand = function(args)
	-- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
	ls.lsp_expand(args.body) -- For `luasnip` users.
	-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
	-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
	end,
	},
	window = {
		-- completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
		},
	mapping = cmp.mapping.preset.insert({
	['<C-b>'] = cmp.mapping.scroll_docs(-4),
	['<C-f>'] = cmp.mapping.scroll_docs(4),
	['<C-Space>'] = cmp.mapping.complete(),
	['<C-e>'] = cmp.mapping.abort(),
	['<C-j>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
	{ name = 'nvim_lsp' },
	--{ name = 'vsnip' }, -- For vsnip users.
	{ name = 'luasnip' }, -- For luasnip users.
	-- { name = 'ultisnips' }, -- For ultisnips users.
	-- { name = 'snippy' }, -- For snippy users.
	}, {
		{ name = 'buffer' },
	})
	})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
	sources = cmp.config.sources({
	{ name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
	}, {
		{ name = 'buffer' },
	})
	})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' }
	}
	})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
	{ name = 'path' }
	}, {
		{ name = 'cmdline' }
	})
	})
-----------------------------------------------------------KEYMAP SECTION------------------------------------------------------
require("mason").setup()
require("mason-nvim-dap").setup()
require("mason-lspconfig").setup()
-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<space>k', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = bufnr,
      callback = function()
          -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
          -- on later neovim version, you should use vim.lsp.buf.format({ async = false }) instead
          vim.lsp.buf.format({ bufnr = bufnr })
      end,
    })
  end
end

require('lspconfig')['yamlls'].setup{
    settings = {
        yaml = {
           -- schemas = { kubernetes = "globPattern" },
          schemas = {
    kubernetes = "*.yaml",
    ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
    ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
    ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
    ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
    ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
    ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
    ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
    ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
    ["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
    ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
    ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
    ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
  },
        }
	}
}

-- In mac, don't download this in mason as clang is installed by default
require('lspconfig')['clangd'].setup {
	on_attach = on_attach,
	capabilities = capabilities,
}
-- Varun in future, this LSP only runs if you have .git in root folder or package.json
-- Long story short git init your folder
require('lspconfig')['tsserver'].setup {
	on_attach = on_attach,
	capabilities = capabilities,
}
require('lspconfig')['jsonls'].setup {
	on_attach = on_attach,
	capabilities = capabilities,
}
require('lspconfig')['rust_analyzer'].setup {
  on_attach = on_attach,
  capabilities = capabilities,
}
require('lspconfig')['tailwindcss'].setup {
  on_attach = on_attach,
  capabilities = capabilities,
}
require('lspconfig')['emmet_ls'].setup{
	on_attach = on_attach,
	capabilities = capabilities,
}

require('lspconfig')['pyright'].setup {
	on_attach = on_attach,
	capabilities = capabilities,
}
-- require('lspconfig')['pylsp'].setup {
-- 	on_attach = on_attach,
-- 	capabilities = capabilities,
-- }


-- require'lspconfig'.vuels.setup{}
    require('lspconfig')['vuels'].setup {
        on_attach = on_attach,
        capabilities = capabilities,
        init_options = {
      config = {
        css = {},
        emmet = {},
        html = {
          suggest = {}
        },
        javascript = {
          format = {}
        },
        stylusSupremacy = {},
        typescript = {
          format = {}
        },
        vetur = {
          completion = {
            autoImport = false,
            tagCasing = "pascal",
            useScaffoldSnippets = false
          },
          format = {
            defaultFormatter = {
              js = "none",
              ts = "none"
            },
            defaultFormatterOptions = {},
            scriptInitialIndent = false,
            styleInitialIndent = false
          },
          useWorkspaceDependencies = false,
          validation = {
            script = true,
            style = true,
            template = true
          }
        }
      }
    }
}

require('lspconfig')['html'].setup {
	on_attach = on_attach,
	capabilities = capabilities,
}
require('lspconfig')['cssls'].setup {
	on_attach = on_attach,
	capabilities = capabilities,
}
-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1
-- empty setup using defaults
require('lualine').setup()
local opts = {
	log_level = 'info',
	auto_session_enable_last_session = false,
	auto_session_root_dir = vim.fn.stdpath('data').."/sessions/",
	auto_session_enabled = true,
	auto_save_enabled = nil,
	auto_restore_enabled = false,
	auto_session_suppress_dirs = nil,
	auto_session_use_git_branch = nil,
	-- the configs below are lua only
	bypass_session_save_file_types = nil
}
require('auto-session').setup(opts)

require("ibl").setup {
	-- for example, context is off by default, use this to turn it on
  exclude = { filetypes = {"dashboard"} }
}
require("nvim-autopairs").setup {
    map_c_w = true,
    map_cr = true,
}
require('Comment').setup()
-- CHANGE TREE HERE
require("nvim-tree").setup({ })
require("oil").setup()
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

require('nvim-ts-autotag').setup()


require('dashboard').setup({
  theme = 'hyper',
  config = {
    week_header = {
     enable = true,
    },
    shortcut = {
      { desc = '󰚰 Update', group = '@property', action = 'PackerUpdate', key = 'u' },
      {
        icon = ' ',
        icon_hl = '@variable',
        desc = 'Files',
        group = 'Label',
        action = 'Telescope find_files',
        key = 'f',
      },
      {
        desc = ' Init',
        group = 'DiagnosticHint',
        action = 'edit ~/.config/nvim/init.lua',
        key = 'i',
      },
      {
        desc = ' dotfiles',
        group = 'Number',
        action = 'Telescope dotfiles',
        key = 'd',
      },
    },
  },
})
-- dashboard setup
-- local home = os.getenv('UserProfile')
-- local db = require('dashboard') 
--
-- db.header = {
--    [[]],
--    [[   ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣭⣿⣶⣿⣦⣼⣆         ]],
--    [[    ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠄⡠⢾⣿⣿⡿⠋⠉⠉⠻⣿⣿⡛⣦       ]],
--    [[          ⠈⢿⣿⣟⠦ ⣾⣿⣿⣷⠄⠄⠄⠄⠻⠿⢿⣿⣧⣄     ]],
--    [[           ⣸⣿⣿⢧ ⢻⠻⣿⣿⣷⣄⣀⠄⠢⣀⡀⠈⠙⠿⠄    ]],
--    [[          ⢠⣿⣿⣿⠈  ⠡⠌⣻⣿⣿⣿⣿⣿⣿⣿⣛⣳⣤⣀⣀   ]],
--    [[   ⢠⣧⣶⣥⡤⢄ ⣸⣿⣿⠘⠄ ⢀⣴⣿⣿⡿⠛⣿⣿⣧⠈⢿⠿⠟⠛⠻⠿⠄  ]],
--    [[  ⣰⣿⣿⠛⠻⣿⣿⡦⢹⣿⣷   ⢊⣿⣿⡏  ⢸⣿⣿⡇ ⢀⣠⣄⣾⠄   ]],
--    [[ ⣠⣿⠿⠛⠄⢀⣿⣿⣷⠘⢿⣿⣦⡀ ⢸⢿⣿⣿⣄ ⣸⣿⣿⡇⣪⣿⡿⠿⣿⣷⡄  ]],
--    [[ ⠙⠃   ⣼⣿⡟  ⠈⠻⣿⣿⣦⣌⡇⠻⣿⣿⣷⣿⣿⣿ ⣿⣿⡇⠄⠛⠻⢷⣄ ]],
--    [[      ⢻⣿⣿⣄   ⠈⠻⣿⣿⣿⣷⣿⣿⣿⣿⣿⡟ ⠫⢿⣿⡆     ]],
--    [[       ⠻⣿⣿⣿⣿⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⢀⣀⣤⣾⡿⠃     ]],
--    [[     ⢰⣶  ⣶ ⢶⣆⢀⣶⠂⣶⡶⠶⣦⡄⢰⣶⠶⢶⣦  ⣴⣶     ]],
--    [[     ⢸⣿⠶⠶⣿ ⠈⢻⣿⠁ ⣿⡇ ⢸⣿⢸⣿⢶⣾⠏ ⣸⣟⣹⣧    ]],
--    [[     ⠸⠿  ⠿  ⠸⠿  ⠿⠷⠶⠿⠃⠸⠿⠄⠙⠷⠤⠿⠉⠉⠿⠆   ]],
--    [[]],
-- }
-- -- db.custom_header = {
-- -- 	[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣤⣤⣤⣤⡼⠀⢀⡀⣀⢱⡄⡀⠀⠀⠀⢲⣤⣤⣤⣤⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
-- -- 	[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣴⣾⣿⣿⣿⣿⣿⡿⠛⠋⠁⣤⣿⣿⣿⣧⣷⠀⠀⠘⠉⠛⢻⣷⣿⣽⣿⣿⣷⣦⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀]],
-- -- 	[[⠀⠀⠀⠀⠀⠀⢀⣴⣞⣽⣿⣿⣿⣿⣿⣿⣿⠁⠀⠀⠠⣿⣿⡟⢻⣿⣿⣇⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣟⢦⡀⠀⠀⠀⠀⠀⠀]],
-- -- 	[[⠀⠀⠀⠀⠀⣠⣿⡾⣿⣿⣿⣿⣿⠿⣻⣿⣿⡀⠀⠀⠀⢻⣿⣷⡀⠻⣧⣿⠆⠀⠀⠀⠀⣿⣿⣿⡻⣿⣿⣿⣿⣿⠿⣽⣦⡀⠀⠀⠀⠀]],
-- -- 	[[⠀⠀⠀⠀⣼⠟⣩⣾⣿⣿⣿⢟⣵⣾⣿⣿⣿⣧⠀⠀⠀⠈⠿⣿⣿⣷⣈⠁⠀⠀⠀⠀⣰⣿⣿⣿⣿⣮⣟⢯⣿⣿⣷⣬⡻⣷⡄⠀⠀⠀]],
-- -- 	[[⠀⠀⢀⡜⣡⣾⣿⢿⣿⣿⣿⣿⣿⢟⣵⣿⣿⣿⣷⣄⠀⣰⣿⣿⣿⣿⣿⣷⣄⠀⢀⣼⣿⣿⣿⣷⡹⣿⣿⣿⣿⣿⣿⢿⣿⣮⡳⡄⠀⠀]],
-- -- 	[[⠀⢠⢟⣿⡿⠋⣠⣾⢿⣿⣿⠟⢃⣾⢟⣿⢿⣿⣿⣿⣾⡿⠟⠻⣿⣻⣿⣏⠻⣿⣾⣿⣿⣿⣿⡛⣿⡌⠻⣿⣿⡿⣿⣦⡙⢿⣿⡝⣆⠀]],
-- -- 	[[⠀⢯⣿⠏⣠⠞⠋⠀⣠⡿⠋⢀⣿⠁⢸⡏⣿⠿⣿⣿⠃⢠⣴⣾⣿⣿⣿⡟⠀⠘⢹⣿⠟⣿⣾⣷⠈⣿⡄⠘⢿⣦⠀⠈⠻⣆⠙⣿⣜⠆]],
-- -- 	[[⢀⣿⠃⡴⠃⢀⡠⠞⠋⠀⠀⠼⠋⠀⠸⡇⠻⠀⠈⠃⠀⣧⢋⣼⣿⣿⣿⣷⣆⠀⠈⠁⠀⠟⠁⡟⠀⠈⠻⠀⠀⠉⠳⢦⡀⠈⢣⠈⢿⡄]],
-- -- 	[[⣸⠇⢠⣷⠞⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠻⠿⠿⠋⠀⢻⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⢾⣆⠈⣷]],
-- -- 	[[⡟⠀⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣶⣤⡀⢸⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⡄⢹]],
-- -- 	[[⡇⠀⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⠈⣿⣼⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠃⢸]],
-- -- 	[[⢡⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⠶⣶⡟⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡼]],
-- -- 	[[⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡾⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁]],
-- -- 	[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡁⢠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
-- -- 	[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣿⣼⣀⣠⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
-- -- }
-- --db.custom_header = {
-- --    [[⠀⠀⠀⠀⠀⠀⣰⠂⠀⣼⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣀⠀⠀⠀⠀⠀⠀⠀]],
-- --    [[⠀⠀⠀⠀⠀⠀⡟⢆⢠⢣⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡘⡇⠹⢦⠀⠀⠀⠀⠀⠀]],
-- --    [[⠀⠀⠀⠀⠀⠀⠹⣦⣹⢸⡖⠤⢀⠀⠘⢿⠛⢔⠢⡀⠃⠣⠀⠇⢡⠀⠀⠀⠀⠀]],
-- --    [[⠀⠀⠀⠀⠀⠀⠀⠀⠹⠀⡷⣄⠠⡈⠑⠢⢧⠀⢢⠰⣼⢶⣷⣾⠀⠃⠀⠀⠀⠀]],
-- --    [[⠀⠀⠀⠀⠀⠀⠀⠤⢖⡆⠰⡙⢕⢬⡢⣄⠀⠑⢼⠀⠚⣿⢆⠀⠱⣸⠀⠀⠀⠀]],
-- --    [[⠀⠀⠀⠀⠀⢀⣤⡶⠮⢧⡀⠑⡈⢢⣕⡌⢶⠀⠀⣱⣠⠉⢺⡄⠀⢹⠀⠀⠀⠀]],
-- --    [[⠀⠀⠀⠀⠀⠀⢀⡸⠀⠈⡗⢄⡈⢆⠙⠿⣶⣿⠿⢿⣷⣴⠉⠹⢶⢾⡆⠀⠀⠀]],
-- --    [[⠀⠀⠀⢠⠶⠿⡉⠉⠉⠙⢻⣮⡙⢦⣱⡐⣌⠿⡄⢁⠄⠑⢤⣀⠐⢻⡇⠀⠀⠀]],
-- --    [[⠀⠀⠀⢀⣠⠾⠖⠛⢻⠟⠁⢘⣿⣆⠹⢷⡏⠀⠈⢻⣤⡆⠀⠑⢴⠉⢿⣄⠀⠀]],
-- --    [[⠀⠀⢠⠞⢃⢀⣠⡴⠋⠀⠈⠁⠉⢻⣷⣤⠧⡀⠀⠈⢻⠿⣿⡀⠀⢀⡀⣸⠀⠀]],
-- --    [[⠀⠀⢀⠔⠋⠁⡰⠁⠀⢀⠠⣤⣶⠞⢻⡙⠀⠙⢦⠀⠈⠓⢾⡟⡖⠊⡏⡟⠀⠀]],
-- --    [[⠀⢠⣋⢀⣠⡞⠁⠀⠔⣡⣾⠋⠉⢆⡀⢱⡀⠀⠀⠀⠀⠀⠀⢿⡄⠀⢇⠇⠀⠀]],
-- --    [[⠀⠎⣴⠛⢡⠃⠀⠀⣴⡏⠈⠢⣀⣸⣉⠦⣬⠦⣀⠀⣄⠀⠀⠈⠃⠀⠀⠙⡀⠀]],
-- --    [[⠀⡸⡁⣠⡆⠀⠀⣾⠋⠑⢄⣀⣠⡤⢕⡶⠁⠀⠀⠁⢪⠑⠤⡀⠀⢰⡐⠂⠑⢀]],
-- --    [[⠀⠏⡼⢋⠇⠀⣸⣟⣄⠀⠀⢠⡠⠓⣿⠇⠀⠀⠀⠀⠀⠑⢄⡌⠆⢰⣷⣀⡀⢸]],
-- --    [[⠀⣸⠁⢸⠀⢀⡿⡀⠀⠈⢇⡀⠗⢲⡟⠀⠀⠀⠀⠀⠀⠀⠀⠹⡜⠦⣈⠀⣸⡄]],
-- --    [[⠀⣧⠤⣼⠀⢸⠇⠉⠂⠔⠘⢄⣀⢼⠃⡇⠀⠀⠀⠀⠀⠀⠀⠀⠈⠑⠚⠳⠋⠀]],
-- --    [[⠐⠇⣰⢿⠀⣾⢂⣀⣀⡸⠆⠁⠀⣹⠀⢡⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
-- --    [[⠀⢀⡏⣸⠀⣟⠁⠀⠙⢄⠼⠁⠈⢺⠀⠘⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
-- --    [[⠀⠈⡏⣸⢰⡯⠆⢤⠔⠊⢢⣀⣀⡼⡇⠀⠹⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
-- --    [[⠀⠀⢠⢻⢸⡇⠀⠀⠑⣤⠊⠀⠀⠈⣧⠀⠀⠙⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
-- --    [[⠀⠀⠸⣼⢸⠟⠑⠺⡉⠈⢑⠆⠠⠐⢻⡄⠀⠀⠈⢆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
-- --    [[⠀⠀⠀⡟⣸⡀⠀⠀⣈⣶⡁⠀⠀⠀⢠⢻⡄⠀⠀⠀⠑⠤⣄⡀⠀⠀⠀⠀⠀⠀]],
-- --    [[⠀⠀⢰⠁⣿⡿⠟⢏⠁⠀⢈⠖⠒⠊⠉⠉⠹⣄⠀⠀⠀⠀⠀⠈⠑⠢⡀⠀⠀⠀]],
-- --    [[⠀⣀⠟⢰⡇⠀⠀⠈⢢⡴⠊⠀⠀⠀⠀⠀⣸⢙⣷⠄⢀⠀⠠⠄⠐⠒⠚⠀⠀⠀]],
-- --    [[⠘⠹⠤⠛⠛⠲⢤⠐⠊⠈⠂⢤⢀⠠⠔⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
-- --    [[⠀⠀⠀⠀⠀⠀⠀⠣⢀⡀⠔⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
-- --}
-- db.preview_file_width = 70
-- db.center = {
-- 	{icon = '  ',
-- 		desc = 'Recently latest session                  ',
-- 		shortcut = 'SPC s l',
-- 		action =':RestoreSession'},
--     {icon = '  ',
--         desc = 'Recently opened files                   ',
--         action =  'Telescope oldfiles',
--         shortcut = 'SPC f h'},
--     {icon = '  ',
--         desc = 'Find  File                              ',
--         action = 'Telescope find_files find_command=rg,--hidden,--files',
--         shortcut = 'SPC f f'},
--     {icon = '  ',
--         desc = 'Find  word                              ',
--         action = 'Telescope live_grep',
--         shortcut = 'SPC f w'},
--     {icon = '  ',
--         desc = 'Configure NeoVim                        ',
--         action = 'edit ~/.config/nvim/init.lua',
--         shortcut = 'SPC f d'},
--     {icon = '  ',
--         desc = 'Configure NeoVim Packer                 ',
--         action = 'edit ~/.config/nvim/lua/plugins.lua',
--         shortcut = 'SPC f d'},
-- }
-- local quotes = {"Tonight, Gehrman joins the hunt", "Tonight, Gehrman joins the hunt", "When the frail of heart join the fray, the hunter becomes the hunted!", "We are born of the blood, made men by the blood, undone by the blood. Our eyes have yet to open... Fear the Old Blood", "Roberrrrrrtooooooooooooooooooo!!", "Hesitation Is Defeat.", "Can be thrown at foes. Quite thrilling.", "Dear oh dear, what was it? The Hunt? The Blood? Or the Horrible Dream?", "A Code Must Be Determined By The Individual... This Is What I've Decided", "HITOOOOOOTSU (ONE!) The parent is absolute. Their Will must be obeyed. ...Yet I'm sensing some insubordination.", "FUTAAAAAATSU (TWO!) The master is absolute. You give your life to keep him safe. You bring him back at any cost. ...At this rate, you'll lose him again.", "MIIIIITSU (THREE!) Fear is absolute. There is no shame in losing one battle. But you must take revenge by any means necessary!...I wonder if you've got it in you - to bring me down.", "Listen...I want to become a carp.", "死", "Good hunter, have you seen the thread of light? Just a hair, a fleeting thing, yet I clung to it, steeped as I was in the stench of blood and beasts. I never wanted to know, what it really was.", "Aah, you were at my side all along. My true mentor... My guiding moonlight...", "Ah, good...that is a relief. To know I did not suffer such denigration for nothing. Thank you kindly. Now I may sleep in peace. Even in this darkest of nights, I see... the moonlight...", "Oh, my. Just as I feared. Then a beast-possessed degenerate was I, as my detractors made eminently clear. Does the nightmare never end?!"}
-- math.randomseed(os.time()*10000000)
-- db.footer = {
-- 	desc = quotes[math.random(1,#quotes)]
-- }
require("bufferline").setup()
-- lsp server configurations
--require("lspconfig").setup{}
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
require("null-ls").setup({
	sources = {
		require("null-ls").builtins.diagnostics.cpplint,
		require("null-ls").builtins.diagnostics.eslint_d,
    require("null-ls").builtins.formatting.prettier,
		-- require("null-ls").builtins.formatting.pylint,
		require("null-ls").builtins.formatting.black,
		require("null-ls").builtins.formatting.clang_format,
    require("null-ls").builtins.diagnostics.mypy,
    require("null-ls").builtins.diagnostics.ruff,

	},
})

-- LuaSnip starts here but the snips are in lua luaSnipConfigCustom
local ls = require("luasnip")
local types = require('luasnip.util.types')
require("luasnip.loaders.from_lua").load({paths = directoryOfSnippet})
ls.config.set_config ({

	history = true,
	updateevents = "TextChanged,TextChangedI",
	enable_autosnippets = true,
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = { { "<-", "Error"} }
			},
		},
	},
})
vim.keymap.set({"i", "s"}, "<c-k>", function()
	if ls.expand_or_jumpable() then
		ls.expand_or_jump()
	end
end, {silent = true})

vim.keymap.set({"i", "s"}, "<c-j>", function()
	if ls.jumpable(-1) then
		ls.jump(-1)
	end
end, {silent = true})

vim.keymap.set("i", "<c-l>", function()
	if ls.choice_activate() then
		ls.change_choice(1)
	end
end)
-- telescope configuration
local builtin = require('telescope.builtin')
vim.keymap.set('n', 'fg', builtin.live_grep, {})
vim.keymap.set('n', 'fb', builtin.buffers, {})
vim.keymap.set('n', 'fh', builtin.help_tags, {})
--Whenever it updates, :TSUpdate
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "c", "lua", "python", "javascript", "cpp" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  }
}
require('nightfox').setup({
	options = {
		transparent = true,
	}
})
vim.diagnostic.config({
  virtual_text = false
})

--debugging

local dap = require('dap')


-- dap.adapters.cppdbg = {
--   id = 'cppdbg',
--   type = 'executable',
--   command = 'C:\\extension\\debugAdapters\\bin\\OpenDebugAD7.exe',
--   options = {
--     detached = false
--   }
-- }
--

-- dap.configurations.cpp = {
--   {
--     name = "Launch file",
--     type = "cppdbg",
--     request = "launch",
--     program = function()
--       return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
--     end,
--     cwd = '${workspaceFolder}',
--     stopAtEntry = true,
--   },
--   {
--     name = 'Attach to gdbserver :1234',
--     type = 'cppdbg',
--     request = 'launch',
--     MIMode = 'gdb',
--     miDebuggerServerAddress = 'localhost:1234',
--     miDebuggerPath = '/usr/bin/gdb',
--     cwd = '${workspaceFolder}',
--     program = function()
--       return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
--     end,
--   },
-- 	-- setupCommands = {  
-- 	-- 	{ 
-- 	-- 		text = '-enable-pretty-printing',
-- 	-- 		description =  'enable pretty printing',
-- 	-- 		ignoreFailures = false 
-- 	-- 	},
-- 	-- },
-- }

-- dap.adapters.codelldb {
--   type = 'server',
--   host = '127.0.0.1',
--   port = 13000
-- }
--
-- dap.configurations.cpp = {
--   {
--     name = "Launch file",
--     type = "codelldb",
--     request = "launch",
--     program = function()
--       return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
--     end,
--     cwd = '${workspaceFolder}',
--     stopOnEntry = false,
--   },
-- }

require("dapui").setup()
require("flutter-tools").setup{
    flutter_path = "D:/flutter/bin/flutter.bat",
}
require('neogit').setup{}

-- local metals_config = require("metals").bare_config()
-- metals_config.settings = {
--   showImplicitArguments = true,
-- }
-- metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()


local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "scala", "sbt", "java" },
    callback = function()
    require("metals").initialize_or_attach({})
end,
    group = nvim_metals_group,
})

vim.keymap.set("n", "<F5>", ":lua require'dap'.continue()<CR>")
vim.keymap.set("n", "<F10>", ":lua require'dap'.step_over()<CR>")
vim.keymap.set("n", "<F11>", ":lua require'dap'.step_into()<CR>")
vim.keymap.set("n", "<F12>", ":lua require'dap'.step_out()<CR>")
vim.keymap.set("n", "<F6>", ":lua require'dap'.terminate()<CR>")
vim.keymap.set("n", "<leader>b", ":lua require'dap'.toggle_breakpoint()<CR>")
vim.keymap.set("n", "<leader>B", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition : '))<CR>")
vim.keymap.set("n", "<leader>lp", ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>")
vim.keymap.set("n", "<leader>dr", ":lua require'dap'.repl.open()<CR>")
vim.api.nvim_set_keymap("n", "<Leader>dh", "<CMD>lua require('dapui').eval()<CR>",
  { noremap = true, silent = true })
vim.fn.sign_define('DapBreakpoint', { text = '🟥', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '⭐️', texthl = '', linehl = '', numhl = '' })
local signs = { Error = "", Warn = "", Hint = "", Info = "󰋼" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
vim.diagnostic.config({
  float = {
    source = "always",  -- Or "if_many"
  },
})
require("telescope").load_extension("yaml_schema")

-- -- Show line diagnostics automatically in hover window
vim.o.updatetime = 250
vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]
vim.cmd("colorscheme nordfox")
-- Create a breakpoint in nvim-dap
vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]
