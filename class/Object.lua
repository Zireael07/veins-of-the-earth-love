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
    self.add_name = t.add_name
    self.slot = t.slot
    self.combat = t.combat
    self.wielder = t.wielder
    self.ammo_type = t.ammo_type
    self.cost = 0
    self.desc = t.desc
    --flags
    self.ranged = t.ranged or false
    if t.cost then
        print_to_log("[OBJECT] setting value for "..t.name)
        self.cost = self:setValue((t.cost.platinum or 0), (t.cost.gold or 0), (t.cost.silver or 0))
    end
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
        if found_x and found_y then
            print("Object: updating map cell: ", found_x, found_y)
            Map:setCellObject(found_x, found_y, self) 
        end
    else
        print("Object: updating map cell: ", x, y)
        Map:setCellObject(x, y, self)
    end
    
end

function _M:descAttribute(attr)
    if attr == "COMBAT_AMMO" then
        local c = self.combat
        return c.capacity
    elseif attr == "LITE" then
        return self.fuel
    end
end   

function _M:getName(t)
    t = t or {}
    local name = self.name

    if not t.no_add_name and self.add_name then --and self:isIdentified() then
    name = name .. self.add_name:gsub("#([^#]+)#", function(attr)
            return self:descAttribute(attr)
        end)
    end

    return name
end

function _M:getExamineDescription()
    if not self.desc then return "No description available" end
    local desc = self.desc
    desc = desc.."\n "..self:formatPrice()
    return desc
end

--10 coppers to a silver, 20 silvers to a gold means 200 coppers to a gold
--10 gold to a platinum means 2000 coppers to a platinum
function _M:setValue(plat, gold, silver)
    print_to_log("[OBJECT] Setting value: plat ", plat, " gold ", gold, " silver ", silver)
    local cost = 0

    if plat > 0 then
        cost = cost + plat*2000
    end
    if gold > 0 then
        cost = cost + gold*200
    end
    if silver > 0 then
        cost = cost + silver*10
    end
    print_to_log("[OBJECT] Cost is ", cost)
    return cost
end

--Note it omits any coppers unless the price is given in coppers
function _M:formatPrice()
    local platinum = math.floor(self.cost/2000)
    local gold = math.floor(self.cost/200)
    local silver = math.floor(self.cost/10)

    local plat_change = self.cost - (platinum*2000)
    local gold_change = self.cost - (gold*200)
    local silver_rest = self.cost - (silver*10)

    local plat_rest = math.floor(plat_change/200)
    local gold_rest = math.floor(gold_change/10)

    if self.cost >= 2000 then
        if (plat_rest or 0) > 0 then return ""..platinum.." pp "..plat_rest.." gp"
        else return ""..platinum.." pp" end
    elseif self.cost >= 200 then
        if (gold_rest or 0) > 0 then return ""..gold.." gp "..gold_rest.." sp"
        else return ""..gold.." gp" end
    elseif self.cost > 10 then
        if (silver_rest or 0) > 0 then return silver.." sp "..silver_rest.." cp"
        else return silver.." sp" end
    else return self.cost
    end
end

return _M