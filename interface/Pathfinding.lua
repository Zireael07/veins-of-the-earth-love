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
    print("We are getting a map")
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

return Pathfinding