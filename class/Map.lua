require 'T-Engine.class'

local Cell = require 'class.Cell'

module("Map", package.seeall, class.make)

function _M:init(width, height)
    print('Map:initialize', width, height)
    
    self.cells = {}
    self.bounds = { X=0, Y=0, Width=width, Height=height }

    -- Initialize the array of cells
    for x = 0, self.bounds.Width-1 do
        self.cells[x] = {}
        for y = 0, self.bounds.Height-1 do
            self.cells[x][y] = Cell:new()
        end
    end
end


function Map:loadTiles()
    floor = love.graphics.newImage("gfx/tiles/terrain/floor.png")
    wall = love.graphics.newImage("gfx/tiles/terrain/wall.png")
    floor_bright = love.graphics.newImage("gfx/tiles/terrain/floor_bright.png")
    player_tile = love.graphics.newImage("gfx/tiles/player/racial_dolls/human_m.png")
    orc = love.graphics.newImage("gfx/tiles/mobiles/orc.png")
end

function Map:setupMapView()
   --???
   map_w = 2
   map_h = 2
   --scrolling offset
   map_x = 0
   map_y = 0
   --where to draw
   map_offset_x = 120
   map_offset_y = 0
   --size in cells
   map_display_w = Map:getWidth()-1
   map_display_h = Map:getHeight()-1
 
   --tile size
   tile_w = 32
   tile_h = 32
end

function Map:getBounds()
--  print('Map:getBounds')
    return self.bounds
end

-- renamed functions!!
function Map:getCell(x, y)
    --print('Map:getCell', x, y)
    if x > self.bounds.Width - 1 or x < 0 then 
    --  print("ERROR: Tried to get cell of "..x.." which is outside bounds!")
      return end

    if y > self.bounds.Height-1 or y < 0 then
    --  print("ERROR: Tried to get cell of "..y.."which is outside bounds!")
      return end

    if not self.cells[x][y] then
    --  print("ERROR: Tried to get cell of "..x..","..y.."but no such cell!") 
      return end
    return self.cells[x][y]
end

--defaults to setting terrain
function Map:setCell(x, y, value)
   -- print('Map:setCell :', x, y, value)
    self.cells[x][y]:setTerrain(value)
end

function Map:setCellActor(x, y, value)
  --print("Map:setCellActor: ", x, y, value)
  self.cells[x][y]:setActor(value)
end

function Map:setCellObject(x, y, value)
  print("Map:setCellObject: ", x, y, value)
  self.cells[x][y]:setObject(value)
end

--getters
function Map:getCellTerrain(x, y)
  local res
  if not Map:getCell(x,y) then return nil 
  else 
    local cell = Map:getCell(x,y)
    res = cell:getTerrain()
   -- print("Terrain for cell: "..x.." "..y.." is..", res)
    return res
    end
end 

function Map:getCellActor(x,y)
   local res
  if not Map:getCell(x,y) then return nil 
  else 
    local cell = Map:getCell(x,y)
    res = cell:getActor()
    --if res then print("Actor for cell: "..x.." "..y.." is..", res) end
    return res
    end
end

function Map:getCellObject(x,y)
   local res
  if not Map:getCell(x,y) then return nil 
  else 
    local cell = Map:getCell(x,y)
    res = cell:getObject()
    --if res then print("Object for cell: "..x.." "..y.." is..", res) end
    return res
    end
end

--bounds
function Map:getWidth()
--  print('Map:getWidth')
    return self.bounds.Width
end
function Map:getHeight()
--  print('Map:getHeight')
    return self.bounds.Height
end

--convert terrain symbols to tiles
function Map:convertTerraintoTile(x, y)
  if not Map:getCellTerrain(x,y) then tile = floor_bright 
  else
    local string = Map:getCellTerrain(x, y)
      if string == "." then tile = floor end
      if string == "#" then tile = wall end
    end
    
    --print("Tile gotten for x: "..x.."y: "..y)
    return tile
end

--assume we already checked if there is an actor at x,y
function Map:convertActortoTile(x,y)
  local string = Map:getCellActor(x,y)
  if string == "player_tile" then tile = player_tile end
  if string == "orc" then tile = orc end
  --print ("Actor tile gotten for x: "..x.."y: "..y)
  return tile
end



--assume we already checked if there is an actor at x,y
function Map:convertObjecttoTile(x,y)
  local string = Map:getCellObject(x,y)
  if string == "longsword" then tile = longsword end
  --print ("Object tile gotten for x: "..x.."y: "..y)
  return tile
end

function Map:display()
  for y=0, Map:getWidth()-1 do
      for x=0, Map:getHeight()-1 do                                                      
         --print("Querying: ", x, map_x, y, map_y)
         --draw terrain
         love.graphics.draw(
            Map:convertTerraintoTile(x+map_x, y+map_y),
            (x*tile_w)+map_offset_x, 
            (y*tile_h)+map_offset_y)
         --check if we have any objects to draw
         if Map:getCellObject(x,y) then
            --if yes then draw
            love.graphics.draw(
              Map:convertObjecttoTile(x+map_x, y+map_y),
              (x*tile_w)+map_offset_x, 
              (y*tile_h)+map_offset_y)
          end
         --check if we have any actors to draw
         if Map:getCellActor(x,y) then
            --if yes then draw
            love.graphics.draw(
              Map:convertActortoTile(x+map_x, y+map_y),
              (x*tile_w)+map_offset_x, 
              (y*tile_h)+map_offset_y)
          end
      end
   end
end