require 'T-Engine.class'

require 'class.Map'

require 'class.NPC'
require 'class.Object'

local Entity = require 'class.Entity'

module("Spawn", package.seeall, class.make)

function Spawn:createActor(x,y, id)
    if not x or not y then print("No location parameters") return end
    if x > Map:getHeight()-1 then print("X out of bounds") end
    if y > Map:getWidth()-1 then print("Y out of bounds") end
    if not Map:getCell(x,y) then print("No cell at x,y") end
    
    local actor

    if id and npc_types[id] then
      local t = npc_types[id]
      print("Creating an npc from data", id)
      t = Entity:newEntity(t, "actor")
      actor = NPC.new(t)
    else
      --actor = Actor.new()
      print("Id not given, not doing anything") return
    end
    if actor then
      actor:move(x,y)
    end
    
    --return actor
    return Entity:addEntity(actor)
end

function Spawn:createItem(x,y, id)
    if not x or not y then print("No location parameters") return end
    if x > Map:getHeight()-1 then print("X out of bounds") end
    if y > Map:getWidth()-1 then print("Y out of bounds") end
    if not Map:getCell(x,y) then print("No cell at x,y") end

    local object
    if id and object_types[id] then
      local t = object_types[id]
      print("Creating an object from data", id)
      t = Entity:newEntity(t, "object")
      object = Object.new(t)
    else
      --object = Object.new()
      print("Id not given, not doing anything") return
    end

    if object then
      print("[Spawn] Created item at ",x,y)
      object:place(x,y)
    end

    return object
end

--NOTE: this one doesn't return, it's just called plainly
function Spawn:createPlayer(x,y)
    if not x or not y then print("No location parameters") return end
    if x > Map:getHeight()-1 then print("X out of bounds") end
    if y > Map:getWidth()-1 then print("Y out of bounds") end

    player_temp = Player.new(
      { faction = "player",
        body_parts = { torso=1, arms=1, legs=1, head=1 },
        languages = {"Undercommon"},
    body = { MAIN_HAND=1, OFF_HAND=1, SHOULDER=1, BODY=1, CLOAK=1, BELT=1, QUIVER=1, GLOVES=1, LEGS=1, ARMS=1, BOOTS=1, HELM=1, RING=2, AMULET=1, LITE=1, TOOL=1, INVEN=30 }
  })
--    Entity:addEntity(player_temp)
    player_temp:move(player_x, player_y)

    --fix player visibility on turn 1
    --player:PlayerMove("left")
    --update FOV
    player_temp:update_draw_visibility_new()

    print("[Spawn] Created player at ", x,y)
    return Entity:addEntity(player_temp)
end

function Spawn:createEncounter(data, x, y)
    if not x or not y then print("No location parameters") return end
    if x > Map:getHeight()-1 then print("X out of bounds") end
    if y > Map:getWidth()-1 then print("Y out of bounds") end

    for i, id in ipairs(data) do
      print("[Spawn] creating an encounter actor", id)
      Spawn:createActor(x,y, id)
      x = x + 2
      y = y + 2
      if Map:getCell(x,y) then
        if Map:getCellTerrain(x,y).display == "#" then
          found_x, found_y = Map:findFreeGrid(x,y,5)
          x = found_x
          y = found_y
        end
      end
    end
    
    print("[Spawn] Creating an encounter")
end


return Spawn