local shell = function(cmd)
  return vim.fn.trim(vim.fn.system(cmd))
end

local current_tmux_session = shell "tmux display-message -p '#S'"
local current_activity_option = shell 'tmux show-options visual-activity'

-- tmux window name can change at any time, so lets get the value in a function every time we need it
local function get_editor_window()
  return shell "tmux display-message -p '#W'"
end

local join_pane = function(is_vsplit, target_window)
  local split_param = is_vsplit and '-h' or '-v' -- what tmux calls vertical and horizontal splits is opposite of vim
  local editor_window = get_editor_window()

  --stylua: ignore
  local cmd = 'tmux'
    .. ' join-pane ' .. split_param .. ' -s ' .. current_tmux_session .. ':' .. target_window .. ' \\;'
    .. ' select-pane -t ' .. current_tmux_session .. ':' .. editor_window .. '.1'
  shell(cmd)
end

local break_pane = function(target_window)
  local editor_window = get_editor_window()

  --stylua: ignore
  local cmd = 'tmux'
  .. ' select-pane -t ' .. current_tmux_session .. ':' .. editor_window .. '.2 \\; '
  .. ' break-pane -t ' .. current_tmux_session .. ' \\; '
  .. ' rename-window -t ' .. current_tmux_session .. ' ' .. target_window .. ' \\; '
  .. ' select-window -t ' .. current_tmux_session .. ':' .. editor_window

  shell 'tmux set-option visual-activity off'
  shell(cmd)
  shell('tmux set-option ' .. current_activity_option)
end

local function escape_shell_chars(str)
  --stylua: ignore
  return (str
    :gsub('\\', '\\\\')
    :gsub('"', '\\"')
    :gsub('`', '\\`')
    :gsub('%$', '\\$'))
end

local send_text = function(target, text)
  local escapedText = escape_shell_chars(text)
  local cmd = 'tmux send-keys -t ' .. target .. ' "' .. escapedText .. '" C-m'
  shell(cmd)
end

local joined_window = nil
local is_join_vertical = false

local M = {}

M.setup = function()
  local augroup = vim.api.nvim_create_augroup('tmux-repl', { clear = true })
  vim.api.nvim_create_autocmd('VimLeavePre', { callback = M.break_pane, group = augroup })
end

M.join_pane = function(target_window, is_vsplit)
  if joined_window == target_window and is_join_vertical == is_vsplit then
    return
  end
  if joined_window then
    M.break_pane()
  end
  joined_window = target_window
  is_join_vertical = is_vsplit
  join_pane(is_vsplit, target_window)
end

M.join_pane_vertical = function(target_window)
  M.join_pane(target_window, true)
end

M.join_pane_horizontal = function(target_window)
  M.join_pane(target_window, false)
end

M.break_pane = function()
  if not joined_window then
    return
  end
  break_pane(joined_window)
  joined_window = nil
end

M.send_text = function(target_window, text)
  local editor_window = get_editor_window()
  local target = target_window
  if target == joined_window then
    target = editor_window .. '.2'
  end
  send_text(target, text)
end

return M
