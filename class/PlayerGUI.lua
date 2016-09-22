require 'T-Engine.class'

require 'class.Player'

module("PlayerGUI", package.seeall, class.make)


function PlayerGUI:init(player)

end

function PlayerGUI:loadGUI()
    stone_bg = love.graphics.newImage("gfx/stone_background.png")
    --inventory
    ammo_inv = love.graphics.newImage("gfx/inventory/ammo_inv.png")
    amulet_inv = love.graphics.newImage("gfx/inventory/amulet_inv.png")
    armor_inv = love.graphics.newImage("gfx/inventory/armor_inv.png")
    arms_inv = love.graphics.newImage("gfx/inventory/arms_inv.png")
    belt_inv = love.graphics.newImage("gfx/inventory/belt_inv.png")
    boots_inv = love.graphics.newImage("gfx/inventory/boots_inv.png")
    cloak_inv = love.graphics.newImage("gfx/inventory/cloak_inv.png")
    gloves_inv = love.graphics.newImage("gfx/inventory/gloves_inv.png")
    head_inv = love.graphics.newImage("gfx/inventory/head_inv.png")
    light_inv = love.graphics.newImage("gfx/inventory/light_inv.png")
    mainhand_inv = love.graphics.newImage("gfx/inventory/mainhand_inv.png")
    offhand_inv = love.graphics.newImage("gfx/inventory/offhand_inv.png")
    ring_inv = love.graphics.newImage("gfx/inventory/ring_inv.png")
    shoulder_inv = love.graphics.newImage("gfx/inventory/shoulder_inv.png")
    tool_inv = love.graphics.newImage("gfx/inventory/tool_inv.png")

    --player
    player_tile = love.graphics.newImage("gfx/tiles/player/racial_dolls/human_m.png")
end

function PlayerGUI:draw_GUI(player)
    local hp = player.hitpoints
    local wounds = player.wounds

    love.graphics.draw(stone_bg, 0,0, 0, 0.25, 1)
    love.graphics.draw(stone_bg, 0, 320, 0, 0.25, 1)

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
        love.graphics.print(a.name, mouse.x+10, mouse.y+30)
        love.graphics.print(a.hitpoints or "N/A", mouse.x+100, mouse.y+30)
      end
      if Map:getCellObject(tile_x, tile_y) then
        o = Map:getCellObject(tile_x, tile_y)
        love.graphics.print(o.name, mouse.x+10, mouse.y+60)
      end
    end
end

function PlayerGUI:draw_log_messages()
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

function PlayerGUI:draw_inventorytest()
    love.graphics.setColor(255,255,255)
    --background
    love.graphics.draw(stone_bg, 150, 30, 0, 1.5,1.5)

    --draw upscaled player tile
    love.graphics.draw(player_tile, 200,120, 0, 2.5, 2.5)

    --draw inventory UI bits
    --top
    love.graphics.draw(head_inv, 210, 50)
    love.graphics.draw(amulet_inv, 270, 50)
    --2nd line
    love.graphics.draw(ammo_inv, 160, 100)
    love.graphics.draw(shoulder_inv, 270, 100)
    --3rd line
    love.graphics.draw(mainhand_inv, 160, 150)
    love.graphics.draw(offhand_inv, 270, 150)
    --4th line
    love.graphics.draw(ring_inv, 160, 200)
    love.graphics.draw(ring_inv, 270, 200)
    --5th line
    love.graphics.draw(cloak_inv, 160, 250)
    love.graphics.draw(belt_inv, 270, 250)
    --6th line
    love.graphics.draw(boots_inv, 270, 300)
    love.graphics.draw(light_inv, 160, 300)
    --bottom
    love.graphics.draw(tool_inv, 210, 300)

    --backpack
    local x = 160
    local y = 400

    --total of INVEN slots (30)
    --one row
    for i=1,15 do
        --black fill
        love.graphics.setColor(0,0,0)
        love.graphics.rectangle('fill', x, y, 42, 42)
        --gold border
        love.graphics.setColor(255, 255, 102)
        love.graphics.rectangle('line', x, y, 42, 42)

        x = x + 45
    end
    --2nd row
    y = 470
    x = 160
    for i=1,15 do
        --black fill
        love.graphics.setColor(0,0,0)
        love.graphics.rectangle('fill', x, y, 42, 42)
        --gold border
        love.graphics.setColor(255, 255, 102)
        love.graphics.rectangle('line', x, y, 42, 42)

        x = x + 45
    end

    --drop slots
    x = 350
    y = 120
    love.graphics.print("Ground", x, y-20)
    for i=1,5 do
        --black fill
        love.graphics.setColor(0,0,0)
        love.graphics.rectangle('fill', x, y, 42, 42)
        --red border
        love.graphics.setColor(255, 51, 51)
        love.graphics.rectangle('line', x, y, 42, 42)

        y = y + 45
    end
end

return PlayerGUI