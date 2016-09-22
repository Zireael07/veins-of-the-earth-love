require 'T-Engine.class'

local Entity = require 'class.Entity'

module("ActorLife", package.seeall, class.make)

function ActorLife:init(t)
    self.max_hitpoints = t.max_hitpoints or 10
    self.hitpoints = t.hitpoints or t.max_hitpoints
    self.max_wounds = t.max_wounds or 1
    self.wounds = t.wounds or 1
    --self.die_at = t.die_at or -10
end

function ActorLife:takeHit(value, src)
    --no negative values
    if value <=0 then return 0 end

    --subtract hp
    if value < self.hitpoints and value > 0 then
        self.hitpoints = self.hitpoints - value
        logMessage({200,200,200, 255}, src.name.." hits "..self.name.." for "..value.." damage!")
    end
    
    --subtract wounds
    if value > self.hitpoints and value > 0 then

        local wounds_remaining = value - self.hitpoints
        value = value - self.hitpoints
        self.hp = 0

        self.wounds = self.wounds - wounds_remaining

        --log
        logMessage({255,0,0, 255}, src.name.." hits "..self.name.." for "..math.floor(wounds_remaining).." wounds")

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

function ActorLife:die(src)
    --log
    print(src.name.." killed "..self.name.."!")

    --remove ourselves from map
    if Map:getCellActor(self.x, self.y) then
        Map:setCellActor(self.x, self.y, nil)
    end

    self.dead = true
end

return ActorLife