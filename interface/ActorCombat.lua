require 'T-Engine.class'

local dice = require('libraries/dice')

local utils = require 'utils'

module("ActorCombat", package.seeall, class.make)

function ActorCombat:attackTarget(target)
    -- returns your weapon if you are armed, or unarmed combat.
      local weapon = (self:getInven("MAIN_HAND") and self:getInven("MAIN_HAND")[1]) or self
      --returns your offhand weapon (not shield) or your weapon again if it is double
      local offweapon = (self:getInven("OFF_HAND") and self:getInven("OFF_HAND")[1] and self:getInven("OFF_HAND")[1].combat and self:getInven("OFF_HAND")[1]) or (weapon and weapon.double and weapon)

      --If not wielding anything in offhand and wielding a one-handed martial weapon then wield it two-handed
      local twohanded = false

      if not (self:getInven("OFF_HAND") and self:getInven("OFF_HAND")[1]) and not weapon.double and not weapon.light then
         twohanded = true
      end

      --No more 'extra-pokey longbows'
      if weapon and weapon.ranged then
        logMessage(colors.WHITE, "You can't use a ranged weapon in melee!")
        return
      end

      self:attackRoll(target, weapon)
end 

function ActorCombat:attackRoll(target, weapon)
    local d = dice.roll('1d20')
    local hit = true
    local crit = false

    local ac = target:getAC()

    --Hit check
    --if concealment
    if d == 1 then hit = false
    elseif d == 20 then hit = true
    elseif d < ac then hit = false
    end

     -- Crit check
    local threat = 0 + (weapon and weapon.combat.threat or 0)
    
    self:attackMessage(target, hit, d, ac)

    if hit and d >= 20 - threat then
      -- threatened critical hit confirmation roll
      if not (dice.roll('1d20') < ac) then
         crit = true
      else
          logMessage(colors.WHITE, "Critical confirmation roll failed")
      end
   end

    if hit then
        self:dealDamage(target, weapon, crit)
    end
end

function ActorCombat:dealDamage(target, weapon, crit)
  local dam = dice.roll(weapon.combat.dam[1].."d"..weapon.combat.dam[2])

  --Minimum 1 point of damage unless Damage Reduction works
    dam = math.max(1, dam)

    --print("Dealing "..dam.." damage")

    target:takeHit(dam, self)
end 

function ActorCombat:attackMessage(target, hit, d, ac)
    if hit then
        logMessage(colors.GOLD, "Hit "..target.name.." roll "..d.." vs. AC "..ac)
    else
        logMessage(colors.LIGHT_BLUE, "Missed "..target.name.." roll "..d.." vs. AC "..ac)
    end
end

function ActorCombat:getAC(log, touch)
    --Add logging
    local log_ac = ""

    local ac_bonuses = 0

    local ac_notfortouch = { "armor", "shield", "natural", "magic_armor", "magic_shield", }
    local ac_bonuses_table = { "dodge", "protection", "untyped", "parry" }

    if not touch then
        table.append(ac_bonuses_table, ac_notfortouch)
    end

    for i, source in pairs(ac_bonuses_table) do
        local value = self["combat_"..source] or 0

        local string = source:gsub("_", " ")
        ac_bonuses = (ac_bonuses or 0) + value

        if log == true and value > 0 then log_ac = log_ac..string:capitalize().." "..value.." " end
    end

    if log == true then
        return math.floor(10 + ac_bonuses + (dex_bonus or 0)), log_ac
    else
        return math.floor(10 + ac_bonuses + (dex_bonus or 0))
    end

    print(self.name.." AC: ".. log_ac)
end

return ActorCombat