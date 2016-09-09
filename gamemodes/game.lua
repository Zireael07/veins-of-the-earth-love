-- gamemode for LOVE to handle the game itself
gamemode = {}

ROT=require 'libraries/rotLove/rotLove'

require 'class.Area'
require 'class.Map'
require 'class.Player'


function gamemode.load()
    --load tiles
    Map:loadTiles()

    --area = Area.new()
    Area:generate(1, 20, 20)

    Map:setupMapView()
    
    player = Player.new()
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
    end
end