require 'T-Engine.class'

local Camera = require 'libraries.camera'

local Map = require 'class.Map'

module("CameraHandler", package.seeall, class.make)

--based on On the Roadside by rm-code

local cam_speed = 5
local scroll_margin = 30
local scroll_speed = 5

function CameraHandler.new(px, py)
    local self = Camera.new();

    local tx, ty = px, py;
    local savedX, savedY;
    local locked;

    ---
    -- Linear interpolation between a and b.
    -- @param a (number) The current value.
    -- @param b (number) The target value.
    -- @param t (number) The time value.
    -- @return  (number) The interpolated value.
    --
    local function lerp(a, b, t)
        return a + ( b - a ) * t;
    end

    local function scroll()
        local mx, my = love.mouse.getPosition();
        local x, y = tx, ty;

        if mx < scroll_margin then
            x = x - scroll_speed;
        elseif mx > love.graphics.getWidth() - scroll_margin then
            x = x + scroll_speed;
        end

        if my < scroll_margin then
            y = y - scroll_speed;
        elseif my > love.graphics.getHeight() - scroll_margin then
            y = y + scroll_speed;
        end

        -- Clamp the camera to the map dimensions.
        local w, h = Map:getPixelDimensions()
        tx = math.max( 0, math.min( x, w ));
        ty = math.max( 0, math.min( y, h ));
    end

    function self:update( dt )
        if not locked then
            scroll();
        end
        px = lerp( px, tx, dt * cam_speed );
        py = lerp( py, ty, dt * cam_speed );
        self:lookAt( math.floor( px ), math.floor( py ));
    end

    function self:setTargetPosition( dx, dy )
        tx, ty = dx, dy;
    end

    function self:getMousePosition()
        return self:mousepos();
    end

    function self:storePosition()
        savedX, savedY = tx, ty;
    end

    function self:restorePosition()
        if savedX and savedY then
            tx, ty = savedX, savedY;
            savedX, savedY = nil, nil;
        end
    end

    function self:lock()
        locked = true;
    end

    function self:unlock()
        locked = false;
    end

    return self;
end

return CameraHandler;
