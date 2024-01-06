vim.g.mapleader = ','

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
  { "ellisonleao/gruvbox.nvim", 
    priority = 1000 , 
    config = function()
      vim.cmd.colorscheme 'gruvbox'
    end, 
    opts = {},
  },
  { 'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        icons_enabled = false,
        theme = 'onedark',
        component_separators = '|',
        section_separators = '',
      },
    },
  },
  { 'nvim-telescope/telescope.nvim', tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim',  }
  },
  'folke/which-key.nvim',
  'nvim-treesitter/nvim-treesitter',
})

-- fix tabbing
vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.shiftwidth = 2

vim.o.number = true -- show numbers 
vim.o.signcolumn = "yes" -- always show the sign column left of numbers
vim.o.ignorecase = true -- ignore case when searching
vim.o.scrolloff = 1 -- number of lines kept above/below cursor
vim.o.termguicolors = true
-- vim.o.cmdheight = 2

-- reopen file at last position
vim.api.nvim_create_autocmd('BufReadPost', {
    pattern = '*',
    callback = function()
        if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
            vim.cmd([[normal! g`"]])
        end
    end
})

-- copy paste between windows
vim.keymap.set('v', '<leader>y', ':w! /tmp/vitmp<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>p', ':r! cat /tmp/vitmp<CR>', { noremap = true, silent = true })

-- maximize tmux (need szw/vim-maximizer)
-- vim.keymap.set('n', '<C-w>z', :MaximizerToggle<CR>, { noremap = true, silent = true })
-- vim.keymap.set('v', '<C-w>z', :MaximizerToggle<CR>gv, { noremap = true, silent = true })
-- vim.keymap.set('i', '<C-w>z', <C-o>:MaximizerToggle<CR>, { noremap = true, silent = true })

local tsb = require('telescope.builtin')
local function telescope_live_grep_open_files()
  tsb.live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end

-- search git
vim.keymap.set('n', '<leader>gf', tsb.git_files, { desc = 'Search [G]it [F]iles' })

-- search file names
vim.keymap.set('n', '<leader>sf', tsb.find_files, { desc = '[S]earch [F]iles' })

-- search text in just open files
vim.keymap.set('n', '<leader>s/', telescope_live_grep_open_files, { desc = '[S]earch [/] in Open Files' })
-- search text in files using grep
vim.keymap.set('n', '<leader>sg', tsb.live_grep, { desc = '[S]earch by [G]rep' })
-- search text in files using grep on hovered word
vim.keymap.set('n', '<leader>sw', tsb.grep_string, { desc = '[S]earch current [W]ord' })

-- search diagnostics 
vim.keymap.set('n', '<leader>sd', tsb.diagnostics, { desc = '[S]earch [D]iagnostics' })
-- resume previous search
vim.keymap.set('n', '<leader>sr', tsb.resume, { desc = '[S]earch [R]esume' })

-- search vim help documentation
vim.keymap.set('n', '<leader>sh', tsb.help_tags, { desc = '[S]earch [H]elp' })
-- search telescope built in functions
vim.keymap.set('n', '<leader>ss', tsb.builtin, { desc = '[S]earch [S]elect Telescope' })


-- Custom live_grep function to search in git root
-- local function live_grep_git_root()
--   local git_root = find_git_root()
--   if git_root then
--     require('telescope.builtin').live_grep {
--       search_dirs = { git_root },
--     }
--   end
-- end
-- vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })

