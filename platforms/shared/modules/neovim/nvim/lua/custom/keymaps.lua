local opts = { noremap = true, silent = true }
local desc = function(description)
  return { noremap = true, silent = true, desc = description }
end
local keymap = vim.keymap.set

-- jk for quick escape
keymap('i', 'jk', '<ESC>', desc 'Quick escape')

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
-- vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- show and hide command line
vim.keymap.set({ 'i', 'n' }, '<m-B>', function()
  if vim.opt.cmdheight:get() == 0 then
    vim.opt.cmdheight = 1
  else
    vim.opt.cmdheight = 0
  end
end, { silent = true })

-- Diagnostic keymaps
keymap('n', '[d', vim.diagnostic.goto_prev, desc 'Go to previous diagnostic message')
keymap('n', ']d', vim.diagnostic.goto_next, desc 'Go to next diagnostic message')
keymap('n', '<space>d', vim.diagnostic.open_float, desc 'Open floating [d]iagnostic message')

-- move forward and back while in insert mode
keymap('i', '<M-l>', '<right>', desc 'Move forward while in insert mode')
keymap('i', '<M-h>', '<left>', desc 'Move backward while in insert mode')

-- eslint fix all
vim.keymap.set({ 'n' }, '<space>ef', '<cmd>LspEslintFixAll<cr>', desc '[e]slint [f]ix All')

-- edit snippets
vim.keymap.set({ 'n' }, '<space>es', function()
  require('luasnip.loaders').edit_snippet_files {}
end, { desc = '[E]dit [S]nippet ' })

-- save file
vim.keymap.set({ 'n', 'i' }, '<c-s>', function()
  vim.cmd 'w'
end, { desc = '[S]ave File' })

-- reload all changed files
vim.keymap.set({ 'n' }, '<space>ea', function()
  vim.cmd 'checktime'
end, { desc = '[E] reload [A]ll' })
