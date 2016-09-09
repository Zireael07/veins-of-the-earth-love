-- engine functions

-- toggles whether the game is fullscreen or windowed
function toggleFullscreen()
    options.screen.isFull = not options.screen.isFull
    setScreen(options.screen.isFull and options.screen.full or options.screen.window)
end

-- sets the screen
function setScreen(opt)
    love.graphics.setMode(opt.w or 800,opt.h or 450, opt.full or false, opt.vsync or true, opt.aa or 0)
    love.mouse.setVisible(false)    -- it seems this needs to be reset each res change?...
    screen = opt
end

-- load a new gamemode
function loadGamemode(mode, skipQuit)
    if not mode then return false end
    if not skipQuit and oldGamemode and oldGamemode.quit then oldGamemode.quit() end
    love.filesystem.load("gamemodes/"..mode..".lua")() gamemode.load()
    print("Gamemode "..mode.." loaded")
    return true
end