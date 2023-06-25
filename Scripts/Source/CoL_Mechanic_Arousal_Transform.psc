Scriptname CoL_Mechanic_Arousal_Transform extends Quest

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_Interface_Arousal_Script Property iArousal Auto
CoL_ConfigHandler_Script Property configHandler Auto

Event OnInit()
EndEvent

State Initialize
    Event OnBeginState()
        Maintenance()
    EndEvent
EndState

State Polling
    Event OnBeginState()
        RegisterForSingleUpdate(30)
    EndEvent

    Event OnUpdate()
        float averageArousal = iArousal.GetActorArousal(CoL.playerRef)

        CoL.Log("Average arousal: " + averageArousal)
        CoL.Log("Upper Threshold: " + configHandler.transformArousalUpperThreshold)
        CoL.Log("Lower Threshold: " + configHandler.transformArousalLowerThreshold)

        if ((configHandler.transformArousalUpperThreshold != 0 && averageArousal >= configHandler.transformArousalUpperThreshold) || ( configHandler.transformArousalLowerThreshold != 0 && averageArousal < configHandler.transformArousalLowerThreshold ))
            forceTransform()
        elseif ((configHandler.transformArousalUpperThreshold == 0 || averageArousal <= configHandler.transformArousalUpperThreshold) && (configHandler.transformArousalLowerThreshold == 0 || averageArousal > configHandler.transformArousalLowerThreshold))
            forceUntransform()
        endif

        RegisterForSingleUpdate(30)
    EndEvent

    Event OnEndState()
        UnregisterForUpdate()
    EndEvent
EndState

State Uninitialize
    Event OnBeginState()
        UnregisterForModEvent("CoL_GameLoad")
        if CoL.isTransformed
            CoL.lockTransform = false
        endif
    EndEvent

    Function Maintenance()
        UnregisterForModEvent("CoL_GameLoad")
        UnregisterForUpdate()
    EndFunction
EndState

Function Maintenance()
    RegisterForModEvent("CoL_GameLoad", "Maintenance")

    if iArousal.IsInterfaceActive()
        GoToState("Polling")
    endif

EndFunction

Function forceTransform()
    if CoL.isBusy()
        CoL.Log("Transform triggered but player is busy")
        return
    elseif CoL.isTransformed
        CoL.Log("Transform triggered but player is already transformed")
        return
    endif
    CoL.transformSpell.Cast(Col.playerRef)
    CoL.lockTransform = true
EndFunction

Function forceUntransform()
    if CoL.isBusy()
        CoL.Log("Untransform triggered but player is busy")
        return
    elseif !CoL.isTransformed
        CoL.Log("Untransform triggered but player is already untransformed")
        return
    endif
    CoL.lockTransform = false
    CoL.transformSpell.Cast(Col.playerRef)
EndFunction

Function UpdateConfig()
    if configHandler.transformArousalUpperThreshold == 0 && configHandler.transformArousalUpperThreshold == 0
        GoToState("Uninitialize")
    elseif GetState() != "Polling"
        GoToState("Initialize")
    endif
EndFunction