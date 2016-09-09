require 'T-Engine.class'

module("utils", package.seeall, class.make)

function utils:dirfromstring(str)
    
    if str == "left" then dx = -1 dy = 0
    elseif str == "right" then dx = 1 dy = 0
    elseif str == "down" then dx = 0 dy = 1
    elseif str == "up" then dx = 0 dy = -1
    end
    
    return dx or 0, dy or 0
end

function utils:distance(sx, sy, tx, ty)
  return math.max( sx-tx, tx-ty )
end

return utils