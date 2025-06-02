local shell = function(cmd)
  return vim.fn.trim(vim.fn.system(cmd))
end

local current_tmux_session = shell "tmux display-message -p '#S'"
local current_activity_option = shell 'tmux show-options visual-activity'

-- tmux window name can change at any time, so lets get the value in a function every time we need it
local function get_current_tmux_window()
  return shell "tmux display-message -p '#W'"
end

local join_pane = function(is_vsplit, target_pane)
  local split_param = is_vsplit and '-h' or '-v' -- what tmux calls vertical and horizontal splits is opposite of vim
  local current_tmux_window = get_current_tmux_window()
  local cmd = 'tmux join-pane '
    .. split_param
    .. ' -s '
    .. current_tmux_session
    .. ':'
    .. target_pane
    .. ' \\;'
    .. ' select-pane -t '
    .. current_tmux_session
    .. ':'
    .. current_tmux_window
    .. '.1'
  shell(cmd)
end

local break_pane = function(target_pane)
  local current_tmux_window = get_current_tmux_window()
  local cmd = 'tmux select-pane -t '
    .. current_tmux_session
    .. ':'
    .. current_tmux_window
    .. '.2 \\; '
    .. ' break-pane -t '
    .. current_tmux_session
    .. ' \\; '
    .. ' rename-window -t '
    .. current_tmux_session
    .. ' '
    .. target_pane
    .. ' \\; '
    .. ' select-window -t '
    .. current_tmux_session
    .. ':'
    .. current_tmux_window
  shell 'tmux set-option visual-activity off'
  shell(cmd)
  shell('tmux set-option ' .. current_activity_option)
end

local joined_window = nil
local is_join_vertical = false

local M = {}

M.setup = function()
  local augroup = vim.api.nvim_create_augroup('tmux-repl', { clear = true })
  vim.api.nvim_create_autocmd('VimLeavePre', { callback = M.break_pane, group = augroup })
end

M.join_pane = function(target_pane, is_vsplit)
  if joined_window == target_pane and is_join_vertical == is_vsplit then
    return
  end
  if joined_window then
    M.break_pane()
  end
  joined_window = target_pane
  is_join_vertical = is_vsplit
  join_pane(is_vsplit, target_pane)
end

M.join_pane_vertical = function(target_pane)
  M.join_pane(target_pane, true)
end

M.join_pane_horizontal = function(target_pane)
  M.join_pane(target_pane, false)
end

M.break_pane = function()
  if not joined_window then
    return
  end
  break_pane(joined_window)
  joined_window = nil
end

return M
