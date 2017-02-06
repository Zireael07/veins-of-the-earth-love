--Veins of the Earth
--Zireael 2013-2016

--Ranged weapons
object_types["ranged"] = {
    type = "weapon",
    ranged = true,
    ammo_type = "arrow",
    slot = "MAIN_HAND",
    offslot = "SHOULDER",
    material = "steel",
    durability = 10,
}

object_types["hxbow"] = { base = "ranged",
    slot = "MAIN_HAND",
    slot_forbid = "OFF_HAND",
    type = "weapon", subtype="crossbow",
    image = "tiles/object/crossbow_heavy.png",
    encumber = 8,
    rarity = 6,
    simple = true,
    ranged = true,
    name = "heavy crossbow",
    desc = "A normal trusty heavy crossbow.\n\n",
    cost = {
        gold = 1,
        silver = 150,
    },
    combat = {
        dam = {1,10},
        threat = 1,
        range = 12,
    },
}

--Range 80 ft.
object_types["lxbow"] = { base = "ranged",
    slot = "MAIN_HAND",
    slot_forbid = "OFF_HAND",
    type = "weapon", subtype="crossbow",
    image = "tiles/object/crossbow_light.png",
    encumber = 8,
    rarity = 6,
    simple = true,
    ranged = true,
    desc = "A normal trusty light crossbow.\n\n",
    name = "light crossbow",
    cost = {
        silver = 150,
    },
    combat = {
        dam = {1,8},
        threat = 1,
        range = 8,
    },
}

object_types["sling"] = { base = "ranged",
    slot = "MAIN_HAND",
    slot_forbid = "OFF_HAND",
    type = "weapon", subtype="sling",
    image = "sling",
    encumber = 1,
    rarity = 6,
    ammo_type = "bullet",
    desc = "A normal unremarkable sling.\n\n",
    name = "sling",
    cost = 3,
    combat = {
        dam = {1,4},
        range = 4,
    },
    material = "leather",
}


--Bows
object_types["lbow"] = { base = "ranged",
    slot = "MAIN_HAND",
    slot_forbid = "OFF_HAND",
    type = "weapon", subtype="bow",
    ranged = true,
    ammo_type = "arrow",
    --require = { talent = { Talents.T_LONGBOW_PROFICIENCY }, },
    encumber = 3,
    martial = true,
    desc = "A normal trusty bow.\n\n",
    material = "wood",
}

object_types["longbow"] = { base = "lbow",
    name = "longbow",
    image = "longbow",
    rarity = 5,
    cost = {
        gold = 1,
    },
    combat = {
        dam = {1,8},
        critical = 3,
        range = 10,
    },
}

object_types["composite longbow"] = { base = "lbow",
    name = "composite longbow",
    desc = "A curved longbow with an increased range.\n\n",
    rarity = 10,
    image = "tiles/object/bow_long_composite.png",
    cost = {
        gold = 1,
        silver = 25,
    },
    combat = {
        dam = {1,8},
        critical = 3,
        range = 11,
    },
}

object_types["sbow"] = { base = "ranged",
    slot = "MAIN_HAND",
    slot_forbid = "OFF_HAND",
    type = "weapon", subtype="bow",
    --require = { talent = { Talents.T_SHORTBOW_PROFICIENCY }, },
    encumber = 2,
    martial = true,
    ranged = true,
    ammo_type = "arrow",
    name = "a generic bow",
    desc = "A normal trusty short bow.\n\n",
}

object_types["shortbow"] = { base = "sbow",
    name = "shortbow",
    image = "shortbow",
    rarity = 5,
    cost = {
        silver = 75,
    },
    combat = {
        dam = {1,6},
        critical = 3,
        range = 6,
    },
}

object_types["composite shortbow"] = { base = "sbow",
    name = "composite shortbow",
    image = "tiles/object/bow_short_composite.png",
    rarity = 12,
    level_range = {1, 10},
    cost = {
        silver = 175,
    },
    desc = "A curved short bow with an increased range.\n\n",
    combat = {
        dam = {1,6},
        critical = 3,
        range = 7,
    },
}

--Ammo
object_types["ammo"] = { base = "ranged",
    slot = "QUIVER",
    type = "ammo",
    add_name = " (#COMBAT_AMMO#)",
    encumber = 1,
    ammo = true,
    material = "steel",
    durability = 2,
}

object_types["arrow"] = { base = "ammo",
    type = "ammo", subtype="arrow",
    image = "arrows",
    encumber = 3,
    rarity = 7,
    archery_ammo = "arrow",
    desc = "Arrows are used with bows to pierce your foes to death.",
    name = "arrows",
    cost = {
        silver = 1,
    },
    combat = {
        capacity = 10,
    },
    material = "wood",
}


object_types["bolt"] = { base = "ammo",
    type = "ammo", subtype="bolt",
    image = "bolts",
    add_name = " (#COMBAT_AMMO#)",
    rarity = 5,
    archery_ammo = "bolt",
    desc = "Bolts are used with crossbows to pierce your foes to death.",
    name = "bolts",
    cost = {
        silver = 2,
    },
    combat = {
        capacity = 10,
    },
}

object_types["bullet"] = { base = "ranged",
    type = "ammo", subtype="bullet",
    image = "bullets",
    rarity = 5,
    archery_ammo = "bullet",
    desc = "Bullets are used with slings to kill your foes.",
    name = "bullets",
    cost = 5,
    combat = {
        capacity = 10,
    },
}
