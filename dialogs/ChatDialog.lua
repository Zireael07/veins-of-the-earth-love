require 'T-Engine.class'

module("ChatDialog", package.seeall, class.make)

function ChatDialog:draw(chat, id)
    self.chat = chat
    self.npc = chat.npc
    self.player = chat.player
    self.cur_id = id

    print("[CHAT] drawing chat for ", self.npc.name, id)
    self:generateText()

    love.graphics.setColor(255,255,255)
    --background
    love.graphics.draw(loaded_tiles["stone_bg"], 150, 30, 0, 1,1)

    love.graphics.printf(self.text, 150, 40, 300)
end

function ChatDialog:generateText()
    print("[CHAT] generating text")
    self.text = self.chat:get(self.cur_id).text
end

return ChatDialog