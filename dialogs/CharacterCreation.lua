require 'T-Engine.class'

local dice = require('libraries/dice')
local utf8 = require("utf8")

module("CharacterCreation", package.seeall, class.make)

function CharacterCreation:load()
    text = " "
end

function CharacterCreation:draw(player)
    love.graphics.setColor(255,255,255)
    --background
    love.graphics.draw(loaded_tiles["stone_bg"], 150, 20, 0, 1.5,1.5)

    
    love.graphics.setColor(255, 255, 102)

    love.graphics.print("CHARACTER CREATION", 200, 30)

    local y = 50
    love.graphics.print("STR:", 155, y)
    love.graphics.print("DEX:", 155, y+25)
    love.graphics.print("CON:", 155, y+50)
    love.graphics.print("INT:", 155, y+75)
    love.graphics.print("WIS:", 155, y+100)
    love.graphics.print("CHA:", 155, y+125)
    for i=1,6 do
        love.graphics.setColor(colors.RED)
        love.graphics.rectangle('line', 200, y, 20, 20)
        
        love.graphics.setColor(255, 255, 102)
        local stat = CharacterCreation:getStatForBox(i)
        if player:getStat(stat) then
            love.graphics.print(player:getStat(stat), 200, y)
        end

        y = y + 25
    end

    local y = 50
    love.graphics.setColor(255, 255, 102)
    love.graphics.print("REROLL", 250, y+30)

    love.graphics.setColor(colors.WHITE)
    if self.rolled then
        for i,s in ipairs(self.rolled) do
            if i == index then
                love.graphics.setColor(colors.RED)
            else
                love.graphics.setColor(colors.WHITE)
            end
            love.graphics.print(self.rolled[i], 350, y)
            y = y + 25
        end
    end
    if drag then
        love.graphics.setColor(colors.GREEN)
        love.graphics.print(drag.val, mouse.x + 10, mouse.y + 2)
    end

    --pick gender
    local x = 400
    local y = 50

    love.graphics.setColor(255, 255, 102)
    if not player.gender then
        love.graphics.rectangle('line', x, y, 20, 20)
    elseif player.gender == "female" then
        love.graphics.rectangle('fill', x, y, 20, 20)
    end
    love.graphics.print("Female", x+30, y)

    --love.graphics.rectangle('line', x+100, y, 20, 20)
    if not player.gender then
        love.graphics.rectangle('line', x+100, y, 20, 20)
    elseif player.gender == "male" then
        love.graphics.rectangle('fill', x+100, y, 20, 20)
    end
    love.graphics.print("Male", x+130, y)

    --name input
    love.graphics.setColor(colors.SLATE)
    local x = 400
    local y = 75
    love.graphics.rectangle('fill', x, y, 200, 20)
    love.graphics.setColor(255, 255, 102)
    love.graphics.printf(text, x, y, 600)

    --race selection
    love.graphics.setColor(255, 255, 102)
    races = { {name="Human"},  {name="Half-Elf", stats_add = { cha = 2, }}, {name="Dwarf", stats_add = { con = 2, cha = -2}} }
    local x = 400
    local y = 100
    for i, r in ipairs(races) do
        if i == race then
            love.graphics.setColor(colors.RED)
        else
            love.graphics.setColor(255, 255, 102)
        end
        love.graphics.print(r.name, x, y)
        y = y + 15
    end
end

function CharacterCreation:mouse_pressed(x,y,b)
    if mouse.x < 150 or mouse.y < 30 then return end 

    local s = 40
    if b == 1 then
        if mouse.x > 250 and mouse.x < 250+s then
            CharacterCreation:reroll()
        end
        if drag then
            if box then
                --set the proper stat
                stat = CharacterCreation:getStatForBox(box)
                CharacterCreation:setStat(stat, drag.val)
                --remove it from rolled stats
                CharacterCreation:removeRolled(drag.index)
                --quit dragging
                drag = nil
            end
        end

        if mouse_over then
            drag = { val = mouse_over, index = index}
        end

        --gender
        if mouse.x > 400 and mouse.x < 420 then
            if mouse.y > 50 and mouse.y < 75 then
                CharacterCreation:setGender("female")
            end
        end
        if mouse.x > 500 and mouse.x < 520 then
            if mouse.y > 50 and mouse.y < 75 then
                CharacterCreation:setGender("male")
            end
        end

        --races
        if mouse.x > 400 and mouse.x < 450 then
            if race then
                CharacterCreation:selectRace(race)
            end
        end
    --right mouse button
    elseif b == 2 then
        --cancel drag
        if drag then
            drag = nil
        end
    end
end

function CharacterCreation:reroll()
    --print("Rerolling!")
    self.rolled = {}

    for i=1,6 do
        self.rolled[i] = dice.roll('3d6')
    end
end

function CharacterCreation:mouse()
    mouse_over, index = CharacterCreation:mousetodrag()
    box = CharacterCreation:mousetobox()
    race = CharacterCreation:mousetoRace()
end

function CharacterCreation:mousetodrag()
    if mouse.x < 350 or mouse.y < 50 then return end

    if not self.rolled then return end

    local val
    local index
    if mouse.x > 350 and mouse.x < 400 then
        if mouse.y > 50 and mouse.y < 75 then
            index = 1
            val = self.rolled[index]
        end
        if mouse.y > 75 and mouse.y < 100 then
            index = 2
            val = self.rolled[index]
        end
        if mouse.y > 100 and mouse.y < 125 then
            index = 3
            val = self.rolled[index]
        end
        if mouse.y > 125 and mouse.y < 150 then
            index = 4
            val = self.rolled[index]
        end
        if mouse.y > 150 and mouse.y < 175 then
            index = 5
            val = self.rolled[index]
        end
        if mouse.y > 175 and mouse.y < 200 then
            index = 6
            val = self.rolled[index]
        end
    end

    return val, index
end

function CharacterCreation:mousetobox()
    if mouse.x < 150 and mouse.y < 60 then return end

    local box
    if mouse.x > 200 and mouse.x < 250 then
        if mouse.y > 50 and mouse.y < 75 then
            box = 1
        end
        if mouse.y > 75 and mouse.y < 100 then
            box = 2
        end
        if mouse.y > 100 and mouse.y < 125 then
            box = 3
        end
        if mouse.y > 125 and mouse.y < 150 then
            box = 4
        end
        if mouse.y > 150 and mouse.y < 175 then
            box = 5
        end
        if mouse.y > 175 and mouse.y < 200 then
            box = 6
        end
    end

    return box
end

function CharacterCreation:getStatForBox(box)
    boxes = { [1] = "STR", [2] = "DEX", [3] = "CON", [4] = "INT", [5] = "WIS", [6]="CHA"}
    --print("Getting stat for box", box, "stat: ", boxes[box])
    return boxes[box]
end

function CharacterCreation:setStat(stat, val)
    --print("[CHARACTER CREATION] Setting stat", stat, val)
    player:setStat(stat, val)
end

function CharacterCreation:removeRolled(index)
    table.remove(self.rolled, index)
end

function CharacterCreation:setGender(val)
    player.gender = val
end

function CharacterCreation:mousetoRace()
    if mouse.x < 400 and mouse.y < 100 then return end
    local race
    if mouse.x > 400 and mouse.x < 450 then
        if mouse.y > 100 and mouse.y < 115 then
            race = 1 --"Human"
        end
        if mouse.y > 115 and mouse.y < 130 then
            race = 2 --"Half-Elf"
        end
        if mouse.y > 130 and mouse.y < 150 then
            race = 3 --"Dwarf"
        end
    end

    return race
end

function CharacterCreation:selectRace(race)
    --print("[CHARACTER CREATION] selected race #", race)

    print("Race selected is", races[race].name)

    if races[race].stats_add then
        for stat, val in pairs(races[race].stats_add) do
            local curr = player:getStat(stat:upper())
            --print("Current val for stat", curr, stat, "to add", val)
            player:setStat(stat:upper(), curr+val)
        end
    end
end

--text input
function CharacterCreation:textinput(t)
    text = text .. t
end

function CharacterCreation:keypressed(key)
    if key == "backspace" then
        -- get the byte offset to the last UTF-8 character in the string.
        local byteoffset = utf8.offset(text, -1)
 
        if byteoffset then
            -- remove the last UTF-8 character.
            -- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
            text = string.sub(text, 1, byteoffset - 1)
        end
    end
end

return CharacterCreation