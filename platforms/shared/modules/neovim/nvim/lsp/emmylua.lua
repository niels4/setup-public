---@brief
---
--- https://github.com/EmmyLuaLs/emmylua-analyzer-rust
---
--- Emmylua Analyzer Rust. Language Server for Lua.
---
--- `emmylua_ls` can be installed using `cargo` by following the instructions[here]
--- (https://github.com/EmmyLuaLs/emmylua-analyzer-rust?tab=readme-ov-file#install).
---
--- The default `cmd` assumes that the `emmylua_ls` binary can be found in `$PATH`.
--- It might require you to provide cargo binaries installation path in it.

local root_markers = { '.emmyrc.json', '.emmyrc.jsonc' }

---@type vim.lsp.Config
return {
  cmd = { 'emmylua_ls' },
  filetypes = { 'lua' },
  workspace_required = false,
  root_dir = function(bufnr, on_dir)
    local project_root = vim.fs.root(bufnr, root_markers)

    if not project_root then
      return
    end

    on_dir(project_root)
  end,
}
