require 'T-Engine.class'

module("Cell", package.seeall, class.make)

SideType = { Empty=1, Wall=2, Door=3 }

function Cell:init()
    --side detection
    self.eastSide = SideType.Wall
    self.northSide = SideType.Wall
    self.southSide = SideType.Wall
    self.westSide = SideType.Wall
    self.visited = false
    self.isCorridor = false

    --see what we contain
    self.terrain = nil
    self.actor = nil
    self.object = nil

    --FOV
    self.seen = false
    self.visible = false
end

function Cell:CalculateDeadEndCorridorDirection()
    if (not self:getIsDeadEnd()) then print('ERROR: InvalidOperationException (Cell:CalculateDeadEndCorridorDirection): not getIsDeadEnd()') end

    if (self.northSide == SideType.Empty) then return DirectionType.North end
    if (self.southSide == SideType.Empty) then return DirectionType.South end
    if (self.westSide == SideType.Empty) then return DirectionType.West end
    if (self.eastSide == SideType.Empty) then return DirectionType.East end

    print('ERROR: InvalidOperationException (Cell:CalculateDeadEndCorridorDirection)')
end

------------------------------------------------------
-- helper functions
------------------------------------------------------
function Cell:getVisited()
    return self.visited
end
function Cell:setVisited( visited )
    self.visited = visited
end

function Cell:getNorthSide()
    return self.northSide
end
function Cell:setNorthSide( northSide )
    self.northSide = northSide
end

function Cell:getSouthSide()
    return self.southSide
end
function Cell:setSouthSide( southSide )
    self.southSide = southSide
end

function Cell:getEastSide()
    return self.eastSide
end
function Cell:setEastSide( eastSide )
    self.eastSide = eastSide
end

function Cell:getWestSide()
    return self.westSide
end
function Cell:setWestSide( westSide )
    self.westSide = westSide
end

function Cell:getIsDeadEnd()
--  print("Wallcount=", self:getWallCount() )
    return self:getWallCount() == 3
end

function Cell:getIsCorridor()
    return self.isCorridor
end
function Cell:setIsCorridor( isCorridor )
    self.isCorridor = isCorridor
end

function Cell:getWallCount()
    local wallCount = 0
    if (self.northSide == SideType.Wall) then wallCount=wallCount+1 end
    if (self.southSide == SideType.Wall) then wallCount=wallCount+1 end
    if (self.westSide == SideType.Wall) then wallCount=wallCount+1 end
    if (self.eastSide == SideType.Wall) then wallCount=wallCount+1 end
    return wallCount
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