-- Use coroutine.wrap to make a sorted table iterator

local U = require 'util'; local printf = U.printf

function sorted_pairs(tbl)
  -- 1. Generate list of table keys
  local keys = {}
  for k in pairs(tbl) do
    keys[#keys+1] = k
  end

  -- 2. Sort keys with comparison function that handles mixed key types
  table.sort(keys, function(a,b)
    if type(a) == type(b) then
      return a < b
    else
      return type(a) < type(b)
    end
  end)

  -- 3. Return iterator that traverses the keys in sorted order
  --    NOTE: This may be slower than using a regular closure, but the point
  --          here is to demonstrate coroutine iterators.
  return coroutine.wrap(function ()
    for _,k in ipairs(keys) do
      coroutine.yield(k, tbl[k])
    end
  end)
end

-- Make a mixed table with integer and string keys
local t = {1, 2, 3, 4, once = "upon", a = "midnight", dreary = "while"}

-- Printed table sorted by keys
for k,v in sorted_pairs(t) do
  printf("k='%s', v='%s'", k, v)
end

--[[
$ lua coroutine-wrap-iterator.lua 
k='1', v='1'
k='2', v='2'
k='3', v='3'
k='4', v='4'
k='a', v='midnight'
k='dreary', v='while'
k='once', v='upon'
--]]
