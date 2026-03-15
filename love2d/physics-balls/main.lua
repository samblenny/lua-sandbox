-- luacheck: globals love
local lg = love.graphics
local lp = love.physics
local unpack = unpack or table.unpack  -- table.unpack not present in Lua 5.1
local circle = lg.circle

local balls = {}
local maxBalls = 60
local ballSpawnPeriod = 1/6  -- unit is seconds
local first,last = 1,1
local gravity = 299
local friction = 0.4
local damping = 0.9

local width = lg.getWidth()
local height = lg.getHeight()
local world = lp.newWorld(0, gravity, true) -- gravity=(0,500), sleep allowed
-- luacheck: ignore statics
-- The static bodies will get incorporated into the physics world, but
-- luacheck can't see how love.physics uses them.
local statics = {top={}, left={}, bottom={}, right={}}

local palette = { fill={0.3,0.9,0.3}, bg={0.6,0.2,0.7}, stroke={0.3,0.3,0.3} }

-- Generate a new ball with randomized initial values
-- This recycles old balls in a ring buffer
local function throwBall()
  local vx = math.random(20, 300)
  if math.random() < 0.5 then
    vx = vx * -1
  end
  local r = math.random(8, 17)
  local x = r/2

  if #balls < maxBalls then
    -- Add the ball to the not-yet-full ring buffer
    local body = lp.newBody(world, x, 0, 'dynamic')
    local shape = lp.newCircleShape(r)
    local fixture = lp.newFixture(body, shape, 1)
    fixture:setRestitution(damping)
    fixture:setFriction(friction)
    body:setLinearVelocity(vx, 0)

    last = #balls + 1
    balls[last] = {body=body, shape=shape, fixture=fixture}
  else
    -- Recycle the oldest slot of full ring buffer
    last = first
    first = (first % #balls) + 1  -- Lua uses 1-based indexing
    local b = balls[last]

    b.body:setPosition(x, 0)
    b.body:setLinearVelocity(vx, 0)
    -- reuse the old radius to avoid having to recreate the fixture
  end
end

-- Set Color helper
local function c(color)
  lg.setColor(unpack(color))
end

-- Return a love.physics static rectangle body
local function staticRect(x, y, wide, high)
  local body = lp.newBody(world, x, y, 'static')
  local shape = lp.newRectangleShape(wide, high)
  local fixture = lp.newFixture(body, shape)
  return {body=body, shape=shape, fixture=fixture}
end

-- Init
function love.load()
  statics.top = staticRect(width/2, -5, width+20, 10)
  statics.left = staticRect(-5, height/2, 10, height+20)
  statics.bottom = staticRect(width/2, height+5, width+20, 10)
  statics.right = staticRect(width+5, height/2, 10, height+20)
  throwBall()
  lg.setBackgroundColor(unpack(palette.bg))
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
  -- This runs at a slow framerate, so split physics update into
  -- smaller time steps to avoid tunneling during collisions
  local steps = 6
  for _ = 1,steps do
    world:update(dt/steps)
  end
  -- clamp small velocities
  for _,b in ipairs(balls) do
    local vx,vy = b.body:getLinearVelocity()
    local epsilon = 1
    if math.abs(vx) < epsilon then vx = 0 end
    if math.abs(vy) < epsilon then vy = 0 end
    b.body:setLinearVelocity(vx, vy)
  end
  love.timer.sleep(1/24)  -- cap fps to avoid saturating CPU
end

local function drawBall(b)
  c(palette.fill)
  circle("fill", b.body:getX(), b.body:getY(), b.shape:getRadius())
  c(palette.stroke)
  circle("line", b.body:getX(), b.body:getY(), b.shape:getRadius())
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

