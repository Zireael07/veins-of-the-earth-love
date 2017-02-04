require 'T-Engine.class'

module("UIElements", package.seeall, class.make)

element = {}

function UIElements:load()
end

function UIElements:unload()
    element = {}
end

function UIElements:init_text_button(x,y, w, id, text, on_press)
    if not x or not y or not id or not text then print("[UI] Missing parameters!") return end
    element[#element+1] = {x = x, y=y, w=w, id=id, text=text, on_press=on_press}
end

--function UIElements:init_

--generic stuff
function UIElements:draw(id)
    for i, e in ipairs(element) do
        if id == e.id then
            love.graphics.setColor(colors.RED)
        else
            love.graphics.setColor(255, 255, 102)
        end
        love.graphics.print(e.text, e.x, e.y)
    end
end

function UIElements:mouse()
    local id
    for i,e in ipairs(element) do
        if mouse.x > e.x and mouse.x < e.x + e.w then
            if mouse.y > e.y and mouse.y < e.y + 20 then
                id = e.id
                --print("We're over element "..id)
            end
        end
    end
    return id
end

function UIElements:mouse_pressed(x,y,b)
    if b == 1 then
        for i,e in ipairs(element) do
            if x > e.x and x < e.x + e.w then
                if y > e.y and y < e.y + 20 then
                    --print("Pressed mouse over element "..e.id)
                    if e.on_press then
                        print("We have on_press, calling it")
                        e.on_press()
                    end
                end
            end
        end
    end
end

return UIElements