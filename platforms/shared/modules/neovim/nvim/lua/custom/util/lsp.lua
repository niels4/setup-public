local M = {}

M.perform_source_action = function(action_key)
  local range_params = vim.lsp.util.make_range_params(0, 'utf-8')

  local params = {
    textDocument = range_params.textDocument,
    range = range_params.range,
    context = {
      diagnostics = {},
      only = { action_key },
    },
  }

  vim.lsp.buf_request(0, 'textDocument/codeAction', params, function(err, result)
    if err then
      vim.notify('Error fetching code actions: ' .. err.message, vim.log.levels.ERROR)
      return
    end
    if not result or vim.tbl_isempty(result) then
      vim.notify('No code actions available', vim.log.levels.INFO)
      return
    end

    for _, action in pairs(result) do
      if action.edit then
        vim.lsp.util.apply_workspace_edit(action.edit, 'utf-8')
      end
      if action.command then
        vim.lsp.buf_request(0, 'workspace/executeCommand', action.command)
      end
    end
  end)
end

return M
