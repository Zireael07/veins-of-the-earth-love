require 'T-Engine.class'

local Entity = require 'class.Entity'
local dice = require('libraries/dice')

module("ActorLife", package.seeall, class.make)

function ActorLife:init(t)
    self.max_hitpoints = t.max_hitpoints or 10
    self:setMaxHP()
    self.hitpoints = self.max_hitpoints or t.hitpoints
    self.max_wounds = t.max_wounds or 1
    self.wounds = t.wounds or 1
    --print_to_log("[ACTOR LIFE] Inited:", self.max_hitpoints, self.hitpoints)
    --self.die_at = t.die_at or -10
    
end



function ActorLife:getHPDieSize(type)
    if not type then return end
    local typetodie = {
    humanoid = 8,
}
    print("[ActorLife] Getting HP die for "..type)
    return typetodie[type]
end

function ActorLife:setMaxHP()
    if self.hit_die and self.hit_die > 0 then
        self.max_hitpoints = dice.roll(self.hit_die..'d'..self:getHPDieSize(self.type))
        print("[ActorLife] "..self.hit_die..'d'..self:getHPDieSize(self.type).. "result "..self.max_hitpoints)
    end
end

function ActorLife:takeHit(value, src)
    --no negative values
    if value <=0 then return 0 end

    --set flags that are used by splash drawing
    self.damage_taken = value

    --if we deal damage
    if value > 0 then
        --subtract hp
        if value <= self.hitpoints then
            self.hitpoints = self.hitpoints - value
            logMessage(colors.WHITE, src.name.." hits "..self.name.." for "..value.." damage!")
        --we exceeded hitpoints in our hit
        else
            --show log message
            logMessage(colors.WHITE, src.name.." hits "..self.name.." for "..self.hitpoints.." damage!")
            --subtract wounds
            local wounds_remaining = value - self.hitpoints
            value = value - self.hitpoints
            --simulate the normal hit
            self.hitpoints = 0
            
            --deal damage
            self.wounds = self.wounds - wounds_remaining

            --log
            logMessage(colors.LIGHT_RED, src.name.." hits "..self.name.." for "..math.floor(wounds_remaining).." health damage!")

            if self.hitpoints <= 1 then value = 0 end

            wounds_remaining = 0
            if self.max_wounds and self.wounds < self.max_wounds then
                if self.wounds <= self.max_wounds/2 then
                    --disabled
                else
                    --fatigued
                end
            end
            --we're out of wounds, die
            if self.wounds <= 0 and not self.dead then
                self:die(src)
            end
        end
    end
end

function ActorLife:die(src)
    print_to_log("[ActorLife] die: ", self.name)
    --log
    logMessage(colors.RED, src.name.." killed "..self.name.."!")

    --remove ourselves from map
    if Map:getCellActor(self.x, self.y) then
        Map:setCellActor(self.x, self.y, nil)
    end

    self.dead = true

    --do other stuff
    self:on_die(src)
end

function ActorLife:gethitpointPerc()
    return self.hitpoints * 100 / self.max_hitpoints
end

function ActorLife:getHealthState()
    local perc = self:gethitpointPerc()

    if perc == 100 then return "Uninjured"
    elseif perc >= 75 then return "Healthy"
    elseif perc >= 50 then return "Barely injured"
    elseif perc >= 25  then return "Injured"
    elseif perc >= 10 then return "Bloodied"
    elseif perc >= 1 then return "Severely wounded"
    else return "Nearly dead"
    end
end

function ActorLife:getBodyPartHP(part)
    local hp
    if self.body_parts[part] then
        hp = self["hitpoints_"..part]
        --print("[ACTOR LIFE] Body part", part, "hp", hp)
        return hp
    end
    return nil
end

return ActorLife