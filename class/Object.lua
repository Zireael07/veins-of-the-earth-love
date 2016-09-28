require 'T-Engine.class'

require 'class.Map'

module("Object", package.seeall, class.inherit(Entity))

function _M:init(t)
    if t then print("We were given a table") end
    t = t or {}
    --default loc for testing
    self.x = 1
    self.y = 1
    self.display = t.display or "/"
    --if t.display then print("We were provided a display", t.display) end
    self.image = t.image or "longsword"
    self.name = t.name or "sword"
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

    print("Object: updating map cell: ", x, y)
    Map:setCellObject(x, y, self) --self.image)

end

return _M