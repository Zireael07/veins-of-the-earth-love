require 'T-Engine.class'

module("ActorStats", package.seeall, class.make)

ActorStats.stats = { 'STR', 'DEX', 'CON', 'INT', 'WIS', 'CHA' } --, 'LUC' }
ActorStats.stat_names = {
  STR = 'Strength',
  DEX = 'Dexterity',
  CON = 'Constitution',
  INT = 'Intelligence',
  WIS = 'Wisdom',
  CHA = 'Charisma',
  LUC = 'Luck'
}

function ActorStats:init(t)
    self.stats = {}
  for _, s in ipairs(ActorStats.stats) do
    self.stats[s] = { current = 10 }
    --print("Actor: stat "..s.." set to ", self.stats[s].current)
  end

  if not self.player then
    local array = self:setArray()
    self:applyArray(array)
  end

  print_to_log("Actor: initiated stats for ", self.name)
end

function ActorStats:getStat(s)
    local stat = self.stats[s]
    assert(stat, 'no stat '..s)

    local val
    val = stat.current
    --print("Value is", val)
    return val
end

function ActorStats:getStatMod(s)
    local stat = self.stats[s]
    assert(stat, 'no stat '..s)

    local val
    val = stat.current
    val = math.floor((val - 10) /2)
    --print("Mod value is", val)
    return val
end

function ActorStats:setStat(s, val)
  local stat = self.stats[s]

  stat.current = val
  print_to_log("Set stat", s, "to", val)
end


function ActorStats:setArray(val)
  local array = {}
  if val == "heroic" then
    array = { 15, 14, 13, 12, 10, 8}
  else
    array = { 13, 12, 11, 10, 9, 8 }
  end

  return array
end

function ActorStats:applyArray(array, str)

  if str == "ranged" then
    print("Using ranged array")
    self:setStat("STR", array[3])
    self:setStat("DEX", array[1])
    self:setStat("CON", array[2])
    self:setStat("INT", array[4])
    self:setStat("WIS", array[5])
    self:setStat("CHA", array[6])
  elseif str == "divine" then
    self:setStat("STR", array[4])
    self:setStat("DEX", array[6])
    self:setStat("CON", array[2])
    self:setStat("INT", array[5])
    self:setStat("WIS", array[1])
    self:setStat("CHA", array[3])
  elseif str == "arcane" then
    self:setStat("STR", array[6])
    self:setStat("DEX", array[2])
    self:setStat("CON", array[4])
    self:setStat("INT", array[1])
    self:setStat("WIS", array[5])
    self:setStat("CHA", array[3])
  elseif str == "skill" then
    self:setStat("STR", array[4])
    self:setStat("DEX", array[2])
    self:setStat("CON", array[3])
    self:setStat("INT", array[1])
    self:setStat("WIS", array[6])
    self:setStat("CHA", array[5])
  else 
    --bog-standard melee
    print("Using melee array")
    self:setStat("STR", array[1])
    self:setStat("DEX", array[3])
    self:setStat("CON", array[2])
    self:setStat("INT", array[5])
    self:setStat("WIS", array[4])
    self:setStat("CHA", array[6])
  end
end

return ActorStats