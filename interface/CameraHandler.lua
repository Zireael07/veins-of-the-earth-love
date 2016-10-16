require 'T-Engine.class'

local Camera = require 'libraries.camera'

local Map = require 'class.Map'

module("CameraHandler", package.seeall, class.make)

--based on On the Roadside by rm-code

local cam_speed = 5
local scroll_margin = 5
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
        
        --print("[Scroll] X,Y are ", x, y)
        -- Clamp the camera to the map dimensions.
        local w, h = Map:getPixelDimensions()
        --cut off the last 4 tiles' width (roughly equal to 120 px = our hud)
        w = w - 32*4
        -- and 9 tiles height
        h = h - 32*9
        tx = math.max( 0, math.min( x, w ));
        ty = math.max( 0, math.min( y, h ));
        --print("[Scroll] Target is ", tx, ty)
    end

    function self:update( dt )
        if not locked then
            scroll();
        px = lerp( px, tx, dt * cam_speed );
        py = lerp( py, ty, dt * cam_speed );
        --safeguard for crazy values
        if px > tx then px = tx end
        if py > ty then py = ty end
       -- print("[Camera] px, py are", px, py)
        end
         --self:lookAt( math.floor( px ), math.floor( py ));
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

    function self:camlockWindow(x, y, xmin, xmax, ymin, ymax)
        return self:lockWindow(x, y, xmin, xmax, ymin, ymax)
    end

    --viewport
    function self:cameraFollowPlayer(player)
      local x, y = player.x, player.y
      local border_x = 120
      local border_y = 40
      local xmin, xmax = border_x, love.graphics.getWidth() - border_x
      local ymin, ymax = border_y, love.graphics.getHeight() - border_y
      --local smoother = self.cameraSmoother
      self:camlockWindow(x, y, xmin, xmax, ymin, ymax)
    end

    return self;
end

return CameraHandler;
