require 'T-Engine.class'

require 'class.Map'

require 'class.Actor'

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

return Spawn