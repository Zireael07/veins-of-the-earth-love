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

--No scrambling, just get text
function _M:getText(text)
    return text
end

function _M:replace(text, actor)
    --languages
    if not self.player:speakSameLanguage(self.npc) then
        if actor == self.npc and self.npc:speakLanguage("Drow") then
            text = self:drowLanguage(text)
        else
        --scramble text
        text = self:scramble(text)
        end
    else
        --apply dwarven accent always
        if actor:speakLanguage("Dwarven") then
            text = self:dwarvenAccent(text)
        end
    end

    return text
end

--Languages support
--Scramble languages
--ROT13 function from luausers.org 2004/10/21 Philippe Lhoste
function _M:scramble(text)
  local byte_a, byte_A = string.byte('a'), string.byte('A')
  return (string.gsub(text, "[%a]",
      function (char)
        local offset = (char < 'a') and byte_A or byte_a
        local b = string.byte(char) - offset -- 0 to 25
        b = math.mod(b  + 13, 26) + offset -- Rotate
        return string.char(b)
      end
    ))
end

--Based on string.bookCapitalize
function _M:postProcess(text)
    local words = text:split(' ')

    for i = 1, #words do
        local word = words[i]

        -- Don't scramble certain words
        if word ~= "vendui" and word ~= "usstan" and word ~= "lil" and word ~= "nau" and word ~= "xun" and word ~= "luth" and word ~= "bol"
        then
            words[i] = self:scramble(word)
        end
    end

    return table.concat(words, " ")
end

--Drow
function _M:drowLanguage(text)
    text = text:gsub(" welcome ", " vendui ")
    text = text:gsub(" I ", " usstan ")
    text = text:gsub(" the ", " lil ")
    text = text:gsub(" no ", " nau ")
    text = text:gsub(" do ", " xun ")
    text = text:gsub(" cast ", " luth ")
    text = text:gsub(" item ", " bol ")

    text = self:postProcess(text)
    return text
end

--Dwarven accent from FK
function _M:dwarvenAccent(text)
    text = text:gsub(" about ", " aboot ")
    text = text:gsub(" after ", " efter ")
    text = text:gsub(" all ", " a' ")
    text = text:gsub(" alright ", " a'right ")
    text = text:gsub(" and ", " an' ")
    text = text:gsub(" being ", " bein' ")
    text = text:gsub(" before ", " afore ")
    text = text:gsub(" between ", " a'tween ")
    text = text:gsub(" call ", " ca' ")
    text = text:gsub(" can ", " kin ")
    text = text:gsub(" cannot ", " cannae ")
    text = text:gsub(" can't ", " cannae ")
    text = text:gsub(" children ", " weans ")
    text = text:gsub(" cold ", " cauld ")
    text = text:gsub(" couldn't ", " couldnae ")
    text = text:gsub(" crazy ", " daft ")
    text = text:gsub(" dead ", " deid ")
    text = text:gsub(" deaf ", " deef ")
    text = text:gsub(" down ", " doon ")
    text = text:gsub(" fellow ", " fella ")

    text = text:gsub(" I ", " Ah ")
    text = text:gsub(" do", " dae ")
    text = text:gsub(" does ", " diz ")
    text = text:gsub(" done ", " doon ")
    text = text:gsub(" don't ", " donnae ")
    text = text:gsub(" for ", " fur ")
    text = text:gsub(" girl ", " lass ")
    text = text:gsub(" boy ", " lad ")
    text = text:gsub(" give ", " gie ")
    text = text:gsub(" gonna ", " gonnae ")
    text = text:gsub(" haven't ", " havnae ")
    text = text:gsub(" into ", " intae ")
    text = text:gsub(" isn't ", " isnae ")
    text = text:gsub(" just ", " jist ")
    text = text:gsub(" my ", " ma ")
    text = text:gsub(" no ", " nae ")
    text = text:gsub(" not ", " no' ")
    text = text:gsub(" of ", " o' ")
    text = text:gsub(" on ", " oan ")
    text = text:gsub(" our ", " oor ")
    text = text:gsub(" out ", " oot ")
    text = text:gsub(" over ", " o'er ")
    text = text:gsub(" shouldn't ", " shouldnae ")
    text = text:gsub(" to ", " tae ")
    text = text:gsub(" too ", " tae ")
    text = text:gsub(" wasn't ", " wiznae ")
    text = text:gsub(" what ", " whit ")
    text = text:gsub(" won't ", " willnae ")
    text = text:gsub(" with ", "wi' ")
    text = text:gsub(" you ", " ye ")
    text = text:gsub(" your ", " yer ")

    text = text:gsub(" head ", " heid ")
    text = text:gsub(" herself ", " hersel' ")
    text = text:gsub(" himself ", " himsel' ")
    text = text:gsub(" home ", " hame ")
    text = text:gsub(" hundred ", " hunner ")
    text = text:gsub(" little ", " wee ")
    text = text:gsub(" messy ", " manky ")
    text = text:gsub(" more ", " mair ")
    text = text:gsub(" myself ", " masel' ")
    text = text:gsub(" poor ", " puir ")
    text = text:gsub(" round ", " roond ")
    text = text:gsub(" small ", " wee ")
    text = text:gsub(" south ", " sooth ")
    text = text:gsub(" those ", " thae ")
    text = text:gsub(" told ", " telt ")
    text = text:gsub(" would ", " wid ")
    text = text:gsub(" wouldn't ", " wouldnae ")
    text = text:gsub(" yourself ", "yersel' ")

    return text
end


return Chat