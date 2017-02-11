require 'T-Engine.class'

require 'class.Map'

local Faction = require 'class.Faction'

--needs to be req'd first
local ActorTemporaryValues = require 'T-Engine.interface.ActorTemporaryValues'

local ActorInventory = require 'interface.ActorInventory'
local Combat = require 'interface.ActorCombat'
local ActorLife = require 'interface.ActorLife'
local ActorStats = require 'interface.ActorStats'
local ActorSkills = require 'interface.ActorSkills'
local NameGenerator = require "class.NameGenerator"

--AI
local ActorAI = require 'interface.ActorAI'
local Treasure = require 'class.Treasure'

--Player
local Chat = require 'class.Chat'

module("Actor", package.seeall, class.inherit(ActorTemporaryValues,
  ActorInventory, Combat, ActorLife, ActorStats, ActorSkills))

function _M:init(t)
    --if t then print("We were given a table") end
    t = t or {}
    --default loc for testing
    self.x = 1
    self.y = 1
    self.display = t.display --or "o"
    self.image = t.image --or "orc"
    self.name = t.name --or "orc"
    self.type = t.type
    self.subtype = t.subtype
    self.path = nil
    self.faction = t.faction or "enemy"

    self.inventory = t.inventory
    self.lite = t.lite
    self.darkvision = t.darkvision or 0
    --dialogue
    self.text = t.text
    self.convo = t.convo
    self.languages = t.languages
    -- Default melee barehanded damage
    self.combat = { dam = {1,4} }
    self.hit_die = t.hit_die
     --Body parts
    self.body_parts = t.body_parts or {}

    self.gender = t.gender or "neuter"
    --portrait
    self.show_portrait = t.show_portrait or false
    if self.show_portrait then
      self:portraitGen()
    end
    --init inherited stuff
    ActorInventory.init(self, t)
    ActorLife.init(self, t)
    ActorStats.init(self, t)
    ActorSkills.init(self, t)

    --more delayed setup
    if self.body_parts then
      self:setBodyPartsHP()
    end
    if self.inventory then
      --print("We have an inventory")
      self:equipItems(self.inventory)
    end
end

function _M:act()
  --check if we're alive
  if self.dead then return false end
end

function _M:getName()
  local name = self.name

  return name
end

function _M:move(x, y)
  if not x or not y then return end
  
  --print_to_log("Actor:moving")
  x = math.floor(x)
	y = math.floor(y)
  
  --don't go out of bounds
  if x < 0 then x = 0 end
	if x >= Map:getWidth() then x = Map:getWidth() - 1 end
	if y < 0 then y = 0 end
	if y >= Map:getHeight() then y = Map:getHeight() - 1 end
  
  self.old_x, self.old_y = self.x or x, self.y or y
	self.x, self.y = x, y
  print_to_log("Actor: new x,y : ", self.x, self.y)
  --update map
  --print_to_log("Actor: updating map cell: ", x, y)
  --print_to_log("Actor:old cell: ", self.old_x, self.old_y) 
  Map:setCellActor(self.old_x, self.old_y, nil)
  Map:setCellActor(x, y, self)

  --trigger on_stand
  local terrain = Map:getCellTerrain(x,y)
  if terrain.on_stand then
    print("[Actor] on_stand effects triggered")
    terrain.on_stand(terrain, x, y, self)
  end
  
end

function _M:moveDir(dx, dy)
  if not dx then dx = 0 end
  if not dy then dy = 0 end
  print_to_log("[Actor] move in dir", dx, dy)
  
  local tx = self.x+dx
  local ty = self.y+dy
  print_to_log("[Actor] Move to", tx, ty)
  if self:canMove(tx, ty) then
    self:move(tx, ty)
  else
    print("[Actor] Failed a move attempt to", tx, ty)
  end
 
end

function _M:canMove(x,y)
  --if no map at x,y then refuse
  if not Map:getCell(x,y) then return false end
  --should call combat
  if Map:getCellActor(x,y) then 
    local target = Map:getCellActor(x,y)
    self:bumpTarget(target)
    return false 
  end
  --legit block
  if Map:getCellTerrain(x,y).display == "#" then return false end
 -- if x == player.x and y == player.y then return false end
  return true
end

function _M:moveAlongPath(path)
  if not path or not path[2] then return end
  local tx = path[2].x
  local ty = path[2].y
  print("[Actor] Moving along path", tx, ty)
  if self:canMove(tx, ty) then
    self:move(path[2].x, path[2].y)
  end
end

function _M:isNear(x,y, radius)
  radius = radius or 1
  if utils:distance(self.x, self.y, x, y) > radius then return false end
  return true
end


function _M:reactionToward(target)
  return Faction:factionReaction(self.faction, target.faction)
end

function _M:indicateReaction()
  local str
  if self:reactionToward(player) > 50 then str = "helpful"
  elseif self:reactionToward(player) > 0 then str = "friendly"
  elseif self:reactionToward(player) < -50 then str = "hostile"
  elseif self:reactionToward(player) < 0 then str = "unfriendly"
  else str = "neutral" end

  return str
end

function _M:bumpTarget(target)
  --check for reaction
  if target:reactionToward(self) < -50 then
    self:attackTarget(target)
  else --if target:reactionToward(self) 
    --print("[ACTOR] Bumped nonhostile target")
    if self.player == true then
      
      --target.emote = "Hey you!"
      if target.convo then
        local chat = Chat.new(target.convo, target, self)
        chat:invoke()
      end
    end
  end
end

function _M:on_die(src)
  print("[ACTOR] on_die")
  --drop our inventory
  local dropx, dropy = self.x, self.y
  local invens = {}
  for id, inven in pairs(self.inven) do
    invens[#invens+1] = inven
  end

  for id, inven in pairs(invens) do
    for i = #inven, 1, -1 do
      local o = inven[i]
      o.dropped_by = o.dropped_by or self.name
      --Add info on where and by whom it was dropped (from ToME 2 port)
      --[[o.found = {
        type = 'mon_drop',
        mon_name = self.name,
        zone_name = game.zone.name,
        town_zone = game.zone.town,
        level = game:getDunDepth(),
        level_name = game.level.name,
        }]]
      self:removeObject(inven, i)
      Map:setCellObject(dropx, dropy, o)
      print("[ACTOR] on death: dropped item from inventory", o.name)
    end
  end
  self.inven = {}
end

function _M:setBodyPartsHP()
  local hp = self.max_hitpoints
  if self.body_parts["head"] then 
    self.max_hitpoints_head = math.floor(hp*0.33)
    self.hitpoints_head = self.max_hitpoints_head
  end
  if self.body_parts["torso"] then
    self.max_hitpoints_torso = math.floor(hp*0.4)
    self.hitpoints_torso = self.max_hitpoints_torso
  end
  if self.body_parts["arms"] then
    self.max_hitpoints_arms = math.floor(hp*0.25)
    self.hitpoints_arms = self.max_hitpoints_arms
  end
  if self.body_parts["legs"] then
    self.max_hitpoints_legs = math.floor(hp*0.25)
    self.hitpoints_legs = self.max_hitpoints_legs
  end
end  


--languages
function _M:getLanguages()
  local list = {}

    for i, n in pairs(self.languages) do
        list[#list+1] = {
            name = n
        }
    end

  return list
end

function _M:speakLanguage(lg)
  if type(lg) ~= "string" then return nil end

  for i,t in pairs(self:getLanguages()) do
    if t.name == lg then return true end
  end
  return false
end

function _M:speakSameLanguage(target)
  for i, t in pairs(self:getLanguages()) do
    if target:speakLanguage(t.name) then return true end
    return false
  end
end

--Portrait generator
function _M:portraitGen()
  local doll = "doll"

  if self.show_portrait == true then

    local base = {"dwarf", "dwarf_alt"}

    if self.subtype == "drow" then
      doll = "doll_drow"
    elseif self.subtype == "dwarf" then
      doll = "doll_"..rng_table(base)
    end

    self.portrait = doll

    --First things first
    local add = {}

    --Now the rest of the face
    local eyes_light = {"amber", "seablue", "seagreen", "yellow"}
    local eyes_medium = {"green", "blue", "gray"}
    local eyes_dark = {"black", "brown"}
    local eyes_red = {"red", "pink"}

    local eyes_dwarf = {"1", "2", "3", "4"}
    local eyes_human = {}
    local eyes_all = {}

    local mouth = {"mouth", "mouth2"}

    --Hair colors
    local color = {"black", "black2", "brown", "gray", "red", "white"}
    local color_choice = rng_table(color)

    --Hair
    if self.subtype == "drow" then
      local drow_hair = {"1", "2", "3", "4"}
      add[#add+1] = {name="drow_hair"..rng_table(drow_hair) }
    else
  --  elseif self.subtype == "dwarf" then
      add[#add+1] = {name="hair_"..color_choice }
  --  else
    end


    if self.subtype == "drow" then
      add[#add+1] = {name="eyebrows_drow"}
    else
      add[#add+1] = {name="eyebrows_"..color_choice }
    end

    if self.subtype == "dwarf" then
    --  table.append(eyes_dwarf, eyes_medium)
    --  table.append(eyes_dwarf, eyes_dark)
      add[#add+1] = {name="eyes_dwarf_"..rng_table(eyes_dwarf) }
    elseif self.subtype == "human" then
      table.append(eyes_human, eyes_light)
      table.append(eyes_all, eyes_medium)
      table.append(eyes_human, eyes_dark)
      add[#add+1] = {name="eyes_"..rng_table(eyes_human) }
    else
      table.append(eyes_all, eyes_light)
      table.append(eyes_all, eyes_medium)
      table.append(eyes_all, eyes_dark)
      table.append(eyes_all, eyes_red)
      add[#add+1] = {name="eyes_"..rng_table(eyes_all) }
    end

    if self.subtype == "dwarf" then
      add[#add+1] = {name="dwarf_nose"}
    end

    if self.subtype == "drow" then
      add[#add+1] = {name="drow_"..rng_table(mouth) }
    elseif self.subtype == "dwarf" then
      add[#add+1] = {name="dwarf_"..rng_table(mouth) }
    else
      add[#add+1] = {name=rng_table(mouth) }
    end


    if self.subtype == "dwarf" then
      add[#add+1] = {name="dwarf_beard_"..color_choice }
    end

    --Decor
    if self.name:find("noble") then
      add[#add+1] = {name="noble_outfit"}
    end

    if self.name:find("commoner") or self.name:find("courtesan") then
      add[#add+1] = {name="hood_base"}
    end

    if self.name:find("shopkeeper") or self.name:find("sage") then
      local glasses = {"1", "2"}
      add[#add+1] = {name="glasses"..rng_table(glasses) }
    end

    if self.name:find("sage") then
      add[#add+1] = {name="robes"}
    end

    if self.name:find("hireling") then
      add[#add+1] = {name="armor" }
    end

    self.portrait_table = add
  end
end

function _M:nameGenerator()
  local name
  local namegen = NameGenerator.new(NameGenerator.drow_female_def)
      name = namegen:generate()

      --print("[NAME GEN] name is", name)
    return name
end

function _M:equipItems(t)
  print("Equipping items")
  for i, v in ipairs(t) do
    print("Spawning item for equipment for", self.name)
    local o
      o = Spawn:createItem(1, 1, v.name)

      if o then
        if o.slot then
          --print("Object's slot is", o.slot)
          if self:wearObject(o, o.slot) then

          print("Wearing an object", o.name)
          else
            self:addObject(self.INVEN_INVEN, o)
            print("Adding object to inventory", o.name)
          end
        end
      end
  end
end

return _M