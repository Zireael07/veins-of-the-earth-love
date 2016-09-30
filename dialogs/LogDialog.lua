require 'T-Engine.class'

module("LogDialog", package.seeall, class.make)

function LogDialog:draw()
    x = love.graphics.getWidth()/2
    y = 50
    local a = 255
    for i, message in ipairs(logMessages) do
        local myColor = r,g,b,a
        love.graphics.setColor(a,a,a,a)
        love.graphics.print(message['message'], x, y)
        y = y < love.graphics.getHeight()-10 and y + 20 or 50
    end
end

return LogDialog