require 'T-Engine.class'

module("LogDialog", package.seeall, class.make)

function LogDialog:load()
    scrolling = false
end

function LogDialog:draw()
    love.graphics.setColor(colors.SLATE[1], colors.SLATE[2], colors.SLATE[3], 100)
    w = 450
    x = 150
    y = 50
    max_h = love.graphics.getHeight()-70
    h = max_h-50-75 --minus the y we start drawing at, minus on-screen log height (5*15)
    love.graphics.rectangle('fill', x, y, w, h)

    local lines_num = math.floor(h/20)

    local i2 = #logMessages
    local i1 = i2-lines_num
    i1 = math.max(1, i1+1)

    print("i1 = " .. i1 .. ", i2 = " .. i2)

    local a = 255
    --messages
    for i = i1, i2 do
        local myColor = r,g,b,a
        love.graphics.setColor(a,a,a,a)
        love.graphics.print(logMessages[i]['message'], x, y)
        y = y + 20
    end


end

return LogDialog