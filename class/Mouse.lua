require 'T-Engine.class'

module("Mouse", package.seeall, class.make)

local camera;

function Mouse:init( ncamera, tile_size)
    camera = ncamera;
    tile_s = tile_size
end

function Mouse:getWorldPosition()
    return camera:toWorld(love.mouse.getPosition())
end

function Mouse:getGridPosition()
    local mx, my = Mouse:getWorldPosition()

    local x, y = math.floor(mx/tile_s), math.floor(my/tile_s)

    if x < 1 then return end
    if y < 1 then return end

    return x, y
end

return Mouse