vim.keymap.set({ 'n' }, '<space>cf', function()
  vim.cmd 'LspRuffFixAll'
end, { desc = 'Ruff [f]ix all', buffer = true, silent = true, noremap = true })
