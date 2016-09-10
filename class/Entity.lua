require 'T-Engine.class'

module("Entity", package.seeall, class.make)

function Entity:addEntity(e)
    if not e then print("No entity")
    else
    table.insert(entities, e)
    print("Registered an entity")
    return e
    
    end
end

return Entity