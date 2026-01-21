-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
    -- custom: use <c^n> just like in the NerdTree days
    { '<c-n>', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window',

          -- custom: add custom keymappings
          ['/'] = 'noop',
          ['oc'] = 'noop',
          ['od'] = 'noop',
          ['og'] = 'noop',
          ['om'] = 'noop',
          ['on'] = 'noop',
          ['os'] = 'noop',
          ['ot'] = 'noop',

          ['<c-n>'] = 'close_window',
          ['<cr>'] = 'open',
          ['o'] = 'open',
          ['O'] = 'expand_all_subnodes',
          ['c'] = 'close_all_subnodes',
          ['l'] = 'set_root',
          ['h'] = 'navigate_up',
          ['F'] = 'fuzzy_finder',
          ['J'] = { 'scroll_preview', config = { direction = -10 } },
          ['K'] = { 'scroll_preview', config = { direction = 10 } },

          ['t'] = { 'show_help', nowait = false, config = { title = 'Sor[t] by', prefix_key = 't' } },
          ['tc'] = { 'order_by_created', nowait = false },
          ['td'] = { 'order_by_diagnostics', nowait = false },
          ['tg'] = { 'order_by_git_status', nowait = false },
          ['tm'] = { 'order_by_modified', nowait = false },
          ['tn'] = { 'order_by_name', nowait = false },
          ['ts'] = { 'order_by_size', nowait = false },
          ['tt'] = { 'order_by_type', nowait = false },
        },
      },
    },
    -- custom: close neo-tree when we open a file
    event_handlers = {
      {
        event = 'file_open_requested',
        handler = function()
          require('neo-tree.command').execute { action = 'close' }
        end,
      },
    },
  },
}
