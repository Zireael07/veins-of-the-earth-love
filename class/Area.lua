require 'T-Engine.class'

require 'class.Map'

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