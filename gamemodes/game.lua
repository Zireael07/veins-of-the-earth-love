-- gamemode for LOVE to handle the game itself
gamemode = {}

ROT=require 'libraries/rotLove/rotLove'

require 'class.Area'
require 'class.Map'
require 'class.Player'
local GUI = require 'class.PlayerGUI'
require 'class.Entity'

function gamemode.load()
    --list of entities
    entities = {}

    --messages
    logMessages = {}

    popup_dialog = ''

    --load tiles
    Map:loadTiles()
    --load GUI
    GUI:loadGUI()

    --area = Area.new()
    Area:generate(1, 20, 20)
  
      --fix spawning in wall
    player_x, player_y = Map:findFreeGrid(1, 1, 5)

    player = Spawn:createPlayer(player_x, player_y)

    Map:setupMapView()
    
    --load scheduler
    s  =ROT.Scheduler.Action:new()
    --put entities into scheduler
    for i, e in ipairs(entities) do
      s:add(i,true,i-1) 
    end
end

--drawing
function draw_map()
   Map:display()
end

function draw_GUI(player)
  GUI:draw_GUI(player)
  GUI:draw_unit_indicator()
  GUI:draw_mouse()
  GUI:draw_tip()
  GUI:draw_log_messages()
  draw_dialogs(player)
end

function drawdebug()
  GUI:draw_schedule()
  GUI:draw_drawstats()
end

function draw_dialogs(player)
  if popup_dialog == "inventory" then
    GUI:draw_inventory_test(player)
  end
end

--shorthand
function celltotile(x, y)
    return Map:convertTerraintoTile(x,y)
end

function gamemode.draw()
    love.graphics.setColor(255, 255, 255)
    draw_map()
    if player then draw_GUI(player) end
    if player then drawdebug() end
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
      --dialogs
      elseif k == 'i' then
        popup_dialog = 'inventory'
      end

    end
end

function gamemode.mousepressed(x,y,b)
  print("Calling mousepressed",x,y,b)
  if popup_dialog == '' then
    if b == 1 then player:movetoMouse(tile_x, tile_y, player.x, player.y) end
  elseif popup_dialog == 'inventory' then
      GUI:inventory_mouse_pressed(x,y,b)
  end
end

--update!
function gamemode.update()
  --get mouse coords
    mouse = {
   x = love.mouse.getX(),
   y = love.mouse.getY()
  }
  
  if popup_dialog == '' then
    tile_x, tile_y = Map:mousetoTile()
  elseif popup_dialog == 'inventory' then
    GUI:inventory_mouse()
  end
  
  --removeDead()
  --schedule()
  rounds()
end

function schedule()
  --clear the scheduler
  s:clear()
  print("Clear the scheduler")

  --put entities into scheduler
   for i, e in ipairs(entities) do
      s:add(i,true,i-1) 
      print("[Scheduler] Added: ", i, e)
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
    schedule_curr = "TURN: "..curr_ent.name.." ["..c.."] for "..dur.." units of time"
    if curr_ent.player == true then 
      game_lock()
      schedule_curr = "PLAYER "..schedule_curr end
    --draw_y= draw_y< 400 and draw_y +10 or 200
end

--turn-basedness
function game_lock()
  game_locked = true
  --clear log
  logMessages = {}
end

function game_unlock()
  if game_locked == false then return end
  game_locked = false

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
end