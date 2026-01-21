require 'user.options'

require 'user.keymaps'

-- [[ add some global functions for developing and debugging neovim plugins ]]
require 'user.dev.globals'

-- [[ bootstrap lazy ]]
require 'user.lazy-init'

-- [[ enable lsp clients ]]
require 'user.lsp'

-- automatically load plugins from the user/plugins/ directory
require('lazy').setup({
  { import = 'user.plugins' },
}, {
  change_detection = { enabled = false },
})
