require 'T-Engine.class'

require 'class.Map'

module("Object", package.seeall, class.inherit(Entity))

function _M:init(t)
    --if t then print("We were given a table") end
    t = t or {}
    --default loc for testing
    self.x = 1
    self.y = 1
    self.display = t.display or "/"
    self.image = t.image --or "longsword"
    self.name = t.name --or "sword"
    self.slot = t.slot
    self.combat = t.combat
    self.wielder = t.wielder
end

function _M:act()
  --nothing for now
end

--equivalent to Actor:move()
function _M:place(x,y)
    x = math.floor(x)
    y = math.floor(y)
  
  --don't go out of bounds
    if x < 0 then x = 0 end
    if x >= Map:getWidth() then x = Map:getWidth() - 1 end
    if y < 0 then y = 0 end
    if y >= Map:getHeight() then y = Map:getHeight() - 1 end

    --don't place in walls
    if Map:getCellTerrain(x,y).display == "#" then
        found_x, found_y = Map:findFreeGrid(x, y, 10)
    end
    if found_x and found_y then
        print("Object: updating map cell: ", found_x, found_y)
        Map:setCellObject(found_x, found_y, self) --self.image)
    end
end

return _M