require 'T-Engine.class'

module("HelpControls", package.seeall, class.make)

function HelpControls:draw()
    love.graphics.setColor(255,255,255)
    --background
    love.graphics.draw(loaded_tiles["stone_bg"], 150, 20, 0, 1.5,1.5)

    love.graphics.setColor(255, 255, 102)
    love.graphics.print("HELP - CONTROLS", 180, 30)

    local text = [[
    Use arrow keys or mouse to move. 
    Press G to pick up items. These only work on your turn!

    Press TAB to show labels for actors and items on the screen.
    Press C to display character sheet.
    Press I to display your inventory.
    Press L to display all the log messages.

    Press ESC to exit any dialogs.

    Press ? (Shift + /) to bring up this help screen.]]


    love.graphics.printf(text, 150, 50, 600)

end

return HelpControls