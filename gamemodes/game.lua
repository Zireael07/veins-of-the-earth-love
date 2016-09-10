-- gamemode for LOVE to handle the game itself
gamemode = {}

ROT=require 'libraries/rotLove/rotLove'

require 'class.Area'
require 'class.Map'
require 'class.Player'
require 'class.Entity'

function gamemode.load()
    --list of entities
    entities = {}
    --load tiles
    Map:loadTiles()

    --area = Area.new()
    Area:generate(1, 20, 20)

    Map:setupMapView()
    
    player = Player.new()
    Entity:addEntity(player)
    
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

--shorthand
function celltotile(x, y)
    return Map:convertTerraintoTile(x,y)
end

function gamemode.draw()
    love.graphics.setColor(255, 255, 255)
    draw_map()
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
    elseif k == "return" then
        endTurn()
    end
end

--update!
function gamemode.update()
  rounds()
end

function rounds()
    --do nothing if we're locked (waiting for player to finish turn)
    if game_locked then return end
      love.timer.sleep(.5)
    --gets the number
    c  =s:next()
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
end

function game_unlock()
  if game_locked == false then return end
  game_locked = false

  for i=1,#entities do
    local item = entities[i]
    if item['act'] then item:act() end
  end
end

function endTurn()
  game_unlock()
  print("[GAME] Ended our turn")
end