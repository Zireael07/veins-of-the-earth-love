-- LÖVE Shortcuts
lg  = love.graphics

--print to console in realtime
io.stdout:setvbuf('no')

--do stuff
do
    --require
    require "gamefunctions"
    --create log file
    make_log_file()
    open_save()

    --load stuff that is necessary for all the classes/modules
    load = love.filesystem.load("load.lua")
    local loaded = load()

    --require npc test
    require 'data/npcs'
    require 'data/objects'

    
    --show menu screen
    loadGamemode("menu")
end

--Zerobrane debugging
function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() end

  --set default font (large because of main menu)
  love.graphics.setFont(sherwood_large)
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

--called when the window is focused
function love.focus(f)
    if f then
        print("Window is focused.")
    else
        print("Window is not focused.")
    end
    if gamemode and gamemode.focus then gamemode.focus(f) end
end