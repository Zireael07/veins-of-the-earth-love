require 'T-Engine.class'

local Actor = require 'class.Actor'
--AI
local ActorAI = require 'interface.ActorAI'
local Treasure = require 'class.Treasure'

module("NPC", package.seeall, class.inherit(Actor))

function _M:init(t)
    --init inherited stuff
    Actor.init(self, t)
end

function _M:act()
    self:target(player)
end

function _M:target(player)
  dir_x, dir_y = ActorAI:target(player, self.x, self.y)
  print("[NPC] AI moving in dir", dir_x, dir_y)
  self:moveDir(dir_x, dir_y)
end 

function _M:on_die(src)
    print("[NPC] on die")
    --gen treasure
    Treasure:getTreasure(1)
end

return _M