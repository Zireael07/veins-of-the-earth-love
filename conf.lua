function love.conf(t)
    --version
    t.version = "0.10.1"  

    --window size
    t.window.width = 1024
    t.window.height = 768
    t.window.title = "Veins of the Earth"

    --disable unused modules
    t.modules.joystick = false
    t.modules.physics = false
end