require 'T-Engine.class'

require 'class.Player'

--bar
local Hotbar = require 'class.Hotbar'

--dialogs
local InventoryDialog = require 'dialogs.InventoryDialog'
local LogDialog = require 'dialogs.LogDialog'
local ChatDialog = require 'dialogs.ChatDialog'
local CharacterCreation = require 'dialogs.CharacterCreation'
local CharacterSheet = require 'dialogs.CharacterSheet'

--for debug overlays
local Pathfinding = require 'interface.Pathfinding'

module("PlayerGUI", package.seeall, class.make)

function PlayerGUI:loadGUI()
    love.graphics.setFont(goldbox_font)
end

function PlayerGUI:draw_GUI(player)
    --reset color
    love.graphics.setColor(255, 255, 255)
    
    local hp = player.hitpoints
    local wounds = player.wounds

    love.graphics.draw(loaded_tiles["stone_bg"], 0,0, 0, 0.25, 1)
    love.graphics.draw(loaded_tiles["stone_bg"], 0, 320, 0, 0.25, 1)

    love.graphics.setFont(goldbox_large_font)

    love.graphics.setColor(255, 51, 51)
    love.graphics.print("HP: "..player.hitpoints, 10, 10)
    love.graphics.print("Wounds: "..player.wounds, 10, 25)

    --draw body
    love.graphics.setColor(colors.GREEN)
    if player.body_parts then
        local x = 25
        local y = 50
        love.graphics.draw(loaded_tiles["body_ui"], x, y)
    end
end

function PlayerGUI:draw_hotbar()
    Hotbar:draw()
end

function PlayerGUI:hotbar_mouse()
    Hotbar:mouse()
end

function PlayerGUI:hotbar_mouse_pressed(x,y,b)
    Hotbar:mouse_pressed(x,y,b)
end

--tooltip stuff
function PlayerGUI:draw_mouse(x,y)
    love.graphics.setFont(sherwood_font)
    love.graphics.setColor(255,255,255)
    --love.graphics.print(mouse.x..", "..mouse.y, mouse.x + 10, mouse.y)
    love.graphics.print((tile_x or "N/A")..", "..(tile_y or "N/A"), mouse.x+10, mouse.y)
    love.graphics.setColor(255, 255, 102)
    love.graphics.print(player.x..", "..player.y, mouse.x+10, mouse.y+15)
end

function PlayerGUI:draw_tip()
    love.graphics.setFont(sherwood_font)
    love.graphics.setColor(255, 255, 102)
    if tile_x and tile_y then
      if Map:getCellActor(tile_x, tile_y) then
        a = Map:getCellActor(tile_x, tile_y)
        love.graphics.print(a.name, mouse.x+10, mouse.y+30)
        if a.type then  --player doesn't have it yet
            love.graphics.print(a.type, mouse.x+10, mouse.y+40)
        end
        love.graphics.print(a.faction, mouse.x+10, mouse.y+50)
        love.graphics.print(a:indicateReaction(), mouse.x+70, mouse.y+50)
        love.graphics.print(a.hitpoints or "N/A", mouse.x+100, mouse.y+30)
        love.graphics.print(a:getHealthState(), mouse.x+90, mouse.y+40)
      end
      if Map:getCellObject(tile_x, tile_y, 1) then
        o = Map:getCellObject(tile_x, tile_y, 1)
        love.graphics.print(o:getName(), mouse.x+10, mouse.y+60)
      end
    end
end

function PlayerGUI:draw_border_mousetile()
    --reset color
    love.graphics.setColor(255, 255, 255)
    if tile_x and tile_y then
        love.graphics.setColor(colors.GOLD)
        love.graphics.rectangle('line', tile_x*32, tile_y*32, 32, 32)
    end    
end

function PlayerGUI:draw_targeting_overlay()
    --reset color
    love.graphics.setColor(255, 255, 255)
    if tile_x and tile_y then
        love.graphics.setColor(colors.LIGHT_RED)
        love.graphics.rectangle('line', tile_x*32, tile_y*32, 32, 32)
    end
end

function PlayerGUI:draw_unit_indicator()
    for y=1, Map:getWidth()-1 do
        for x=1, Map:getHeight()-1 do 
            if Map:isTileSeen(x,y) and Map:getCellActor(x,y) then 
               -- local circle_x = x*(32)+16
               -- local circle_y = y*(32)+16
                local circle_x = x*32+16
                local circle_y = y*32+26
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
function PlayerGUI:tiletoactorlabel(x,y)
    pixel_x = math.floor(x*32)
    --label needs to go *above* the tile, which is every 32px
    pixel_y = math.floor((y*32)-15)
    --print("Tile to pixel for x, y"..x..", "..y.."pixel x"..pixel_x..", "..pixel_y)
    return pixel_x, pixel_y
end

function PlayerGUI:tiletoobjectlabel(x,y)
    pixel_x = math.floor((x*32)+20)
    pixel_y = math.floor(y*32)
    --print("Tile to pixel for x, y"..x..", "..y.."pixel x"..pixel_x..", "..pixel_y)
    return pixel_x, pixel_y
end


function PlayerGUI:draw_labels()
    --reset color
    love.graphics.setColor(255, 255, 255)
    for y=1, Map:getWidth()-1 do
        for x=1, Map:getHeight()-1 do
            if Map:isTileSeen(x,y) and Map:getCellActor(x,y) then
                a = Map:getCellActor(x, y)
                love.graphics.setColor(255, 255, 102)
                love.graphics.print(a.name, PlayerGUI:tiletoactorlabel(x,y))
            end
            if Map:isTileSeen(x,y) and Map:getCellObject(x,y) then
                o = Map:getCellObject(x,y)
                love.graphics.setColor(255, 255, 255)
                love.graphics.print(o.name, PlayerGUI:tiletoobjectlabel(x,y))
            end
        end
    end
end


function PlayerGUI:draw_log_messages()
    love.graphics.setFont(sherwood_font)
    -- draw log messages
    local height = love.graphics.getHeight()
    local hotbar = 70

    local a = 255
    local font_h = 15
    if #visiblelogMessages > 0 then
        for i, message in ipairs(visiblelogMessages) do
            local myColor = r,g,b,a
            love.graphics.setColor(a,a,a,a)
            love.graphics.print(message['message'], 120, 
            height-hotbar-(font_h*5)+(font_h*i))--15*i)
        end    

        for i,message in ipairs(visiblelogMessages) do
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


function PlayerGUI:tiletosplash(x,y)
    pixel_x = math.floor(x*32)
    pixel_y = math.floor(y*32)
    return pixel_x, pixel_y
end

function PlayerGUI:draw_damage_splashes()
    --reset color
    love.graphics.setColor(255, 255, 255)
    for y=1, Map:getWidth()-1 do
        for x=1, Map:getHeight()-1 do
            if Map:isTileSeen(x,y) and Map:getCellActor(x,y) then
                a = Map:getCellActor(x, y)
                if a.damage_taken then
                    local pixel_x, pixel_y = PlayerGUI:tiletosplash(x,y)
                    love.graphics.setColor(colors.RED)
                    love.graphics.draw(loaded_tiles["damage_tile"], pixel_x-2, pixel_y+8)
                    --reset color
                    love.graphics.setColor(255, 255, 255)
                    love.graphics.print(a.damage_taken, pixel_x+8, pixel_y+8)
                end
            end
        end
    end 
end

function PlayerGUI:draw_emotes()
    love.graphics.setFont(sherwood_font)
    love.graphics.setColor(colors.GOLD)
    for y=1, Map:getWidth()-1 do
        for x=1, Map:getHeight()-1 do
            if Map:isTileSeen(x,y) and Map:getCellActor(x,y) then
                a = Map:getCellActor(x, y)
                if a.emote then
                    local pixel_x, pixel_y = PlayerGUI:tiletosplash(x,y)
                    love.graphics.setColor(colors.GOLD)
                    love.graphics.print(a.emote, pixel_x, pixel_y-15)
                end
            end
        end
    end 
end

--debugging stuff
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

function PlayerGUI:draw_pause_debug()
    love.graphics.print("Non-dialog input locked", 300, 300)
end

--"map" is a table representing dijkstra map
function PlayerGUI:draw_dijkstra_overlay(map)
    for y=1, Map:getWidth()-1 do
        for x=1, Map:getHeight()-1 do
            if Map:isTileSeen(x,y) then
                -- Draws the path overlay
                local pixel_x, pixel_y = PlayerGUI:tiletosplash(x,y)
                love.graphics.setBlendMode( 'add' );
                local color = Pathfinding:selectPathNodeColor(map, x,y)
                love.graphics.setColor(colors[color])
                love.graphics.rectangle('fill', pixel_x, pixel_y, 32, 32);
                love.graphics.setColor( 255, 255, 255, 200);
                love.graphics.setBlendMode( 'alpha' );
            end
        end
    end 
end

--handle screens
--character creation
function PlayerGUI:draw_character_creation(player)
    CharacterCreation:draw(player)
end

function PlayerGUI:character_creation_mouse()
    CharacterCreation:mouse()
end

function PlayerGUI:character_creation_mouse_pressed(x,y,b)
    CharacterCreation:mouse_pressed(x,y,b)
end

function PlayerGUI:draw_character_sheet(player)
    CharacterSheet:draw(player)
end

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

--log
function PlayerGUI:draw_log_dialog()
    LogDialog:draw()
end

--NPC chat screen
function PlayerGUI:draw_chat(npc_chat)
    ChatDialog:draw(npc_chat.chat, npc_chat.id)
end

function PlayerGUI:chat_mouse()
    ChatDialog:mouse()
end

function PlayerGUI:chat_mouse_pressed(x,y,b)
    ChatDialog:mouse_pressed(x,y,b)
end

return PlayerGUI