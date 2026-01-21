return {
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    --[[ custom, get rid of that annoying scope decoration
    opts = {},
    ]]
    opts = {
      scope = {
        enabled = false,
      },
    },
  },
}
