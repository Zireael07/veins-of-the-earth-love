--Based on T-Engine
-- Copyright (C) 2009 - 2016 Nicolas Casalini
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
-- Nicolas Casalini "DarkGod"
-- darkgod@te4.org

require "T-Engine.class"

module("ActorInventory", package.seeall, class.make)

_M.inven_def = {}

function _M:defineInventory(short_name, name, is_worn, desc, show_equip, infos)
    assert(name, "no inventory slot name")
    assert(short_name, "no inventory slot short_name")
    assert(desc, "no inventory slot desc")
    table.insert(self.inven_def, {
        name = name,
        short_name = short_name,
        description = desc,
        is_worn = is_worn,
        is_shown_equip = show_equip,
        infos = infos,
        stack_limit = infos and infos.stack_limit,
    })
    self.inven_def[#self.inven_def].id = #self.inven_def
    self.inven_def[short_name] = self.inven_def[#self.inven_def]
    self["INVEN_"..short_name:upper()] = #self.inven_def
    print("[INVENTORY] define slot", #self.inven_def, self.inven_def[#self.inven_def].name)
end

-- Auto define the inventory
_M:defineInventory("INVEN", "In inventory", false, "") --INVEN_INVEN assumed to have no stacking limit

--- Initialises inventories with default values if needed
function _M:init(t)
    self.inven = t.inven or {}
    self.body = t.body
    self:initBody()
end

--- generate inventories according to the body definition table
--  @param self.body = {SLOT_ID = max, ...}
--  @param max = number of slots if number or table of properties (max = , stack_limit = , ..) merged into definition
function _M:initBody()
    if self.body then
        local def
        for inven, max in pairs(self.body) do
            def = self.inven_def[self["INVEN_"..inven]]
            assert(def, "inventory slot undefined.. "..inven)
            self.inven[self["INVEN_"..inven]] = {worn=def.is_worn, id=self["INVEN_"..inven], name=inven, stack_limit = def.stack_limit}
            if type(max) == "table" then
                table.merge(self.inven[self["INVEN_"..inven]], max, true)
            else
                self.inven[self["INVEN_"..inven]].max = max
            end
        end
        self.body = nil
    end
end

--- Returns the content of an inventory as a table
function _M:getInven(id)
    if type(id) == "number" then
        return self.inven[id]
    elseif type(id) == "string" then
        return self.inven[self["INVEN_"..id]]
    else
        return id
    end
end

--- Tells if an inventory still has room left
function _M:canAddToInven(id)
    if type(id) == "number" then
        return #self.inven[id] < self.inven[id].max
    elseif type(id) == "string" then
        return #self.inven[self["INVEN_"..id]] < self.inven[self["INVEN_"..id]].max
    else
        return id
    end
end

--- Get stacking limit for an inventory
--  @param id inventory id or table (stack_limit in inventory table takes precedence)
function _M:invenStackLimit(id)
    local inven = self:getInven(id)
    return inven.stack_limit or self.inven_def[inven.id].stack_limit or math.huge
end

function _M:addObject(inven_id, o)
    local inven = self:getInven(inven_id)

    if #inven >= inven.max then
    return false end

    table.insert(inven, #inven +1, o)

    --callbacks? onWear and onAddObject?
    --print("Added object ", inven)
    return true
end 

--item is the index we want to remove from
function _M:removeObject(inven_id, item)
    local inven = self:getInven(inven_id)

    local o = inven[item]

    table.remove(inven, item)
end

function _M:pickupFloor()
    local inven = self:getInven(self.INVEN_INVEN)
    if not inven then return end

    if Map:getCellObject(self.x, self.y) then
        o = Map:getCellObject(self.x, self.y)
        local ok = self:addObject(self.INVEN_INVEN, o)
        if ok then
            print("Picked up", o.name)
            Map:setCellObject(self.x, self.y, nil)
        end
    else
        print("Nothing to pick up here")
    end    

end

function _M:canWearObject(o, try_slot)
    print("Checking if we can wear object ", o.name, try_slot)
    -- check the slot
    if try_slot and try_slot ~= o.slot then
        return nil, "wrong equipment slot"
    end

    return true
end

function _M:wearObject(o, inven_id)
--    print("Wearing: ", o, inven_id)
    local inven = self:getInven(inven_id)

    local ok, err = self:canWearObject(o, inven.name)

    if not ok then
        print("Can not wear", o.name)
        return false
    end

    local added = self:addObject(inven_id, o)
    if added then
        print("Wearing "..o.name.." in slot "..inven.name)
    end
end

function _M:doWear(inven, item, o, dst)
    self:removeObject(inven, item)
    self:wearObject(o, dst)
end


return _M