require 'T-Engine.class'

module("CharacterSheet", package.seeall, class.make)

function CharacterSheet:draw(player)
    love.graphics.setColor(255,255,255)
    --background
    love.graphics.draw(loaded_tiles["stone_bg"], 150, 20, 0, 1.5,1.5)

    
    love.graphics.setColor(255, 255, 102)
    love.graphics.setFont(goldbox_large_font)

    love.graphics.print("CHARACTER SHEET", 300, 20)

   

    love.graphics.setColor(255, 51, 51)
    love.graphics.print("HP: "..player.hitpoints, 155, 50)
    love.graphics.print("Wounds: "..player.wounds, 155, 75)

    --draw stats
    love.graphics.setColor(255, 255, 102)
    love.graphics.print("STR: "..player:getStat("STR"), 155, 100)
    love.graphics.print("DEX: "..player:getStat("DEX"), 155, 125)
    love.graphics.print("CON: "..player:getStat("CON"), 155, 150)
    love.graphics.print("INT: "..player:getStat("INT"), 155, 175)
    love.graphics.print("WIS: "..player:getStat("WIS"), 155, 200)
    love.graphics.print("CHA: "..player:getStat("CHA"), 155, 225)

end

return CharacterSheet