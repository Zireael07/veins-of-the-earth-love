require 'T-Engine.class'

require 'Map'

module("ActorFOV", package.seeall, class.make)

function ActorFOV:update_draw_visibility_new()
    print("Our x, y are: ", self.x, self.y)
    --[[visibleTiles={}
    -- mark all seen tiles as not currently seen
    for i,v in ipairs(seenTiles) do
        seenTiles['i'] = 0
    end]]
    fov=ROT.FOV.Precise:new(lightPassesCallback,{topology=8})
    results = fov:compute(self.x,self.y,6,isVisibleCallback)
end

-- for FOV calculation
function lightPassesCallback(coords,qx,qy)
    -- required as otherwise moving near the edge crashes
    if Map:getCell(qx, qy) then
        -- actual check
        if Map:getCellTerrain(qx, qy) == "." then
            return true
        end
    end
    return false
end

-- for FOV calculation
function isVisibleCallback(x,y,r,v)
    print("Setting as visible", x, y, r, v)
  --[[ -- first mark as visible
    table.insert(visibleTiles,{x=x,y=y,r=r,last=r,v=v})
    -- also mark in seen tiles as currently seen
    table.insert(seenTiles,{x=x,y=y})]]
end

return ActorFOV