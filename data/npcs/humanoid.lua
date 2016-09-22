npc_types['drow'] = {
    type = "humanoid",
    body = { INVEN = 10, MAIN_HAND = 1, OFF_HAND = 1, BODY = 1, HELM = 1, QUIVER=1 },
    body_parts = { torso=1, arms=1, legs=1, head=1 },
    --emote_anger = "I will kill you!",

    name = "drow",
    image = "drow",
    subtype = "drow",
    emote_anger = "Oloth plynn d'jal!",

    desc = [[A dark silhouette.]],
    specialist_desc = [[Drow do not sleep or dream, and are immune to sleep effects. Instead, they refresh themselves by entering a meditative reverie for a few hours a night. Drow are resistant to magic, but once per day they can use spell-like abilities to create dancing lights, darkness, and faerie fire, which they use to disorient their foes.]],
    uncommon_desc = [[A drow’s sharp senses are attuned to life underground. Drow can see so well in the dark that sudden exposure to bright light can blind them.]],
    common_desc = [[Drow are known for their evil natures, matriarchal cultures, and zealous worship of malign, arachnid gods. They are more delicate than humans, but also more dextrous and more cunning. Drow are talented spellcasters, with drow women holding all divine roles. Culturally, drow train their children with the rapier, short sword, and hand crossbow, and they often poison their weapons.]],
    base_desc = [[This lithe, ebon-skinned humanoid is a dark elf, also known as a drow. These subterranean elves speak both Elven and Undercommon, and typically also speak Common. Some drow also learn other racial languages or a form of sign language known only to them.]],
    
    infravision = 120, --divide by 5 to get number of squares
    alignment = "Chaotic Evil",
    skill_hide = 1,
    skill_movesilently = 1,
    skill_listen = 2,
    skill_search = 3,
    skill_spot = 2,
    hit_die = 1,
    challenge = 1,
    max_hitpoints = 6,
}

npc_types['orc'] = {
    type = "humanoid",
    body = { INVEN = 10, MAIN_HAND = 1, OFF_HAND = 1, BODY = 1, HELM = 1, QUIVER=1 },
    body_parts = { torso=1, arms=1, legs=1, head=1 },
   -- emote_anger = "I will kill you!",

    name = "orc",
    image = "orc",
    subtype = "orc",
    emote_anger = "Me kill you!",
    desc = [[An ugly orc.]],
    uncommon_desc = [[Orcs are tribal by nature with most tribes separated by the deity that they pick as their patron.
    Orcs do have one weakness - a sensitivity to bright light that can dazzle these naturally noctunal creatures. Orc leaders are traditionally warriors of one kind or another, often from the Barbarian tradition. Although rare, orc spellcasters are typically ruthlessly ambitious, and the rivalries between warrior and spellcaster factions can sometimes tear a tribe apart. Orc society is usually patriarchal, with females seen as prized possesions at best and chattel at worst.]],
    common_desc = [[Orcs are considerably stronger than the average human, though this is countered by a general lack of the more cerebral traits. A warlike people who believe that to survive they must conquer as much territory as they can, they are often at odds with those they encounter (including other tribes of their own kind) and are a generally hated race for this reason. Their warlike culture does however mean that all of their kind are well trained in the use of weaponry, and many prefer large, two-handed weapons that deal as much damage as quickly as possible.]],
    base_desc = "This primitive looking creature is an orc, one of the most prolific and agressive of the humanoid races. Orcs speak their own language, and the more intelligent of their kind often learn Goblin or Giant. ",

    infravision = 60,
    alignment = "Chaotic Evil",
    skill_listen = 2,
    skill_spot = 2,
    hit_die = 1,
    challenge = 1,
    max_hitpoints = 8,
}

npc_types['human'] = {
    type = "humanoid",
    body = { INVEN = 10, MAIN_HAND = 1, OFF_HAND = 1, BODY = 1, HELM = 1, QUIVER=1 },
    body_parts = { torso=1, arms=1, legs=1, head=1 },
    emote_anger = "I will kill you!",

    name = "human",
    image = "human",
    subtype = "human",

    hit_die = 1,
    alignment = "Neutral Good",
    challenge = 1,
    max_hitpoints = 8,
}

npc_types['gnome'] = {
    type = "humanoid",
    body = { INVEN = 10, MAIN_HAND = 1, OFF_HAND = 1, BODY = 1, HELM = 1, QUIVER=1 },
    body_parts = { torso=1, arms=1, legs=1, head=1 },
    emote_anger = "I will kill you!",

    name = "gnome",
    image = "gnome",
    subtype = "gnome",

    desc = [[A lost gnome.]],
    uncommon_desc = [[Gnomes are renowned for two traits: their sense of humor and their innate talents for arcane illusions. As a spell-like ability, any gnome can speak with burrowing mammals, and talented gnomes can produce dancing lights, ghost sound, and prestidigitation as well.]],
    common_desc = [[Gnomes can see well in dim light and have sharp ears. They have a particular dislike for the more bestial “smallfolk,” such as goblins and kobolds, and are well-versed at evading the ponderous attacks of giants.]],
    base_desc = [[This small, spindly humanoid is a gnome, one of the civilized nonhuman races. Gnomes speak their own language, but also learn Common. Clever gnomes often know other racial languages as well.]],

    hit_die = 1,
    alignment = "Neutral Good",
    challenge = 1/2,
    darkvision = 3,
    skill_hide = 3,
    skill_listen = 1,
    skill_spot = 1,
    max_hitpoints = 8,
}