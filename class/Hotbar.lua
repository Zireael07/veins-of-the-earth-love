require 'T-Engine.class'

module("Hotbar", package.seeall, class.make)

elements = {}

function Hotbar:load()
    print("Load hotbar image")
    local h = love.graphics.getHeight()
    local y = h - 70
    local spacing = 5

    Hotbar:init_hotbar_button(120+spacing, y+spacing, "attack", "hotbar_attack", {}, function() 
        --for the targeting display
        setMouseMode(button)
        print("[HOTBAR] pressed", button) end)
    Hotbar:init_hotbar_button(184+spacing, y+spacing, "skills", "hotbar_skills", {}, function()
        --for the targeting display
        setMouseMode(button)
        print("[HOTBAR] pressed", button) end)
end

function Hotbar:init_hotbar_button(x,y,id, image, on_press)
    if not x or not y or not image then print("[Hotbar button] Missing parameters!") end
    elements[#elements+1] = {x=x, y=y, id=id, image=image, on_press=on_press}
end

function Hotbar:draw_buttons(id)
    for i,e in ipairs(elements) do
        love.graphics.setColor( 255, 255, 255);
        local width, height = loaded_tiles[e.image]:getDimensions()
        love.graphics.draw(loaded_tiles[e.image], e.x, e.y, 0, 48/width, 48/height)
        --border around menu buttons
        love.graphics.setColor(colors.SANDY_BROWN)
        love.graphics.rectangle('line', e.x, e.y, 48, 48)
        love.graphics.setColor( 255, 255, 255);
        if id then
            love.graphics.setBlendMode( 'add' );
            love.graphics.setColor(colors.BLUE)
            if id == e.id then
                love.graphics.rectangle('fill', e.x, e.y, 48, 48)
            end
            love.graphics.setColor( 255, 255, 255);
            love.graphics.setBlendMode( 'alpha' );
        end
    end
end

function Hotbar:mouse_buttons()
    for i,e in ipairs(elements) do
        local width = 48
        if mouse.x > e.x and mouse.x < e.x + width then
            --if mouse.y > e.y and mouse.y < e.y + height then
                if e.id then
                    id = e.id
                end
                --print("We're over element "..id)
            --end
        end
    end
    return id
end

function Hotbar:draw()
    --reset color
    love.graphics.setColor(255, 255, 255)

    local h = love.graphics.getHeight()
    local y = h - 70
    local spacing = 5

    --bar background
    love.graphics.draw(loaded_tiles["stone_bg"], 120, y, 0, 1, 1)

    --buttons
    Hotbar:draw_buttons(button)
end

function Hotbar:mouse()
    if mouse.x < 120 or mouse.y < (love.graphics.getHeight() - 70) then return end
    button = Hotbar:mouse_buttons()
end

function Hotbar:mouse_pressed(x,y,b)
    local pressed
    if b == 1 then
        if button then
            pressed = button 
            --for the targeting display
            setMouseMode(button)
            print("[HOTBAR] pressed", button)
        end    
    end
end

return Hotbar