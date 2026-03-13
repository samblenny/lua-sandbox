-- Number Guessing Game

local lo, hi = 0, 100
local quitKeys = {['quit'] = true, [''] = true}

function promptUntilMatch(n)
  local result = nil
  while true do
    local answer = io.read()
    if answer == nil or quitKeys[answer] then
      break
    end
    local guess = math.tointeger(answer)
    if guess < n then
      io.write(string.format("%d is too low, try again: ", guess))
    elseif guess > n then
      io.write(string.format("%d is too high, try again: ", guess))
    else
      print("You guessed right!")
      break
    end
  end
  return result
end

while true do
  local n = math.random(lo, hi)
  io.write(string.format("Pick a number between %d and %d: ", lo, hi))
  promptUntilMatch(n)
  -- confirm before making another guess
  io.write("Go again? [Y/n]: ")
  local answer = io.read()
  if answer == nil or (answer ~= 'Y' and answer ~= 'y') then
    break
  end
end

--[[
$ lua number-game.lua 
Pick a number between 0 and 100: 50
50 is too low, try again: 75
75 is too low, try again: 87
87 is too high, try again: 81
81 is too low, try again: 84
You guessed right!
Go again? [Y/n]: n
--]]
