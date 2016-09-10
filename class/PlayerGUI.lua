require 'T-Engine.class'

require 'class.Player'

module("PlayerGUI", package.seeall, class.make)


function PlayerGUI:init(player)

end

function PlayerGUI:loadGUI()
    stone_bg = love.graphics.newImage("gfx/stone_background.png")
end

function PlayerGUI:draw_GUI(player)
    local hp = player.hitpoints
    local wounds = player.wounds

    love.graphics.draw(stone_bg, 0,0, 0, 0.25, 1)
    love.graphics.draw(stone_bg, 0, 320, 0, 0.25, 1)

    love.graphics.print("HP: "..player.hitpoints, 10, 10)
    love.graphics.print("Wounds: "..player.wounds, 10, 25)
end

function PlayerGUI:draw_schedule()
    --if color_r and color_g and color_b then love.graphics.setColor(color_r, color_g, color_b) end
    love.graphics.setColor(128, 255, 0)
    love.graphics.print(schedule_curr, 700, 2) --draw_y)
end

return PlayerGUI