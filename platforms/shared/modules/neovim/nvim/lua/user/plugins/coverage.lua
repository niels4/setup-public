return {
  {
    'andythigpen/nvim-coverage',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      auto_reload = true,
      lcov_file = 'coverage/lcov.info',
      sign_group = 'coverage',
      signs = {
        covered = { priority = 15, text = '▎' },
        uncovered = { priority = 15, text = '▎' },
        partial = { priority = 15, text = '▎' },
      },
    },
    cmd = { 'CoverageLoad', 'CoverageShow', 'CoverageHide', 'CoverageToggle', 'CoverageSummary' },
    keys = {
      { '<leader>cvl', '<cmd>CoverageLoad<cr><cmd>CoverageShow<cr>', desc = '[c]o[v]erage [l]oad' },
      { '<leader>cvs', '<cmd>CoverageSummary<cr>', desc = 'Co[v]erage [s]ummary' },
      { '<leader>cV', '<cmd>CoverageToggle<cr>', desc = 'Co[V]erage toggle' },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
