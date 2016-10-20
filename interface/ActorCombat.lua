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

    --get our attack bonus
    attack, attacklog_add = self:combatAttack(weapon)

    local ac = target:getAC()

    --Hit check
    --if concealment
    if d == 1 then hit = false
    elseif d == 20 then hit = true
    elseif d + attack < ac then hit = false
    end

     -- Crit check
    local threat = 0 + (weapon and weapon.combat.threat or 0)
    
    self:attackMessage(target, hit, d, attack, ac)

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
  --print_to_log("[COMBAT] rolling", weapon.combat.dam[1], weapon.combat.dam[2])
  -- Stat damage bonus
    if weapon and weapon.ranged then
        strmod = strmod or 0
    else
        strmod = strmod or 1
    end
    --print_to_log("[COMBAT] damage after rolling", dam)

    dam = dam + (strmod * self:getStatMod("STR"))
    --print_to_log("[COMBAT] strength mod:", self:getStatMod("STR"), "total damage:", dam)

  --Minimum 1 point of damage unless Damage Reduction works
    dam = math.max(1, dam)

    --print("Dealing "..dam.." damage")

    target:takeHit(dam, self)
end 

function ActorCombat:attackMessage(target, hit, d, attack, ac)
    if hit then
        logMessage(colors.GOLD, "Hit "..target.name.." roll "..d.." + "..attack.." vs. AC "..ac)
    else
        logMessage(colors.LIGHT_BLUE, "Missed "..target.name.." roll "..d.." + "..attack.." vs. AC "..ac)
    end
end

function ActorCombat:getAC(log, touch, location)
    --Add logging
    local log_ac = ""

    local dex_bonus = self:getStatMod("DEX")

    local ac_bonuses = 0

    local ac_notfortouch = { "armor", "shield", "natural", "magic_armor", "magic_shield", }
    local ac_bonuses_table = { "dodge", "protection", "untyped", "parry" }

    if not touch then
        table.append(ac_bonuses_table, ac_notfortouch)
    end

    for i, source in pairs(ac_bonuses_table) do
        local value = self["combat_"..source] or 0

        --only armor is actually locational
        if (source == "armor" or source == "magic_armor") and location ~= nil then
            value = self["combat_"..source.."_"..location] or 0
        end

        local string = source:gsub("_", " ")
        ac_bonuses = (ac_bonuses or 0) + value

        if log == true and value > 0 then log_ac = log_ac..string:capitalize().." "..value.." " end
    end

    if self.max_dex_bonus then dex_bonus = math.min(dex_bonus, self.max_dex_bonus) end
    if log then log_ac = log_ac.."Dex "..dex_bonus.." " end

    if log == true then
        return math.floor(10 + ac_bonuses + (dex_bonus or 0)), log_ac
    else
        return math.floor(10 + ac_bonuses + (dex_bonus or 0))
    end

    print_to_log("[COMBAT]"..self.name.." AC: ".. log_ac)
end

--Get attack mods for the character sheet
function _M:combatAttack(weapon)
    --log
    local attacklog = attacklog or ""
    local attack = 0

    -- Stat bonuses
    local stat_used = "STR"

    if weapon and weapon.ranged then
       stat_used = "DEX"
    end

    if stat_used == "STR" then
        local str = self:getStatMod("STR")
        attacklog = attacklog.." "..str.." Str"
    end

    attack = attack + (weapon and weapon.combat.magic_bonus or 0) + (self:getStatMod(stat_used) or 0)

    return attack, attacklog
end

--Body parts code
function _M:randomBodyPart()
    local roll = rng.dice(1,20)

    if roll >= 19 then return "head"
    elseif roll >= 16 then return "wing"
    elseif roll >= 12 then return "torso"
    elseif roll >= 8 then return "legs"
    elseif roll >= 5 then return "tail"
    else return "arms"
    end
end

function _M:getLocationAC()
    local location
    location = self:randomBodyPart()

    if location == "wing" and not self.body_parts[wing] then location = self:randomBodyPart() end
    if location == "tail" and not self.body_parts[tail] then location = self:randomBodyPart() end

    return self:getAC(false, false, location)
end

--Ranged combat
function _M:checkRangedWeapons()
  local weapon = self:getInven("MAIN_HAND") and self:getInven("MAIN_HAND")[1]
  local ammo = self:getInven("QUIVER") and self:getInven("QUIVER")[1]

  if not (weapon and weapon.combat and weapon.combat.range) then
      if not silent then logMessage(colors.WHITE, "You need a ranged weapon to shoot") end return nil end
  if not weapon or not weapon.ranged then
      if not silent then logMessage(colors.WHITE, "You need a ranged weapon to shoot with!") end return nil end
  if weapon and weapon.ammo_type and not ammo then
      if not silent then logMessage(colors.WHITE, "Your weapon requires ammo!") end return nil end
  if weapon and ammo and not weapon.ammo_type == ammo.archery_ammo then
      if not silent then logMessage(colors.WHITE, "You have the wrong ammo type equipped!") end return nil end
  if ammo and ammo.combat.capacity <= 0 then
      if not silent then logMessage("You're out of ammo!") end return nil end


  return true
end

function _M:getShootRange()
  return self:getInven("MAIN_HAND")[1].combat.range
end

function _M:archery_attack(target)
  if self:checkRangedWeapons() then
    print_to_log("[COMBAT] archery attack!")
    local range = self:getShootRange()
    if utils:distance(self.x, self.y, target.x, target.y) < range then
      local weapon = self:getInven("MAIN_HAND")[1]
      local ammo = self:getInven("QUIVER")[1]

       --Use the ammo up!
      if ammo and weapon.ammo_type and ammo.combat.capacity then --and not ammo.infinite then
        print_to_log("[COMBAT] Use up ammo!")
        ammo.combat.capacity = ammo.combat.capacity - 1
      end

      if ammo and ammo.combat.capacity <= 0 then
        self:removeObject(self:getInven("QUIVER"), 1)
      end

      --if thrown then remove the item
      --[[if not weapon.ammo_type and not weapon.returning then
          self:removeObject(self:getInven("MAIN_HAND"), 1)
    --  self:addObject(self.INVEN_INVEN, weapon)
    --  self:sortInven()
      end]]

      --Check range for shooting opponents in melee range
      --[[if self:isNear(tx, ty, 1) and not self:knowTalent(self.T_PRECISE_SHOT)  then
          attackmod = -4
      end]]

      --do we hit?
      local hit, crit = self:attackRoll(target, weapon) --, attackmod)
      if hit then
          local damage = dice.roll(weapon.combat.dam[1].."d"..weapon.combat.dam[2])
          if crit then
              damage = damage * (weapon and weapon.combat.critical or 2) 
          end

          --Minimum 1 point of damage unless Damage Reduction works
          dam = math.max(1, dam)

          --print("Dealing "..dam.." damage")

          target:takeHit(dam, self)
      end
    end
  end

  endTurn()
end

return ActorCombat