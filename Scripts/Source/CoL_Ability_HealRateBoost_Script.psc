Scriptname CoL_Ability_HealRateBoost_Script extends activemagiceffect  

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_Mechanic_EnergyHandler_Script Property energyHandler Auto
CoL_ConfigHandler_Script Property configHandler Auto

Spell Property healRateSpell Auto
Spell Property healRateMultSpell Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if energyHandler.playerEnergyCurrent >= configHandler.healRateBoostCost
        AddSpells()
        RegisterForSingleUpdate(1.0)
    else
        Debug.Notification("Out of Energy: Heal Rate Boost Disabled")
        CoL.playerRef.RemoveSpell(CoL.HealRateBoost)
    endif
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    RemoveSpells()
EndEvent

Function AddSpells()
    healRateSpell.SetNthEffectMagnitude(0, configHandler.healRateBoostAmount)
    healRateMultSpell.SetNthEffectMagnitude(0, configHandler.healRateBoostMult)
    CoL.playerRef.AddSpell(healRateSpell, false)
    CoL.playerRef.AddSpell(healRateMultSpell, false)
EndFunction

Function RemoveSpells()
    CoL.playerRef.RemoveSpell(healRateSpell)
    CoL.playerRef.RemoveSpell(healRateMultSpell)
EndFunction

Function Log(string msg)
    CoL.Log("Heal Rate Boost - " + msg)
EndFunction

Event OnUpdate()
    if GetMagnitude() > 0 ; Assume this effect is from Healing Form Perk
        return
    endif
    if energyHandler.playerEnergyCurrent < configHandler.healRateBoostCost
        Log("Out of Energy")
        Debug.Notification("Out of Energy: Heal Rate Boost Disabled")
        RemoveSpells()
        CoL.playerRef.RemoveSpell(CoL.healRateBoost)
        return
    endif
    energyHandler.playerEnergyCurrent -= configHandler.healRateBoostCost
    RegisterForSingleUpdate(1.0)
EndEvent
