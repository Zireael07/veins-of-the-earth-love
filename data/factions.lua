local Faction = require 'class.Faction'

--Factions

--Basic
Faction:add{ name="Player", reaction={enemy=-100} }
Faction:add{ name="Enemy", reaction={player=-100} }


Faction:add{ name="Neutral", reaction={}}
Faction:setInitialReaction("neutral", "enemy", 0, true)
Faction:setInitialReaction("neutral", "player", 0, true)

--More complex
Faction:add{ name="Ally", reaction={}}
Faction:setInitialReaction("ally", "enemy", -100, true)
Faction:setInitialReaction("ally", "player", 100, true)