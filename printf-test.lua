local U = require 'util'
local printf, sorted_pairs = U.printf, U.sorted_pairs

local t = {
  ['room temp'] = {22, '°C'},
  pi = {3.14, nil},
  e = {2.718, nil},
}

for k, v in sorted_pairs(t) do
  if v[2] then
    printf('%9s = %s %s', k, v[1], v[2])
  else
    printf('%9s = %s', k, v[1])
  end
end

--[[
$ lua printf-test.lua
        e = 2.718
       pi = 3.14
room temp = 22 °C
--]]
