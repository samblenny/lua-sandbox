-- util.lua
-- Convenience functions to save typing for commonly needed operations

local M = {}

-- Print with variadic arguments like printf from C
function M.printf(fmt, ...)
  print(string.format(fmt, ...))
end

-- Works like pairs() but with the keys in sorted order
function M.sorted_pairs(t)
  -- 1. Generate sorted list of table keys
  local keys = {}
  for k in pairs(t) do
    table.insert(keys, k)
  end
  table.sort(keys)

  -- 2. Return closure function to iterate over k,v pairs in sorted order
  local i = 0
  return function()
    i = i + 1
    local k = keys[i]
    if k ~= nil then
      return k, t[k]
    end
  end
end

return M
