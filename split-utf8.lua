-- Demonstrate the utf-8 API

print(string.format("Splitting utf-8 with %s", _VERSION))

for index, codepoint in utf8.codes("你好, world") do
  print(string.format("%2d  %s", index, utf8.char(codepoint)))
end

-- This only works with lua5.3 or later:
--[[
$ lua split-utf8.lua 
Splitting utf-8 with Lua 5.3
 1  你
 4  好
 7  ,
 8   
 9  w
10  o
11  r
12  l
13  d
--]]

