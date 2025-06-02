local util = require 'simple_tmux_repl.util'
local tmux = require 'simple_tmux_repl.tmux_interface'

local M = {}

M.setup = function()
  tmux.setup()
end

M.join_pane = tmux.join_pane

M.join_pane_vertical = tmux.join_pane_vertical

M.join_pane_horizontal = tmux.join_pane_horizontal

M.break_pane = tmux.break_pane

M.send_text = tmux.send_text

M.send_selected = function(target_window)
  local selectedText = util.get_visual_selection()
  tmux.send_text(target_window, selectedText)
end

return M
