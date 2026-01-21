-- [[ Basic Keymaps ]]
--  See `:help keymap()`
local lsp_util = require 'user.util.lsp'
local keymap = vim.keymap.set

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
keymap('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
keymap('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
keymap('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
keymap('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
keymap('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
keymap('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
keymap('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('user-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

local opts = { noremap = true, silent = true }
local desc = function(description)
  return { noremap = true, silent = true, desc = description }
end

-- jk for quick escape
keymap('i', 'jk', '<ESC>', desc 'Quick escape')

-- for developing plugins
keymap('n', ',,x', '<cmd>w<cr><cmd>source %<cr>', desc 'Evaluate the current file')

keymap('n', '<C-w>c', ':set cursorcolumn!<cr>:set cursorline!<cr>', desc 'Toggle line and column highlights')

-- auto indent entire file
keymap('n', ',,f', 'mmgg=G`m', desc 'Auto indent current file')

keymap('n', ',cd', '<cmd>cd %:p:h<cr><cmd>pwd<cr>', desc 'Change directory to that of current file')

-- Visual Block: Move text up and down
keymap('x', 'J', ":move '>+1<CR>gv-gv", opts)
keymap('x', 'K', ":move '<-2<CR>gv-gv", opts)

-- close other windows
keymap('n', ',on', '<cmd>only<cr>', desc 'Close all other windows')
keymap('n', ',cc', '<cmd>cclose<cr>', desc 'Close the quick window')

-- Resize window
keymap('n', '<m-k>', ':resize -2<CR>', desc 'Resize window, reduce vertical')
keymap('n', '<m-j>', ':resize +2<CR>', desc 'Resize window, increase vertical')
keymap('n', '<m-h>', ':vertical resize -2<CR>', desc 'Resize window, reduce horizontal')
keymap('n', '<m-l>', ':vertical resize +2<CR>', desc 'Resize window, increase horizontal')

-- horizontal scrolling
keymap('n', '<m-L>', '20zl', desc 'Scroll right')
keymap('n', '<m-H>', '20zh', desc 'Scroll left')

-- Navigate buffers
keymap('n', '<S-l>', ':bnext<CR>', desc 'Buffer Next')
keymap('n', '<S-h>', ':bprevious<CR>', desc 'Buffer Previous')

-- Stay in indent mode
keymap('v', '<', '<gv', opts)
keymap('v', '>', '>gv', opts)

-- space key nop in normal mode
-- keymap({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- show and hide command line
keymap({ 'i', 'n' }, '<m-B>', function()
  if vim.opt.cmdheight == 0 then
    vim.opt.cmdheight = 1
  else
    vim.opt.cmdheight = 0
  end
end, { silent = true })

local function goto_prev_diagnostic()
  vim.diagnostic.jump { count = -1, float = true }
end

local function goto_next_diagnostic()
  vim.diagnostic.jump { count = 1, float = true }
end

-- Diagnostic keymaps
keymap('n', '[d', goto_prev_diagnostic, desc 'Go to previous diagnostic message')
keymap('n', ']d', goto_next_diagnostic, desc 'Go to next diagnostic message')
keymap('n', '<space>d', vim.diagnostic.open_float, desc 'Open floating [d]iagnostic message')

-- Universal LSP keymaps
keymap('n', '<space>ca', lsp_util.list_available_code_actions, desc 'List available [c]ode [a]ctions')
keymap('n', '<space>cll', lsp_util.list_active_clients, desc 'List of active [l]sp clients')
keymap('n', '<space>clc', lsp_util.list_available_commands, desc 'List of active lsp [c]ommands')

-- move forward and back while in insert mode
keymap('i', '<M-l>', '<right>', desc 'Move forward while in insert mode')
keymap('i', '<M-h>', '<left>', desc 'Move backward while in insert mode')

-- edit snippets
keymap({ 'n' }, '<space>es', function()
  require('luasnip.loaders').edit_snippet_files {}
end, { desc = '[E]dit [S]nippet ' })

-- save file
keymap({ 'n', 'i' }, '<c-s>', function()
  vim.cmd 'w'
end, { desc = '[S]ave File' })

-- reload all changed files
keymap({ 'n' }, '<space>ea', function()
  vim.cmd 'checktime'
end, { desc = '[E] reload [A]ll' })
