-- gamemode for LOVE to handle the game itself
gamemode = {}

ROT=require 'libraries/rotLove/rotLove'

require 'class.Area'
require 'class.Map'
require 'class.Player'
local GUI = require 'class.PlayerGUI'
require 'class.Entity'
local utils = require 'utils'
local Calendar = require "T-Engine.Calendar"

local TurnManager = require "interface.TurnManager"

local gamera = require 'libraries.gamera'
local Mouse = require 'class.Mouse'

function gamemode.load()
    --list of entities
    entities = {}
    visible_actors = {}

    --messages
    logMessages = {}
    visiblelogMessages = {}

    popup_dialog = ''

    --settings
    tile_size = 32

    --load GUI
    GUI:loadGUI()

    Area:generate(1, "test")
    --Area:generate(1, "astray")
  
      --fix spawning in wall
    player_x, player_y = Map:findFreeGrid(1, 1, 5)

    player = Spawn:createPlayer(player_x, player_y)


    --set up gamera
    cam1 = gamera.new(0, 0, Map:getWidth()*32, Map:getHeight()*32)
    local view_w = 10
    local view_h = 10
    cam1:setWindow(120,0,640,640)

    --pass the cam to the stuff that needs to be aware of it
    Mouse:init(cam1, tile_size)

    Map:setupMapView(tile_size)
    
    --load scheduler
    TurnManager:init(entities)
    visible_actors = TurnManager:getVisibleActors()
    s = TurnManager:getSchedulerClass()

    calendar = Calendar.new("data/calendar", "Today is the %s %s of %s DR. The time is %02d:%02d.", 1371, 1, 11)
    game_turn = s:getTime()

    love.timer.sleep(.5)
    setDialog("character_creation")

end

--drawing
function draw_map(l,t,w,h)
   Map:display(l,t,w,h)
end

function draw_map_GUI(tile_size)
  GUI:draw_damage_splashes(tile_size)
  if not mouse_mode then
    GUI:draw_border_mousetile(tile_size)
  else
    --if mouse_mode
    GUI:draw_targeting_overlay()
  end
  if not game_locked then
    if dijkstra then
      GUI:draw_dijkstra_overlay(dijkstra, tile_size)
    end
  end
end

function draw_GUI(player)
  GUI:draw_GUI(player)
  GUI:draw_turns_order()
  GUI:draw_area_name(Area:getAreaName())
  GUI:draw_hotbar()
  GUI:draw_mouse()
  GUI:draw_tip()
  GUI:draw_emotes()
  GUI:draw_log_messages()
  if not game_locked then
    GUI:draw_pause_debug()
  end
  draw_dialogs(player)
end

function drawdebug()
  GUI:draw_schedule()
  GUI:draw_drawstats()
end

function draw_labels(tile_size)
  GUI:draw_labels(tile_size)
end

function draw_dialogs(player)
  --if popup_dialog ~= '' then print("[GAME] popup_dialog is", popup_dialog) end
  if popup_dialog == "character_creation" then 
    GUI:draw_character_creation(player)
  elseif popup_dialog == "inventory" then
    GUI:draw_inventory_test(player)
  elseif popup_dialog == "character_sheet" then
    GUI:draw_character_sheet(player)
  elseif popup_dialog == "skills" then
    GUI:draw_skills_dialog(player)
  elseif popup_dialog == "help_controls" then
    GUI:draw_help_controls()
  elseif popup_dialog == "log" then
    GUI:draw_log_dialog()
  elseif popup_dialog == "chat" then
    GUI:draw_chat(npc_chat)
  end

end

function gamemode.draw()
    love.graphics.setColor(255, 255, 255)
    --camera
    cam1:draw(function(l,t,w,h)
      --map
      draw_map(l,t,w,h)
      draw_map_GUI(tile_size)
      if player and do_draw_labels == true then draw_labels(tile_size) end
  end)

    --camera independent GUI
    if player then draw_GUI(player) end
    if player then drawdebug() end
end


--input
function gamemode.keypressed(k, sc)
    local shift = (love.keyboard.isScancodeDown("lshift") or love.keyboard.isScancodeDown("rshift"))
    if popup_dialog == "inventory" then
      if sc == "escape" then dragged = nil end
    end
    if popup_dialog == "character_creation" then
      if sc == "backspace" then
        GUI:character_creation_keypressed(k)
      end
      if sc == "escape" then
        popup_dialog = "skills" return end
    end
    --if any dialog then
    if popup_dialog ~= '' then
      -- escape to exit
      if sc == "escape" then popup_dialog = '' end
    --no dialogs
    else
      --for actions, check if game is locked before doing anything
      if game_locked then
        if sc == "left" then
          player:PlayerMove("left")
        elseif sc == "right" then
            player:PlayerMove("right")
        elseif sc == "down" then
            player:PlayerMove("down")
        elseif sc == "up" then
            player:PlayerMove("up")
        elseif sc == "." and shift then
            trychangeLevel(player)
        elseif sc == "," and shift then
            trychangeLevel(player)
        elseif sc == "g" then
            player:playerPickup()
        elseif sc == "r" then
            player:playerRest()
        elseif sc == "return" then
            endTurn()
        end
      end
      --dialogs
      if sc == 'i' then
        popup_dialog = 'inventory'
      elseif sc == 'l' then
        popup_dialog = 'log'
      elseif sc == 'c' then
        popup_dialog = "character_sheet"
      elseif sc == "/" and shift then
        popup_dialog = "help_controls"
      --labels
      elseif sc == "tab" then 
        if not do_draw_labels then      
          do_draw_labels = true
        else
          do_draw_labels = false
        end
      --zoom
      elseif sc == "=" and shift then
          --print("We're zooming!")
          tile_size = 64
          Map:setupMapView(tile_size)
          Mouse:init(cam1, tile_size)
      elseif sc == "-" and shift then
          --print("We're zooming out!")
          tile_size = 32
          Map:setupMapView(tile_size)
          Mouse:init(cam1, tile_size)
      end

    end
end

function gamemode.mousepressed(x,y,b)
  print("Calling mousepressed",x,y,b)
  if popup_dialog == '' then
    if b == 1 then 
      if mouse.x > 120 and mouse.y < (love.graphics.getHeight() - 70) then
        if not mouse_mode then
        player:movetoMouse(tile_x, tile_y, player.x, player.y)
        else
           if Map:getCellActor(tile_x, tile_y) then
            a = Map:getCellActor(tile_x, tile_y)
            player:archery_attack(a)
            --nullify mouse mode
            setMouseMode(nil)
          end
        end
      else
        GUI:hotbar_mouse_pressed(x,y,b)
      end
    end
  elseif popup_dialog == "character_creation" then
    GUI:character_creation_mouse_pressed(x,y,b)
  elseif popup_dialog == "skills" then
    GUI:skills_dialog_mouse_pressed(x,y,b)
  elseif popup_dialog == 'inventory' then
      GUI:inventory_mouse_pressed(x,y,b)
  elseif popup_dialog == "chat" then
      GUI:chat_mouse_pressed(x,y,b)
  end
end

function gamemode.focus(f)
  local px = player.x * 32
  local py = player.y * 32
  if f then 
     --print("[GAME] Focus", px, py)
     cam1:setPosition(px, py)
  else
    --print("[GAME] Lock camera on focus lost")
  end
end

function gamemode.textinput(t)
  if popup_dialog == 'character_creation' then
    GUI:character_creation_textinput(t)
  end
end

function updateCamera(dt)
  --print("Player world position", player.x, player.y)
  cam1:setPosition(player.x*tile_size, player.y*tile_size)
end

--update!
function gamemode.update(dt)
  --get mouse coords
    mouse = {
   x = love.mouse.getX(),
   y = love.mouse.getY()
  }
  
  if popup_dialog == '' then
    if mouse.x > 120 and mouse.y < (love.graphics.getHeight() - 70) then
      tile_x, tile_y = Mouse:getGridPosition() --Map:mousetoTile()
    else
      GUI:hotbar_mouse()
    end
  elseif popup_dialog == 'character_creation' then
    GUI:character_creation_mouse()
  elseif popup_dialog == "skills" then
    GUI:skills_dialog_mouse()
  elseif popup_dialog == 'inventory' then
    GUI:inventory_mouse()
  elseif popup_dialog == "chat" then
    GUI:chat_mouse()
  end
  
  rounds()

  if player then
    updateCamera(dt)
  end
end

function schedule()
  visible_actors = {}
  print("[GAME] Clear visible actors")
  TurnManager:schedule()
  visible_actors = TurnManager:getVisibleActors()
end

function rounds()
  TurnManager:rounds()
  schedule_curr = TurnManager:getDebugString()
end

--turn-basedness
function player_lock()
  player:actPlayer()
end

function game_lock()
  game_locked = true
  --clear log
  visiblelogMessages = {}
end

function game_unlock()
  --if game_locked == false then return end
  game_locked = false

  TurnManager:unlocked()
end

function endTurn()
  game_unlock()
  print("[GAME] Ended our turn")
  print_to_log("[GAME] Ended our turn")
end

function removeDead()
  TurnManager:removeDead()
end

function logMessage(color,string)
  table.insert(logMessages,{time=os.clock(),message={color,string}})
  table.insert(visiblelogMessages,{time=os.clock(),message={color,string}})
end

function onTurn()
  --Calendar
  if not day_of_year or day_of_year ~= calendar:getDayOfYear(s:getTime()) then
    logMessage(colors.GOLD, calendar:getTimeDate(s:getTime()))
    day_of_year = calendar:getDayOfYear(s:getTime())
  end
end

function setDialog(str, data)
  print("[GAME] set dialog")
  popup_dialog = str
  if data then
    npc_chat = data
  end
end

function setDijkstra(map)
  --print("[GAME] Set dijkstra")
  dijkstra = map
end

function setMouseMode(mode)
  mouse_mode = mode
end

function trychangeLevel(player)
  if not player.x and player.y then return end

  if Map:getCellTerrain(player.x, player.y).display == ">" or Map:getCellTerrain(player.x, player.y).display == "<" then
    local area_display = Area:getAreaName()
    local split = area_display:split(" : ")
    if split[1] then area = split[1] end
    if split[2] then level = split[2] end
    --print("Area is", area, "lvl", level)
    level = tonumber(level)
    --fix bad turn order display
    entities = {}
    --lock so that no NPCs are trying to move while loading next level
    game_lock()
    setArea(level+1, area)
    --fix spawning in wall
    player_x, player_y = Map:findFreeGrid(1, 1, 5)
    player:move(player_x, player_y)
    Entity:addEntity(player)
    
  else 
    logMessage(colors.WHITE, "There is no way out of this level here")
  end
end

function setArea(level, name)
  if not name or not level then return end
  print("Setting area to", name, "lvl", level)
  Area:generate(level, name)
end