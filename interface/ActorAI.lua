require 'T-Engine.class'

local Pathfinding = require "interface.Pathfinding"

local Map = require "class.Map"

module("ActorAI", package.seeall, class.make)

actor_path = {}

function ActorAI:target(tx, ty, self_x, self_y)
    if not tx or not ty then return end
    
    print("[ActorAI] running AI")

    --test
    local w = Map:getWidth()-1
    local h = Map:getHeight()-1
    dir_x, dir_y = Pathfinding:findPathDijkstra(tx, ty, self_x, self_y, w, h)

    return dir_x, dir_y

    --[[actor_path = Pathfinding:findPath(target.x, target.y, self_x, self_y)
    if actor_path then 
      --print("[ActorAI] We have a self path") 
      return ActorAI:getPath()
    end]]
end

function ActorAI:getPath()
  --print("Getting path")
  return actor_path
end

return ActorAI
