require 'T-Engine.class'

module("Cell", package.seeall, class.make)

function Cell:init()

    --see what we contain
    self.terrain = nil
    self.actor = nil
    self.object = nil

    --FOV
    self.seen = false
    self.visible = false
end

--terrain/actor/object
function Cell:getTerrain()
    return self.terrain
end

function Cell:setTerrain(val)
    self.terrain = val
end

function Cell:getActor()
    return self.actor
end

function Cell:setActor(val)
    self.actor = val
end

function Cell:getObject()
    return self.object
end

function Cell:setObject(val)
    self.object = val
end

--FOV
function Cell:isVisible()
    return self.visible
end

function Cell:setVisible(val)
    self.visible = val
end    

function Cell:isSeen()
    return self.seen
end

function Cell:setSeen(val)
    self.seen = val
end

return Cell