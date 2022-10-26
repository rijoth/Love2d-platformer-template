Player = Actor:extend()

-- controller config
Player.input = Baton.new {
  controls = {
    left = {'key:left', 'key:a', 'axis:leftx-', 'button:dpleft'},
    right = {'key:right', 'key:d', 'axis:leftx+', 'button:dpright'},
    up = {'key:up', 'key:w', 'axis:lefty-', 'button:dpup'},
    down = {'key:down', 'key:s', 'axis:lefty+', 'button:dpdown'},
    action = {'key:x', 'button:a'},
  },
  pairs = {
    move = {'left', 'right', 'up', 'down'}
  },
  joystick = love.joystick.getJoysticks()[1],
}

function Player:new(world)
  self.id = "player"
  self.x = 10
  self.y = 160
  self.w = 16
  self.h = 16
  self.colls = 0
  self.speed = 100
  self.world = world
  self.super:new(self.x, self.y, self.w, self.h, self.world)
  -- modify some base class params
  self.friction = 10
  self.acc = 50
  self.maxspeed = 100
  -- jump related
  self.jump_acc = 600
end

function Player:update(dt)
  -- update input (baton)
  self.input:update()
  -- collision filter passed to update world
  local filter = function (item, other)
    -- implment pass through bottom platform if platform has id 'jumpthru'
    if not (other.id == "jumpthru" and item.y + item.h > other.y) then return "slide" end
  end
  -- update x, y  inherited from actor base class
  self.x, self.y, self.colls = self:update_world(filter, dt)

  -- inherit movement from actor class move() function (using baton input())
  if self.input:down('left') then
    self:move("left", dt)
  elseif self.input:down("right") then
    self:move("right", dt)
  end
  if self.input:down("action") and self.is_grounded then
    self:move("up", dt)
  end

  -- treat collisions
  for _, coll  in ipairs(self.colls) do
    if coll.touch.y > self.goal_y then
      self.jump_reachedmax = true
      self.is_grounded = false
    elseif coll.normal.y < 0 then
      self.jump_reachedmax = false
      self.is_grounded = true
    end
  end
end

function Player:draw()
  love.graphics.rectangle("fill", self.x, self.y, 16, 16)
end
