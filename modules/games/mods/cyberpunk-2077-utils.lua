local Utils = {}

local TransactionSystem = Game.GetTransactionSystem()
local StatsSystem = Game.GetStatsSystem()

local createStatModifier = Game["gameRPGManager::CreateStatModifier;gamedataStatTypegameStatModifierTypeFloat"]

Utils.UpgradeWeapon = function(slot)
  local player = Game.GetPlayer()

  local playerData = Game
    .GetScriptableSystemsContainer()
    :Get(CName.new("EquipmentSystem"))
    :GetPlayerData(player)


  local item = playerData["GetItemInEquipSlot;gamedataEquipmentAreaInt32"](playerData, "Weapon", slot)

  if item.id.hash == 0 then
    print("No weapon found in slot", slot)
    return
  end

  local objectId = TransactionSystem:GetItemData(player, item):GetStatsObjectID()

  StatsSystem:RemoveAllModifiers(objectId, "Quality", true)
  StatsSystem:AddSavedModifier(objectId, createStatModifier("Quality", "Additive", 4))
  StatsSystem:RemoveAllModifiers(objectId, "IsItemPlus", true)
  StatsSystem:AddSavedModifier(objectId, createStatModifier("IsItemPlus", "Additive", 2))

  print("Item upgraded")
end

Utils.Weapons = {
  Nue = function() Game.AddToInventory("Items.Preset_Nue_Default") end,
  Tamayura = function() Game.AddToInventory("Items.Preset_Nue_Arasaka_2020") end,
  Overture = function() Game.AddToInventory("Items.Preset_Overture_Legendary") end,
  Saratoga = function() Game.AddToInventory("Items.Preset_Saratoga_Default") end,
  Igla = function() Game.AddToInventory("Items.Preset_Igla_Pimp") end,
  Tactician = function() Game.AddToInventory("Items.Preset_Tactician_Default") end,
  Kyubi = function() Game.AddToInventory("Items.Preset_Kyubi_Default") end,
  Ajax = function() Game.AddToInventory("Items.Preset_Ajax_Default") end,
  MA70 = function() Game.AddToInventory("Items.Preset_MA70_Default") end,
  Kolac = function() Game.AddToInventory("Items.Preset_Kolac_Default") end,
  Grad = function() Game.AddToInventory("Items.Preset_Grad_Default") end,
  ChefsKnife = function() Game.AddToInventory("Items.Preset_Chefs_Knife_Default") end,
}

Utils.Mods = {
  Silencio = function() Game.AddToInventory("Items.MeleeMod3_Legendary") end,
  Pax = function() Game.AddToInventory("Items.GenericMod1_Legendary") end,
  Equalizer = function() Game.AddToInventory("Items.RangedMod3_Legendary") end,
  SwissCheese = function() Game.AddToInventory("Items.PowerMod2_Legendary") end,
  Parallax = function() Game.AddToInventory("Items.HGMod3_X") end,
  ZeroG = function() Game.AddToInventory("Items.ThrowMod2_Legendary") end,
}

Utils.Money = function(amount)
  Game.AddToInventory("Items.money", amount)
end

Utils.Progress = {
  Level = function(level)
    Game.SetLevel("Level", level, 1)
  end,
  StreetCreda = function(level)
    Game.SetLevel("StreetCred", level, 1)
  end,
  AttributePoint = function(count)
    for _=1,count do
      Game.AddToInventory("Items.AttributePointSkillbook")
    end
  end,
  PerkPoint = function(count)
    for _=1,count do
      Game.AddToInventory("Items.PerkPointSkillbook")
    end
  end,
  RelicPoint = function(count)
    for _=1,count do
      Game.AddToInventory("Items.Espionage_Skillbook")
    end
  end,
  CyberwareCapacity = function(count)
    if math.fmod(count, 2) ~= 0 then
      print("Count must be divisible by 2")
      return
    end
    for _=1,count/2 do
      Game.AddToInventory("Items.CWCapacityPermaReward_Uncommon")
    end
  end,
  SoloExperience = function(count)
    if math.fmod(count, 400) ~= 0 then
      print("Count must be divisible by 400")
      return
    end
    for _=1,count/400 do
      Game.AddToInventory("Items.BodySkill_Skillbook_Legendary")
    end
  end,
  HeadhunterExperience = function(count)
    if math.fmod(count, 400) ~= 0 then
      print("Count must be divisible by 400")
      return
    end
    for _=1,count/400 do
      Game.AddToInventory("Items.CoolSkill_Skillbook_Legendary")
    end
  end,
  NetrunnerExperience = function(count)
    if math.fmod(count, 400) ~= 0 then
      print("Count must be divisible by 400")
      return
    end
    for _=1,count/400 do
      Game.AddToInventory("Items.IntelligenceSkill_Skillbook_Legendary")
    end
  end,
  ShinobiExperience = function(count)
    if math.fmod(count, 400) ~= 0 then
      print("Count must be divisible by 400")
      return
    end
    for _=1,count/400 do
      Game.AddToInventory("Items.ReflexSkill_Skillbook_Legendary")
    end
  end,
  EngineerExperience = function(count)
    if math.fmod(count, 400) ~= 0 then
      print("Count must be divisible by 400")
      return
    end
    for _=1,count/400 do
      Game.AddToInventory("Items.TechnicalAbilitySkill_Skillbook_Legendary")
    end
  end,
}

return Utils
