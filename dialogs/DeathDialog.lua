require 'T-Engine.class'

module("DeathDialog", package.seeall, class.make)

function DeathDialog:draw()
    love.graphics.setColor(255,255,255)
    --background
    love.graphics.draw(loaded_tiles["stone_bg"], 150, 20, 0, 1.5,1.5)

    love.graphics.setColor(255, 255, 102)
    love.graphics.print("Dead!", 180, 30)

    local text = [[
    You have died!
    Death in Veins of the Earth is usually permanent.]]


    love.graphics.printf(text, 150, 50, 600)

end

return DeathDialog