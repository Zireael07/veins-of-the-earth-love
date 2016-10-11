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

require 'T-Engine.class'

module("ActorTemporaryValues", package.seeall, class.make)

--- temporary values storage
_M.temporary_values_conf = {}

--- Computes a "temporary" value into a property
-- Necessary for the item or effect-conferred bonuses to be removable
-- @param[opt=tab|string] prop the property to affect.  This can be either a string or a table of strings, the latter allowing nested properties to be modified.
-- @param[opt=number|tab] v the value to add.  This should either be a number or a table of properties and numbers.
-- @param[type=boolean] noupdate if true the actual property is not changed and needs to be changed by the caller
-- @return an id that can be passed to removeTemporaryValue() to delete this value
function _M:addTemporaryValue(prop, v, noupdate)
    if not self.compute_vals then self.compute_vals = {n=0} end

    local t = self.compute_vals
    local id = t.n + 1
    while t[id] ~= nil do id = id + 1 end
    t[id] = v
    t.n = id

    -- Find the base, one removed from the last prop
    local initial_base, initial_prop
    if type(prop) == "table" then
        initial_base = self
        local idx = 1
        while idx < #prop do
            initial_base = initial_base[prop[idx]]
            idx = idx + 1
        end
        initial_prop = prop[idx]
    else
        initial_base = self
        initial_prop = prop
    end

    -- The recursive enclosure
    local recursive
    recursive = function(base, prop, v, method)
        method = self.temporary_values_conf[prop] or method
        if type(v) == "number" then
            -- Simple addition
            if method == "mult" then
                base[prop] = (base[prop] or 1) * v
            --[[elseif method == "mult0" then
                base[prop] = (base[prop] or 1) * (1 + v)
            elseif method == "perc_inv" then
                v = v / 100
                local b = (base[prop] or 0) / 100
                b = 1 - (1 - b) * (1 - v)
                base[prop] = b * 100
            elseif method == "inv1" then
                v = util.bound(v, -0.999, 0.999)
                t[id] = v
                local b = (base[prop] or 1) - 1
                b = 1 - (1 - b) * (1 - v)
                base[prop] = b + 1
            elseif method == "highest" then
                base["__thighest_"..prop] = base["__thighest_"..prop] or {[-1] = base[prop]}
                base["__thighest_"..prop][id] = v
                base[prop] = table.max(base["__thighest_"..prop])
            elseif method == "lowest" then
                base["__tlowest_"..prop] = base["__tlowest_"..prop] or {[-1] = base[prop]}
                base["__tlowest_"..prop][id] = v
                base[prop] = table.min(base["__tlowest_"..prop])
            elseif method == "last" then
                base["__tlast_"..prop] = base["__tlast_"..prop] or {[-1] = base[prop]}
                local b = base["__tlast_"..prop]
                b[id] = v
                b = table.listify(b)
                table.sort(b, function(a, b) return a[1] > b[1] end)
                base[prop] = b[1] and b[1][2]
                ]]
            else
if type(base[prop] or 0) ~= "number" or type(v) ~= "number" then
    print("ERROR: Attempting to add value", v, "property", prop, "to", base[prop]) table.print(base[prop]) table.print(v)
    print("Entity:", self) -- table.print(self)
    game.debug._debug_entity = self
end
                base[prop] = (base[prop] or 0) + v
            end
            self:onTemporaryValueChange(prop, v, base)
--          print("addTmpVal", base, prop, v, " :=: ", #t, id, method)
        elseif type(v) == "table" then
            for k, e in pairs(v) do
--              print("addTmpValTable", base[prop], k, e)
                base[prop] = base[prop] or {}
                recursive(base[prop], k, e, method)
            end
        elseif type(v) == "string" then
            -- Only last works on strings
            if true or method == "last" then
                base["__tlast_"..prop] = base["__tlast_"..prop] or {[-1] = base[prop]}
                local b = base["__tlast_"..prop]
                b[id] = v
                b = table.listify(b)
                table.sort(b, function(a, b) return a[1] > b[1] end)
                base[prop] = b[1] and b[1][2]
            else
                base[prop] = (base[prop] or 0) + v
            end
--          print("addTmpVal", base, prop, v, " :=: ", #t, id, method)
        else
            error("unsupported temporary value type: "..type(v).." :=: "..tostring(v).." (on key "..tostring(prop)..")")
        end
    end

    -- Update the base prop
    if not noupdate then
        recursive(initial_base, initial_prop, v, "add")
    end

    return id
end

--- Removes a temporary value, see addTemporaryValue()
-- @param[opt=tab|string] prop the property to affect
-- @int id the id of the increase to delete
-- @param[type=boolean] noupdate if true the actual property is not changed and needs to be changed by the caller
function _M:removeTemporaryValue(prop, id, noupdate)
    local oldval = self.compute_vals[id]
--  print("removeTempVal", prop, oldval, " :=: ", id)
    if not id then util.send_error_backtrace("error removing prop "..tostring(prop).." with id nil") return end
    self.compute_vals[id] = nil

    -- Find the base, one removed from the last prop
    local initial_base, initial_prop
    if type(prop) == "table" then
        initial_base = self
        local idx = 1
        while idx < #prop do
            initial_base = initial_base[prop[idx]]
            idx = idx + 1
        end
        initial_prop = prop[idx]
    else
        initial_base = self
        initial_prop = prop
    end

    -- The recursive enclosure
    local recursive
    recursive = function(base, prop, v, method)
        method = self.temporary_values_conf[prop] or method
        if type(v) == "number" then
            -- Simple addition
            if method == "mult" then
                base[prop] = base[prop] / v
            --[[elseif method == "mult0" then
                base[prop] = base[prop] / (1 + v)
            elseif method == "perc_inv" then
                v = v / 100
                local b = base[prop] / 100
                b = 1 - (1 - b) / (1 - v)
                base[prop] = b * 100
            elseif method == "inv1" then
                local b = base[prop] - 1
                b = 1 - (1 - b) / (1 - v)
                base[prop] = b + 1
            elseif method == "highest" then
                base["__thighest_"..prop] = base["__thighest_"..prop] or {}
                base["__thighest_"..prop][id] = nil
                base[prop] = table.max(base["__thighest_"..prop])
                if not next(base["__thighest_"..prop]) then base["__thighest_"..prop] = nil end
            elseif method == "lowest" then
                base["__tlowest_"..prop] = base["__tlowest_"..prop] or {}
                base["__tlowest_"..prop][id] = nil
                base[prop] = table.min(base["__tlowest_"..prop])
                if not next(base["__tlowest_"..prop]) then base["__tlowest_"..prop] = nil end
            elseif method == "last" then
                base["__tlast_"..prop] = base["__tlast_"..prop] or {}
                local b = base["__tlast_"..prop]
                b[id] = nil
                b = table.listify(b)
                table.sort(b, function(a, b) return a[1] > b[1] end)
                base[prop] = b[1] and b[1][2]
                if not next(base["__tlast_"..prop]) then base["__tlast_"..prop] = nil end
                ]]
            else
                if not base[prop] then util.send_error_backtrace("Error removing property "..tostring(prop).." with value "..tostring(v).." : base[prop] is nil") return end
                base[prop] = base[prop] - v
            end
            self:onTemporaryValueChange(prop, -v, base)
--          print("delTmpVal", prop, v, method)
        elseif type(v) == "table" then
            for k, e in pairs(v) do
                recursive(base[prop], k, e, method)
            end
        elseif type(v) == "string" then
            -- Only last works on strings
            if true or method == "last" then
                base["__tlast_"..prop] = base["__tlast_"..prop] or {}
                local b = base["__tlast_"..prop]
                b[id] = nil
                b = table.listify(b)
                table.sort(b, function(a, b) return a[1] > b[1] end)
                base[prop] = b[1] and b[1][2]
                if b[1] and b[1][1] == -1 then base["__tlast_"..prop][-1] = nil end
                if not next(base["__tlast_"..prop]) then base["__tlast_"..prop] = nil end
            else
                if not base[prop] then util.send_error_backtrace("Error removing property "..tostring(prop).." with value "..tostring(v).." : base[prop] is nil") return end
                base[prop] = base[prop] - v
            end
--          print("delTmpVal", prop, v, method)
        else
            if config.settings.cheat then
                if type(v) == "nil" then
                    error("ERROR!!! unsupported temporary value type: "..type(v).." :=: "..tostring(v).." for "..tostring(prop))
                else
                    error("unsupported temporary value type: "..type(v).." :=: "..tostring(v).." for "..tostring(prop))
                end
            end
        end
    end

    -- Update the base prop
    if not noupdate then
        recursive(initial_base, initial_prop, oldval, "add")
    end
end

--- Helper function to add temporary values
function _M:tableTemporaryValue(t, k, v)
    t[#t+1] = {k, self:addTemporaryValue(k, v)}
end

--- Helper function to remove temporary values
function _M:tableTemporaryValuesRemove(t)
    for i = 1, #t do
        self:removeTemporaryValue(t[i][1], t[i][2])
    end
end

--- Called when a temporary value changes (added or deleted)
-- This does nothing by default, you can overload it to react to changes
-- @param prop the property changing
-- @param v the value of the change
-- @param base the base table of prop
function _M:onTemporaryValueChange(prop, v, base)
end

return _M