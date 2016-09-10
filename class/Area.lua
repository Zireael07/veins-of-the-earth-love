require 'T-Engine.class'

require 'class.Map'
local Spawn = require 'class.Spawn'
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
  Area:makeWalled(width, height)
  --Area:fillWalls(width, height)
  
  Area:getAreaMap()
  if path_map then print("Created a path_map successfully!")  end
  
    --test!
  Spawn:createActor(4, 4)
  Spawn:createActor(10,10)
  
  Spawn:createItem(2,2)
  Spawn:createItem(6,6)
  
end

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
      if empty then Map:setCell(x, y, ".")
      else Map:setCell(x, y, "#")
      end
    end
  end
end

function Area:getAreaMap()
  path_map = Pathfinding:create()
  return path_map
end

return Area