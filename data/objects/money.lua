local function pickupMoney(self, who, id)
    logMessage(colors.WHITE, who.name.." picked up some money")
    --remove from map
    Map:setCellObjectbyIndex(self.x, self.y, nil, id)
end

object_types["money"] = {
    type = "money", subtype = "money",
    encumber = 0,
    desc = [[Money, money, money!]],
}

object_types["copper coins"] = {
    base = "money",
    name = "copper coins",
    image = "copper_coins",
    desc = [[A pile of copper coins]],
    setup=function(instance)
        print("Setting our coin amount")
        if not instance.number_coins then
            instance.number_coins=love.math.random(1,3)*100 --rng.random(1,3)*100
            print("Coin amount is ", instance.number_coins)
        end
    end,
    on_prepickup = function(self, who, id)
        logMessage(colors.WHITE, who.name.." picked up some money")
        --remove from map
        Map:setCellObjectbyIndex(self.x, self.y, nil, id)
        if who.player then who:incMoney("copper", self.number_coins) end
        return true
    end,
}

object_types["silver coins"] = {
    base = "money",
    name = "silver coins",
    image = "silver_coins",
    desc = [[A pile of silver coins]],
    setup=function(instance)
        print("Setting our coin amount")
        if not instance.number_coins then
            instance.number_coins= love.math.random(1,4)*10 --rng.random(1,4)*10
            print("Coin amount is ", instance.number_coins)
        end
    end,
    on_prepickup = function(self, who, id)
        --pickupMoney(self, who, id)
        logMessage(colors.WHITE, who.name.." picked up some money")
        --remove from map
        Map:setCellObjectbyIndex(self.x, self.y, nil, id)
        if who.player then who:incMoney("silver", self.number_coins) end
        return true
    end,
}

object_types["gold coins"] = {
    base = "money",
    name = "gold coins",
    image = "gold_coins",
    desc = [[A pile of gold coins]],
    on_prepickup = function(self, who, id)
        pickupMoney(self, who, id)
        if who.player then
            who:incMoney("gold", 20)
        end
        return true
    end,
}

object_types["platinum coins"] = {
    base = "money",
    name = "platinum coins",
    image = "platinum_coins",
    desc = [[A pile of platinum coins]],
    on_prepickup = function(self, who, id)
        pickupMoney(self, who, id)
        if who.player then
            who:incMoney("platinum", 2)
        end
        return true
    end,
}