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

function PlayerGUI:draw_drawstats()
    love.graphics.setColor(255, 255, 102)
    local stats = love.graphics.getStats()
 
    local str = string.format("Estimated texture memory used: %.2f MB", stats.texturememory / 1024 / 1024)
    love.graphics.print(str, 700, 50)
    local drawcalls = string.format("Drawcalls: %d", stats.drawcalls)
    love.graphics.print(drawcalls, 700, 65)
end

function PlayerGUI:draw_mouse(x,y)
    love.graphics.setColor(255,255,255)
   -- love.graphics.print(mouse.x..", "..mouse.y, mouse.x+10, mouse.y)
    love.graphics.print((tile_x or "N/A")..", "..(tile_y or "N/A"), mouse.x+10, mouse.y+15)
    love.graphics.setColor(255, 255, 102)
    love.graphics.print(player.x..", "..player.y, mouse.x+10, mouse.y)
end

function PlayerGUI:draw_tip(x,y)
    love.graphics.setColor(255, 255, 102)
    if tile_x and tile_y then
      if Map:getCellActor(tile_x, tile_y) then
        a = Map:getCellActor(tile_x, tile_y)
        love.graphics.print(a.name, 120, 500)
      end
    end
end


return PlayerGUI