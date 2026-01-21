return {
  { -- Autocompletion
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          -- {
          --   'rafamadriz/friendly-snippets',
          --   config = function()
          --     require('luasnip.loaders.from_vscode').lazy_load()
          --   end,
          -- },
        },
        --[[ custom: use a config function instead of opts
        opts = {},
        ]]
        config = function()
          local luasnip = require 'luasnip'

          luasnip.config.setup {}
          require('luasnip.loaders.from_snipmate').lazy_load()
          luasnip.filetype_extend('javascriptreact', { 'javascript' })
          luasnip.filetype_extend('typescript', { 'javascript' })
          luasnip.filetype_extend('typescriptreact', { 'typescript', 'javascript', 'javascriptreact' })
        end,
      },
      'folke/lazydev.nvim',
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        -- 'default' (recommended) for mappings similar to built-in completions
        --   <c-y> to accept ([y]es) the completion.
        --    This will auto-import if your LSP supports it.
        --    This will expand snippets if the LSP sent a snippet.
        -- 'super-tab' for tab to accept
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- For an understanding of why the 'default' preset is recommended,
        -- you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        --
        -- All presets have the following mappings:
        -- <tab>/<s-tab>: move to right/left of your snippet expansion
        -- <c-space>: Open menu or open docs if already open
        -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
        -- <c-e>: Hide menu
        -- <c-k>: Toggle signature help
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        preset = 'default',

        -- custom: add snippet keymaps
        ['<tab>'] = { 'accept', 'fallback' },
        ['<cr>'] = { 'accept', 'fallback' },
        ['<m-j>'] = { 'snippet_forward' },
        ['<m-k>'] = { 'snippet_backward' },

        -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
      },

      completion = {
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        --[[ custom: auto_show documentation
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
        ]]
        documentation = { auto_show = true, auto_show_delay_ms = 0 },
      },

      sources = {
        --[[ custom: add buffer and path sources
        default = { 'lsp', 'path', 'snippets', 'lazydev' },
        ]]
        default = { 'lsp', 'path', 'lazydev', 'snippets', 'buffer', 'path' },
        providers = {
          snippets = { min_keyword_length = 1 },
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        },
      },

      snippets = { preset = 'luasnip' },

      -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
      -- which automatically downloads a prebuilt binary when enabled.
      --
      -- By default, we use the Lua implementation instead, but you may enable
      -- the rust implementation via `'prefer_rust_with_warning'`
      --
      -- See :h blink-cmp-config-fuzzy for more information
      --[[ custom: use rust fuzzy sorter, lua matcher kept putting my snippets first on the list
      fuzzy = { implementation = 'lua' },
      ]]
      fuzzy = { implementation = 'rust' },

      -- Shows a signature help window while you type arguments for a function
      --[[ custom: show signature as we type
      signature = { enabled = true },
      ]]
      signature = {
        enabled = true,
        trigger = {
          enabled = true,
          show_on_keyword = true,
          show_on_trigger_character = true,
          show_on_insert = true,
          show_on_insert_on_trigger_character = true,
        },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
