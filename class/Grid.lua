require 'T-Engine.class'

require 'class.Map'

module("Grid", package.seeall, class.make)

function _M:init(t)
    --if t then print("We were given a table") end
    t = t or {}
    --default loc for testing
    self.x = 1
    self.y = 1
    self.display = t.display or "."
    --if t.display then print("We were provided a display", t.display) end
    self.image = t.image
    self.name = t.name
    self.on_stand = t.on_stand
end

function _M:place(x,y, str)
    x = math.floor(x)
    y = math.floor(y)
  
  --don't go out of bounds
    if x < 0 then x = 0 end
    if x >= Map:getWidth() then x = Map:getWidth() - 1 end
    if y < 0 then y = 0 end
    if y >= Map:getHeight() then y = Map:getHeight() - 1 end

    print("Terrain: updating map cell: ", x, y, str)
    Map:setCell(x, y, self) --self.image)

end

return Grid