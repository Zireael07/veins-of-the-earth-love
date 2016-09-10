require 'T-Engine.class'

require 'class.Map'
local Spawn = require 'class.Spawn'

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
  Area:fillWalls(width, height)
  
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

return Area