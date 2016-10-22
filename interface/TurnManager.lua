require 'T-Engine.class'

--Handle turns
module("TurnManager", package.seeall, class.make)

function TurnManager:init(entities)
    print("[TURN MANAGER] Initing entities")

    s = TurnManager:getSchedulerClass()
    --s  =ROT.Scheduler.Action:new()
    --put entities into scheduler
    for i, e in ipairs(entities) do
      s:add(i,true,i-1) 
    end

    --self:getVisibleActors()
end 

function TurnManager:getSchedulerClass()
    s  =ROT.Scheduler.Action:new()

    return s
end

function TurnManager:rounds()
    --do nothing if we're locked (waiting for player to finish turn)
    if game_locked then return end
      --love.timer.sleep(.5)
    --gets the number
    c  =s:next()
    
    --test 
    curr_ent = TurnManager:getCurrentEntity()
    
    dur=10 --test
    s:setDuration(dur)

    --move actors in sync with the debug display
    for i=1,#entities do
        local item = entities[i]
        --is it our round to act?
        if i == c then
            if item['act'] then item:act() end
        end
    end

    --debug display
    local name = curr_ent.name
    --used by debug display
    if s then
      local time_elapsed = s:getTime()
      schedule_curr = "TIME: "..time_elapsed
    end
    schedule_curr = "["..schedule_curr.."] TURN: "..curr_ent.name.." ["..c.."] for "..dur.." units of time"
    
    if curr_ent.player == true then 
      player_lock()
      --calendar
      if s:getTime() > 0 then onTurn() end

      schedule_curr = "PLAYER "..schedule_curr 
    end

      self:setDebugString(schedule_curr)

      game_turn = s:getTime()
end

function TurnManager:getCurrentEntity()
    curr_ent = entities[c]
    return curr_ent
end

function TurnManager:setDebugString(s)
    schedule_debug = s
end

function TurnManager:getDebugString()
    return schedule_debug
end

function TurnManager:schedule()
    print("[TURN MANAGER] Cleaning up the scheduler...")
    --clear the scheduler
    s:clear()

    --put entities into scheduler
    for i, e in ipairs(entities) do
      s:add(i,true,i-1) 
      --print("[Scheduler] Added: ", i, e)
    end

    --self:getVisibleActors()
end

function TurnManager:removeDead()
    for i=#entities,1,-1 do
        local item = entities[i]
        if item.dead then
            print("Removing entity from list", i, item.name)
            table.remove(entities, i)
        end
    end
end

function TurnManager:unlocked()
    removeDead()
    schedule()
end

function TurnManager:getVisibleActors()
    --print("[TURN MANAGER] Getting visible actors")
    temp_actors = table.clone(entities, true)
   for y=1, Map:getWidth()-1 do
      for x=1, Map:getHeight()-1 do 
          --if Map:isTileSeen(x,y) and Map:getCellActor(x,y) then 
          if not Map:isTileSeen(x,y) and Map:getCellActor(x,y) then
              a = Map:getCellActor(x, y)
              

              for i=#temp_actors, 1, -1 do
                local item = temp_actors[i]
                if a == item then
                  print("Removing non-visible entity from list #", i, a.name)
                  table.remove(temp_actors, i)
                end
              end
--[[              for i=1, #entities do
                local item = entities[i]
                if a == item then
                  visible_actors[#visible_actors+1] = a
                  print("[TURN MANAGER] Added actor "..a.name.." to visible actors")
                end
              end]]
          end
      end
  end
  for i, e in ipairs(temp_actors) do
    print("[TURN MANAGER] Visible actor #", i, "name: ", e.name)
  end

  return temp_actors

end

return TurnManager