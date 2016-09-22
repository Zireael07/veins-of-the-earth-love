require 'T-Engine.class'

module("ActorStats", package.seeall, class.make)

ActorStats.stats = { 'STR', 'DEX', 'CON', 'INT', 'WIS', 'CHA', 'LUC' }
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
  print("Actor: initiated stats for ", self.name)
end

function ActorStats:getStat(s)
    local stat = self.stats[s]
    assert(stat, 'no stat '..s)

    local val
    val = stat.current
    --print("Value is", val)
    return val
end

return ActorStats