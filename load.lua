--file for loading all the stuff that must be accessible to all classes/modules
ROT=require 'libraries/rotLove/rotLove'

local ActorInventory = require "interface.ActorInventory"
local Faction = require "class.Faction"

--randomness
rng = ROT.RNG.Twister:new()
rng:randomseed()

--colors
dofile("colors.lua")

  --load fonts
  print('Loading fonts')
  sherwood_large = love.graphics.newFont("fonts/sherwood.ttf", 20)
  sherwood_font = love.graphics.newFont("fonts/sherwood.ttf", 14)
  goldbox_font = love.graphics.newFont("fonts/Gold_Box.ttf", 12)
  goldbox_large_font = love.graphics.newFont("fonts/Gold_Box.ttf", 16)

--load factions
dofile("data/factions.lua")


--inventory
ActorInventory:defineInventory("MAIN_HAND", "In main hand", true, "Most weapons are wielded in the main hand.", nil, {equipdoll_back="ui/equipdoll/mainhand_inv.png"})
ActorInventory:defineInventory("OFF_HAND", "In off hand", true, "You can use shields or a second weapon in your off-hand, if you have the talents for it.", nil, {equipdoll_back="ui/equipdoll/offhand_inv.png"})
ActorInventory:defineInventory("BODY", "Main armor", true, "Armor protects you from physical attacks. The heavier the armor the more it hinders the use of talents and spells.", nil, {equipdoll_back="ui/equipdoll/armor_inv.png"})
ActorInventory:defineInventory("CLOAK", "Cloak", true, "A cloak can simply keep you warm or grant you wondrous powers should you find a magical one.", nil, {equipdoll_back="ui/equipdoll/cloak_inv.png"})
ActorInventory:defineInventory("BELT", "Around waist", true, "Belts are worn around your waist.", nil, {equipdoll_back="ui/equipdoll/belt_inv.png"})
ActorInventory:defineInventory("QUIVER", "Quiver", true, "Your readied ammo.", nil, {equipdoll_back="ui/equipdoll/ammo_inv.png"})
ActorInventory:defineInventory("GLOVES", "On hands", true, "Various gloves can be worn on your hands.", nil, {equipdoll_back="ui/equipdoll/gloves_inv.png"})
ActorInventory:defineInventory("BOOTS", "On feet", true, "Sandals or boots can be worn on your feet.", nil, {equipdoll_back="ui/equipdoll/boots_inv.png"})
ActorInventory:defineInventory("HELM", "On head", true, "You can wear helmets or crowns on your head.", nil, {equipdoll_back="ui/equipdoll/head_inv.png"})
ActorInventory:defineInventory("RING", "On fingers", true, "Rings are worn on fingers.", nil, {equipdoll_back="ui/equipdoll/ring_inv.png"})
ActorInventory:defineInventory("AMULET", "Around neck", true, "Amulets are worn around the neck.", nil, {equipdoll_back="ui/equipdoll/amulet_inv.png"})
ActorInventory:defineInventory("LITE", "Light source", true, "A light source allows you to see in the dark places of the world.", nil, {equipdoll_back="ui/equipdoll/light_inv.png"})
ActorInventory:defineInventory("TOOL", "Tool", true, "This is your readied tool, usually a shovel.", nil, {equipdoll_back="ui/equipdoll/tool_inv.png"})
--For swapping weapons
ActorInventory:defineInventory("SHOULDER", "Shouldered weapon", true, "This is your readied weapon, usually a ranged one.", nil, {equipdoll_back="ui/equipdoll/shoulder_inv.png"})
--New
ActorInventory:defineInventory("LEGS", "On legs", true, "Greaves are worn on your legs", nil, {equipdoll_back="ui/equipdoll/legs_inv.png"})
ActorInventory:defineInventory("ARMS", "Around arms", true, "Bracers or bracelets are worn on your arms", nil, {equipdoll_back="ui/equipdoll/arms_inv.png"})
