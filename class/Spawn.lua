require 'T-Engine.class'

require 'class.Map'

require 'class.Actor'
require 'class.Object'

local Entity = require 'class.Entity'

module("Spawn", package.seeall, class.make)

function Spawn:createActor(x,y)
    if not x or not y then print("No location parameters") return end
    if x > Map:getHeight()-1 then print("X out of bounds") end
    if y > Map:getWidth()-1 then print("Y out of bounds") end

    actor = Actor.new()
    actor:move(x,y)

    --return actor
    return Entity:addEntity(actor)
end

function Spawn:createItem(x,y)
    if not x or not y then print("No location parameters") return end
    if x > Map:getHeight()-1 then print("X out of bounds") end
    if y > Map:getWidth()-1 then print("Y out of bounds") end

    object = Object.new()

    print("[Spawn] Created item at ",x,y)
    object:place(x,y)

    return object
end

--NOTE: this one doesn't return, it's just called plainly
function Spawn:createPlayer(x,y)
    if not x or not y then print("No location parameters") return end
    if x > Map:getHeight()-1 then print("X out of bounds") end
    if y > Map:getWidth()-1 then print("Y out of bounds") end

    player_temp = Player.new(
      {
    body = { MAIN_HAND=1, OFF_HAND=1, SHOULDER=1, BODY=1, CLOAK=1, BELT=1, QUIVER=1, GLOVES=1, LEGS=1, ARMS=1, BOOTS=1, HELM=1, RING=2, AMULET=1, LITE=1, TOOL=1, INVEN=30 }
  })
--    Entity:addEntity(player_temp)
    player_temp:move(player_x, player_y)

    --fix player visibility on turn 1
    --player:PlayerMove("left")

    print("[Spawn] Created player at ", x,y)
    return Entity:addEntity(player_temp)
end

return Spawn