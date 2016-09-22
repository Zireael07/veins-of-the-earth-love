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
  GUI:draw_mouse()
  GUI:draw_tip()
  GUI:draw_log_messages()
  --GUI:draw_inventorytest()
end

function drawdebug()
  GUI:draw_schedule()
  GUI:draw_drawstats()
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
    if k == "left" then
      player:PlayerMove("left")
       --[[map_x = map_x-1
       if map_x -1 < 0 then map_x = 0 end
       print("Pressed left key, map_x: ", map_x)]]
    elseif k == "right" then
        player:PlayerMove("right")
       --[[ map_x = map_x +1
        if map_x > map_display_w then map_x = map_display_w end
        print("Pressed right key, map_x: ", map_x)]]
    elseif k == "down" then
        player:PlayerMove("down")
        --[[map_y = map_y+1
        if map_y > map_h+map_display_h then map_y = map_h+map_display_h end
        print("Pressed down key, map_y: ", map_y)]]
    elseif k == "up" then
        player:PlayerMove("up")
        --[[map_y = map_y-1
        if map_y < 0 then map_y = 0 end
        print("Pressed up key, map_y: ", map_y)]]
    elseif k == "g" then
        player:playerPickup()
    elseif k == "return" then
        endTurn()
    end
end

function gamemode.mousepressed(x,y,b)
  print("Calling mousepressed",x,y,b)
  if b == 1 then player:movetoMouse(tile_x, tile_y, player.x, player.y) end
end

--update!
function gamemode.update()
  --get mouse coords
    mouse = {
   x = love.mouse.getX(),
   y = love.mouse.getY()
  }
  tile_x, tile_y = Map:mousetoTile()
  
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