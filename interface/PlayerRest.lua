-- Based on T-Engine
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

--- Handles player resting
module("PlayerRest", package.seeall, class.make)

--- Initializes resting
function _M:restInit(turns, what, past, on_end, on_very_end)
    what = what or "resting"
    past = past or "rested"
    self.resting = {
        rest_turns = turns,
        past = past,
        on_end = on_end,
        on_very_end = on_very_end,
        cnt = 0,
    }

    logMessage(what:capitalize().." starts...")

    self:onRestStart()

    local ret, msg = self:restCheck()
    if ret and self.resting and self.resting.rest_turns and self.resting.cnt > self.resting.rest_turns then ret = false msg = nil end
    if not ret then
        self:restStop(msg)
    else
        endTurn()
        self.resting.cnt = self.resting.cnt + 1
    end
end

--- We started resting
-- Rewrite this method to do whatever you need
function _M:onRestStart()
end


--- Rest a turn
-- @return[1] true if we can continue to rest
-- @return[2] false if we can't continue
function _M:restStep()
    --print("Doing a rest step")
    if not self.resting then 
        --print("Not resting") 
    return false  end

    local ret, msg = self:restCheck()
    if ret and self.resting and self.resting.rest_turns and self.resting.cnt > self.resting.rest_turns then ret = false msg = nil end
    if not ret then
        self:restStop(msg)
        return false
    else
        --print("Resting, we should end the turn")
        endTurn()
        self.resting.cnt = self.resting.cnt + 1
        return true
    end
end

--- Can we continue resting?  
-- @return[1] true if we can continue to rest
-- @return[2] false if we can't continue
function _M:restCheck()
    --print("Doing rest check")
    if self:spotHostiles(self) then return false, "hostile spotted" end

    --Start healing after having rested for 20 turns
    if self.resting.cnt > 5 then
    end

    --Only do the stuff once
    if self.resting.cnt == 6 then

        --normal healing
        --use Wis instead of Con if have Mind over Body feat
        local con = self:getStat("CON")
        local heal = ((1+3)*con)/5

        --Heal skill
        if (self.skill_heal or 0) > 0 then
            heal = ((1 + self.skill_heal +3)*con)/5
        end

        self.hitpoints = math.min(self.max_hitpoints, self.hitpoints + heal)

        --heal one wound
        if self.wounds < self.max_wounds then
            self.wounds = self.wounds + 1
        end

        --reset the ignore wound feat flag
        --self.ignored_wound = false

    end

    --quit resting after 30 turns total
    if self.resting.cnt < 10 then return true end

    return false, "You feel fully rested"
end

--- Stops resting
function _M:restStop(msg)
    if not self.resting then return false end


    if msg then
        logMessage(self.resting.past:capitalize().." for "..self.resting.cnt.. " turns (stop reason: "..msg..").")
    else
        logMessage(self.resting.past:capitalize().." for "..self.resting.cnt.." turns.")
    end

    local finish = self.resting.cnt and self.resting.rest_turns and self.resting.cnt > self.resting.rest_turns
    local on_very_end = self.resting.on_very_end
    if self.resting.on_end then self.resting.on_end(self.resting.cnt, self.resting.rest_turns) end
    self:onRestStop()
    self.resting = nil
    if on_very_end then on_very_end(finish) end
    return true
end


function _M:onRestStop()
    if self.resting.cnt > 5 then
    --Passage of time
    game_turn = game_turn + calendar.HOUR * 8
    --Spawn monsters

    --Passage of time
  elseif self.resting.cnt == 0 then game_turn = game_turn
  else game_turn = game_turn + calendar.HOUR * 4 end

  --Calendar
  logMessage(calendar:getTimeDate(game_turn))
end

return _M