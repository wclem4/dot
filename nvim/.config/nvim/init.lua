vim.g.mapleader = ','

-- Fix tabbing
vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.shiftwidth = 2

vim.o.number = true      -- Show numbers
vim.o.signcolumn = 'yes' -- Always show sign column
vim.o.ignorecase = true  -- Ignore case when searching
vim.o.scrolloff = 1      -- Number of lines kept above/below cursor

-- Reopen file at last position
vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = '*',
  callback = function()
    if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
      vim.cmd([[normal! g`"]])
    end
  end
})

-- Copy/Paste between vim sessions
vim.keymap.set('v', '<leader>y', ':w! /tmp/vitmp<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>p', ':r! cat /tmp/vitmp<CR>', { noremap = true, silent = true })

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  -- Color Scheme
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme "kanagawa"
    end,
  },

  -- Status Line
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'f-person/git-blame.nvim',
    },
  },

  -- Formatter
  'stevearc/conform.nvim',

  -- Parser
  "nvim-treesitter/nvim-treesitter",

  -- Notifications
  "j-hui/fidget.nvim",

  -- Search
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.6',
    dependencies = {
      'nvim-lua/plenary.nvim',
    }
  },

  -- Key Dictionary
  'folke/which-key.nvim',

  -- Package Manager
  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',

  -- LSP
  'neovim/nvim-lspconfig',

  -- Completion
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-nvim-lsp',
  'dcampos/nvim-snippy',
  'dcampos/cmp-snippy',
})

-- Status Line Setup
local git_blame = require('gitblame');
vim.g.gitblame_display_virtual_text = 0;
require('lualine').setup {
  options = {
    component_separators = '|',
    section_separators = '',
  },
  sections = {
    lualine_c = { { git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available } }
  }
}

-- Formatter Setup
require("conform").setup({
  formatters_by_ft = {
    javascript = { "prettier" },
    typescript = { "prettier" },
    go = { "goimports", "gofmt" }
  },
  format_on_save = {
    lsp_fallback = true,
  },
})

-- Parser Setup
require("nvim-treesitter.configs").setup {
  ensure_installed = {
    "javascript",
    "typescript",
    "tsx",
    "sql",
    "go",
    "gomod",
    "gosum",
    "lua",
    "vim",
    "vimdoc",
    "query",
    "c",
  },
  highlight = {
    enable = true,
  },
}

-- Notifications Setup
require("fidget").setup()

-- Search Setup
require('telescope').setup()
local tsb = require('telescope.builtin')
vim.keymap.set('n', '<leader>gf', tsb.git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', tsb.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sg', tsb.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sw', tsb.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sd', tsb.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', tsb.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>sh', tsb.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>ss', tsb.builtin, { desc = '[S]earch [S]elect Telescope' })

-- Key Dictionary Setup
require('which-key').setup()

-- Package Manager Setup
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "bashls",
    "jsonls",
    "gopls",
    "sqlls",
    "tsserver",
    "lua_ls",
    "eslint",
  },
  automatic_installation = true,
})

-- LSP Setup
local lspconfig = require('lspconfig')
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
lspconfig.bashls.setup({ capabilities = lsp_capabilities })
lspconfig.jsonls.setup({ capabilities = lsp_capabilities })
lspconfig.gopls.setup({ capabilities = lsp_capabilities })
lspconfig.sqlls.setup({ capabilities = lsp_capabilities })
lspconfig.tsserver.setup({ capabilities = lsp_capabilities })
lspconfig.lua_ls.setup({
  capabilities = lsp_capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' },
      },
    }
  },
})
lspconfig.eslint.setup({ capabilities = lsp_capabilities })

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function()
    local opts = { buffer = true }
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', 'gl', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  end
})

local sign = function(opts)
  vim.fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = ''
  })
end

sign({ name = 'DiagnosticSignError', text = '✘' })
sign({ name = 'DiagnosticSignWarn', text = '▲' })
sign({ name = 'DiagnosticSignHint', text = '⚑' })
sign({ name = 'DiagnosticSignInfo', text = '' })

vim.diagnostic.config({
  virtual_text = true,
  severity_sort = true,
  float = {
    source = 'always',
  },
})

-- Completion Setup
vim.opt.completeopt = { 'menu', 'menuone' }
local cmp = require('cmp')
local select_opts = { behavior = cmp.SelectBehavior.Select }
cmp.setup({
  snippet = {
    expand = function(args)
      require('snippy').expand_snippet(args.body)
    end,
  },
  sources = {
    { name = 'path' },
    { name = 'buffer',  keyword_length = 2 },
    { name = 'nvim_lsp' },
  },
  formatting = {
    fields = { 'menu', 'abbr', 'kind' },
    format = function(entry, item)
      local menu_icon = {
        nvim_lsp = 'LSP',
        buffer = 'Buffer',
        path = 'Path',
      }
      item.menu = menu_icon[entry.source.name]
      return item
    end,
  },
  mapping = {
    ['<Up>'] = cmp.mapping.select_prev_item(select_opts),
    ['<Down>'] = cmp.mapping.select_next_item(select_opts),

    ['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
    ['<C-n>'] = cmp.mapping.select_next_item(select_opts),

    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),

    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),

    ['<Tab>'] = cmp.mapping(function(fallback)
      local col = vim.fn.col('.') - 1

      if cmp.visible() then
        cmp.select_next_item(select_opts)
      elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        fallback()
      else
        cmp.complete()
      end
    end, { 'i', 's' }),

    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item(select_opts)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
})
