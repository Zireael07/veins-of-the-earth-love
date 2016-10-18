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

function _M:generate(level, width, height)
  print("Generating dungeon :"..level)
  dungeon[level] = {}
  dungeon[level].width = width
  dungeon[level].height = height
  dungeon[level].map = {}
  
  --remember to init the map
  Map:init(width+1, height+1)
  
  --test
  --Area:makeAstray(width, height)
  Area:makeWalled(width, height)
  --Area:fillWalls(width, height)
  
  Area:getAreaMap()
  if path_map then print("Created a path_map successfully!")  end

  Area:spawnStuff()
  Area:spawnTest()

  --test
  Encounter:getNPCsByCR(1)
  local encounter = Encounter:makeEncounter()
  local tx, ty = Map:findRandomStandingGrid()
  Spawn:createEncounter(encounter, tx,ty)
  local tx, ty = Map:findRandomStandingGrid()
  Spawn:createEncounter(encounter, tx,ty)

  Map:drawMaptoLog()
end

--Simple area generation
function Area:fillWalls(width, height)
  for x=1, width do
    --dungeon[level].map[x] = {}
    for y=1, height do
            --dungeon[level].map[x][y] = {}
      Area:placeTerrain(x, y, ".")
    end
  end
end

function Area:makeWalled(width, height)
 for x=1, width do
    --dungeon[level].map[x] = {}
    for y=1, height do
      local empty= x>1 and y>1 and x<width and y<height
            --dungeon[level].map[x][y] = {}
      if empty then Area:placeTerrain(x,y, ".")
      else Area:placeTerrain(x,y, "#")
      end
    end
  end
end

--requires A* checking!
function Area:makeRandom(width, height)
  for x=1, width do
    for y=1, height do
      local str = rng:random(1,2) == 1 and "." or "#"
      Area:placeTerrain(x, y, str)
    end
  end
end

function Area:makeAstray(width, height)
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
               Area:placeTerrain(x, y, res)
          end
        end
  end
end


--Generic stuff
function Area:placeTerrain(x,y, str)
    if not x or not y then print("No location parameters") return end
    if x > Map:getHeight()-1 then print("X out of bounds") end
    if y > Map:getWidth()-1 then print("Y out of bounds") end

    terrain = Grid.new({display=str, 
      --test
      --[[on_stand = function(self, x, y, who)
        who:takeHit(1, {name="fire"})
      end,]]
    }
    )

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
end

function Area:spawnTest()
  Spawn:createItem(3,3, "light wooden shield")
  Spawn:createItem(3,3, "leather armor")

end

return Area