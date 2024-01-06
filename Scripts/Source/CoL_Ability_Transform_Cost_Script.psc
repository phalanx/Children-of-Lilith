
Scriptname CoL_Ability_Transform_Cost_Script extends activemagiceffect  

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_ConfigHandler_Script Property configHandler auto
CoL_Mechanic_EnergyHandler_Script Property energyHandler Auto

bool pauseCost

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if configHandler.transformCost > 0
        Maintenance()
        RegisterForSingleUpdate(1) ;Initial delay to account for animation
    endif
EndEvent

Function Log(string msg)
    CoL.Log("Transform - Cost - " + msg)
EndFunction

Function Maintenance()
    RegisterForModEvent("CoL_GameLoad", "Maintenance")
    RegisterForModEvent("CoL_startScene", "StartScene")
    RegisterForModEvent("CoL_endScene", "EndScene")
EndFunction

Function StartScene()
    Log("Pausing")
    pauseCost = true
    UnregisterForUpdate()
EndFunction

Function EndScene()
    Log("Unpausing")
    pauseCost = false
    RegisterForSingleUpdate(1)
EndFunction

Event OnUpdate()
    if configHandler.transformCost > 0
        if pauseCost
            return
        endif
        if energyHandler.playerEnergyCurrent > configHandler.transformCost
            energyHandler.playerEnergyCurrent -= configHandler.transformCost
            RegisterForSingleUpdate(1)
        elseif !CoL.lockTransform
            energyHandler.playerEnergyCurrent = 0
            Debug.Notification("Out of Energy")
            CoL.transformSpell.Cast(CoL.playerRef, CoL.playerRef)
        endif
    endif
EndEvent