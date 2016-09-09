require 'T-Engine.class'

local Actor = require 'class.Actor'

local utils = require 'utils'

module("Player", package.seeall, class.inherit(Actor))

function _M:init(t)
    print("Initializing player")
    self.hitpoints = 20
    self.display = "@"
    self.image = "player_tile"  --"gfx/player/racial_dolls/human_m.png"
    self.wounds = 20
    self.name = "Player"
    self.player = true
    Actor:init(self, t)
end

function _M:PlayerMove(dir_string)
  if not dir_string then print("No direction!") 
  else 
    dir_x, dir_y = utils:dirfromstring(dir_string)
    --print("Direction: ", dir_x, dir_y)
    end
  self:moveDir(dir_x, dir_y)
end

return _M