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
    if self:reactionToward(player) < 0 then
        self:target(player.x, player.y)
    end
end

function _M:target(x,y)
  dir_x, dir_y = ActorAI:target(x, y, self.x, self.y)
  print("[NPC] AI moving in dir", dir_x, dir_y)
  self:moveDir(dir_x, dir_y)
end  

function _M:on_die(src)
    print("[NPC] on die")
    --gen treasure
    Treasure:getTreasure(1)
end

return _M