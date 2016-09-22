require 'T-Engine.class'

module("Encounter", package.seeall, class.make)

encounter = {}

function Encounter:getNPCsByCR(val)
    print("[Encounter] val is: ", val)
    for k, v in pairs(npc_types) do
        print("[Encounter] Getting NPC types", k, v)

        --check CR
        if v.challenge == val then
            table.insert(encounter, k)
        end
    end
end

function Encounter:makeEncounter()
    local x = x
    local y = y
    for i,e in ipairs(encounter) do
        print("[Encounter] Getting encounter: ", i,e)
    end

    return encounter
end


return Encounter