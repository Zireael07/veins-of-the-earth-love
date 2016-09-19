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

function table.append(dst, src)
    for i = 1, #src do dst[#dst+1] = src[i] end
    return dst
end

function string.capitalize(str)
    if #str > 1 then
        return string.upper(str:sub(1, 1))..str:sub(2)
    elseif #str == 1 then
        return str:upper()
    else
        return str
    end
end

return utils