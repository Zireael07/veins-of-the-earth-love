require 'T-Engine.class'

module("MenuDialog", package.seeall, class.make)

function MenuDialog:draw()
    love.graphics.setColor(255,255,255)
    --background
    love.graphics.draw(loaded_tiles["stone_bg"], 200, 100)

    love.graphics.setColor(255, 255, 102)
    love.graphics.print("MAIN MENU", 210, 120)

    love.graphics.setColor(colors.GOLD)
    love.graphics.line(200, 140, 550, 140)

    if button == "help" then
        love.graphics.setColor(colors.RED)
    else
        love.graphics.setColor(255, 255, 102)
    end
    love.graphics.print("Help", 210, 150)
    if button == "debug" then
     love.graphics.setColor(colors.RED)
    else
        love.graphics.setColor(255, 255, 102)
    end   
    love.graphics.print("Debug menu", 210, 170)
end

function MenuDialog:mouse()
    local button
    if mouse.x > 500 then return end
    if mouse.x > 210 and mouse.x < 250 then
        if mouse.y > 150 then
            button = "help"
        elseif mouse.y > 170 then
            button = "debug"
        end
    end

    return button
end

function MenuDialog:mouse_pressed(x,y,b)
    if mouse.x > 500 or mouse.y < 100 then return end
    if b == 1 then
        if mouse.x > 210 then
            if mouse.y > 150 and mouse.y < 170 then
                setDialog("help_controls")
            end
            if mouse.y > 170 then
                print("Pressed debug menu option")
                --remember to init
                setDialog("test", nil, true)
            end
        end
    end
end

return MenuDialog