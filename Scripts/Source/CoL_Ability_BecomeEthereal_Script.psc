Scriptname CoL_Ability_BecomeEthereal_Script extends activemagiceffect

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_Mechanic_EnergyHandler_Script Property energyHandler Auto
CoL_ConfigHandler_Script Property configHandler Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if energyHandler.playerEnergyCurrent >= configHandler.becomeEtherealCost
        RegisterForSingleUpdate(1.0)
    else
        Debug.Notification("Out of Energy: Become Ethereal Disabled")
        CoL.playerRef.RemoveSpell(CoL.becomeEthereal)
    endif
EndEvent

Function Log(string msg)
    CoL.Log("Become Ethereal - " + msg)
EndFunction

Event OnUpdate()
    if energyHandler.playerEnergyCurrent < configHandler.becomeEtherealCost
        Log("Out of Energy")
        Debug.Notification("Out of Energy: Become Ethereal Disabled")
        energyHandler.playerEnergyCurrent = 0
        CoL.playerRef.RemoveSpell(CoL.becomeEthereal)
        return
    endif
    energyHandler.playerEnergyCurrent -= configHandler.becomeEtherealCost
    RegisterForSingleUpdate(1.0)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    CoL.playerRef.RemoveSpell(CoL.becomeEthereal)
EndEvent