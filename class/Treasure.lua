require 'T-Engine.class'

module("Treasure", package.seeall, class.make)

treasure = {
    coins = { 
        [1] = {
            {1, 14, "nil"},
            {15, 29, "1d6 x 1000 cp"},
            {30, 52, "1d8 x 100 sp"},
            {53, 95, "2d8 x 10 gp"},
            {96, 100, "1d4 x 1 pp"}
        }
    },
    goods = {
        [1] = {
            {1, 90, "nil"},
            {91, 95, "1 gem"},
            {96, 100, "1 art"}
    }
    },
    items = {
        [1] = {
            {1, 71, "nil"},
            {72, 95, "1 mundane"},
            {96, 100, "1 minor"}
    }
}
}

function Treasure:getCoins(lvl)
    local table = treasure.coins[lvl]
    local roll = rng:random(1, 100)

    for i, entry in ipairs(table) do
        if roll > entry[1] and roll < entry[2] then
            local res = entry[3]
            print_to_log("[TREASURE] Roll: ", roll, "generated coins: ", res)
            return res 
        end
    end

end

function Treasure:getGoods(lvl)
    local table = treasure.goods[lvl]
    local roll = rng:random(1, 100)

    for i, entry in ipairs(table) do
        if roll > entry[1] and roll < entry[2] then
            local res = entry[3]
            print_to_log("[TREASURE] Roll: ", roll, "generated goods: ", res)
            return res 
        end
    end
end

function Treasure:getItems(lvl)
    local table = treasure.items[lvl]
    local roll = rng:random(1, 100)

    for i, entry in ipairs(table) do
        if roll > entry[1] and roll < entry[2] then
            local res = entry[3]
            print_to_log("[TREASURE] Roll: ", roll, "generated items: ", res)
            return res 
        end
    end
end

function Treasure:getTreasure(lvl, val)
    local coins = Treasure:getCoins(lvl)
    local goods = Treasure:getGoods(lvl)
    local items = Treasure:getItems(lvl)
    return coins, goods, items
end

return Treasure