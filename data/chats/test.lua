--Veins of the Earth
--Zireael 2016

newChat{ id="start",
    text = [[Welcome, adventurer! Would you like me to help?]],
    answers = {
        {[[Yes, please.]], action = function(npc, player)
--[[    if player:skillCheck("diplomacy", 10) then return "test"
    else return "sorry"  end]]
    return "test"
    end
    },
        {[[I don't have money.]], skill = "bluff", action = function(npc, player)
    if player:skillCheck("bluff", 10) then return "test"
    else return "sorry" end
    end,
    cond=function(npc, player)
        if player:getStat("INT") < 10 then return end
        return true
    end
    },
        {[[Me no have money.]], skill = "bluff", action = function(npc, player)
    if player:skillCheck("bluff", 10) then return "test"
    else return "sorry" end
    end,
    cond=function(npc, player)
        if player:getStat("INT") >= 10 then return end
        return true
    end
    },
        {[[Show them or I will kill you!]], skill = "intimidate", action = function(npc, player)
    if player:skillCheck("intimidate", 10) then return "test"
    else return "sorry" end
    end,
    cond=function(npc, player)
        if player:getStat("INT") < 10 then return end
        return true
    end
    },
        {[[You give stuff or me kill you!]], skill = "intimidate", action = function(npc, player)
    if player:skillCheck("intimidate", 10) then return "test"
    else return "sorry" end
    end,
    cond=function(npc, player)
        if player:getStat("INT") >= 10 then return end
        return true
    end
    },
       -- {[[Back away.]], action = function(npc, player) player:displace(npc) end    },
    },
}

newChat{ id="test",
    text = [[I will help you.]],
    answers = {
        {[[Thank you]], action = function(npc, player)

    end
    },
    },
}

newChat{ id="sorry",
    text = [[I will not help you, you ruffian!]],
    answers = {
        {[[*Get angry and kill him*]], action = function(npc, player)
            npc.faction = "enemy"
        end
        },
        {[[Leave.]]},
    },
}


return "start"
