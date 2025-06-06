local M = {}

local is_extending = false

-- simple function to extend ftplugin scripts
-- see nvim/after/ftplugin/typescriptreact.lua for example usage

M.extend = function(filetype)
  -- only extend 1 level deep. No recursive extends
  if is_extending then
    return
  end

  is_extending = true
  vim.cmd.runtime { 'after/ftplugin/' .. filetype .. '.lua', bang = true }
  is_extending = false
end

return M
