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

function UIElements:init_image_button(x,y, id, image, param, on_press)
    if not x or not y or not id or not image then print("[UI] Missing parameters!") return end
    element[#element+1] = {x=x, y=y, id=id, image=image, param=param, on_press=on_press}
end

--generic stuff
function UIElements:draw(id)
    for i, e in ipairs(element) do
        if e.text then
            if id == e.id then
                love.graphics.setColor(colors.RED)
            else
                love.graphics.setColor(255, 255, 102)
            end
            love.graphics.print(e.text, e.x, e.y)
        end
        if e.image then
            love.graphics.draw(loaded_tiles[e.image], e.x, e.y)
        end
    end
end

function UIElements:mouse()
    local id
    local param
    for i,e in ipairs(element) do
        local width = e.w or 20
        local height = 20 
        if e.inventory then width = 42 height = 42 end

        if mouse.x > e.x and mouse.x < e.x + width then
            if mouse.y > e.y and mouse.y < e.y + height then
                if e.id then
                    id = e.id
                end
                if e.param then
                    param = e.param
                end
                --print("We're over element "..id)
            end
        end
    end
    return id, param
end

function UIElements:mouse_pressed(x,y,b)
    if b == 1 then
        for i,e in ipairs(element) do
            local width = e.w or 20
            local height = 20 
            if e.inventory then width = 42 height = 42 end

            if x > e.x and x < e.x + width then
                if y > e.y and y < e.y + height then
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

function UIElements:getParameters(i)
    return element[i].param
end

return UIElements