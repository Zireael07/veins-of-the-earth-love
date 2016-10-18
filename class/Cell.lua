require 'T-Engine.class'

module("Cell", package.seeall, class.make)

function Cell:init()

    --see what we contain
    self.terrain = nil
    self.actor = nil
    self.object = {}

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

function Cell:getObjects()
    if #self.object > 0 then return self.object
    else return false end
end

function Cell:getNbObjects()
    if #self.object > 0 then
        local i = 0
        --print("[Cell] we have a self.object table")
        for k,v in pairs(self.object) do
            i = i + 1
        end
        --print("[Cell] Number of objects is", i)
        return i
    else 
        return 0 end
end

function Cell:getObject(i)
    return self.object[i]
end

function Cell:setObject(val, i)
    if not i then i = 1 end
    self.object[i] = val
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