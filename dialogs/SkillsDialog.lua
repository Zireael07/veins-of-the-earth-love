require 'T-Engine.class'

local ActorSkills = require "interface.ActorSkills"

module("SkillsDialog", package.seeall, class.make)

function SkillsDialog:draw(player)
    love.graphics.setColor(255,255,255)
    --background
    love.graphics.draw(loaded_tiles["stone_bg"], 150, 20, 0, 1.5,2)
    love.graphics.setColor(255, 255, 102)

    love.graphics.print("STARTING SKILLS", 200, 30)

    love.graphics.print("Points left: "..player.player_skillpoints, 200, 50)
    local x = 200
    local y = 70
    for i, s in ipairs(ActorSkills.skill_defs) do
        local skill = s.id
        local value = player["skill_"..skill]
        love.graphics.print(s.name..": "..value, x, y)
        love.graphics.draw(loaded_tiles["ui_left_arrow"], x+135, y-5)
        love.graphics.draw(loaded_tiles["ui_right_arrow"], x+160, y-5)
        y = y + 20
    end
end

function SkillsDialog:mouse()
    skill, change = SkillsDialog:mousetoskill()
end

function SkillsDialog:mousetoskill()
    if mouse.x < 335 or mouse.y < 70 then return end

    local val
    local change

    local x = 335
    local y = 70
    for i=1, #ActorSkills.skill_defs do
        if mouse.x > x and mouse.x < x + 20 then
            change = "minus"
            if mouse.y > y and mouse.y < y + 20 then
                val = ActorSkills.skill_defs[i].id
            end
        elseif mouse.x > x + 20 and mouse.x < x + 40 then
            change = "plus"
            if mouse.y > y and mouse.y < y + 20 then
                val = ActorSkills.skill_defs[i].id
            end
        end
        y = y + 20
    end

    --print("[STARTING SKILLS] Val :", val, "change:", change)

    return val, change, index
end

function SkillsDialog:mouse_pressed(x,y,b)
    if b == 1 then
        if skill and change then
            local amount = 1
            if player.player_skillpoints > 0 then
                if change == "plus" then
                    player["skill_"..skill] = player["skill_"..skill] + amount
                    player.player_skillpoints = player.player_skillpoints - amount
                else
                    player["skill_"..skill] = player["skill_"..skill] - amount
                    player.player_skillpoints = player.player_skillpoints + amount
                end
            end
        end
    end
end

return SkillsDialog