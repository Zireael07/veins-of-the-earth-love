require 'T-Engine.class'

local Pathfinding = require "interface.Pathfinding"

module("ActorAI", package.seeall, class.make)

actor_path = {}

function ActorAI:target(target, self_x, self_y)
    if not target then return end
    
    print("[ActorAI] running AI")

    actor_path = Pathfinding:findPath(target.x, target.y, self_x, self_y)
    if actor_path then 
      --print("[ActorAI] We have a self path") 
      return ActorAI:getPath()
    end
end

function ActorAI:getPath()
  --print("Getting path")
  return actor_path
end

return ActorAI
