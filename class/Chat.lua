--Based on T-Engine
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
-- Nicolas Casalini "DarkGod"
-- darkgod@te4.org

require 'T-Engine.class'

local ChatDialog = require 'dialogs.ChatDialog'

module("Chat", package.seeall, class.make)

function Chat:init(name, npc, player)
    self.chats = {}
    self.npc = npc
    self.player = player
    self.name = name
    data = setmetatable({}, {__index=_G})
    self.data = data
    if not data.player then data.player = player end
    if not data.npc then data.npc = npc end

    local f, err = loadfile(self:getChatFile(name))
    if not f and err then error(err) end
    setfenv(f, setmetatable({
        newChat = function(c) self:addChat(c) end,
    }, {__index=data}))
    self.default_id = f()
end

function Chat:getChatFile(file)
    return "data/chats/"..file..".lua"
end

function Chat:addChat(c)
    assert(c.id, "no chat id")
    assert(c.text, "no chat text")
    assert(c.answers, "no chat answers")
    self.chats[c.id] = c
    print("[CHAT] loaded", c.id, c)
end

function Chat:get(id)
    local c = self.chats[id]
    return c
end

function Chat:invoke(id)
    --[[if self.npc.onChat then self.npc:onChat() end
    if self.player.onChat then self.player:onChat() end]]

    print("[CHAT] invoking")

    setDialog("chat", {chat=self, id=id or self.default_id})
end

function _M:replace(text)
    return text
end

return Chat