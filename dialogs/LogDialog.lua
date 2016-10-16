require 'T-Engine.class'

module("LogDialog", package.seeall, class.make)

function LogDialog:draw()
    love.graphics.setColor(colors.SLATE)
    w = 450
    x = 150
    y = 50
    max_h = love.graphics.getHeight()-70
    h = max_h-20
    love.graphics.rectangle('fill', x, y, w, h)

    local a = 255
    --messages
    for i, message in ipairs(logMessages) do
        local myColor = r,g,b,a
        love.graphics.setColor(a,a,a,a)
        love.graphics.print(message['message'], x, y)
        y = y < max_h and y + 20 or 50
    end
end

return LogDialog