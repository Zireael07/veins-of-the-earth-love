require 'T-Engine.class'

require 'class.Map'

--pathfinding stuff
local Grid = require ("libraries.jumper.grid") -- The grid class
local Pathfinder = require ("libraries.jumper.pathfinder") -- The pathfinder class
local Path = require ("libraries.jumper.core.path") --Path smoothing

module("Pathfinding", package.seeall, class.make)

--0 is walkable, 1 is unwalkable (see Jumper)
function Pathfinding:create(map)
    local _map = {}

    for y=0, Map:getWidth()-1 do
      for x=0, Map:getHeight()-1 do
         _map[x] = _map[x] or {}                                                      
         --print("[PATH] Querying: ", x, y)
         if Pathfinding:isunWalkable(x,y) then
            _map[x][y] = 1
            --print("[PATH] "..x.." "..y.." is unwalkable")
         else
            _map[x][y] = 0
            --print("[PATH] "..x.." "..y.." is walkable")
         end
      end
   end

    return _map
end

function Pathfinding:isunWalkable(x, y)
  if not Map:getCellTerrain(x,y) then return true
  else
    local string = Map:getCellTerrain(x,y)
    if string == "." then return false end
  end 
end

function Pathfinding:getMap(map)
    --print_to_log("[Pathfinding] We have got an area map")
    return map
end

function Pathfinding:debugMap(map)
    for x,v in pairs(map) do
        for y, v in pairs(v) do
        --print(k,v)
        print(x,y,v)
        end
    end
end

function Pathfinding:findPath(x, y, self_x, self_y)
  print("[Pathfinding] trying to find a path")
-- First, set a collision map
--see Area:29
local map = Area:getAreaMap()
--Pathfinding:debugMap(map)

-- Value for walkable tiles
local walkable = 0
 
-- Creates a grid object
local my_grid = Grid(map) 


-- Creates a pathfinder object using Jump Point Search
local myFinder = Pathfinder(my_grid, 'JPS', walkable) 

--pass the coords
local startx, starty = self_x,self_y
local endx, endy = x,y
print("Start x y are:", self_x, self_y)
print("Target x and y are: ", x, y)
 
 --safety
if not startx or not starty then return end 
-- Calculates the path, and its length

local path, length = myFinder:getPath(startx, starty, endx, endy)
if path then
  if length > 1 then
    path:fill()
  end
  print(('Path found! Length: %.2f'):format(length))
    for node, count in path:iter() do
      print(('Step: %d - x: %d - y: %d'):format(count, node.x, node.y))
    end
end


  return path
end

function Pathfinding:findPathDijkstra(target_x, target_y, self_x, self_y, width, height)
    player_dijkstra_map = Pathfinding:makeDijkstraMap(target_x, target_y, self_x, self_y, width, height)

    dir_x, dir_y = player_dijkstra_map:dirTowardsGoal(self_x,self_y)
    if dir_x == nil then dir_x = 0 end
    if dir_y == nil then dir_y = 0 end
    --print("[DIJKSTRA] return", dir_x, dir_y)

    return dir_x, dir_y
end

function isTilePassable(x,y)
  --print("Calling isTilePassable, x", x, "y", y)
  if x == nil or y == nil then 
    print("ERROR: invalid coords for passability check") return
  end

  if Map:getCell(x, y) then
    if Map:getCellTerrain(x,y).display == "." then return true 
    else return false end
    if Map:getCellActor(x,y) then return false end

    if x ~= self_x and y ~= self_y then return true end
  end

  return false
end

function Pathfinding:makeDijkstraMap(target_x, target_y, self_x, self_y, width, height)
    print("[DIJKSTRA] target x: ", target_x, "y", target_y, "self x", self_x, "y: ", self_y, "width", width, "height", height)
    player_dijkstra_map = ROT.DijkstraMap:new(target_x, target_y, width, height, isTilePassable)
    player_dijkstra_map:compute()
    --player_dijkstra_map:writeMapToConsole()

    temp_string = player_dijkstra_map:writeMapToConsole(true)

    map_string = Pathfinding:setDijkstraString(temp_string)
    dijkstra = Pathfinding:parseDijkstraString(map_string)
    setDijkstra(dijkstra)

    return player_dijkstra_map
end

function Pathfinding:setDijkstraString(str)
    map_string = str
    --print("[DIJKSTRA] Our string is", map_string)
    return map_string
end

function Pathfinding:getDijkstraString()
    return map_string
end

function Pathfinding:parseDijkstraString(str)
  dijkstra = {}

  local rows = str:split("\n")
  for i= 1, #rows do
    local row = rows[i]
    --print("Row #", i, "is", row)
    dijkstra[i] = {} --this is our y parameter
    local x = 0
      for s in string.gmatch(row, "%d+") do     
        x = x + 1
        --print("Value in row is", s, "x is", x)
        dijkstra[i][x] = s
    end
  end

  return dijkstra
end

function Pathfinding:getValuesFromMap(map, x, y)
    local val
    val = map[y][x]
    print("Val for x", x, 'y', y, "is", val)
    return val
end

function Pathfinding:selectPathNodeColor(map, x,y)
    val = Pathfinding:getValuesFromMap(map, x, y)
    val = tonumber(val)

    values_to_colors = {
    [0] = "YELLOW",
    [1] = "YELLOW",
    [2] = "ORANGE",
    [3] = "RED",
    [4] = "RED",
    [5] = "LIGHT_RED",
    [6] = "VIOLET",
    [7] = "DARK_ORCHID",
    [8] = "PURPLE",
    [9] = "BLUE"
}

    local color
    if values_to_colors[val] then
        color = values_to_colors[val]
    else
        color = "DARK_BLUE"
    end
    print("Djikstra color is", color)
    return color
end

return Pathfinding