return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.config', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      --[[ custom: don't pre install any tree-sitter parsers
      ]]
      -- Autoinstall languages that are not installed
      ensure_installed = {
        'javascript',
        'typescript',
        'json',
        'html',
        'css',
        'lua',
        'luadoc',
        'python',
        'rust',
        'swift',
        'go',
        'c',
        'bash',
        'diff',
        'markdown',
        'markdown_inline',
        'vim',
        'vimdoc'
      },
      auto_install = true,
      highlight = {
        enable = true,
      },
      indent = { enable = true },
    },
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },
}
