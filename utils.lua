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
    local x_diff = sx-tx
    local y_diff = sy-ty
    --ensure always positive values
    if x_diff < 0 then x_diff = x_diff*-1 end
    if y_diff < 0 then y_diff = y_diff*-1 end
    return math.max(x_diff, y_diff)
end

function table.append(dst, src)
    for i = 1, #src do dst[#dst+1] = src[i] end
    return dst
end

function table.clone(tbl, deep, k_skip)
    if not tbl then return nil end
    local n = {}
    k_skip = k_skip or {}
    for k, e in pairs(tbl) do
        if not k_skip[k] then
            -- Deep copy subtables, but not objects!
            if deep and type(e) == "table" and not e.__ATOMIC and not e.__CLASSNAME then
                n[k] = table.clone(e, true, k_skip)
            else
                n[k] = e
            end
        end
    end
    return n
end

table.NIL_MERGE = {}

--- Merges two tables in-place.
-- The table.NIL_MERGE is a special value that will nil out the corresponding dst key.
-- @param dst The destination table, which will have all merged values.
-- @param src The source table, supplying values to be merged.
-- @param deep Boolean that determines if tables will be recursively merged.
-- @param k_skip A table containing key values set to true if you want to skip them.
-- @param k_skip_deep Like k_skip, except this table is passed on to the deep recursions.
-- @param addnumbers Boolean that determines if two numbers will be added rather than replaced.
function table.merge(dst, src, deep, k_skip, k_skip_deep, addnumbers)
    k_skip = k_skip or {}
    k_skip_deep = k_skip_deep or {}
    for k, e in pairs(src) do
        if not k_skip[k] and not k_skip_deep[k] then
            -- Recursively merge tables
            if deep and dst[k] and type(e) == "table" and type(dst[k]) == "table" and not e.__ATOMIC and not e.__CLASSNAME then
                table.merge(dst[k], e, deep, nil, k_skip_deep, addnumbers)
            -- Clone tables if into the destination
            elseif deep and not dst[k] and type(e) == "table" and not e.__ATOMIC and not e.__CLASSNAME then
                dst[k] = table.clone(e, deep, nil, k_skip_deep)
            -- Nil out any NIL_MERGE entries
            elseif e == table.NIL_MERGE then
                dst[k] = nil
            -- Add number entries if "add" is set
            elseif addnumbers and not dst.__no_merge_add and dst[k] and type(dst[k]) == "number" and type(e) == "number" then
                dst[k] = dst[k] + e
            -- Or simply replace/set with the src value
            else
                dst[k] = e
            end
        end
    end
    return dst
end

function table.mergeAppendArray(dst, src, deep, k_skip, k_skip_deep, addnumbers)
    -- Append the array part
    k_skip = k_skip or {}
    for i = 1, #src do
        k_skip[i] = true
        local b = src[i]
        if deep and type(b) == "table" then
            if b.__ATOMIC or b.__CLASSNAME then
                b = b:clone()
            else
                b = table.clone(b, true)
            end
        end
        table.insert(dst, b)
    end
    -- Copy the table part
    return table.merge(dst, src, deep, k_skip, k_skip_deep, addnumbers)
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

--necessary for calendar
function string.ordinal(number)
    local suffix = "th"
    number = tonumber(number)
    local base = number % 10
    if base == 1 then
        suffix = "st"
    elseif base == 2 then
        suffix = "nd"
    elseif base == 3 then
        suffix = "rd"
    end
    return number..suffix
end

return utils