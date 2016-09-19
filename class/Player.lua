require 'T-Engine.class'

local Actor = require 'class.Actor'
local ActorInventory = require 'interface.ActorInventory'
local ActorFOV = require 'interface.ActorFOV'
local utils = require 'utils'

module("Player", package.seeall, class.inherit(Actor, ActorFOV))

function _M:init(t)
    print("Initializing player")
    self.hitpoints = 20
    self.display = "@"
    self.image = "player_tile"  --"gfx/player/racial_dolls/human_m.png"
    self.wounds = 20
    self.name = "Player"
    self.player = true
    self.body = t.body or {}
    --init inherited stuff
    Actor:init(self, t) 
    --[[ActorInventory.init(self, t)
    --debug
    if self.body then 
      print("We have a body")
      for k, v in pairs(self.body) do
        print(k, v)
      end
    end]]
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
  self:pickupFloor()
end

return _M