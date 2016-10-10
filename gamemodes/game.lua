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

local CameraHandler = require 'interface.CameraHandler'
local Mouse = require 'class.Mouse'

function gamemode.load()
    --list of entities
    entities = {}

    --messages
    logMessages = {}
    visiblelogMessages = {}

    popup_dialog = ''

    --load GUI
    GUI:loadGUI()

    --area = Area.new()
    Area:generate(1, 20, 20)
  
      --fix spawning in wall
    player_x, player_y = Map:findFreeGrid(1, 1, 5)

    player = Spawn:createPlayer(player_x, player_y)

    camera = CameraHandler.new(player.x * 32, player.y * 32)
    --pass the cam to the stuff that needs to be aware of it
    Mouse:init( camera )
    GUI:init(player, camera)


    Map:setupMapView()
    
    --load scheduler
    s  =ROT.Scheduler.Action:new()
    --put entities into scheduler
    for i, e in ipairs(entities) do
      s:add(i,true,i-1) 
    end

    calendar = Calendar.new("data/calendar.lua", "Today is the %s %s of %s DR. \nThe time is %02d:%02d.", 1371, 1, 11)
  
    love.timer.sleep(.5)
    setDialog("character_creation")
end

--drawing
function draw_map()
   Map:display()
end

function draw_GUI(player, camera)
  GUI:draw_GUI(player)
  GUI:draw_damage_splashes()
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

function draw_labels()
  GUI:draw_labels()
end

function draw_dialogs(player)
  --if popup_dialog ~= '' then print("[GAME] popup_dialog is", popup_dialog) end
  if popup_dialog == "character_creation" then 
    GUI:draw_character_creation(player)
  elseif popup_dialog == "inventory" then
    GUI:draw_inventory_test(player)
  elseif popup_dialog == "log" then
    GUI:draw_log_dialog()
  elseif popup_dialog == "chat" then
    GUI:draw_chat(npc_chat)
  end

end

--shorthand
function celltotile(x, y)
    return Map:convertTerraintoTile(x,y)
end

function gamemode.draw()
    love.graphics.setColor(255, 255, 255)
    --camera
    camera:attach()
    --map
    draw_map()
    --detach
    camera:detach()
    --GUI
    if player and camera then draw_GUI(player, camera) end
    if player then drawdebug() end
    if player and do_draw_labels == true then draw_labels() end
end


--input
function gamemode.keypressed(k)
    if popup_dialog == "inventory" then
      print("Pressed key in inventory", k)
      if k == "escape" then dragged = nil end
    end
    --if any dialog then
    if popup_dialog ~= '' then
      -- escape to exit
      if k == "escape" then popup_dialog = '' end
    --no dialogs
    else
      --for actions, check if game is locked before doing anything
      if game_locked then
        if k == "left" then
          player:PlayerMove("left")
        elseif k == "right" then
            player:PlayerMove("right")
        elseif k == "down" then
            player:PlayerMove("down")
        elseif k == "up" then
            player:PlayerMove("up")
        elseif k == "g" then
            player:playerPickup()
        elseif k == "return" then
            endTurn()
        end
      end
      --dialogs
      if k == 'i' then
        popup_dialog = 'inventory'
      elseif k == 'l' then
        popup_dialog = 'log'
      --labels
      elseif k == "tab" then 
        if not do_draw_labels then
        --print("Do draw labels...")       
          do_draw_labels = true
        else
          do_draw_labels = false
        end
      end

    end
end

function gamemode.mousepressed(x,y,b)
  print("Calling mousepressed",x,y,b)
  if popup_dialog == '' then
    if b == 1 then player:movetoMouse(tile_x, tile_y, player.x, player.y) end
  elseif popup_dialog == "character_creation" then
    GUI:character_creation_mouse_pressed(x,y,b)
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
     print("[GAME] Focus", px, py)
    camera:lookAt( math.floor( px ), math.floor( py )) 
  else
    camera:lock()
    print("[GAME] Lock camera on focus lost")
  end
end

--update!
function gamemode.update(dt)
  --camera
  camera:update(dt)

  --get mouse coords
    mouse = {
   x = love.mouse.getX(),
   y = love.mouse.getY()
  }
  
  if popup_dialog == '' then
    tile_x, tile_y = Mouse:getGridPosition() --Map:mousetoTile()
  elseif popup_dialog == 'character_creation' then
    GUI:character_creation_mouse()
  elseif popup_dialog == 'inventory' then
    GUI:inventory_mouse()
  elseif popup_dialog == "chat" then
    GUI:chat_mouse()
  end
  
  --removeDead()
  --schedule()
  rounds()
end

function schedule()
  print("Cleaning up the scheduler...")
  --clear the scheduler
  s:clear()
  

  --put entities into scheduler
   for i, e in ipairs(entities) do
      s:add(i,true,i-1) 
      --print("[Scheduler] Added: ", i, e)
   end
end

function rounds()
    --do nothing if we're locked (waiting for player to finish turn)
    if game_locked then return end
      love.timer.sleep(.5)
    --gets the number
    c  =s:next()
    --handle removed entities
    --[[if not entities[c] then 
      
      if c > #entities then
        c=1 
      --go back to number 1
      --if less than total, just advance on
      else
        c=c+1
      end
    end]]
    
    --test 
    curr_ent = entities[c]
    --debug display
    local name = curr_ent.name

    dur=10 --test
    s:setDuration(dur)

    --used by debug display
    if s then
      local time_elapsed = s:getTime()
      schedule_curr = "TIME: "..time_elapsed
    end
    schedule_curr = "["..schedule_curr.."] TURN: "..curr_ent.name.." ["..c.."] for "..dur.." units of time"
    if curr_ent.player == true then 
      game_lock()
      if s:getTime() > 0 then onTurn() end
      schedule_curr = "PLAYER "..schedule_curr end
    --draw_y= draw_y< 400 and draw_y +10 or 200
end

--turn-basedness
function game_lock()
  game_locked = true
  --unlock camera
  camera:unlock();
  camera:restorePosition();
  --clear log
  visiblelogMessages = {}
end

function game_unlock()
  if game_locked == false then return end
  game_locked = false
  --lock camera
  camera:lock();
  camera:storePosition();

  for i=1,#entities do
    local item = entities[i]
    if item['act'] then item:act() end
  end

    removeDead()
    schedule()
end

function endTurn()
  game_unlock()
  print("[GAME] Ended our turn")
end

function removeDead()
  for i=#entities,1,-1 do
    local item = entities[i]
    if item.dead then
      print("Removing entity from list", i, item.name)
      table.remove(entities, i)
      --remove from scheduler, too
      if s:remove(i) then print("Removed from scheduler", i) end
    end
  end
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