require 'T-Engine.class'

local UI = require "UIElements"

module("TestDialog", package.seeall, class.make)


function TestDialog:load()
    UI:init_text_button(210, 120, 60, "dummy", "Dummy button", function() print("Clicked dummy!") end)
    UI:init_text_button(210, 140, 20, "blah", "Blah", function() setDialog("help_controls") end)
    UI:init_image_button(210, 160, "val", "ui_left_arrow", "minus", function() print("Value change is "..(UI:getParameters(3) or " nil")) end)
end

function TestDialog:draw()
    love.graphics.setColor(255,255,255)
    --background
    love.graphics.draw(loaded_tiles["stone_bg"], 200, 100)

    UI:draw(id)
end

function TestDialog:mouse()
    id = UI:mouse()
end

function TestDialog:mouse_pressed(x,y,b)
    UI:mouse_pressed(x,y,b)
end

return TestDialog