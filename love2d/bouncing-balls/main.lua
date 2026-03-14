local lg = love.graphics
local unpack = unpack or table.unpack  -- table.unpack not present in Lua 5.1

local balls = {}
local gravity = 199
local friction = 0.8
local damping = 0.85
local box = { x1=0, x2=lg.getWidth(), y1=0, y2=lg.getHeight() }
local palette = { fill={0.3,0.9,0.3}, bg={0.6,0.2,0.7}, stroke={0.3,0.3,0.3} }

-- Generate a new ball with randomized initial values
function newBall()
  local vx = math.random(20, 200)
  if math.random() < 0.5 then
    vx = vx * -1
  end
  local r = math.random(8, 24)
  local x = r/2
  return { x=x, y=0, vx=vx, vy=0, r=r }
end

-- Set Color helper
function c(color)
  lg.setColor(unpack(color))
end

-- Init
function love.load()
  lg.setBackgroundColor(unpack(palette.bg))
  balls[#balls+1] = newBall()
  print("type 'q' to quit")
end

-- Update state
function love.update(dt)
  for _, ball in ipairs(balls) do
    updateBall(ball, dt)
  end
  love.timer.sleep(1/24)  -- cap fps to avoid saturating CPU
end

-- Draw frame
function love.draw()
  local fill,stroke = palette.fill, palette.stroke
  local circle = lg.circle
  lg.setLineWidth(1)
  for _, ball in ipairs(balls) do
    c(fill)
    circle("fill", ball.x, ball.y, ball.r)
    c(stroke)
    circle("line", ball.x, ball.y, ball.r)
  end
end

-- Keyboard input
function love.keypressed(key)
  if key == 'q' then  -- press q to quit
    love.event.quit()
  elseif key == 'space' then  -- press space to drop a new ball
    balls[#balls+1] = newBall()
  end
end

-- Do physics for 1 ball
function updateBall(b, dt)
  -- Velocity gets acceleration from gravity
  b.vy = b.vy + gravity * dt

  -- Position gets displacement from velocity
  b.x = b.x + b.vx * dt
  b.y = b.y + b.vy * dt

  -- Adjust position and velocity for bounces
  local epsilon = 1e-5
  local r = b.r
  if b.y > box.y2 - r then  -- floor
    b.y = box.y2 - r
    b.vy = -b.vy * damping
    if math.abs(b.vy) < epsilon then  -- clamp low vy to 0
      b.vy = 0
      b.y = box.y2 - r
    end
  else
  end
  if b.y < box.y1 + r then  -- ceiling
    b.y = r
    b.vy = -b.vy * damping
  end
  if b.x > box.x2 - r then  -- left wall
    b.x = box.x2 - r
    b.vx = -b.vx * damping
  end
  if b.x < box.x1 + r then  -- right wall
    b.x = r
    b.vx = -b.vx * damping
  end

  -- Rolling friction when touching floor
  if math.abs((box.y2 - r) - b.y) < epsilon and b.vy < epsilon then
    b.vx = b.vx * friction
    if math.abs(b.vx) < epsilon then b.vx = 0 end
  end
end

