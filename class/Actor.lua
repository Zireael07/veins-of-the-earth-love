require 'T-Engine.class'

require 'class.Map'

local Faction = require 'class.Faction'

local ActorInventory = require 'interface.ActorInventory'
local Combat = require 'interface.ActorCombat'
local ActorLife = require 'interface.ActorLife'
local ActorStats = require 'interface.ActorStats'


--AI
local ActorAI = require 'interface.ActorAI'

module("Actor", package.seeall, class.inherit(ActorInventory, Combat, ActorLife, ActorStats))

function _M:init(t)
    if t then print("We were given a table") end
    t = t or {}
    --default loc for testing
    self.x = 1
    self.y = 1
    self.display = t.display --or "o"
    self.image = t.image --or "orc"
    self.name = t.name --or "orc"
    self.path = nil
    self.faction = t.faction or "enemy"
    -- Default melee barehanded damage
    self.combat = { dam = {1,4} }
    --init inherited stuff
    ActorInventory.init(self, t)
    ActorLife.init(self, t)
    ActorStats.init(self, t)
end

function _M:act()
  if not self.player == true then 
    --do AI stuff
    self:target(player)
  end
end

function _M:target(player)
  self.path = ActorAI:target(player, self.x, self.y)
  if self.path then 
      print_to_log("[Actor] We have a self path")
  
      self:moveAlongPath(self.path)
  end
end 

function _M:move(x, y)
  if not x or not y then return end
  
  print_to_log("Actor:moving")
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
  Map:setCellActor(x, y, self) --self.image) 

  --trigger on_stand
  local terrain = Map:getCellTerrain(x,y)
  if terrain.on_stand then
    print("[Actor] on_stand effects triggered")
    terrain.on_stand(terrain, x, y, self)
  end

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
  --if no map at x,y then refuse
  if not Map:getCell(x,y) then return false end
  --should call combat
  if Map:getCellActor(x,y) then 
    local target = Map:getCellActor(x,y)
    self:bumpTarget(target)
    return false 
  end
  --legit block
  if Map:getCellTerrain(x,y).display == "#" then return false end
 -- if x == player.x and y == player.y then return false end
  return true
end

function _M:moveAlongPath(path)
  if not path or not path[2] then return end
  local tx = path[2].x
  local ty = path[2].y
  print("[Actor] Moving along path", tx, ty)
  if self:canMove(tx, ty) then
    self:move(path[2].x, path[2].y)
  end
end

function _M:reactionToward(target)
  return Faction:factionReaction(self.faction, target.faction)
end

function _M:indicateReaction()
  local str
  if self:reactionToward(player) > 50 then str = "helpful"
  elseif self:reactionToward(player) > 0 then str = "friendly"
  elseif self:reactionToward(player) < -50 then str = "hostile"
  elseif self:reactionToward(player) < 0 then str = "unfriendly"
  else str = "neutral" end

  return str
end

function _M:bumpTarget(target)
  self:attackTarget(target)
end

return _M