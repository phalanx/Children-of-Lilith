Scriptname CoL_Perk_Infinite_Script extends activemagiceffect  

Perk Property transformHealthPerk Auto
Perk Property transformStaminaPerk Auto
Perk Property transformMagickaPerk Auto
Perk Property transformCarryWeightPerk Auto
Perk Property transformMeleeDamagePerk Auto
Perk Property transformArmorPerk Auto
Perk Property transformMagicResistPerk Auto
Perk Property effecientFeeder Auto
Perk Property energyStorage Auto
CoL_PlayerSuccubusQuestScript Property CoL Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    CoL.Log("Infinite perk script triggered")
    if CoL.playerRef.HasPerk(transformHealthPerk)
        CoL.Log("Transform Health Perk detected")
        CoL.transformHealth += 1
        CoL.Log("Transform Health Ranks: " + CoL.transformHealth)
        CoL.playerRef.RemovePerk(transformHealthPerk)
    endif
    if CoL.playerRef.HasPerk(transformStaminaPerk)
        CoL.Log("Transform Stamina Perk detected")
        CoL.transformStamina += 1
        CoL.Log("Transform Stamina Ranks: " + CoL.transformStamina)
        CoL.playerRef.RemovePerk(transformStaminaPerk)
    endif
    if CoL.playerRef.HasPerk(transformMagickaPerk)
        CoL.Log("Transform Magicka Perk detected")
        CoL.transformMagicka += 1
        CoL.Log("Transform Magicka Ranks: " + CoL.transformMagicka)
        CoL.playerRef.RemovePerk(transformMagickaPerk)
    endif
    if CoL.playerRef.HasPerk(transformCarryWeightPerk)
        CoL.Log("Transform Carry Weight Perk detected")
        CoL.transformCarryWeight += 1
        CoL.Log("Transform Carry Weight Ranks: " + CoL.transformCarryWeight)
        CoL.playerRef.RemovePerk(transformCarryWeightPerk)
    endif
    if CoL.playerRef.HasPerk(transformMeleeDamagePerk)
        CoL.Log("Transform Melee Damage Perk detected")
        CoL.transformMeleeDamage += 1
        CoL.Log("Transform Melee Damage Ranks: " + CoL.transformMeleeDamage)
        CoL.playerRef.RemovePerk(transformMeleeDamagePerk)
    endif
    if CoL.playerRef.HasPerk(transformArmorPerk)
        CoL.Log("Transform Armor Perk detected")
        CoL.transformArmor += 1
        CoL.Log("Transform Armor Ranks: " + CoL.transformArmor)
        CoL.playerRef.RemovePerk(transformArmorPerk)
    endif
    if CoL.playerRef.HasPerk(transformMagicResistPerk)
        CoL.Log("Transform Magic Resist Perk detected")
        CoL.transformMagicResist += 1
        CoL.Log("Transform Magic Resist Ranks: " + CoL.transformMagicResist)
        CoL.playerRef.RemovePerk(transformMagicResistPerk)
    endif
    if CoL.playerRef.HasPerk(effecientFeeder)
        CoL.Log("Efficient Feeder Perk detected")
        CoL.efficientFeeder += 1
        CoL.Log("Efficient Feeder Ranks: " + CoL.efficientFeeder)
        CoL.playerRef.RemovePerk(effecientFeeder)
    endif
    if CoL.playerRef.HasPerk(energyStorage)
        CoL.Log("Energy Storage Perk detected")
        CoL.energyStorage += 1
        CoL.Log("Energy Storage Ranks: " + CoL.energyStorage)
        CoL.playerEnergyMax += 10
        CoL.playerRef.RemovePerk(energyStorage)
    endif
EndEvent