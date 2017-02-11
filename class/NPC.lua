require 'T-Engine.class'

local Actor = require 'class.Actor'
--AI
local ActorAI = require 'interface.ActorAI'
local Treasure = require 'class.Treasure'

local Map = require 'class.Map'

module("NPC", package.seeall, class.inherit(Actor, ActorAI))

function _M:init(t)
    --init inherited stuff
    Actor.init(self, t)
    ActorAI.init(self)
end

function _M:act()
    ActorAI.act(self)
    if self:reactionToward(player) < 0 and self:canSeePlayer() then
        self:target(player.x, player.y)
    else
        self:randomTarget()
    end
end

function _M:target(x,y)
  dir_x, dir_y = ActorAI:target(x, y, self.x, self.y)
  --print("[NPC] AI moving in dir", dir_x, dir_y)
  self:moveDir(dir_x, dir_y)
end  

function _M:randomTarget()
    x, y = Map:findRandomStandingGrid()
    dir_x, dir_y = ActorAI:target(x, y, self.x, self.y)
    --print("[NPC] AI moving in dir", dir_x, dir_y)
    self:moveDir(dir_x, dir_y)
end  

function _M:on_die(src)
    Actor.on_die(self, src)
    print("[NPC] on die")
    --gen treasure
    self:spawnTreasure(1)
end

function _M:spawnTreasure(lvl)
    print("[TREASURE] Spawn treasure")

    local coinage_to_item = {
        ["cp"] = "copper coins",
        ["sp"] = "silver coins",
        ["gp"] = "gold coins",
        ["pp"] = "platinum coins",
    }
    local coins, goods, items = Treasure:getTreasure(lvl)

    if coins then
        local split = coins:split(' ')
        local coin
        if split[4] then
         coin = split[4] 
         --print("[TREASURE] Coinage is ", coin) 
        end
        --print("ID is ", coinage_to_item[coin])
        Spawn:createItem(self.x, self.y, coinage_to_item[coin])
    end
end

return _M