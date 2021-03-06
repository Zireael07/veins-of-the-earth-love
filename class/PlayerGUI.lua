require 'T-Engine.class'

require 'class.Player'

local UI = require "UIElements"

--bar
local Hotbar = require 'class.Hotbar'

--dialogs
local InventoryDialog = require 'dialogs.InventoryDialog'
local LogDialog = require 'dialogs.LogDialog'
local ChatDialog = require 'dialogs.ChatDialog'
local CharacterCreation = require 'dialogs.CharacterCreation'
local CharacterSheet = require 'dialogs.CharacterSheet'
local SkillsDialog = require 'dialogs.SkillsDialog'
local HelpControls = require 'dialogs.HelpControls'
local DeathDialog = require 'dialogs.DeathDialog'
local MenuDialog = require 'dialogs.MenuDialog'
local TestDialog = require 'dialogs.TestDialog'

--for debug overlays
local Pathfinding = require 'interface.Pathfinding'

module("PlayerGUI", package.seeall, class.make)

function PlayerGUI:loadGUI()
    love.graphics.setFont(goldbox_font)
    Hotbar:load()
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
    love.graphics.print("Endure: "..player.hitpoints, 10, 10)
    love.graphics.print("Health: "..player.wounds, 10, 25)

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
    love.graphics.print((tile_x or "N/A")..", "..(tile_y or "N/A"), mouse.x+10, mouse.y)
    love.graphics.setColor(255, 255, 102)
    if tile_x and tile_y then
        local dist = utils:distance(player.x, player.y, tile_x, tile_y)
        local feet = dist*5
        love.graphics.print(dist.." "..feet.." ft", mouse.x+50, mouse.y)
    end 
    love.graphics.print(player.x..", "..player.y, mouse.x+10, mouse.y+15)
end

function PlayerGUI:draw_tip()
    love.graphics.setFont(sherwood_font)
    
    if tile_x and tile_y then
        --draw background
        if Map:getCellActor(tile_x, tile_y) or Map:getCellObject(tile_x, tile_y, 1) then
            --add a background to the tooltip
            love.graphics.setColor(153, 76, 0, 100)
            love.graphics.rectangle('fill', mouse.x +10, mouse.y+28, 160, 100)
        end
        --draw text
      if Map:getCellActor(tile_x, tile_y) then
        a = Map:getCellActor(tile_x, tile_y)
        love.graphics.setColor(255, 255, 102)
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
        love.graphics.setColor(255, 255, 102)
        o = Map:getCellObject(tile_x, tile_y, 1)
        love.graphics.print("==========", mouse.x+10, mouse.y+60)
        love.graphics.print((o:getName() or " "), mouse.x+10, mouse.y+80)
        if o.cost then
            love.graphics.print(o:formatPrice(), mouse.x+10, mouse.y+100)
        end
      end
    end
end

function PlayerGUI:draw_border_mousetile(tile_size)
    --reset color
    love.graphics.setColor(255, 255, 255)
    if tile_x and tile_y then
        love.graphics.setColor(colors.GOLD)
        love.graphics.rectangle('line', tile_x*tile_size, tile_y*tile_size, tile_size, tile_size)
    end    
end

function PlayerGUI:draw_targeting_overlay(tile_size)
    --reset color
    love.graphics.setColor(255, 255, 255)
    if tile_x and tile_y then
        love.graphics.setColor(colors.LIGHT_RED)
        love.graphics.rectangle('line', tile_x*tile_size, tile_y*tile_size, tile_size, tile_size)
    end
end

function PlayerGUI:draw_area_name(name)
    --reset color
    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(sherwood_font)
    
    if name then
        love.graphics.print(name, (love.graphics:getWidth()-100), 2)
    end
end

function PlayerGUI:indicatorColor(val)
    local color
    if val == "player" or val == "helpful" then
    color = {0, 255, 255}
  elseif val == "friendly" then 
    color = {0, 255, 0}
  elseif val == "neutral" then 
    color = {255, 255, 0}
  elseif val == "unfriendly" then 
    color = {255, 119,0}
  elseif val == "hostile" then
    color = {255, 0, 0}
  end 
  return color
end 

function PlayerGUI:draw_turns_order()
    --reset color
    love.graphics.setColor(255, 255, 255)

    for y=1, Map:getWidth()-1 do
        for x=1, Map:getHeight()-1 do 
            if Map:isTileSeen(x,y) and Map:getCellActor(x,y) then 
                a = Map:getCellActor(x, y)
                draw_x = 135
                draw_y = 15

                for i=1, #visible_actors do
                    local item = visible_actors[i]
                    --reset color
                    love.graphics.setColor(255, 255, 255)
                    love.graphics.draw(loaded_tiles[item.image], draw_x, draw_y)
                    local col = PlayerGUI:indicatorColor(item:indicateReaction())
                    love.graphics.setColor(col)
                    love.graphics.rectangle("line", draw_x, draw_y, 32, 32)
                    draw_x = draw_x + 40
                end
            end 
        end
    end
    love.graphics.setColor(colors.SLATE)
    love.graphics.rectangle("line", 130, 10, draw_x-130, 40)   
end

--labels
function PlayerGUI:tiletoactorlabel(x,y, tile_size)
    pixel_x = math.floor(x*tile_size)
    --label needs to go *above* the tile, which is every 32px
    pixel_y = math.floor((y*tile_size)-15)
    --print("Tile to pixel for x, y"..x..", "..y.."pixel x"..pixel_x..", "..pixel_y)
    return pixel_x, pixel_y
end

function PlayerGUI:tiletoobjectlabel(x,y, tile_size)
    pixel_x = math.floor((x*tile_size)+20)
    pixel_y = math.floor(y*tile_size)
    --print("Tile to pixel for x, y"..x..", "..y.."pixel x"..pixel_x..", "..pixel_y)
    return pixel_x, pixel_y
end


function PlayerGUI:draw_labels(tile_size)
    --reset color
    love.graphics.setColor(255, 255, 255)
    for y=1, Map:getWidth()-1 do
        for x=1, Map:getHeight()-1 do
            if Map:isTileSeen(x,y) and Map:getCellActor(x,y) then
                a = Map:getCellActor(x, y)
                love.graphics.setColor(255, 255, 102)
                love.graphics.print(a.name, PlayerGUI:tiletoactorlabel(x,y, tile_size))
            end
            if Map:isTileSeen(x,y) and Map:getCellObject(x,y) then
                o = Map:getCellObject(x,y)
                love.graphics.setColor(255, 255, 255)
                love.graphics.print(o.name, PlayerGUI:tiletoobjectlabel(x,y, tile_size))
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


function PlayerGUI:tiletosplash(x,y, tile_size)
    pixel_x = math.floor(x*tile_size)
    pixel_y = math.floor(y*tile_size)
    --print("Tile to splash", x, y, tile_size, pixel_x, pixel_y)
    return pixel_x, pixel_y
end

function PlayerGUI:draw_damage_splashes(tile_size)
    --reset color
    love.graphics.setColor(255, 255, 255)
    for y=1, Map:getWidth()-1 do
        for x=1, Map:getHeight()-1 do
            if Map:isTileSeen(x,y) and Map:getCellActor(x,y) then
                a = Map:getCellActor(x, y)
                if a.damage_taken then
                    local pixel_x, pixel_y = PlayerGUI:tiletosplash(x,y, tile_size)
                    love.graphics.setColor(colors.RED)
                    love.graphics.draw(loaded_tiles["damage_tile"], pixel_x-0.06*tile_size, pixel_y+0.25*tile_size)
                    --reset color
                    love.graphics.setColor(255, 255, 255)
                    love.graphics.print(a.damage_taken, pixel_x+0.25*tile_size, pixel_y+0.25*tile_size)
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
    love.graphics.setColor(128, 255, 0)
    love.graphics.print(schedule_curr, 680, 30)
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
function PlayerGUI:draw_dijkstra_overlay(map, tile_size)
    for y=1, Map:getWidth()-1 do
        for x=1, Map:getHeight()-1 do
            if Map:isTileSeen(x,y) then
                -- Draws the path overlay
                local pixel_x, pixel_y = PlayerGUI:tiletosplash(x,y, tile_size)
                love.graphics.setBlendMode( 'add' );
                local color = Pathfinding:selectPathNodeColor(map, x,y)
                love.graphics.setColor(colors[color])
                love.graphics.rectangle('fill', pixel_x, pixel_y, tile_size, tile_size);
                love.graphics.setColor( 255, 255, 255, 200);
                love.graphics.setBlendMode( 'alpha' );
            end
        end
    end 
end

--handle screens
--generic stuff
function PlayerGUI:unload()
    UI:unload()
end

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

function PlayerGUI:character_creation_keypressed(k)
    CharacterCreation:keypressed(k)
end

function PlayerGUI:character_creation_textinput(t)
    CharacterCreation:textinput(t)
end

function PlayerGUI:draw_skills_dialog(player)
    SkillsDialog:draw(player)
end

function PlayerGUI:skills_dialog_mouse()
    SkillsDialog:mouse()
end

function PlayerGUI:skills_dialog_mouse_pressed(x,y,b)
    SkillsDialog:mouse_pressed(x,y,b)
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

function PlayerGUI:draw_help_controls()
    HelpControls:draw()
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

--death screen
function PlayerGUI:draw_death_dialog()
    DeathDialog:draw()
end

function PlayerGUI:death_dialog_mouse()
end

function PlayerGUI:death_dialog_mouse_pressed(x,y,b)
end

--menu
function PlayerGUI:draw_menu_dialog()
    MenuDialog:draw()
end

function PlayerGUI:menu_dialog_mouse()
    MenuDialog:mouse()
end

function PlayerGUI:menu_dialog_mouse_pressed(x,y,b)
    MenuDialog:mouse_pressed(x,y,b)
end

--test
function PlayerGUI:init_dialog(str)
    if str == "test" then
        TestDialog:load()
        --print("Loading test dialog UI")
    end
    if str == "character_creation" then
        CharacterCreation:load()
    end
    if str == "menu_dialog" then
        MenuDialog:load()
    end
    if str == "inventory" then
        InventoryDialog:load()
    end
end

function PlayerGUI:draw_test_dialog()
    TestDialog:draw()
end

function PlayerGUI:test_mouse()
    TestDialog:mouse()
end

function PlayerGUI:test_mouse_pressed(x,y,b)
    TestDialog:mouse_pressed(x,y,b)
end

return PlayerGUI