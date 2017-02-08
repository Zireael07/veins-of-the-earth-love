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

function Map:setupMapView(tile_size)
   --size in cells
   map_display_w = Map:getWidth()-1
   map_display_h = Map:getHeight()-1
 
   --tile size
   tile_w = tile_size
   tile_h = tile_size
end

function Map:getBounds()
--  print('Map:getBounds')
    return self.bounds
end

-- renamed functions!!
function Map:getCell(x, y)
    if not x then return end
    if not y then return end
    --print('Map:getCell', x, y)
    if x > Map:getWidth()-1 or x < 1 then 
    --  print("ERROR: Tried to get cell of "..x.." which is outside bounds!")
      return end

    if y > Map:getHeight()-1 or y < 1 then
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
  local i = 1
  while self.cells[x][y]:getObject(i) do i = i + 1 end
  self.cells[x][y]:setObject(value, i)
  print("Object index is ", i, "val", value)
end

function Map:setCellObjectbyIndex(x,y,value, i)
  print("Map:setCellObjectbyIndex: ", x, y, value, i)
  self.cells[x][y]:setObject(value, i)
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

function Map:getCellObject(x,y, i)
   local res
  if not Map:getCell(x,y) then return nil 
  else 
    local cell = Map:getCell(x,y)
    res = cell:getObject(i)
    --if res then print("Object for cell: "..x.." "..y.." is..", res) end
    return res
    end
end

function Map:getCellObjects(x,y)
     local res
    if not Map:getCell(x,y) then return nil 
    else 
    local cell = Map:getCell(x,y)
    res = cell:getObjects()
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
    local image = Map:getCellTerrain(x,y).image or nil
      --theming
      if image then
        tile = loaded_tiles[image]
      else
        --failsafes
        if string == "." then tile = loaded_tiles["floor"] end
        if string == "#" then tile = loaded_tiles["wall"] end
        if string == "+" then tile = loaded_tiles["door"] end
        if string == ">" then tile = loaded_tiles["stairs_down"] end
        if string == "<" then tile = loaded_tiles["stairs_up"] end
      end
    end
    
  --  print("Tile gotten for x: "..x.."y: "..y)
    return tile
end

--assume we already checked if there is an actor at x,y
function Map:convertActortoTile(x,y)
  local string = Map:getCellActor(x,y).image
  
  if tile_h == 64 then
    tile = loaded_tiles[string.."_large"]
  else
    tile = loaded_tiles[string]
  end

  --safeguard
  if not tile then
    print("Couldn't find tile for "..Map:getCellActor(x,y).name..", size: "..tile_h)
    if tile_h == 64 then
     tile = loaded_tiles["human_large"]
    else
      tile = loaded_tiles["human"]
    end
  end
  --print ("Actor tile gotten for x: "..x.."y: "..y)
  return tile
end



--assume we already checked if there is an actor at x,y
function Map:convertObjecttoTile(x,y, i)
  local string = Map:getCellObject(x,y,i).image

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
  love.graphics.ellipse('line', x, y, 0.46*tile_w, 0.19*tile_h)
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
--x,y,w,h from gamera
function Map:display(x,y,w,h)
  local left, top = Map:getPixeltoTile(x,y)                                                     
  local right, bottom = left + w/tile_w, top + h / tile_h
  for x =left, right do
    for y = top, bottom do
         --print("Drawing X within : ", left, right, " Y within", top, bottom)
         --do we see the tile
         if Map:isTileSeen(x,y) or Map:isTileVisible(x,y) then
            --shade
            if not Map:isTileVisible(x,y) then love.graphics.setColor(128,128,128)
            else love.graphics.setColor(255,255,255) end
           --draw terrain
           if tile_h == 32 then
           love.graphics.draw(
              Map:convertTerraintoTile(x, y),
              x*tile_w, 
              y*tile_h)
          else
            --scale terrain in zoomed mode
            love.graphics.draw(
              Map:convertTerraintoTile(x, y),
              x*tile_w, 
              y*tile_h, 0, 2, 2)
          end
           --draw grid
           --love.graphics.setColor(0,0,0)
           love.graphics.setColor(51, 25, 0)
           love.graphics.rectangle('line', (x*tile_w), (y*tile_h), tile_h, tile_w)
         end
         if Map:isTileVisible(x,y) then
           --reset color
           love.graphics.setColor(255,255,255)
           --check if we have any objects to draw
           if Map:getCellObjects(x,y) then
              --if yes then draw
              if Map:getCell(x,y):getNbObjects() > 1 then
                --print("We have more than one object in cell", x,y)
                if tile_h == 32 then
                love.graphics.draw(
                  --should be the topmost item
                  Map:convertObjecttoTile(x,y,2),
                  (x*tile_w), 
                  (y*tile_h))
                else
                  --special case for offsetting objects in zoomed mode
                  love.graphics.draw(
                  Map:convertObjecttoTile(x,y,2),
                  (x*tile_w), 
                  (y*tile_h), 0, 1, 1, 0, -(tile_h/2))
                end
              else
              if tile_h == 32 then
              love.graphics.draw(
                Map:convertObjecttoTile(x,y, 1),
                (x*tile_w), 
                (y*tile_h))
              else
                --special case for offsetting objects in zoomed mode
                love.graphics.draw(
                  Map:convertObjecttoTile(x,y,1),
                  (x*tile_w), 
                  (y*tile_h), 0, 1, 1, 0, -(tile_h/2))
              end
              end
            end  
           --check if we have any actors to draw
           if Map:getCellActor(x,y) then
                --attitude indicator
                local circle_x = x*tile_h+0.5*tile_w
                local circle_y = y*tile_w+0.81*tile_h
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
                Map:convertActortoTile(x, y),
                (x*tile_w), 
                (y*tile_h))
            end
          end
          --reset color
          love.graphics.setColor(255, 255, 255)
      end
   end
end


--needed for scrolling
function Map:getPixelDimensions()
  local w, h = (Map:getWidth()-1)*tile_w, (Map:getHeight()-1)*tile_h
  --print("[Map] Map pixel dimensions", w, h)
  return w, h
end

function Map:getPixeltoTile(x,y)
  local x, y = math.floor(x/tile_w), math.floor(y/tile_h)
  return x, y
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

function Map:findRandomStandingGrid()
    local x, y = rng:random(1, Map:getHeight()-1), rng:random(1, Map:getWidth()-1)
    local found_x, found_y = 0

    local tries = 0
    while Map:getCellTerrain(x,y).display ~= "." do --and tries < 1000 do
      x, y = rng:random(1, Map:getHeight()-1), rng:random(1, Map:getWidth()-1)
      tries = tries + 1
    end
    --if tries < 1000 then
      found_x = x
      found_y = y  
      print("Random standing grid",x, y)
    --end
    return found_x, found_y
end

function Map:findGrid(terrain)
    for y=1, Map:getWidth()-1 do
      for x=1, Map:getHeight()-1 do
        local string = Map:getCellTerrain(x, y).display
        if string == terrain then
          return x,y
        end
      end
    end
end

function Map:drawMaptoLog()
  title = title or ''
  print_to_log("================================ " .. title .. " ============================================================")
  for y=1,#self.cells[2],1 do 
    local line = ''
    for x=1,#self.cells,1 do
      if self.cells[x][y] ~= nil then
        local cell = Map:getCell(x,y)
        if cell then
          line = line .. Map:getCellTerrain(x, y).display
        end
      end
    end
    print_to_log(line .. " = line #" .. y)
  end
  print_to_log("map supplied was " .. #self.cells[2] .. " (columns/first dimension) x " .. #self.cells[1] .. " (rows/second)")
  print_to_log("============================================================================================================")
end

return Map