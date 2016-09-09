require 'T-Engine.class'

require 'class.Map'

module("Actor", package.seeall, class.make)

function _M:init(t)
    if t then print("We were given a table") end
    t = t or {}
    --default loc for testing
    self.x = 1
    self.y = 1
    self.hitpoints = 0
    self.wounds = t.wounds or 1
    self.display = t.display or "o"
    self.image = t.image or "orc"
    self.name = t.name or "orc"
end

function _M:move(x, y)
  if not x or not y then return end
  
  print("Actor:moving")
  x = math.floor(x)
	y = math.floor(y)
  
  --don't go out of bounds
  if x < 0 then x = 0 end
	if x >= Map:getWidth() then x = Map:getWidth() - 1 end
	if y < 0 then y = 0 end
	if y >= Map:getHeight() then y = Map:getHeight() - 1 end
  
  self.old_x, self.old_y = self.x or x, self.y or y
	self.x, self.y = x, y
  print("Actor: new x,y : ", self.x, self.y)
  --update map
  print("Actor: updating map cell: ", x, y)
  print("Actor:old cell: ", self.old_x, self.old_y) 
  Map:setCellActor(self.old_x, self.old_y, nil)
  Map:setCellActor(x, y, self.image) --display)
  --remove ourselves from old cell if we left it
 --[[ if x ~= self.old_x or y ~= self.old_y then
    Map:setCellActor(self.old_x, self.old_y, nil)
  end]]
  
end

function _M:moveDir(dx, dy)
  if not dx then dx = 0 end
  if not dy then dy = 0 end
  
  local tx = self.x+dx
  local ty = self.y+dy
  print("[Player] Move to", tx, ty)
  if self:canMove(tx, ty) then
    self:move(tx, ty)
  else
    print("[Actor] Failed a move attempt to", tx, ty)
  end
 
end

function _M:canMove(x,y)
  --should call combat
  if Map:getCellActor(x,y) then return false end
  --legit block
  if Map:getCellTerrain(x,y) == "#" then return false end
 -- if x == player.x and y == player.y then return false end
  return true
end

return _M