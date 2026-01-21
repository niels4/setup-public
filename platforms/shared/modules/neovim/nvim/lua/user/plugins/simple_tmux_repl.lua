local local_plugins_dir = vim.fn.stdpath 'config' .. '/local_plugins/'

local repl_window = 'repl'
local shell_window = 'shell'

return {
  dir = local_plugins_dir .. 'simple_tmux_repl',
  config = function()
    local tmux_repl = require 'simple_tmux_repl'
    tmux_repl.setup()

    local join = function(target_window, is_vertertical)
      return function()
        tmux_repl.join_pane(target_window, is_vertertical)
      end
    end

    vim.keymap.set('n', '<f1>', tmux_repl.break_pane)
    vim.keymap.set('n', '<f2>', join(shell_window, true))
    vim.keymap.set('n', '<S-f2>', join(shell_window, false))
    vim.keymap.set('n', '<f3>', join(repl_window, true))
    vim.keymap.set('n', '<S-f3>', join(repl_window, false))

    local send_selected = function(target_window)
      return function()
        tmux_repl.send_selected(target_window)
      end
    end

    local send_paragraph = function(target_window)
      return function()
        tmux_repl.send_paragraph(target_window)
      end
    end

    local send_paragraph_insert = function(target_window)
      return function()
        tmux_repl.send_paragraph_while_insert(target_window)
      end
    end

    vim.keymap.set('v', ',s', send_selected(shell_window))
    vim.keymap.set('n', ',s', send_paragraph(shell_window))
    vim.keymap.set('v', ',r', send_selected(repl_window))
    vim.keymap.set('n', ',r', send_paragraph(repl_window))
    vim.keymap.set('i', '<m-r>', send_paragraph_insert(repl_window))

    -- repeat last command in shell_window. Can override command. example: :let g:f4_command="npm test"
    vim.g.f4_command = '!!'
    -- repeat last command in repl_window. :let g:f5_command="<command>" to override
    vim.g.f5_command = '!!'

    local save_and_run = function(key)
      local window
      if key == 'f4' then
        window = shell_window
      else
        window = repl_window
      end
      return function()
        vim.cmd 'w'
        tmux_repl.send_text(window, vim.g[key .. '_command'])
      end
    end

    vim.keymap.set({ 'n', 'i' }, '<f5>', save_and_run 'f5')
    vim.keymap.set({ 'n', 'i' }, '<f4>', save_and_run 'f4')
  end,
}
