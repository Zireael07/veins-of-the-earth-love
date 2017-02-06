object_types['dagger'] = {
    slot = "MAIN_HAND",
    type = "weapon", subtype = "dagger",
    name = "dagger",
    image = "dagger",
    desc = "A normal trusty dagger.\n\n",
    encumber = 3,
    light = true,
    cost = {
        silver = 30,
    },
    combat = {
        dam = {1,4},
        threat = 1,
    },
    wielder = {
        combat_parry = 4,
    },
    durability = 2,
}

object_types['short spear'] = {
    slot = "MAIN_HAND",
    type = "weapon", subtype = "spear",
    name = "short spear",
    image = "spear",
    desc = "A wooden short spear.\n\n",
    encumber = 10,
    simple = true,
    cost = {
        silver = 20,
    },
    combat = {
        dam = {1,6},
    },
    wielder = {
        combat_parry = 4,
    },
    material = "wood",
    durability = 5,
}

object_types['longsword'] = {
    slot = "MAIN_HAND",
    type = "weapon", subtype = "sword",
    name = "longsword",
    image = "longsword",
    desc = "A trusty sword.\n\n",
    encumber = 4,
    martial = true,
    cost = {
        silver = 175,
    },
    combat = {
        dam = {1,8},
        threat = 2,
    },
    wielder = {
        combat_parry = 3,
    },
    durability = 5,
}