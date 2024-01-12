Scriptname CoL_Ability_HealRateBoost_Script extends activemagiceffect  

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_Mechanic_EnergyHandler_Script Property energyHandler Auto
CoL_ConfigHandler_Script Property configHandler Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if energyHandler.playerEnergyCurrent >= configHandler.healRateBoostCost
        RegisterForSingleUpdate(1.0)
    else
        Debug.Notification("Out of Energy: Heal Rate Boost Disabled")
        CoL.playerRef.RemoveSpell(CoL.HealRateBoost)
    endif
EndEvent

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
        CoL.playerRef.RemoveSpell(CoL.HealRateBoost)
        return
    endif
    energyHandler.playerEnergyCurrent -= configHandler.healRateBoostCost
    RegisterForSingleUpdate(1.0)
EndEvent
