local biome_or_prettier = { 'biome-check', 'prettier', stop_after_first = true }

return {
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = true,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        css = biome_or_prettier,
        javascript = biome_or_prettier,
        javascriptreact = biome_or_prettier,
        typescript = biome_or_prettier,
        typescriptreact = biome_or_prettier,
        json = biome_or_prettier,
        jsonc = biome_or_prettier,
        python = { 'isort', 'black' },
        swift = { 'swift_format' },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
