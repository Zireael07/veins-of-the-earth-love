--do stuff
do
    require "gamefunctions"
    loadGamemode("menu")
end

function love.draw()
    if not (gamemode and gamemode.draw and not gamemode.draw()) then
        love.graphics.print("Debug", 400, 300)
    end
end

function love.keypressed(key)
    print("Pressed key: ".. key)
    --if gamemode and gamemode.keypressed and not gamemode.keypressed(k) then return end
    if gamemode and gamemode.keypressed then gamemode.keypressed(key) end
    --keys that are always active
	local alt = (love.keyboard.isDown("lalt") or love.keyboard.isDown("ralt"))
    if k == "f4" and alt then love.event.push("q") end
end

function love.update(dt)
    if gamemode then
      if gamemode.update then 
        if gamemode.update(dt) then gamemode.update(dt) end
      end
    else return end
end

-- called when a player clicks the mouse
function love.mousepressed(x, y, b)
    if b == 3 then love.keypressed("escape") return end
  --  if gamemode and gamemode.mousepressed and not gamemode.mousepressed(cursor.x, cursor.y, b) then return end
    if gamemode and gamemode.mousepressed then gamemode.mousepressed(x,y,b) end
    if gamemode and gamemode.postmousepressed then gamemode.postmousepressed(cursor.x, cursor.y, b) end
end