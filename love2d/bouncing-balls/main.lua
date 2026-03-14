-- luacheck: globals love
local lg = love.graphics
local unpack = unpack or table.unpack  -- table.unpack not present in Lua 5.1
local circle = lg.circle

local balls = {}
local maxBalls = 99
local ballSpawnPeriod = 1/5  -- unit is seconds
local first,last = 1,1
local epsilon = 1e-5
local gravity = 399
local friction = 0.8
local damping = 0.85
local box = { x1=0, x2=lg.getWidth(), y1=0, y2=lg.getHeight() }
local palette = { fill={0.3,0.9,0.3}, bg={0.6,0.2,0.7}, stroke={0.3,0.3,0.3} }

-- Generate a new ball with randomized initial values
-- This recycles old balls in a ring buffer
local function throwBall()
  local vx = math.random(20, 200)
  if math.random() < 0.5 then
    vx = vx * -1
  end
  local r = math.random(8, 24)
  local x = r/2

  if #balls < maxBalls then
    -- Add the ball to the not-yet-full ring buffer
    last = #balls + 1
    balls[last] = { x=x, y=0, vx=vx, vy=0, r=r }
  else
    -- Recycle the oldest slot of full ring buffer
    last = first
    first = (first % #balls) + 1  -- Lua uses 1-based indexing
    local b = balls[last]
    b.x=x
    b.y=0
    b.vx=vx
    b.vy=0
    b.r=r
  end
end

-- Set Color helper
local function c(color)
  lg.setColor(unpack(color))
end

-- Do physics for 1 ball
local function updateBall(b, dt)
  -- Velocity gets acceleration from gravity
  b.vy = b.vy + gravity * dt

  -- Position gets displacement from velocity
  b.x = b.x + b.vx * dt
  b.y = b.y + b.vy * dt

  -- Adjust position and velocity for bounces
  local r = b.r
  if b.y > box.y2 - r then  -- floor
    b.y = box.y2 - r
    b.vy = -b.vy * damping
    if math.abs(b.vy) < epsilon then  -- clamp low vy to 0
      b.vy = 0
      b.y = box.y2 - r
    end
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
    if math.abs(b.vx) < epsilon then
      b.vx = 0
      b.vy = 0
    end
  end
end

-- Init
function love.load()
  lg.setBackgroundColor(unpack(palette.bg))
  throwBall()
  print("type 'q' to quit")
end

-- Update state
local spawnTimer = 0
function love.update(dt)
  spawnTimer = spawnTimer + dt
  if spawnTimer >= ballSpawnPeriod then
    spawnTimer = spawnTimer - ballSpawnPeriod
    throwBall()
  end
  for _, ball in ipairs(balls) do
    updateBall(ball, dt)
  end
  love.timer.sleep(1/24)  -- cap fps to avoid saturating CPU
end

local function drawBall(b)
  c(palette.fill)
  circle("fill", b.x, b.y, b.r)
  c(palette.stroke)
  circle("line", b.x, b.y, b.r)
end

-- Draw frame
function love.draw()
  lg.setLineWidth(1)
  if first <= last then
    -- Ring buffer has not wrapped yet, so draw it all in one pass
    for i = first,last do
      drawBall(balls[i])
    end
  else
    -- Ring buffer has wrapped, so draw two chunks to get the order right
    for i = first,#balls do
      drawBall(balls[i])
    end
    for i = 1,last do
      drawBall(balls[i])
    end
  end
end

-- Keyboard input
function love.keypressed(key)
  if key == 'q' then  -- press q to quit
    love.event.quit()
  elseif key == 'space' then  -- press space to drop a new ball
    throwBall()
  end
end

