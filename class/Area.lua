require 'T-Engine.class'

require 'class.Map'
local Grid = require 'class.Grid'
local Spawn = require 'class.Spawn'
local Encounter = require 'class.Encounter'
require 'interface.Pathfinding'

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
  Area:makeRandom(width, height)
  --Area:makeWalled(width, height)
  --Area:fillWalls(width, height)
  
  Area:getAreaMap()
  if path_map then print("Created a path_map successfully!")  end

  Area:spawnStuff()

  --test
  Encounter:getNPCsByCR(1)
  local encounter = Encounter:makeEncounter()
  Spawn:createEncounter(encounter, 5,5)
end

--Simple area generation
function Area:fillWalls(width, height)
  for x=0, width do
    --dungeon[level].map[x] = {}
    for y=0, height do
            --dungeon[level].map[x][y] = {}
      Map:setCell(x, y, ".")
    end
  end
end

function Area:makeWalled(width, height)
 for x=0, width do
    --dungeon[level].map[x] = {}
    for y=0, height do
       -- local empty= x>0 and y>0 and x<width and y<height
      local empty= x>0 and y>0 and x<width and y<height
            --dungeon[level].map[x][y] = {}
      if empty then Area:placeTerrain(x,y, ".") --Map:setCell(x, y, ".")
      else Area:placeTerrain(x,y, "#") --Map:setCell(x, y, "#")
      end
    end
  end
end

function Area:makeRandom(width, height)
  for x=0, width do
    for y=0, height do
      local str = rng:random(1,2) == 1 and "." or "#"
      Area:placeTerrain(x, y, str)
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
      --test!
  --[[Spawn:createActor(4, 4, "human")
  Spawn:createActor(5,5, "human")
  
  --test2
  Spawn:createActor(6,6, "drow")]]
  
  Spawn:createItem(6,6, "longsword")

  Spawn:createItem(2,2, "longsword")
  Spawn:createItem(4,4, "leather armor")
end

return Area