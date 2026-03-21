-- use this plugin to handle displaying notifications and lsp progress in the bottom right of the window

return {
  'j-hui/fidget.nvim',
  priority = 900,
  lazy = false,
  keys = {
    { mode = 'n', '<leader>n', '<cmd>Fidget history<cr>', desc = '[n]otify History' },
  },
  opts = {
    notification = {
      override_vim_notify = true,
      window = {
        max_width = 60, -- Forces the window to stay narrow
      },
      view = {
        reflow = true, -- Wrap long messages into multiple lines
      },
    },
  },
}
