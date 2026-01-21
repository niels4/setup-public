return {
  'phaazon/hop.nvim',
  config = function()
    local hop = require 'hop'
    hop.setup()

    local directions = require('hop.hint').HintDirection

    vim.keymap.set('n', ',w', function()
      local line_length = vim.fn.col '$' - 1
      if line_length == 0 then
        vim.cmd 'norm! }{j0'
      end
      hop.hint_words { direction = directions.AFTER_CURSOR }
    end, { desc = 'Hop forward' })

    vim.keymap.set('n', ',b', function()
      local line_length = vim.fn.col '$' - 1
      if line_length == 0 then
        vim.cmd 'norm! {}k$'
      end
      hop.hint_words { direction = directions.BEFORE_CURSOR }
    end, { desc = 'Hop backward' })
  end,
}
