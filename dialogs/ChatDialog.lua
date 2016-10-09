require 'T-Engine.class'

module("ChatDialog", package.seeall, class.make)

function ChatDialog:draw(npc)
    print("[CHAT] drawing chat for ", npc, npc.text)
    love.graphics.setColor(255,255,255)
    --background
    love.graphics.draw(loaded_tiles["stone_bg"], 150, 30, 0, 1,1)

    love.graphics.printf(npc.text, 150, 40, 300)
end


return ChatDialog