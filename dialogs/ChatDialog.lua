require 'T-Engine.class'

module("ChatDialog", package.seeall, class.make)

function ChatDialog:draw(chat, id)
    self.chat = chat
    self.npc = chat.npc
    self.player = chat.player
    self.cur_id = id

    --print("[CHAT] drawing chat for ", self.npc.name, id)
    self:generateText()

    love.graphics.setColor(255,255,255)
    --background
    love.graphics.draw(loaded_tiles["stone_bg"], 150, 30, 0, 1,1)

    love.graphics.printf(self.text, 150, 40, 400)

    love.graphics.setColor(colors.GOLD)
    love.graphics.line(150, 100, 550, 100)

    love.graphics.setColor(colors.WHITE)
    x = 150
    y = 110
    for i, a in ipairs(self.list) do
        --color moused-over answer differently
        if i == mouse_answer_number then
            love.graphics.setColor(colors.GOLD)
        else 
            love.graphics.setColor(colors.WHITE)
        end
        love.graphics.printf(a.name, x, y, 300)
        y = y + 15
    end

end

function ChatDialog:generateText()
    --print("[CHAT] generating text")
    self.text = self.chat:replace(self.chat:get(self.cur_id).text, self.npc)

    -- Makes up the list
    local answers_list = {}
    local nb = 1
    for i, a in ipairs(self.chat:get(self.cur_id).answers) do
        if not a.fallback and (not a.cond or a.cond(self.npc, self.player)) then
            answers_list[#answers_list+1] = { name=string.char(string.byte('a')+nb-1)..") "..self.chat:replace(a[1], self.player), answer=i, color=a.color}
            nb = nb + 1
        end
    end

    self.list = answers_list
end

function ChatDialog:mouse()
    mouse_answer_number = ChatDialog:mousetoanswer()
    mouse_answer = ChatDialog:getAnswerfromMouse()
end

function ChatDialog:getAnswerfromMouse()
    if not self.list then return nil end
    for i, a in ipairs(self.list) do
        --get answer id from the order on screen
        if i == mouse_answer_number then
            --print("[CHAT] Return answer id", a.answer)
            return a.answer
        end
    end
end

function ChatDialog:mousetoanswer()
    if mouse.x < 150 or mouse.y < 110 then return end

    local answer
    local h = 15

    if mouse.x > 150 and mouse.x < 550 then
        if mouse.y > 110 and mouse.y < 110+h then
            answer = 1
        end
        if mouse.y > 125 and mouse.y < 125+h then
            answer = 2
        end
        if mouse.y > 140 and mouse.y < 140+h then
            answer = 3
        end
    end

    --print("Mousing over answer #", answer)

    return answer
end

function ChatDialog:mouse_pressed(x,y,b)
    if b == 1 then
        if mouse_answer then
            ChatDialog:use(mouse_answer)
        end
    end
end

function ChatDialog:use(answer)
    a = self.chat:get(self.cur_id).answers[answer]
    if not a then return end

    print("[CHAT] selected ", a[1], a.action, a.jump)

    if a.action then
        local id = a.action(self.npc, self.player, self)
        if id then
            self.cur_id = id
            self:regen()
            return
        end
    end
    if a.jump and not self.killed then
        self.cur_id = a.jump
        self:regen()
    else
        --close dialog
        setDialog('')
        return
    end
end

function ChatDialog:regen()
    print("[CHAT] regen")
    setDialog("chat", {chat=self.chat, id=self.cur_id})
end

return ChatDialog