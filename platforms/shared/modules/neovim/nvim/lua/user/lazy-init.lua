local util = require 'user.util.util'

--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

local M = {}

--- must register function before lazy.setup is called
---@param plugin_names string|table<string>
local function run_after_loaded(plugin_names, fn)
  if type(plugin_names) == 'string' then
    plugin_names = { plugin_names }
  end

  local plugin_set = util.make_set(plugin_names)
  local plugins_seen = 0

  local id

  id = vim.api.nvim_create_autocmd('User', {
    pattern = 'LazyLoad',
    callback = function(ev)
      if plugin_set[ev.data] then
        plugins_seen = plugins_seen + 1
        if plugins_seen >= #plugin_names then
          vim.api.nvim_del_autocmd(id)
          fn()
        end
      end
    end,
  })
end

M.run_after_loaded = run_after_loaded

return M
