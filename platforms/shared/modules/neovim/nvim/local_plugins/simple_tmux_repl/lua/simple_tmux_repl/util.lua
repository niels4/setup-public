local M = {}

M.shell = function(cmd)
  return vim.fn.trim(vim.fn.system(cmd))
end

M.escape_shell_chars = function(str)
  --stylua: ignore
  return str
    :gsub('\\', '\\\\')
    :gsub('"', '\\"')
    :gsub('`', '\\`')
    :gsub('%$', '\\$')
end

M.get_visual_selection = function()
  local start_pos = vim.fn.getpos 'v'
  local end_pos = vim.fn.getpos '.'
  local mode = vim.fn.mode()
  if mode == 'i' then
    mode = 'V'
  end

  local region = vim.fn.getregion(start_pos, end_pos, { type = mode })
  return table.concat(region, '\n')
end

M.exit_visual_mode = function()
  local esc = vim.api.nvim_replace_termcodes('<esc>', true, false, true)
  vim.api.nvim_feedkeys(esc, 'v', false)
end

M.get_paragraph_text = function()
  local original_pos = vim.api.nvim_win_get_cursor(0)

  vim.cmd 'normal! vip'
  local text = M.get_visual_selection()

  M.exit_visual_mode()
  vim.api.nvim_win_set_cursor(0, original_pos)

  return text
end

return M
