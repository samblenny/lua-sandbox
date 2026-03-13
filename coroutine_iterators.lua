local U = require('util'); local printf = U.printf

-- Return a coroutine closure that acts as an iterator.
-- id: identifying tag to distinguish between iterators
-- count: number of iterations
function new_iterator(id, count)
  printf("Creating new iterator coroutine with id='%s', count=%d", id, count)
  return function(arg)
    for i = 1,count do
      printf("it(%s,%d): i=%d, arg=%s", id, count, i, arg)
      arg = coroutine.yield(arg)
    end
  end
end

-- Create iterator coroutines with different iteration counts
local routines = {
  A = coroutine.create(new_iterator('A', 3)),
  B = coroutine.create(new_iterator('B', 5)),
}

-- Cache frequently used function lookups
local status= coroutine.status
local resume = coroutine.resume

-- Cycle through coroutines until they're all dead
print("Resuming coroutines...")
local j = 1        -- resume counter
local live = true  -- active task tracker
while live do
  live = false
  for k,co in pairs(routines) do
    if status(co) ~= 'dead' then
      live = true
      local ok,val = resume(co, j)
      j = j + 1
      printf("      %s: ok=%s, val=%s", k, ok, val)
    end
  end
end

--[[
$ lua coroutine_iterators.lua 
Creating new iterator coroutine with id='A', count=3
Creating new iterator coroutine with id='B', count=5
Resuming coroutines...
it(A,3): i=1, arg=1
      A: ok=true, val=1
it(B,5): i=1, arg=2
      B: ok=true, val=2
it(A,3): i=2, arg=3
      A: ok=true, val=3
it(B,5): i=2, arg=4
      B: ok=true, val=4
it(A,3): i=3, arg=5
      A: ok=true, val=5
it(B,5): i=3, arg=6
      B: ok=true, val=6
      A: ok=true, val=nil
it(B,5): i=4, arg=8
      B: ok=true, val=8
it(B,5): i=5, arg=9
      B: ok=true, val=9
      B: ok=true, val=nil
--]]
