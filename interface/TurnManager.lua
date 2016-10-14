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
end 

function TurnManager:getSchedulerClass()
    s  =ROT.Scheduler.Action:new()

    return s
end

function TurnManager:rounds()
    --do nothing if we're locked (waiting for player to finish turn)
    if game_locked then return end
      love.timer.sleep(.5)
    --gets the number
    c  =s:next()
    
    --test 
    curr_ent = entities[c]
    --debug display
    local name = curr_ent.name

    dur=10 --test
    s:setDuration(dur)

    --used by debug display
    if s then
      local time_elapsed = s:getTime()
      schedule_curr = "TIME: "..time_elapsed
    end
    schedule_curr = "["..schedule_curr.."] TURN: "..curr_ent.name.." ["..c.."] for "..dur.." units of time"
    if curr_ent.player == true then 
      game_lock()
      if s:getTime() > 0 then onTurn() end
    --end
      schedule_curr = "PLAYER "..schedule_curr end

      self:setDebugString(schedule_curr)
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
    print("Cleaning up the scheduler...")
    --clear the scheduler
    s:clear()

    --put entities into scheduler
    for i, e in ipairs(entities) do
      s:add(i,true,i-1) 
      --print("[Scheduler] Added: ", i, e)
    end
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

return TurnManager