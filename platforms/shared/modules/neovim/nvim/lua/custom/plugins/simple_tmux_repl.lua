local local_plugins_dir = vim.fn.stdpath 'config' .. '/local_plugins/'

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
    vim.keymap.set('n', '<f2>', join('shell', true))
    vim.keymap.set('n', '<S-f2>', join('shell', false))
    vim.keymap.set('n', '<f3>', join('repl', true))
    vim.keymap.set('n', '<S-f3>', join('repl', false))

    local send_selected = function(target_window)
      return function()
        tmux_repl.send_selected(target_window)
      end
    end

    vim.keymap.set('v', ',r', send_selected 'shell')
  end,
}
