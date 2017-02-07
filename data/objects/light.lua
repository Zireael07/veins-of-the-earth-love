--Veins of the Earth
--Zireael 2013-2015


--Light sources
object_types["lite"] = {
    slot = "LITE",
    type = "lite", subtype = "lite",
    image = "torch",
    encumber = 0,
    rarity = 10,
    name = "torch",
    desc = [[A torch.]],
}

--Should last 5000 turns
object_types["torch"] = {
    base = "lite",
    --add_name = " (#LITE#)",
    name = "torch",
    cost = 
    { 
        copper = 4,
    },
    fuel_max = 5000,
    --fuel = resolvers.rngavground(500, 4000),
    wielder = {
    lite=4
  },
}

--Unlimited
object_types["everlasting torch"] = {
    base = "lite",
    name = "everlasting torch",
    level_range = {10, nil},
    cost =
    {
        platinum = 5000,
    },
    wielder = {
    lite=4
  },
}

--Should last 7500 turns
object_types["lantern"] = {
    base = "lite",
    name = "lantern",
    image = "lantern",
    level_range = {5,nil},
    --add_name = " (#LITE#)",
    cost = {
        silver = 10,
    },
    fuel_max = 7500,
    --fuel = resolvers.rngavground(1000,5000),
    wielder = {
    lite=6
  },
}

--Burnt out torch
object_types["burnt out torch"] = {
    base = "lite",
    name = "burnt out torch",
    level_range = {1,10},
    fuel_max = 0,
    fuel = 0,
    cost = 0,
}

--Burnt out lantern
object_types["burnt out lantern"] = {
    base = "lite",
    name = "burnt out lantern",
    image = "lantern",
    level_range = {5,nil},
    fuel_max = 0,
    fuel = 0,
    cost = 0,
}
