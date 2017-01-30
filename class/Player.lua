require 'T-Engine.class'

local Actor = require 'class.Actor'
local ActorInventory = require 'interface.ActorInventory'
local ActorFOV = require 'interface.ActorFOV'
local PlayerRest = require 'interface.PlayerRest'
local utils = require 'utils'

module("Player", package.seeall, class.inherit(Actor, ActorFOV, PlayerRest))

function _M:init(t)
    print("Initializing player")
    self.player = true
    self.body = t.body or {}
    --init inherited stuff
    Actor.init(self, t)
    self.max_hitpoints = 20
    self.hitpoints = 20
    self.player_skillpoints = 20
    self.display = "@"
    self.image = "player_tile"
    self.wounds = 20
    self.name = "Player"
    self.gender = nil
    self.race = "Human"
    --do it again to account for increased hp above
    if self.body_parts then
      self:setBodyPartsHP()
    end
end

function _M:actPlayer()
  --print("[Player] act")
  
  --check for resting
  if self:restStep() then
    --print("Player: Rest step")
    endTurn()
  else
    game_lock()
  end
end

function _M:PlayerMove(dir_string)
  if not dir_string then print("No direction!") 
  else 
    dir_x, dir_y = utils:dirfromstring(dir_string)
    --print("Direction: ", dir_x, dir_y)
    end
  self:moveDir(dir_x, dir_y)
  --update FOV
  self:update_draw_visibility_new()
  --finish turn
  endTurn()
end

function _M:movetoMouse(x,y, self_x, self_y)
  --handle clicking outside of map
  if not x then return end
  if not y then return end
  
  if x == self_x and y == self_y then print("Error: trying to move to own position") return end
  path = Pathfinding:findPath(x, y, self_x, self_y)

  print("Moving to mouse", x,y)
  self:moveAlongPath(path)
  --update FOV
  self:update_draw_visibility_new()
  --finish turn
  endTurn()
end

function _M:playerPickup()
  print("Player: pickup")
    if Map:getCell(self.x,self.y):getNbObjects() > 1 then
      --should draw pickup list
      --for now pick all at once
      for i, o in pairs(Map:getCell(self.x,self.y):getObjects()) do
        self:pickupFloor(i)
      end
    else
    self:pickupFloor(1)
    end
end

function _M:doDrop(inven, item)
  --bugfix
  item = tonumber(item)
  self:dropFloor(inven, item)
end

function _M:spotHostiles()
  print("Player: checking for hostiles")
  local seen = false

  for y=1, Map:getWidth()-1 do
      for x=1, Map:getHeight()-1 do 
        if utils:distance(self.x, self.y, x, y) < 8 then
          if Map:getCellActor(x,y) then 
            local a = Map:getCellActor(x,y)
            if a and self:reactionToward(a) < -50 and Map:isTileVisible(x,y) then
              seen = true
              print("[Player] Spotted hostiles")
            end
          end
        end
      end
  end

  return seen
end

function _M:playerRest()
  self:restInit()
end

function _M:on_die(src)
  --call Actor's on_die
  Actor.on_die(self, src)
  --lock game
  game_lock()
  --display dialog
  setDialog("death_dialog")
end

return _M