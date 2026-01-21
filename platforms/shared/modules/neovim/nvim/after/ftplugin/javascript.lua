local lsp_util = require 'user.util.lsp'

vim.keymap.set({ 'n' }, '<space>cs', function()
  vim.cmd 'LspTypescriptSourceAction'
end, { desc = '[c] Typescript [s]ource action', buffer = true, silent = true, noremap = true })

vim.keymap.set({ 'n' }, '<space>cf', function()
  vim.cmd 'LspEslintFixAll'
end, { desc = '[c] Eslint [f]ix all', buffer = true, silent = true, noremap = true })

vim.keymap.set({ 'n' }, '<space>ci', function()
  lsp_util.perform_source_action 'source.addMissingImports.ts'
end, { desc = '[c] Missing [i]mports', buffer = true, silent = true, noremap = true })

vim.keymap.set('n', '<space>cu', function()
  lsp_util.perform_source_action 'source.removeUnused'
end, { desc = '[C] Remove [u]nused', buffer = true, silent = true, noremap = true })
