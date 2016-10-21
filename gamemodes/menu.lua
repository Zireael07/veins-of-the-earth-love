gamemode = {}

function gamemode.load()
    background = love.graphics.newImage("gfx/Veins.png")
    welcome_text = "Welcome to Veins of the Earth!"
end

function gamemode.keypressed(k)
    if k == "return" then
        welcome_text = "Loading..."
        --print("Pressed escape key")   
        loadGamemode("game")
    end
end

function gamemode.draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(background)
    love.graphics.setColor(colors.GOLD)
    love.graphics.rectangle("line", 100, 100, 350, 100)
    love.graphics.setColor(colors.SLATE)
    love.graphics.rectangle("fill", 100, 100, 350, 100)
    love.graphics.setColor(colors.ORANGE)
    love.graphics.print(welcome_text, 100, 100)
    love.graphics.print("Press ENTER to start game!", 100, 150)
end