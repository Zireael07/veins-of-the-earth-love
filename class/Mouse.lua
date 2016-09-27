require 'T-Engine.class'

module("Mouse", package.seeall, class.make)

local camera;

function Mouse:init( ncamera )
    camera = ncamera;
end

function Mouse:getWorldPosition()
    return camera:worldCoords( love.mouse.getPosition() );
end

function Mouse:getGridPosition()
    --120 is the offset at which we start drawing map
    if mouse.x < 120 then return end

    local mx, my = camera:mousePosition()

    local x, y = math.floor((mx-120)/32), math.floor(my/32)

    if x < 0 then return end
    if y < 0 then return end

    return x, y
end

return Mouse