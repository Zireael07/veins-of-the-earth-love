require 'T-Engine.class'

local dice = require('libraries/dice')

module("CharacterCreation", package.seeall, class.make)

function CharacterCreation:draw(player)
    love.graphics.setColor(255,255,255)
    --background
    love.graphics.draw(loaded_tiles["stone_bg"], 150, 20, 0, 1.5,1.5)

    
    love.graphics.setColor(255, 255, 102)

    love.graphics.print("CHARACTER CREATION", 200, 40)

    y = 50
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

    y = 50
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
    --right mouse button
    elseif b == 2 then
        --cancel drag
        if drag then
            drag = nil
        end
    end
end

function CharacterCreation:reroll()
    print("Rerolling!")
    self.rolled = {}

    for i=1,6 do
        self.rolled[i] = dice.roll('3d6')
    end
end

function CharacterCreation:mouse()
    mouse_over, index = CharacterCreation:mousetodrag()
    box = CharacterCreation:mousetobox()
end

function CharacterCreation:mousetodrag()
    if mouse.x < 350 and mouse.y < 50 then return end

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

return CharacterCreation