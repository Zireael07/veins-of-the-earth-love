local utils = require 'utils'

object_types['padded armor'] = {
    slot = "BODY",
    type = "armor", subtype = "light",
    name = "padded armor",
    image = "padded",
    desc = "A simple padded armor. Does not offer much protection.",
    encumber = 10,
    cost = {
        silver = 140,
    },
    wielder = {
        combat_armor = 1,
        max_dex_bonus = 8,
        spell_fail = 5
    },
}

object_types['leather armor'] = {
    slot = "BODY",
    type = "armor", subtype = "light",
    name = "leather armor",
    image = "leather",
    desc = "A set of leather armor. Does not offer much protection.",
    encumber = 10,
    cost = {
        gold = 1
    },
    wielder = {
        combat_armor = 2,
        max_dex_bonus = 6,
        spell_fail = 10
    },
}

object_types['studded armor'] = {
    slot = "BODY",
    type = "armor", subtype = "light",
    name = "studded armor",
    image = "studded",
    desc = "A set of leather armor. Does not offer much protection.",
    encumber = 10,
    cost = { --525 silver pieces
        gold = 2,
        silver = 125,
    },
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
    name = "chain shirt",
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
    name = "chain mail",
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

--Actual item generation starts here
local function newArmor(base, name, rarity, location, encumber, slot, ac, image)
    local base = object_types[base]
    local temp = table.clone(base)

    object_types[name] = { --base = base,
        name = name,
        image = image,
        rarity = rarity,
        encumber = encumber,
        slot = slot,
        wielder = {
            ["combat_armor_"..location] = ac,
        }
    }   
    table.mergeAppendArray(temp, object_types[name], true)
    object_types[name] = temp
end

newArmor("leather armor", "leather armor", 5, "torso", 10, "BODY", 2, "leather")
newArmor("chain mail", "chain mail", 12, "torso", 40, "BODY", 5, "chain_mail")
--newArmor("plate armor", "plate armor", 18, "torso", 50, "BODY", 7)

newArmor("leather armor", "leather bracers", 5, "arms", 2, "ARMS", 2, "bracers")
newArmor("chain mail", "chain bracers", 12, "arms", 8, "ARMS", 5, "bracers")
--newArmor("plate armor", "plate bracers", 18, "arms", 10, "ARMS", 7, "bracers")

newArmor("leather armor", "leather greaves", 5, "legs", 2, "LEGS", 2, "greaves")
newArmor("chain mail", "chain greaves", 12, "legs", 8, "LEGS", 5, "greaves")
--newArmor("plate armor", "plate greaves", 18, "legs", 10, "LEGS", 7, "greaves")

newArmor("leather armor", "leather helmet", 5, "head", 1, "HELM", 2, "helmet_metal")
newArmor("chain mail", "chain helmet", 12, "head", 4, "HELM", 5, "helmet_metal")
--newArmor("plate armor", "plate helmet", 18, "head", 8, "HELM", 7, "helmet_metal")
