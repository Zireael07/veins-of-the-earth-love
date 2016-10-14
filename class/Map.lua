require 'T-Engine.class'

local Cell = require 'class.Cell'

module("Map", package.seeall, class.make)

function _M:init(width, height)
    print('Map:initialize', width, height)
    
    self.cells = {}
    self.bounds = { X=0, Y=0, Width=width, Height=height }

    -- Initialize the array of cells
    --Need to start at 1 because that's what Dijkstra wants
    for x = 1, self.bounds.Width-1 do
        self.cells[x] = {}
        for y = 1, self.bounds.Height-1 do
            self.cells[x][y] = Cell:new()
        end
    end
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
    if x > self.bounds.Width - 1 or x < 1 then 
    --  print("ERROR: Tried to get cell of "..x.." which is outside bounds!")
      return end

    if y > self.bounds.Height-1 or y < 1 then
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
  if not Map:getCellTerrain(x,y) then tile = loaded_tiles["floor_bright"]
  else
    local string = Map:getCellTerrain(x, y).display
  --  print("Cell terrain string is ", string)
      if string == "." then tile = loaded_tiles["floor"] end
      if string == "#" then tile = loaded_tiles["wall"] end
    end
    
  --  print("Tile gotten for x: "..x.."y: "..y)
    return tile
end

--assume we already checked if there is an actor at x,y
function Map:convertActortoTile(x,y)
  local string = Map:getCellActor(x,y).image

  tile = loaded_tiles[string]

  --print ("Actor tile gotten for x: "..x.."y: "..y)
  return tile
end



--assume we already checked if there is an actor at x,y
function Map:convertObjecttoTile(x,y)
  local string = Map:getCellObject(x,y).image

  tile = loaded_tiles[string]

  --print ("Object tile gotten for x: "..x.."y: "..y)
  return tile
end

--FOV
function Map:isTileVisible(x,y)
  if not Map:getCell(x,y) then return false 
  else
    cell = Map:getCell(x,y)
    return cell:isVisible()
  end
end 

function Map:setTileVisible(x,y, val)
  if not Map:getCell(x,y) then return end
--  print("Map:setTileVisible: ", x, y, val)
  self.cells[x][y]:setVisible(val)
end

function Map:isTileSeen(x,y)
  if not Map:getCell(x,y) then return false 
  else
    cell = Map:getCell(x,y)
    return cell:isSeen()
  end
end 

function Map:setTileSeen(x,y, val)
  if not Map:getCell(x,y) then return end
--  print("Map:setTileSeen: ", x, y, val)
  self.cells[x][y]:setSeen(val)
end

function Map:unitIndicatorCircle(x,y, val)
  if val == "player" or val == "helpful" then
    love.graphics.setColor(0, 255, 255)
  elseif val == "friendly" then 
    love.graphics.setColor(0, 255, 0)
  elseif val == "neutral" then 
    love.graphics.setColor(255, 255, 0)
  elseif val == "unfriendly" then 
    love.graphics.setColor(255, 119,0)
  elseif val == "hostile" then
    love.graphics.setColor(255, 0, 0)
  end 
  love.graphics.ellipse('line', x, y, 15, 6)
end

function Map:unitIndicatorSquare(x,y, val)
  if val == "player" then
    love.graphics.setColor(0, 255, 255)
  else 
    love.graphics.setColor(255, 0, 0)
  end 
  love.graphics.rectangle('line', x, y, tile_h+1, tile_w+1)
end


function Map:drawHex(x,y, size)
  local lastX = nil
  local lastY = nil
  for i=0,6 do
    local angle = 2 * math.pi / 6 * (i + 0.5)
    local x = x + size * math.cos(angle)
    local y = y + size * math.sin(angle)
    if i > 0 then
      love.graphics.line(lastX, lastY, x, y)
    end
    lastX = x
    lastY = y
  end
end



--actual display happens here
function Map:display()
  for y=1, Map:getWidth()-1 do
      for x=1, Map:getHeight()-1 do                                                      
         --print("Querying: ", x, map_x, y, map_y)
         --do we see the tile
         if Map:isTileSeen(x,y) or Map:isTileVisible(x,y) then
            --shade
            if not Map:isTileVisible(x,y) then love.graphics.setColor(128,128,128)
            else love.graphics.setColor(255,255,255) end
           --draw terrain
           love.graphics.draw(
              Map:convertTerraintoTile(x+map_x, y+map_y),
              (x*tile_w)+map_offset_x, 
              (y*tile_h)+map_offset_y)
           --draw grid
           --love.graphics.setColor(0,0,0)
           love.graphics.setColor(51, 25, 0)
           love.graphics.rectangle('line', (x*tile_w)+map_offset_x, (y*tile_h)+map_offset_y, tile_h, tile_w)
           --reset color
           love.graphics.setColor(255,255,255)
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
                --attitude indicator
                local circle_x = x*32+16+120
                local circle_y = y*32+26+0
                local a = Map:getCellActor(x,y)
                if a.player then  
                    Map:unitIndicatorCircle(circle_x, circle_y, "player")
                else
                    Map:unitIndicatorCircle(circle_x, circle_y, a:indicateReaction())
                end
              --reset color
              love.graphics.setColor(255,255,255)
              --if actor then draw
              love.graphics.draw(
                Map:convertActortoTile(x+map_x, y+map_y),
                (x*tile_w)+map_offset_x, 
                (y*tile_h)+map_offset_y)
            end
          end
          --reset color
          love.graphics.setColor(255, 255, 255)
      end
   end
end

--needed for scrolling
function Map:getPixelDimensions()
  local w, h = (Map:getWidth()-1)*32, (Map:getHeight()-1)*32
  --print("[Map] Map pixel dimensions", w, h)
  return w, h
end

function Map:findFreeGrid(sx, sy, radius)
    for y=1, Map:getWidth()-1 do
      for x=1, Map:getHeight()-1 do 
        if utils:distance(sx, sy, x, y) < radius then
          if Map:getCellTerrain(x,y).display ~= "#" then 
            print_to_log("[MAP]: Found a free grid: "..x.." "..y)
            return x, y end
        end
      end
  end
end

return Map