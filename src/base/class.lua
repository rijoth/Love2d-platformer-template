--[[
  simple class implementation in lua
--]]

local Class = {}
Class.__index = Class

-- default implementation
function Class:new() end

-- create a class type from base class
function Class:derive(type)
  local cls = {}
  cls["__call"] = Class.__call
  cls.type = type
  cls.__index = cls
  cls.super = self
  setmetatable(cls, self)
  return cls
end

-- create a class instance
function Class:__call(...)
  local inst = setmetatable({}, self)
  inst:new(...)
  return inst
end

function Class:get_type()
  return self.type
end

return Class
