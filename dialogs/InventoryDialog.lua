require 'T-Engine.class'

module("InventoryDialog", package.seeall, class.make)

function InventoryDialog:drawSlot(inven, x, y)
  local tiles = {
    BODY = loaded_tiles["armor_inv"],
    HELM = loaded_tiles["head_inv"],
    AMULET = loaded_tiles["amulet_inv"],
    QUIVER = loaded_tiles["ammo_inv"],
    SHOULDER = loaded_tiles["shoulder_inv"],
    MAIN_HAND = loaded_tiles["mainhand_inv"],
    OFF_HAND = loaded_tiles["offhand_inv"],
    RING = loaded_tiles["ring_inv"],
    CLOAK = loaded_tiles["cloak_inv"],
    BELT = loaded_tiles["belt_inv"],
    BOOTS = loaded_tiles["boots_inv"],
    LITE = loaded_tiles["light_inv"],
    TOOL = loaded_tiles["tool_inv"],
    }
  
    if player:getInven(player["INVEN_"..inven]) then
        love.graphics.draw(tiles[inven], x, y)
        --if there is an item in the corresponding slot, draw it
        for nb, o in ipairs(player:getInven(player["INVEN_"..inven])) do
            if nb == 1 then
                --black background
                love.graphics.setColor(colors.BLACK)
                love.graphics.rectangle('fill', x, y, 42, 42)
                love.graphics.setColor(255, 255, 255)
                local tile = InventoryDialog:getObjectTile(o)
                love.graphics.draw(tile, x+5, y+5)
            end
        end
        --draw outline around acceptable slots when dragging
        if dragged then
            local slot = dragged.item.slot
            if inven == slot then
                love.graphics.setColor(colors.GOLD)
                love.graphics.rectangle('line', x, y, 42, 42)
                love.graphics.setColor(255, 255, 255)
            end
        end
    end 

end

function InventoryDialog:draw(player)

    love.graphics.setColor(255,255,255)
    --background
    love.graphics.draw(loaded_tiles["stone_bg"], 150, 30, 0, 1.5,1.5)

    --draw upscaled player tile
    love.graphics.draw(loaded_tiles["player_tile"], 200,120, 0, 2.5, 2.5)

    --draw inventory UI bits
    --necessary for the ring slot
    local tiles = {
      RING = loaded_tiles["ring_inv"]
    }
    
    --top
    InventoryDialog:drawSlot("BODY", 160, 50)
    InventoryDialog:drawSlot("HELM", 210, 50)
    InventoryDialog:drawSlot("AMULET", 270, 50)
    --2nd line
    InventoryDialog:drawSlot("QUIVER", 160, 100)
    InventoryDialog:drawSlot("SHOULDER", 270, 100)
    --3rd line
    InventoryDialog:drawSlot("MAIN_HAND", 160, 150)
    InventoryDialog:drawSlot("OFF_HAND", 270, 150)
    --4th line
    --special because two rings
    if player:getInven(player.INVEN_RING) then
        love.graphics.draw(tiles["RING"], 160, 200)
        love.graphics.draw(tiles["RING"], 270, 200)
        --if there is an item in the corresponding slot, draw it
        for nb, o in ipairs(player:getInven(player.INVEN_RING)) do
            if nb == 1 then
                local tile = InventoryDialog:getObjectTile(o)
                love.graphics.draw(tile, 160+5, 200+5)
            elseif nb == 2 then
                local tile = InventoryDialog:getObjectTile(o)
                love.graphics.draw(tile, 270+5, 200+5)
            end
        end
    end

    --5th line
    InventoryDialog:drawSlot("CLOAK", 160, 250)
    InventoryDialog:drawSlot("BELT", 270, 250)
    --6th line
    InventoryDialog:drawSlot("BOOTS", 270, 300)
    InventoryDialog:drawSlot("LITE", 160, 300)
    --bottom
    InventoryDialog:drawSlot("TOOL", 210, 300) 

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
                local tile = InventoryDialog:getObjectTile(o)
                love.graphics.draw(tile, x+5, y+5)
                --print("We are going to draw on slot ", i)
            end
        end


        x = x + 45
    end
    --2nd row
    y = 470
    x = 160
    for i=16,30 do
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

    --fill right hand side
    love.graphics.setColor(255, 255, 102)
    love.graphics.print("INVENTORY", 500, 50)
    --love.graphics.print("AC: "..player:getAC(), 500, 100)


    --tooltip?
    if item then
        love.graphics.setColor(255, 255, 102)
        love.graphics.print(item.name, mouse.x, mouse.y + 20)
    end

    if slot then 
        love.graphics.setColor(colors.RED)
        love.graphics.print(slot, mouse.x + 10, mouse.y + 30)
    end

    --dragged items
    if dragged then
        love.graphics.setColor(255, 255, 255)
        local tile = InventoryDialog:getObjectTile(dragged.item)
        love.graphics.draw(tile, mouse.x + 2, mouse.y + 2)
    end
end

function InventoryDialog:getObjectTile(o)
    local string 
   -- local tile
    if not o.image then print("Object does not have image defined") return end

    string = o.image
    tile = loaded_tiles[string]
    --print ("Object tile gotten for o: "..o.name)
    return tile
end

function InventoryDialog:mouse()
    slot = InventoryDialog:mousetoSlot()
    index, inven = InventoryDialog:slottoIndex(slot)
    item = InventoryDialog:getItemInSlot(index, inven)
end


function InventoryDialog:mousetoSlot()
    if mouse.x < 150 or mouse.y < 30 then return end

    local s = 42

    local slot
    --is there a better way?
    if mouse.x > 160 and mouse.x < 160+s and mouse.y > 50 and mouse.y < 50+s then
        slot = "body"
    end
    if mouse.x > 210 and mouse.x < 210+s and mouse.y > 50 and mouse.y < 50+s then
        slot = "head"
    end
    if mouse.x > 270 and mouse.x < 270+s and mouse.y > 50 and mouse.y < 50+s then
        slot = "amulet"
    end
    if mouse.x > 160 and mouse.x < 160+s and mouse.y > 100 and mouse.y < 100+s then
        slot = "quiver"
    end
    if mouse.x > 270 and mouse.x < 270+s and mouse.y > 100 and mouse.y < 100+s then
        slot = "shoulder"
    end
    if mouse.x > 160 and mouse.x < 160+s and mouse.y > 150 and mouse.y < 150+s then
        slot = "main_hand"
    end
    if mouse.x > 270 and mouse.x < 270+s and mouse.y > 150 and mouse.y < 150+s then
        slot = "off_hand"
    end
    if mouse.x > 160 and mouse.x < 160+s and mouse.y > 200 and mouse.y < 200+s then
        slot = "ring_1"
    end
    if mouse.x > 270 and mouse.x < 270+s and mouse.y > 200 and mouse.y < 200+s then
        slot = "ring_2"
    end
    if mouse.x > 160 and mouse.x < 160+s and mouse.y > 250 and mouse.y < 250+s then
        slot = "cloak"
    end
    if mouse.x > 270 and mouse.x < 270+s and mouse.y > 250 and mouse.y < 250+s then
        slot = "belt"
    end
    if mouse.x > 160 and mouse.x < 160+s and mouse.y > 300 and mouse.y < 300+s then
        slot = "lite"
    end
    if mouse.x > 270 and mouse.x < 270+s and mouse.y > 300 and mouse.y < 300+s then
        slot = "boots"
    end
    if mouse.x > 210 and mouse.x < 210+s and mouse.y > 300 and mouse.y < 300+s then
        slot = "tool"
    end
    
    --inventory
    local x = 160
    local y = 400
    for i=1,15 do
        if mouse.x > x and mouse.x < x + s and mouse.y > y and mouse.y < y + s then
            slot = "inven_"..i    
        end
        x = x + 45
    end

    y = 470
    x = 160
    for i=16,30 do
        if mouse.x > x and mouse.x < x + s and mouse.y > y and mouse.y < y + s then
            slot = "inven_"..i    
        end
        x = x + 45
    end

    --ground
    x = 350
    y = 120
    for i=1,5 do
        if mouse.x > x and mouse.x < x + s and mouse.y > y and mouse.y < y + s then
            slot = "drop_"..i    
        end
        y = y + 45
    end

    --print("Mousing over slot: ", slot)
    return slot
end

function InventoryDialog:slottoIndex(slot)
    --print("Getting index from slot", slot)
    if not slot then return end

    local i
    local inven
    if slot:find("inven_") or slot:find("ring_") then
        local split = slot:split('_')
        if split[2] then
            i = split[2]
            inven = split[1]
        end
    else
        i = 1
        inven = slot
    end
   -- print("Index is ", i)
    --print("Inven is ", inven)
    return i, inven
end

function InventoryDialog:getItemInSlot(index, inven)
    if inven == nil or index == nil then return end
   -- print("Getting item in: ", inven, index)
    if player:getInven(player["INVEN_"..inven:upper()]) then
        for nb, o in ipairs(player:getInven(player["INVEN_"..inven:upper()])) do
            if nb == tonumber(index) then
                return o
            end
        end
    end
end

function InventoryDialog:mouse_pressed(x,y,b)
    if b == 1 then
        if dragged then
            if slot then
                --print("We are dragging an item and are over a slot ", slot:upper())
                local inven_inven = player["INVEN_"..dragged.inven:upper()]
                local slot_inven = player["INVEN_"..slot:upper()]

                if dragged.inven == "inven" and not slot:find("inven") then
                    player:doWear(inven_inven, dragged.index, dragged.item, slot_inven)
                else
                    player:doTakeoff(inven_inven, dragged.index, dragged.item)
                end
                --not dragging anything anymore
                dragged = nil
            end
        end
        if item then 
            dragged = { item=item, index=index, inven=inven }
            --print("[Inventory] We are dragging an item", item)
        end
    --right mouse button
    elseif b == 2 then
        --cancel drag
        if dragged then
            dragged = nil
        end
    end
end

return InventoryDialog