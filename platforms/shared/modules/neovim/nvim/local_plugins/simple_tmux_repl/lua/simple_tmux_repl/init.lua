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
  local text = util.get_visual_selection()
  tmux.send_text(target_window, text)
end

M.send_paragraph = function(target_window)
  local text = util.get_paragraph_text()
  tmux.send_text(target_window, text)
end

M.send_paragraph_while_insert = function(target_window)
  M.send_paragraph(target_window)
  util.exit_visual_mode()
  vim.api.nvim_feedkeys('a', 'n', false)
end

return M
