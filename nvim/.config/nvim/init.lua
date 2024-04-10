vim.g.mapleader = ','

-- fix tabbing
vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.shiftwidth = 2

vim.o.number = true      -- show numbers
vim.o.signcolumn = "yes" -- always show the sign column left of numbers
vim.o.ignorecase = true  -- ignore case when searching
vim.o.scrolloff = 1      -- number of lines kept above/below cursor
vim.o.termguicolors = true

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

require("lazy").setup({
  -- Theme
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'gruvbox'
    end,
    opts = {},
  },

  -- Fancy status line
  {
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        icons_enabled = false,
        theme = 'onedark',
        component_separators = '|',
        section_separators = '',
      },
    },
  },

  "nvim-treesitter/nvim-treesitter",

  -- Search
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim', }
  },
  'benfowler/telescope-luasnip.nvim',

  -- Key dictionary popup
  'folke/which-key.nvim',

  -- LSP
  'neovim/nvim-lspconfig',
  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',

  -- Autocomplete
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'saadparwaiz1/cmp_luasnip',

  -- Snippets
  {
    'L3MON4D3/LuaSnip',
    dependencies = { 'rafamadriz/friendly-snippets', }
  },
  {
    'stevearc/conform.nvim',
    opts = {},
  },
})

require("conform").setup({
  formatters_by_ft = {
    javascript = { "prettier" },
    typescript = { "prettier" }
  },
  format_on_save = {
    async = true,
  },
})

require("nvim-treesitter.configs").setup {
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "javascript", "typescript", "tsx", "sql", "go" },
  highlight = {
    enable = true
  }
}

require("which-key").setup()

-- reopen file at last position
vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = '*',
  callback = function()
    if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
      vim.cmd([[normal! g`"]])
    end
  end
})


-- vim.api.nvim_create_autocmd('BufWritePost', {
--   callback = function()
--     vim.lsp.buf.format()
--   end
-- })

-- copy paste between windows
vim.keymap.set('v', '<leader>y', ':w! /tmp/vitmp<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>p', ':r! cat /tmp/vitmp<CR>', { noremap = true, silent = true })

-- telescope
require('telescope').setup()

local tsb = require('telescope.builtin')

-- search files
vim.keymap.set('n', '<leader>gf', tsb.git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', tsb.find_files, { desc = '[S]earch [F]iles' })

-- search text
vim.keymap.set('n', '<leader>sg', tsb.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sw', tsb.grep_string, { desc = '[S]earch current [W]ord' })

-- search diagnostics
vim.keymap.set('n', '<leader>sd', tsb.diagnostics, { desc = '[S]earch [D]iagnostics' })

-- resume previous search
vim.keymap.set('n', '<leader>sr', tsb.resume, { desc = '[S]earch [R]esume' })

-- search vim help documentation
vim.keymap.set('n', '<leader>sh', tsb.help_tags, { desc = '[S]earch [H]elp' })

-- search telescope built in functions
vim.keymap.set('n', '<leader>ss', tsb.builtin, { desc = '[S]earch [S]elect Telescope' })

-- add snippets to telescope ('Telescope luasnip')
require('telescope').load_extension('luasnip')

-- LSP jumps/refactors
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function()
    local bufmap = function(mode, lhs, rhs)
      local opts = { buffer = true }
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')
    bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
    bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
    bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')
    bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
    bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')
    bufmap('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>')

    bufmap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>')
    bufmap('n', '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>')
    bufmap('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>')

    bufmap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
    bufmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
    bufmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')
  end
})

-- Diag
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
    border = 'rounded',
    source = 'always',
  },
})

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
  vim.lsp.handlers.hover,
  { border = 'rounded' }
)

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  { border = 'rounded' }
)

-- Mason Setup
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

-- LSP config
local lspconfig = require('lspconfig')
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig.bashls.setup({
  capabilities = lsp_capabilities,
})
lspconfig.jsonls.setup({
  capabilities = lsp_capabilities,
})
lspconfig.gopls.setup({
  capabilities = lsp_capabilities,
})
lspconfig.sqlls.setup({
  capabilities = lsp_capabilities,
})
lspconfig.tsserver.setup({
  capabilities = lsp_capabilities,
})
lspconfig.lua_ls.setup({
  capabilities = lsp_capabilities,
})
lspconfig.eslint.setup({
  capabilities = lsp_capabilities,
})

-- Autocomplete
vim.opt.completeopt = { 'menu', 'menuone' }
require('luasnip.loaders.from_vscode').lazy_load()

local cmp = require('cmp')
local luasnip = require('luasnip')
local select_opts = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end
  },
  sources = {
    { name = 'path' },
    { name = 'luasnip' },
    { name = 'nvim_lsp' },
    { name = 'buffer',  keyword_length = 2 },
  },
  window = {
    documentation = cmp.config.window.bordered()
  },
  formatting = {
    fields = { 'menu', 'abbr', 'kind' },
    format = function(entry, item)
      local menu_icon = {
        nvim_lsp = 'lsp',
        luasnip = 'snip',
        buffer = 'buf',
        path = 'path',
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
    ['<CR>'] = cmp.mapping.confirm({ select = false }),

    ['<C-f>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(1) then
        luasnip.jump(1)
      else
        fallback()
      end
    end, { 'i', 's' }),

    ['<C-b>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),

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
