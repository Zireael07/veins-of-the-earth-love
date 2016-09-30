require 'T-Engine.class'

module("Tile", package.seeall, class.make)

_G.loaded_tiles = {}

function Tile:loadTiles()
    print("[TILE] Loading tiles")
    --global table
    _G.loaded_tiles= {
    --map
    floor = love.graphics.newImage("gfx/tiles/terrain/floor.png"),
    wall = love.graphics.newImage("gfx/tiles/terrain/wall.png"),
    floor_bright = love.graphics.newImage("gfx/tiles/terrain/floor_bright.png"),
    player_tile = love.graphics.newImage("gfx/tiles/player/racial_dolls/human_m.png"),
    orc = love.graphics.newImage("gfx/tiles/mobiles/orc.png"),
    drow = love.graphics.newImage("gfx/tiles/mobiles/drow.png"),
    human = love.graphics.newImage("gfx/tiles/mobiles/human.png"),
    gnome = love.graphics.newImage("gfx/tiles/mobiles/npc/gnome_fighter.png"),
    longsword = love.graphics.newImage("gfx/tiles/object/longsword.png"),
    dagger = love.graphics.newImage("gfx/tiles/object/dagger.png"),
    spear = love.graphics.newImage("gfx/tiles/object/spear.png"),
    padded = love.graphics.newImage("gfx/tiles/object/armor_padded.png"),
    leather = love.graphics.newImage("gfx/tiles/object/armor_leather.png"),
    studded = love.graphics.newImage("gfx/tiles/object/armor_studded.png"),
    chain_shirt = love.graphics.newImage("gfx/tiles/object/chain_shirt.png"),
    chain_mail = love.graphics.newImage("gfx/tiles/object/chain_armor.png"),

    --effect
    damage_tile = love.graphics.newImage("gfx/splash_gray.png"),

    --UI texture
    stone_bg = love.graphics.newImage("gfx/stone_background.png"),

    --inventory
    ammo_inv = love.graphics.newImage("gfx/inventory/ammo_inv.png"),
    amulet_inv = love.graphics.newImage("gfx/inventory/amulet_inv.png"),
    armor_inv = love.graphics.newImage("gfx/inventory/armor_inv.png"),
    arms_inv = love.graphics.newImage("gfx/inventory/arms_inv.png"),
    belt_inv = love.graphics.newImage("gfx/inventory/belt_inv.png"),
    boots_inv = love.graphics.newImage("gfx/inventory/boots_inv.png"),
    cloak_inv = love.graphics.newImage("gfx/inventory/cloak_inv.png"),
    gloves_inv = love.graphics.newImage("gfx/inventory/gloves_inv.png"),
    head_inv = love.graphics.newImage("gfx/inventory/head_inv.png"),
    light_inv = love.graphics.newImage("gfx/inventory/light_inv.png"),
    mainhand_inv = love.graphics.newImage("gfx/inventory/mainhand_inv.png"),
    offhand_inv = love.graphics.newImage("gfx/inventory/offhand_inv.png"),
    ring_inv = love.graphics.newImage("gfx/inventory/ring_inv.png"),
    shoulder_inv = love.graphics.newImage("gfx/inventory/shoulder_inv.png"),
    tool_inv = love.graphics.newImage("gfx/inventory/tool_inv.png"),

  }
  
  
  return loaded_tiles
end


return Tile