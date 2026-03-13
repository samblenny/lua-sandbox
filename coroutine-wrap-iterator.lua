-- Use coroutine.wrap to make a sorted table iterator

local U = require 'util'; local printf = U.printf
local I = require 'inspect'

function sorted_pairs(tbl)
  -- 1. Generate sorted list of table keys using a sort comparison function
  --    that allows mixed key types
  keys = {}
  for k,v in pairs(tbl) do
    table.insert(keys, k)
  end
  table.sort(keys, function(a,b)
    if type(a) == type(b) then
      return a < b
    else
      return type(a) < type(b)
    end
  end)
  -- 2. Return iterator that traverses the keys in sorted order
  return coroutine.wrap(function ()
    for _,k in pairs(keys) do
      coroutine.yield(k, tbl[k])
    end
  end)
end

-- Make a mixed table with integer and string keys
local t = {1, 2, 3, 4, once = "upon", a = "midnight", dreary = "while"}

-- Printed it sorted by keys
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
