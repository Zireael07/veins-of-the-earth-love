require 'T-Engine.class'

local UI = require 'UIElements'

module("InventoryDialog", package.seeall, class.make)

function InventoryDialog:load()
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

    --for inven,v in ipairs(tiles) do
        if player:getInven(player["INVEN_BODY"]) then
            InventoryDialog:init_inventory_slot(160, 50, "body", {}, tiles["BODY"])
        end
        if player:getInven(player["INVEN_HELM"]) then
            InventoryDialog:init_inventory_slot(210, 50, "helm", {}, tiles["HELM"])
        end
        if player:getInven(player["INVEN_AMULET"]) then
            InventoryDialog:init_inventory_slot(270, 50, "amulet", {}, tiles["AMULET"])
        end
        --2nd line
        if player:getInven(player["INVEN_QUIVER"]) then
            InventoryDialog:init_inventory_slot(160, 100, "quiver", {}, tiles["QUIVER"])
        end
        if player:getInven(player["INVEN_SHOULDER"]) then
            InventoryDialog:init_inventory_slot(270, 100, "shoulder", {}, tiles["SHOULDER"])
        end
        --3rd line
        if player:getInven(player["INVEN_MAIN_HAND"]) then
            InventoryDialog:init_inventory_slot(160, 150, "main_hand", {}, tiles["MAIN_HAND"])
        end
        if player:getInven(player["INVEN_OFF_HAND"]) then
            InventoryDialog:init_inventory_slot(270, 150, "off_hand", {}, tiles["OFF_HAND"])
        end
        --4th line 
        --rings
        --5th line
        if player:getInven(player["INVEN_CLOAK"]) then
            InventoryDialog:init_inventory_slot(160, 250, "cloak", {}, tiles["CLOAK"])
        end
        if player:getInven(player["INVEN_BELT"]) then
            InventoryDialog:init_inventory_slot(270, 250, "belt", {}, tiles["BELT"])
        end
        --6th line
        if player:getInven(player["INVEN_BOOTS"]) then
            InventoryDialog:init_inventory_slot(270, 300, "boots", {}, tiles["BOOTS"])
        end
        if player:getInven(player["INVEN_LITE"]) then
            InventoryDialog:init_inventory_slot(160, 300, "lite", {}, tiles["LITE"])
        end
        --bottom
        if player:getInven(player["INVEN_TOOL"]) then
            InventoryDialog:init_inventory_slot(210, 300, "tool", {}, tiles["TOOL"]) 
        end
    --end
    --backpack
    local x = 160
    local y = 400

    --total of INVEN slots (30)
    --one row
    for i=1,15 do
        InventoryDialog:init_inventory_slot(x, y, "inven_"..i, {255, 255, 102})
        x = x + 45
    end
    --2nd row
    y = 470
    x = 160
    for i=16,30 do
        InventoryDialog:init_inventory_slot(x,y, "inven_"..i, {255, 255, 102})
        x = x + 45
    end

    --ground
    x = 350
    y = 120
    for i=1,5 do
        InventoryDialog:init_inventory_slot(x,y, "drop_"..i, {255, 51, 51})
        y = y + 45
    end
end

function InventoryDialog:init_inventory_slot(x,y, id, border_color, bg)
    if not x or not y or not id then print("[UI] Inventory slot: missing parameters!") return end
    UI.element[#UI.element+1] = {x=x, y=y, id=id, inventory=true, border_color=border_color, bg=bg}
end

function InventoryDialog:draw_ui()
    for i,e in ipairs(UI.element) do
        --background if any
        if e.bg then
            love.graphics.draw(e.bg, e.x, e.y)
        else
            --black fill
            love.graphics.setColor(0,0,0)
            love.graphics.rectangle('fill', e.x, e.y, 42, 42)
            --colored border
            love.graphics.setColor(e.border_color)
            love.graphics.rectangle('line', e.x, e.y, 42, 42)
        end

        ind, inv = InventoryDialog:slottoIndex(e.id)
        --drop slots have no assigned inven
        if inv ~= "drop" then
            --if there is an item in the corresponding slot, draw it
            for nb, o in ipairs(player:getInven(player["INVEN_"..inv:upper()])) do
                if inv:upper() ~= "INVEN" then
                    if nb == 1 then
                        --black background
                        love.graphics.setColor(colors.BLACK)
                        love.graphics.rectangle('fill', e.x, e.y, 42, 42)
                        love.graphics.setColor(255, 255, 255)
                        local tile = InventoryDialog:getObjectTile(o)
                        love.graphics.draw(tile, e.x+5, e.y+5)
                    end
                else 
                    if nb == tonumber(ind) then
                        local tile = InventoryDialog:getObjectTile(o)
                        love.graphics.draw(tile, e.x+5, e.y+5)
                    end
                end
            end
        end
    end
end

--draw outline around acceptable slots when dragging
    --[[if dragged then
        local slot = dragged.item.slot
        if inven == slot then
            love.graphics.setColor(colors.GOLD)
            love.graphics.rectangle('line', x, y, 42, 42)
            love.graphics.setColor(255, 255, 255)
        end
    end]]

function InventoryDialog:draw(player)

    love.graphics.setColor(255,255,255)
    --background
    love.graphics.draw(loaded_tiles["stone_bg"], 150, 30, 0, 1.5,1.5)

    --draw upscaled player tile
    love.graphics.draw(loaded_tiles["player_tile"], 200,120, 0, 2.5, 2.5)

    --draw inventory UI bits
    love.graphics.setColor(255,255,255)
    InventoryDialog:draw_ui()


    --necessary for the ring slot
    local tiles = {
      RING = loaded_tiles["ring_inv"]
    }
    
    --[[--4th line
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
    end]]

    --drop slots header
    x = 350
    y = 120
    love.graphics.print("Ground", x, y-20)

    --fill right hand side
    love.graphics.setColor(255, 255, 102)
    love.graphics.print("INVENTORY", 500, 50)
    --love.graphics.print("AC: "..player:getAC(), 500, 100)

    --money bar
    
    x = 500
    y = 140
    love.graphics.print("MONEY", x, y-20)
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(loaded_tiles["ui_platinum_coin"], x, y)
    love.graphics.print(player:getCoins("platinum"), x+20, y)
    love.graphics.draw(loaded_tiles["ui_gold_coin"], x+60, y)
    love.graphics.print(player:getCoins("gold"), x+80, y)
    love.graphics.draw(loaded_tiles["ui_silver_coin"], x+120, y)
    love.graphics.print(player:getCoins("silver"), x+140, y)
    love.graphics.draw(loaded_tiles["ui_bronze_coin"], x+180, y)
    love.graphics.print(player:getCoins("copper"), x+200, y)

    --tooltip?
    if item then
        love.graphics.setColor(255, 255, 102)
        love.graphics.print(item:getName(), mouse.x, mouse.y + 20)
    end

    --menu
    if menu then
        y = 30
        love.graphics.setColor(153, 76, 0, 100)
        love.graphics.rectangle('fill', menu.menu_x, menu.menu_y + y, 80, #menu_entries*20)
        for i, v in ipairs(menu_entries) do
            love.graphics.setColor(255, 255, 102)
            love.graphics.print(menu_entries[i], menu.menu_x, menu.menu_y + y)
            y = y + 15
        end
    end

    --examine screen
    if examine then
        love.graphics.setColor(255, 255, 51, 150)
        love.graphics.rectangle('fill', 270, 100, 400, 400)
        love.graphics.setColor(colors.SLATE)
        love.graphics.printf(examine.item:getExamineDescription(), 280, 120, 380)
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
    if not o.image then print("Object does not have image defined") return end

    string = o.image
    tile = loaded_tiles[string]
    --print ("Object tile gotten for o: "..o.name)
    return tile
end

function InventoryDialog:mouse()
    slot = UI:mouse()
    index, inven = InventoryDialog:slottoIndex(slot)
    item = InventoryDialog:getItemInSlot(index, inven)
end

function InventoryDialog:slottoIndex(slot)
    --print("Getting index from slot", slot)
    if not slot then return end

    local i
    local inven
    if slot:find("inven_") or slot:find("ring_") or slot:find("drop_") then
        local split = slot:split('_')
        if split[2] then
            i = split[2]
            inven = split[1]
        end
    else
        i = 1
        inven = slot
    end
    --print("Index is ", i)
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
    UI:mouse_pressed(x,y,b)
    if b == 1 then
        if dragged then
            if slot then
                --print("We are dragging an item and are over a slot ", slot:upper())
                local inven_inven = player["INVEN_"..dragged.inven:upper()]
                local slot_inven = player["INVEN_"..slot:upper()]

                if slot:find("drop") then
                    player:doDrop(inven_inven, dragged.index)
                    --not dragging anything anymore
                    dragged = nil
                return 
                end
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
            --print("[Inventory] We are dragging an item", item, "index", index, "inven"..(inven or " "))
        end
        if menu then
            if x > menu.menu_x and x < menu.menu_x + 80 then
                if y > menu.menu_y and y < menu.menu_y + 45 then
                    print("Pressed menu option 1") --Examine
                    examine = {item=menu.item}
                end
                if y > menu.menu_y + 50 and y < menu.menu_y + 70 then
                    print("Pressed menu option 2") --Wear
                    local inven_inven = player["INVEN_"..menu.inven:upper()]
                    local slot_inven = player["INVEN_"..menu.item.slot:upper()]
                    if not menu.item.slot:find("inven") and menu.inven == "inven" then
                        player:doWear(inven_inven, menu.index, menu.item, slot_inven)
                    end
                    --dismiss menu once we're done
                    menu = nil
                end
                if menu and y < menu.menu_y then
                    menu = nil
                end
            else
            --dismiss menu
            menu = nil
            end
        end

    --right mouse button
    elseif b == 2 then
        --dismiss examine
        if examine then
            examine = nil
        end
        --cancel drag
        if dragged then
            dragged = nil
        else
            --dismiss menu
            if menu then
                menu = nil
            else
                if slot and item then
                    print("Press right mouse on a slot with item")
                    if menu == nil then
                        menu = {menu_x = x, menu_y = y, item = item, index = index, inven=inven}
                        menu_entries = {"Examine", "Wear"}
                    end
                end
            end
        end
    end
end

return InventoryDialog