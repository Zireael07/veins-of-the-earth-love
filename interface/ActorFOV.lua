require 'T-Engine.class'

require 'Map'

module("ActorFOV", package.seeall, class.make)

function ActorFOV:resetVisibleTiles()
    for y=0, Map:getWidth()-1 do
      for x=0, Map:getHeight()-1 do
        Map:setTileVisible(x,y, false)
      end
    end
end

function ActorFOV:update_draw_visibility_new()
    print("Our x, y are: ", self.x, self.y)

    --reset visible tiles
    self:resetVisibleTiles()
    -- mark all seen tiles as not currently seen
    
    fov=ROT.FOV.Precise:new(lightPassesCallback,{topology=8})
    results = fov:compute(self.x,self.y,6,isVisibleCallback)
end

-- for FOV calculation
function lightPassesCallback(coords,qx,qy)
    -- required as otherwise moving near the edge crashes
    if Map:getCell(qx, qy) then
        -- actual check
        if Map:getCellTerrain(qx, qy).display == "." then
            return true
        end
    end
    return false
end

-- for FOV calculation
function isVisibleCallback(x,y,r,v)
    --print("Setting as visible", x, y, r, v)
    -- first mark as visible
    Map:setTileVisible(x,y, true)
    -- also mark  as currently seen
    Map:setTileSeen(x,y, true)
end

return ActorFOV