require 'T-Engine.class'

require 'class.Map'
local Grid = require 'class.Grid'
local Spawn = require 'class.Spawn'
local Encounter = require 'class.Encounter'
require 'interface.Pathfinding'

local astray=require 'libraries/astray/astray'

module("Area", package.seeall, class.make)

dungeon = {}

function _M:init()
  dungeon = {}
end

function _M:generate(level, name)
  print("Generating dungeon :", name, "lvl", level)
  dungeon[level] = {}
  dungeon[level].width = width
  dungeon[level].height = height
  dungeon[level].map = {}
  
  if area_types[name] then
    --print("Getting parameters from data", name)
    local area = area_types[name]
    if not area.width or not area.height then print("No are width or height specified") end
    width = area.width
    height = area.height
  end
  --remember to init the map
  Map:init(width+1, height+1)
  
  --loading from data
  if area_types[name] then
    --print("Creating area from data", name)
    local area = area_types[name]
    if area.setup ~= nil then
      area:setup(area)
    end

    self:setAreaName(name, level)

    --these require a map, so move here for safety
    Area:placeRandomStairs(area, "down")
    if level > 1 then
      Area:placeRandomStairs(area, "up")
    end

    Area:getAreaMap()
    if path_map then print_to_log("Created a path_map successfully!")  end

    Area:spawnStuff()
    Area:spawnTest()

    --test
    Encounter:getNPCsByCR(1/2)
    local encounter = Encounter:makeEncounter()
    local tx, ty = Map:findRandomStandingGrid()
    Spawn:createEncounter(encounter, tx,ty)
    local tx, ty = Map:findRandomStandingGrid()
    Spawn:createEncounter(encounter, tx,ty)

    Map:drawMaptoLog()
  end
  
  
end

function Area:setAreaName(name, level)
  curr_area = name.." : "..level
end

function Area:getAreaName()
  if curr_area then
    return curr_area
  else
    return nil
  end
end

--Simple area generation
function Area:fillWalls(area, width, height)
  for x=1, width do
    for y=1, height do
      Area:placeTerrain(x, y, ".", area)
    end
  end
end

function Area:makeWalled(area, width, height)
 for x=1, width do
    for y=1, height do
      local empty= x>1 and y>1 and x<width and y<height
      if empty then Area:placeTerrain(x,y, ".", area)
      else Area:placeTerrain(x,y, "#", area)
      end
    end
  end
end

--requires A* checking!
function Area:makeRandom(area, width, height)
  for x=1, width do
    for y=1, height do
      local str = rng:random(1,2) == 1 and "." or "#"
      Area:placeTerrain(x, y, str, area)
    end
  end
end

function Area:makeAstray(area, width, height)
  local symbols = {Wall="#", Empty=".", DoorN="+", DoorS="+", DoorE="+", DoorW="+"}

  local generator = astray.Astray:new( width-1, height-1, 80, 70, 100, astray.RoomGenerator:new(4,2,3,2,3) )
  local dungeon = generator:Generate()
  local tmp_tilemap = generator:CellToTiles(dungeon, symbols )
  -- the astray generator begins its tilemap at row 0 and column 0 instead of row 1 and column 1, which does not match other lua code
  for y = 1, #tmp_tilemap[1] do
  local line = ''
        for x = 1, #tmp_tilemap do
          local nx=x-1
          local ny=y-1
          if tmp_tilemap[nx] ~= nil and tmp_tilemap[nx][ny] ~= nil then
               local res = tmp_tilemap[nx][ny]
               Area:placeTerrain(x, y, res, area)
          end
        end
  end
end


function Area:placeRandomStairs(area, dir)
  x, y = Map:findRandomStandingGrid()
  if dir == "down" then
    Area:placeTerrain(x,y, ">", area)
  end
  if dir == "up" then
    Area:placeTerrain(x,y, "<", area)
  end
  print("Creating stairs at ", x,y)
end

--Generic stuff
function Area:getTerrainTile(area, str)
  if area[str] then return area[str] 
  else return nil end
end

function Area:placeTerrain(x,y, str, area)
    if not area then print("We forgot area parameter!!") return end
    if not x or not y then print("No location parameters") return end
    if x > Map:getHeight()-1 then print("X out of bounds") end
    if y > Map:getWidth()-1 then print("Y out of bounds") end

    local image = Area:getTerrainTile(area, str)

    if image then
      terrain = Grid.new({display=str, image = image })
    else
      terrain = Grid.new({display=str
              --test
        --[[on_stand = function(self, x, y, who)
          who:takeHit(1, {name="fire"})
        end,]]
        })
    end

    print("[Area] Created terrain at ",x,y, str)
    terrain:place(x,y,str)

    return terrain
end 


function Area:getAreaMap()
  path_map = Pathfinding:create()
  return path_map
end

function Area:spawnStuff()
  local tx, ty = Map:findRandomStandingGrid()
  Spawn:createItem(tx,ty, "buckler")
  local tx, ty = Map:findRandomStandingGrid()
  Spawn:createItem(tx,ty, "longsword")

  local tx, ty = Map:findRandomStandingGrid()
  Spawn:createItem(tx,ty, "longsword")
  local tx, ty = Map:findRandomStandingGrid()
  Spawn:createItem(tx,ty, "leather armor")
  local tx, ty = Map:findRandomStandingGrid()
  Spawn:createItem(tx,ty, "light steel shield")
  --test
  local tx, ty = Map:findRandomStandingGrid()
  Spawn:createItem(tx,ty, "leather helmet")
  local tx, ty = Map:findRandomStandingGrid()
  Spawn:createItem(tx,ty, "leather armor")
  local tx, ty = Map:findRandomStandingGrid()
  Spawn:createItem(tx,ty, "light wooden shield")
end

function Area:spawnTest()
  Spawn:createItem(3,3, "studded armor")
  Spawn:createItem(2,2, "torch")

  Spawn:createItem(4,4, "longbow")
  Spawn:createItem(4,4, "arrow")

  Spawn:createItem(5,5, "copper coins")
  Spawn:createItem(5,4, "silver coins")
end

return Area