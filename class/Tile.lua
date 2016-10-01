require 'T-Engine.class'

module("Tile", package.seeall, class.make)

_G.loaded_tiles = {}

function Tile:loadTiles()
    print("[TILE] Loading tiles")
    --global table
    _G.loaded_tiles= {
    --map
    floor = lg.newImage("gfx/tiles/terrain/floor.png"),
    wall = lg.newImage("gfx/tiles/terrain/wall.png"),
    floor_bright = lg.newImage("gfx/tiles/terrain/floor_bright.png"),
    player_tile = lg.newImage("gfx/tiles/player/racial_dolls/human_m.png"),
    --NPCs
    orc = lg.newImage("gfx/tiles/mobiles/orc.png"),
    drow = lg.newImage("gfx/tiles/mobiles/drow.png"),
    human = lg.newImage("gfx/tiles/mobiles/human.png"),
    gnome = lg.newImage("gfx/tiles/mobiles/npc/gnome_fighter.png"),
    --objects
    longsword = lg.newImage("gfx/tiles/object/longsword.png"),
    dagger = lg.newImage("gfx/tiles/object/dagger.png"),
    spear = lg.newImage("gfx/tiles/object/spear.png"),
    padded = lg.newImage("gfx/tiles/object/armor_padded.png"),
    leather = lg.newImage("gfx/tiles/object/armor_leather.png"),
    studded = lg.newImage("gfx/tiles/object/armor_studded.png"),
    chain_shirt = lg.newImage("gfx/tiles/object/chain_shirt.png"),
    chain_mail = lg.newImage("gfx/tiles/object/chain_armor.png"),
    shield_buckler = lg.newImage("gfx/tiles/object/shield_buckler.png"),
    shield_light_wooden = lg.newImage("gfx/tiles/object/shield_light_wooden.png"),
    shield_light_steel = lg.newImage("gfx/tiles/object/shield_light_steel.png"),
    shield_heavy_wooden = lg.newImage("gfx/tiles/object/shield_heavy_wooden.png"),
    shield_heavy_steel = lg.newImage("gfx/tiles/object/shield_heavy_steel.png"),
    shield_tower = lg.newImage("gfx/tiles/object/shield_tower.png"),
    --effect
    damage_tile = lg.newImage("gfx/splash_gray.png"),

    --UI texture
    stone_bg = lg.newImage("gfx/stone_background.png"),

    --inventory
    ammo_inv = lg.newImage("gfx/inventory/ammo_inv.png"),
    amulet_inv = lg.newImage("gfx/inventory/amulet_inv.png"),
    armor_inv = lg.newImage("gfx/inventory/armor_inv.png"),
    arms_inv = lg.newImage("gfx/inventory/arms_inv.png"),
    belt_inv = lg.newImage("gfx/inventory/belt_inv.png"),
    boots_inv = lg.newImage("gfx/inventory/boots_inv.png"),
    cloak_inv = lg.newImage("gfx/inventory/cloak_inv.png"),
    gloves_inv = lg.newImage("gfx/inventory/gloves_inv.png"),
    head_inv = lg.newImage("gfx/inventory/head_inv.png"),
    light_inv = lg.newImage("gfx/inventory/light_inv.png"),
    mainhand_inv = lg.newImage("gfx/inventory/mainhand_inv.png"),
    offhand_inv = lg.newImage("gfx/inventory/offhand_inv.png"),
    ring_inv = lg.newImage("gfx/inventory/ring_inv.png"),
    shoulder_inv = lg.newImage("gfx/inventory/shoulder_inv.png"),
    tool_inv = lg.newImage("gfx/inventory/tool_inv.png"),

  }
  
  
  return loaded_tiles
end


return Tile