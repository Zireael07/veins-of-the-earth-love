require 'T-Engine.class'

require 'class.Player'

--dialogs
local InventoryDialog = require 'dialogs.InventoryDialog'

module("PlayerGUI", package.seeall, class.make)

local camera

function PlayerGUI:init(player, ncamera)
    camera = ncamera
end

function PlayerGUI:loadGUI()
    stone_bg = love.graphics.newImage("gfx/stone_background.png")

    InventoryDialog:loadTiles()

    love.graphics.setFont(goldbox_font)
end

function PlayerGUI:draw_GUI(player)
    local hp = player.hitpoints
    local wounds = player.wounds

    love.graphics.draw(stone_bg, 0,0, 0, 0.25, 1)
    love.graphics.draw(stone_bg, 0, 320, 0, 0.25, 1)

    love.graphics.setFont(goldbox_large_font)

    love.graphics.setColor(255, 51, 51)
    love.graphics.print("HP: "..player.hitpoints, 10, 10)
    love.graphics.print("Wounds: "..player.wounds, 10, 25)

    --draw stats
    love.graphics.setColor(255, 255, 102)
    love.graphics.print("STR: "..player.stats["STR"].current, 10, 45)
    love.graphics.print("DEX: "..player.stats["DEX"].current, 10, 60)
    love.graphics.print("CON: "..player:getStat("CON"), 10, 75)
    love.graphics.print("INT: "..player:getStat("INT"), 10, 90)
    love.graphics.print("WIS: "..player:getStat("WIS"), 10, 105)
    love.graphics.print("CHA: "..player:getStat("CHA"), 10, 120)
    love.graphics.print("LUC: "..player:getStat("LUC"), 10, 135)
end

function PlayerGUI:draw_schedule()
    love.graphics.setFont(sherwood_font)
    --if color_r and color_g and color_b then love.graphics.setColor(color_r, color_g, color_b) end
    love.graphics.setColor(128, 255, 0)
    love.graphics.print(schedule_curr, 680, 2) --draw_y)
end

function PlayerGUI:draw_drawstats()
    love.graphics.setFont(sherwood_font)
    love.graphics.setColor(255, 255, 102)
    local stats = love.graphics.getStats()
 
    local str = string.format("Estimated texture memory used: %.2f MB", stats.texturememory / 1024 / 1024)
    love.graphics.print(str, 700, 50)
    local drawcalls = string.format("Drawcalls: %d", stats.drawcalls)
    love.graphics.print(drawcalls, 700, 65)
end

function PlayerGUI:draw_mouse(x,y)
    love.graphics.setFont(sherwood_font)
    love.graphics.setColor(255,255,255)
    --love.graphics.print(mouse.x..", "..mouse.y, mouse.x + 10, mouse.y)
    love.graphics.print((tile_x or "N/A")..", "..(tile_y or "N/A"), mouse.x+10, mouse.y)
    love.graphics.setColor(255, 255, 102)
    love.graphics.print(player.x..", "..player.y, mouse.x+10, mouse.y+15)
end

function PlayerGUI:draw_tip(x,y)
    love.graphics.setFont(sherwood_font)
    love.graphics.setColor(255, 255, 102)
    if tile_x and tile_y then
      if Map:getCellActor(tile_x, tile_y) then
        a = Map:getCellActor(tile_x, tile_y)
        love.graphics.print(a.name, mouse.x+10, mouse.y+30)
        love.graphics.print(a.hitpoints or "N/A", mouse.x+100, mouse.y+30)
      end
      if Map:getCellObject(tile_x, tile_y) then
        o = Map:getCellObject(tile_x, tile_y)
        love.graphics.print(o.name, mouse.x+10, mouse.y+60)
      end
    end
end

function PlayerGUI:draw_unit_indicator()
    for y=0, Map:getWidth()-1 do
        for x=0, Map:getHeight()-1 do 
            if Map:isTileSeen(x,y) and Map:getCellActor(x,y) then 
               -- local circle_x = x*(32)+16+120
               -- local circle_y = y*(32)+16+0
                local circle_x = x*32+16+120
                local circle_y = y*32+26+0
                if Map:getCellActor(x,y).player then  
                    Map:unitIndicatorCircle(circle_x, circle_y, "player")
                    --Map:unitIndicatorSquare((x*32)+120, (y*32), "player")
                else
                    Map:unitIndicatorCircle(circle_x, circle_y)
                    --Map:unitIndicatorSquare((x*32)+120, (y*32))
                end
            end
        end
    end
end

--labels
function PlayerGUI:tiletolabel(x,y)
    cam_x, cam_y = camera:cameraCoords(x,y)
    pixel_x = math.floor((120+(cam_x+(x*32))))

    --label needs to go *above* the tile, which is every 32px
    pixel_y = math.floor((cam_y+(y*32)-15))
    --print("Tile to pixel for x, y"..x..", "..y.."pixel x"..pixel_x..", "..pixel_y)
    return pixel_x, pixel_y
end


function PlayerGUI:draw_labels()
    for y=0, Map:getWidth()-1 do
        for x=0, Map:getHeight()-1 do
            if Map:isTileSeen(x,y) and Map:getCellActor(x,y) then
                a = Map:getCellActor(x, y)
                love.graphics.print(a.name, PlayerGUI:tiletolabel(x,y))
            end
        end
    end
end


function PlayerGUI:draw_log_messages()
    love.graphics.setFont(sherwood_font)
    -- draw log messages
    local a = 255
    if #logMessages > 0 then
        for i, message in ipairs(logMessages) do
            local myColor = r,g,b,a
            love.graphics.setColor(a,a,a,a)
            love.graphics.print(message['message'], 120, 15*i)
        end    

        for i,message in ipairs(logMessages) do
            if message['delete'] == true then
                table.remove(logMessages,i)
            end
        end

        --[[for i,message in ipairs(logMessages) do
            local difference = os.clock() - message['time']
            a = 355 - (255*string.format("%.2f",difference))
            if a > 0 then
                local myColor = r,g,b,a
                love.graphics.setColor(a,a,a,a)
                love.graphics.print(message['message'], 120,15*i)
            else
                message['delete'] = true
            end
        end
        for i,message in ipairs(logMessages) do
            if message['delete'] == true then
                table.remove(logMessages,i)
            end
        end]]
    end
end

--handle screens
--inventory
function PlayerGUI:draw_inventory_test(player)
    InventoryDialog:draw(player)
end

function PlayerGUI:inventory_mouse()
    InventoryDialog:mouse()
end

function PlayerGUI:inventory_mouse_pressed(x,y,b)
    InventoryDialog:mouse_pressed(x,y,b)
end

return PlayerGUI