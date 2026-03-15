function love.conf(t)
  t.window.width = 480
  t.window.height = 320
  t.window.title = "Physics Balls"
  t.window.resizeable = false
  t.window.vsync = true  -- sync draws to vertical refresh
  t.window.msaa = 0      -- anti-aliasing (0, 2, 4, 8)
end
