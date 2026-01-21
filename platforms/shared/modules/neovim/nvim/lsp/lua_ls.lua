local root_markers = { '.luarc.json', '.luarc.jsonc' }

---@type vim.lsp.Config
return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  single_file_support = false,
  root_dir = function(bufnr, on_dir)
    local project_root = vim.fs.root(bufnr, root_markers)

    if not project_root then
      return
    end

    on_dir(project_root)
  end,
}
