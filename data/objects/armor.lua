object_types['padded armor'] = {
    slot = "BODY",
    type = "armor", subtype = "light",
    image = "padded",
    desc = "A simple padded armor. Does not offer much protection.",
    encumber = 10,
    wielder = {
        combat_armor = 1,
        max_dex_bonus = 8,
        spell_fail = 5
    },
}

object_types['leather armor'] = {
    slot = "BODY",
    type = "armor", subtype = "light",
    image = "leather",
    desc = "A set of leather armor. Does not offer much protection.",
    encumber = 10,
    wielder = {
        combat_armor = 2,
        max_dex_bonus = 6,
        spell_fail = 10
    },
}

object_types['studded armor'] = {
    slot = "BODY",
    type = "armor", subtype = "light",
    image = "studded",
    desc = "A set of leather armor. Does not offer much protection.",
    encumber = 10,
    wielder = {
        combat_armor = 3,
        max_dex_bonus = 5,
        spell_fail = 15,
        armor_penalty = 1
    },
}

object_types['chain shirt'] = {
    slot = "BODY",
    type = "armor", subtype = "light",
    image = "chain_shirt",
    desc = "A set of chain links which covers the torso only.\n\n Light armor.",
    encumber = 10,
    wielder = {
        combat_armor = 4,
        max_dex_bonus = 4,
        spell_fail = 20,
        armor_penalty = 2
    },
}

object_types['chain mail'] = {
    slot = "BODY",
    type = "armor", subtype = "medium",
    image = "chain_mail",
    desc = "A suit of armour made of mail.\n\n Medium armor.",
    encumber = 40,
    wielder = {
        combat_armor = 5,
        max_dex_bonus = 2,
        spell_fail = 30,
        armor_penalty = 5
    },
}
