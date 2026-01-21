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

  vim.lsp.buf_request(0, 'textDocument/codeAction', params, function(err, result, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    local client_name = client and client.name or 'UNKNOWN'

    if err then
      vim.notify('Error fetching code actions: ' .. err.message, vim.log.levels.ERROR)
      return
    end
    if not result or vim.tbl_isempty(result) then
      vim.notify('No code actions available for client ' .. client_name, vim.log.levels.INFO)
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

M.list_active_clients = function()
  for _, client in ipairs(vim.lsp.get_clients { bufnr = 0 }) do
    print(
      client.name,
      'id=' .. client.id,
      'root=' .. (client.config.root_dir or 'nil') .. ' active=' .. vim.inspect(client.attached_buffers) .. ' is_stopped = ' .. vim.inspect(client:is_stopped())
    )
  end
end

M.list_available_code_actions = function()
  local range_params = vim.lsp.util.make_range_params(nil, 'utf-8')

  local params = {
    textDocument = range_params.textDocument,
    range = range_params.range,
    context = {
      diagnostics = {},
      only = { 'source', 'eslint.applyAllFixes' },
    },
  }
  vim.lsp.buf_request(0, 'textDocument/codeAction', params, function(err, result, ctx)
    if err then
      print('Error:', err)
      return
    end

    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if not client then
      print 'Error: client not defined'
      return
    end
    print('From client:' .. client.name)

    for _, action in ipairs(result or {}) do
      print(action.kind or 'no kind', action.title)
    end
  end)
end

M.list_available_commands = function()
  for _, client in ipairs(vim.lsp.get_clients { bufnr = 0 }) do
    print('Client commands:', client.name)
    print(vim.inspect(client.server_capabilities.executeCommandProvider))
  end
end

return M
