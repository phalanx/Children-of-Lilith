Scriptname CoL_Perk_Infinite_Script extends activemagiceffect  

; Transformation Perks
; 0 - health
; 1 - stamina
; 2 - magicka
; 3 - carry weight
; 4 - melee damage
; 5 - armor
; 6 - magic resist
Perk[] Property transformPerks Auto
Perk Property effecientFeeder Auto
Perk Property energyStorage Auto
Perk Property perkConverter Auto
CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_Mechanic_EnergyHandler_Script Property energyHandler Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    Log("Triggered")
    int i = 0
    while i < transformPerks.Length
        if CoL.playerRef.HasPerk(transformPerks[i])
            Log(transformPerks[i].GetName()+" detected")
            CoL.transformBuffs[i] = CoL.transformBuffs[i] + 1
            CoL.playerRef.RemovePerk(transformPerks[i])
        endif
        i += 1
    endwhile
    if CoL.playerRef.HasPerk(effecientFeeder)
        Log("Efficient Feeder Perk detected")
        CoL.efficientFeeder += 1
        Log("Efficient Feeder Ranks: " + CoL.efficientFeeder)
        CoL.playerRef.RemovePerk(effecientFeeder)
    endif
    if CoL.playerRef.HasPerk(energyStorage)
        Log("Energy Storage Perk detected")
        CoL.energyStorage += 1
        Log("Energy Storage Ranks: " + CoL.energyStorage)
        energyHandler.playerEnergyMax += 10
        CoL.playerRef.RemovePerk(energyStorage)
    endif
    if CoL.playerRef.hasPerk(perkConverter)
        Log("Perk Conversion Detected")
        Game.AddPerkPoints(1)
        CoL.playerRef.RemovePerk(perkConverter)
    endif
EndEvent

Function Log(string msg)
    CoL.Log("Infinite Perk - " + msg)
EndFunction