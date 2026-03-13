print("Hello World!")
-- I'm a comment
print("Hello " .. "World! with dots") -- the .. is string concat

--[[ I'm a multiline comment
  that goes until these double brackets -> ]]

-- Literal values
print(nil, 1, 1.2, 3.4, 5, true, false)


if _VERSION == 'Lua 5.4' then
  -- Look for packages in the 5.3 directory too (for inspect.lua)
  package.path = package.path .. ';/usr/share/lua/5.3/?.lua'
  -- print("package.path:", package.path)
end

local inspect = require('inspect')

local myTable = {
  key1 = "value1",
  key2 = "value2",
  key3 = {a = 1, b = 2, c = 3},
}
print(inspect(myTable))

-- This method of dumping tables is not great (inspect is much better):
--[[
for k, v in pairs(myTable) do
  print(string.format("%s: %s", k, v))
end
]]

--[[
$ lua hello-inspect-table.lua
Hello World!
Hello World! with dots
nil	1	1.2	3.4	5	true	false
{
  key1 = "value1",
  key2 = "value2",
  key3 = {
    a = 1,
    b = 2,
    c = 3
  }
}
]]
