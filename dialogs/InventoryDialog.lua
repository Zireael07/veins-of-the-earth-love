require 'T-Engine.class'

module("InventoryDialog", package.seeall, class.make)

function InventoryDialog:loadTiles()
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


function InventoryDialog:draw(player)
    love.graphics.setColor(255,255,255)
    --background
    love.graphics.draw(stone_bg, 150, 30, 0, 1.5,1.5)

    --draw upscaled player tile
    love.graphics.draw(player_tile, 200,120, 0, 2.5, 2.5)

    --draw inventory UI bits
    --top
    if player:getInven(player.INVEN_HELM) then
        print("[Inventory dialog] We have a helm")
        love.graphics.draw(head_inv, 210, 50)
    end
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

        --if there is an item in the corresponding slot, draw it
        for nb, o in ipairs(player:getInven(player.INVEN_INVEN)) do
            --print("We have an item in inventory slot ", nb)
            if nb == i then
                --print("We are going to draw on slot ", i)
               -- love.graphics.draw(o.image, x, y)
            end
        end


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

return InventoryDialog