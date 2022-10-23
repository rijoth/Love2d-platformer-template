-- base class for all the actors in the game
Actor = Object:extend()

-- Actor will have unique id passed down from child classes
function Actor:new(x, y, w, h, world)
  self.collider = {
    x = x,
    y = y,
    w = w,
    h = h
  }
  -- init velocity
  self.xvel = 0
  self.yvel = 0
  -- default values change in child classes
  self.acc = 50
  self.maxspeed = 200
  self.friction = 5
  self.gravity = 40
  -- temp movement variables
  self.goal_x, self.goal_y = 0, 0

  -- values specific to jumping
  self.is_jumping = false -- are we in the process of jumping?
  self.is_grounded = false -- are we on the ground?
  self.jump_reachedmax = false -- is this as high as we can go?
  self.jump_acc = 500 -- how fast do we accelerate towards the top
  self.jump_maxspeed = 9.5 -- our speed limit while jumping

  -- world
  self.world = world
  self.colls = 0 -- total collisions

  -- add actor to the world
  self.world:add(self.collider, self.collider.x, self.collider.y, self.collider.w, self.collider.h)
end

function Actor:update_world(fil, dt) -- get filter from child object if any
  local filter = fil or nil

  self.goal_x = self.collider.x + self.xvel
  self.goal_y = self.collider.y + self.yvel
  -- 
  -- actual movement
  self.collider.x, self.collider.y, self.colls = self.world:move(self.collider, self.goal_x, self.goal_y, filter)

  -- apply friction
  self.xvel = self.xvel * (1 - math.min( dt * self.friction, 1))
  self.yvel = self.yvel * (1 - math.min( dt * self.friction, 1))

  -- apply gravity 
  self.yvel = self.yvel + self.gravity * dt

  -- return collisions back
  return self.collider.x, self.collider.y, self.colls
end

-- movement code
function Actor:move(dir, dt)
  -- left and right
  if dir == "left" and self.xvel > -self.maxspeed then
    self.xvel = self.xvel - self.acc * dt
  elseif dir == "right" and self.xvel < self.maxspeed then
    self.xvel = self.xvel + self.acc * dt
  end

  -- jump
  if dir == "up" then
    if -self.yvel < self.jump_maxspeed and not self.jump_reachedmax then
      self.yvel = self.yvel - self.jump_acc * dt
    elseif math.abs(self.yvel) > self.jump_maxspeed then
      self.jump_reachedmax = true
    end
    self.is_grounded = false --actor is not in contact with ground
  end
 end
