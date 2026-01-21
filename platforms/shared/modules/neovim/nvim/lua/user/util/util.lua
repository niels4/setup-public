local M = {}

local function make_set(list)
  local s = {}
  for _, v in ipairs(list) do
    s[v] = true
  end
  return s
end

M.make_set = make_set

return M
