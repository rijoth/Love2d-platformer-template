Object = require('lib.classic')
local bump = require('lib.bump')

require('src.base.actor')
require('src.player')

local player
local world
local ground1 = { id = "ground", x = 0, y = 160, w = 320, h = 16 }
local ground2 = { id = "jumpthru", x = 100, y = 120, w = 100, h = 16 }
function love.load()
  -- setup bump
  world = bump.newWorld(16)

  -- player
  player = Player(world)

  -- test ground
  world:add(ground1, ground1.x, ground1.y, ground1.w, ground1.h)
  world:add(ground2, ground2.x, ground2.y, ground2.w, ground2.h)
end

function love.update(dt)
  player:update(dt)
end

function love.draw()
  -- draw player
  player:draw()

  -- draw ground (testing)
  love.graphics.rectangle("fill", ground1.x, ground1.y, ground1.w, ground1.h)
  love.graphics.rectangle("fill", ground2.x, ground2.y, ground2.w, ground2.h)
end
