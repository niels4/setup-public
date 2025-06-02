local M = {}

M.shell = function(cmd)
  return vim.fn.trim(vim.fn.system(cmd))
end

M.escape_shell_chars = function(str)
  return (str:gsub('\\', '\\\\'):gsub('"', '\\"'):gsub('`', '\\`'):gsub('%$', '\\$'))
end

M.get_visual_selection = function()
  local start_pos = vim.fn.getpos 'v'
  local end_pos = vim.fn.getpos '.'
  local mode = vim.fn.mode()

  local region = vim.fn.getregion(start_pos, end_pos, { type = mode })
  return table.concat(region, '\n')
end

return M
