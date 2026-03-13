print("hello, world")

function love.draw()
  love.graphics.print("Hello World!", 100, 100)
  love.timer.sleep(0.1)  -- 10 fps max
end
