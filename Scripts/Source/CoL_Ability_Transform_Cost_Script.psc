
Scriptname CoL_Ability_Transform_Cost_Script extends activemagiceffect  

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_ConfigHandler_Script Property configHandler auto

bool pauseCost

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if configHandler.transformCost > 0
        Maintenance()
        RegisterForSingleUpdate(5) ;Initial delay to account for animation
    endif
EndEvent

Function Maintenance()
    RegisterForModEvent("CoL_GameLoad", "Maintenance")
    RegisterForModEvent("CoL_startScene", "StartScene")
    RegisterForModEvent("CoL_endScene", "EndScene")
EndFunction

Function StartScene()
    CoL.Log("Pausing transform cost")
    pauseCost = true
    UnregisterForUpdate()
EndFunction

Function EndScene()
    CoL.Log("Unpausing transform cost")
    pauseCost = false
    RegisterForSingleUpdate(1)
EndFunction

Event OnUpdate()
    if CoL.isTransformed && configHandler.transformCost > 0
        if pauseCost
            return
        endif
        if CoL.playerEnergyCurrent > configHandler.transformCost
            CoL.playerEnergyCurrent -= configHandler.transformCost
            RegisterForSingleUpdate(1)
        elseif !CoL.lockTransform
            CoL.playerEnergyCurrent = 0
            Debug.Notification("Out of Energy")
            CoL.transformSpell.Cast(CoL.playerRef, CoL.playerRef)
        endif
    endif
EndEvent