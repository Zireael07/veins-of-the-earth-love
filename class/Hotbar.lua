require 'T-Engine.class'

module("Hotbar", package.seeall, class.make)

function Hotbar:draw()
    --reset color
    love.graphics.setColor(255, 255, 255)

    local h = love.graphics.getHeight()
    local y = h - 70
    local spacing = 5

    --bar background
    love.graphics.draw(loaded_tiles["stone_bg"], 120, y, 0, 1, 1)

    --icons
    local width, height = loaded_tiles["hotbar_attack"]:getDimensions()
    love.graphics.draw(loaded_tiles["hotbar_attack"], 120+spacing, y+spacing, 0, 48/width, 48/height)
    love.graphics.draw(loaded_tiles["hotbar_skills"], 184+spacing, y+spacing, 0, 48/width, 48/height)
    --border around menu buttons
    love.graphics.setColor(colors.SANDY_BROWN)
    love.graphics.rectangle('line', 120+spacing, y+spacing, 48, 48)
    love.graphics.rectangle('line', 184+spacing, y+spacing, 48, 48)
    if button then
        love.graphics.setBlendMode( 'add' );
        love.graphics.setColor(colors.BLUE)
        
        if button == "attack" then
            love.graphics.rectangle('fill', 120+spacing, y+spacing, 48, 48);
        elseif button == "skills" then
            love.graphics.rectangle('fill', 184+spacing, y+spacing, 48, 48);
        end
        love.graphics.setColor( 255, 255, 255);
        love.graphics.setBlendMode( 'alpha' );
    end
end

function Hotbar:mouse()
    button = Hotbar:mousetoButton()
end

function Hotbar:mousetoButton()
    if mouse.x < 120 or mouse.y < (love.graphics.getHeight() - 70) then return end

    local button
    if mouse.x > 125 and mouse.x < 125+48 then
        button = "attack"
    end
    if mouse.x > 189 and mouse.x < 189+48 then
        button = "skills"
    end
   -- print("[HOTBAR] button is ", button)
    return button
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