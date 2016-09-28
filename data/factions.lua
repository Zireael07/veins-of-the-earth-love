local Faction = require 'class.Faction'

--Factions

--Basic
Faction:add{ name="Player", reaction={enemy=-100} }
Faction:add{ name="Enemy", reaction={player=-100} }

--What it says on the tin
Faction:add{ name="Neutral", reaction={}}
Faction:setInitialReaction("neutral", "enemy", 0, true)
Faction:setInitialReaction("neutral", "player", 0, true)

--They do nothing but glare at ya!
Faction:add{ name="Unfriendly", reaction={}}
Faction:setInitialReaction("unfriendly", "enemy", 0, true)
Faction:setInitialReaction("unfriendly", "player", -50, true)

--More complex
Faction:add{ name="Ally", reaction={}}
Faction:setInitialReaction("ally", "enemy", -100, true)
Faction:setInitialReaction("ally", "player", 100, true)

